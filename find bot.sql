
USE [PS_GameLog]
GO

/****** Object:  Table [dbo].[ActivedPlayer]    Script Date: 30.01.2021 15:04:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ActivedPlayer](
	[UserUID] [int] NULL,
	[CharID] [int] NULL,
	[CharName] [varchar](30) NULL,
	[PlayerKey] [varchar](50) NULL,
	[CTime] [datetime] NULL
) ON [PRIMARY]

GO


*********************** usp_Insert_Action_Log_E part ***********************


DECLARE @Key varchar(50) = (SELECT SUBSTRING(CONVERT(NVARCHAR(40), NEWID()),1,6) AS BTOMER)
DECLARE @PlayerMessage varchar(50)
DECLARE @PlayerKey varchar(50)

IF (@ActionType = 107)
BEGIN
IF NOT EXISTS (Select CharID From ActivedPlayer Where CharID=@CharID)
BEGIN
INSERT INTO PS_GameLog.dbo.ActivedPlayer values(@UserUID,@CharID,@CharName,@Key,GETDATE())
END
END

IF (@ActionType = 108)
BEGIN
DELETE FROM PS_GameLog.dbo.ActivedPlayer WHERE CharID=@CharID
END
-- map and time control
IF(@MapID=64 AND (DATEADD(MINUTE, 1, (SELECT TOP 1 CTime From PS_GameLog.dbo.ActivedPlayer where CharID=@CharID order by CTime desc )) < GETDATE()) or (SELECT TOP 1 CTime From PS_GameLog.dbo.ActivedPlayer where CharID=@CharID order by CTime desc) IS NULL)
BEGIN
-- Find Player key data
SET @PlayerKey = (Select PlayerKey From ActivedPlayer Where CharID=@CharID) 
-- Send Player key data notice 
SET @msg = N'!ntplayer '+@CharName+' "pls write in 15 sec : '+@PlayerKey+'"'
EXEC [PS_Agent].[dbo].[usp_Notice_Player]
@Input= @msg,
@CharName=@CharName
-- Find Player last 10 message
SET @PlayerMessage =(SELECT top 10 ChatData from PS_Chatlog.dbo.ChatLog Where CharID=@CharID order by ChatTime desc)

-- if player message = playerkey send notice
WAITFOR DELAY '00:00:20'
IF(@PlayerKey IN (SELECT top 10 ChatData from PS_Chatlog.dbo.ChatLog Where CharID=@CharID order by ChatTime desc))
BEGIN
SET @msg = N'!ntplayer '+@CharName+' "thank you"'
EXEC [PS_Agent].[dbo].[usp_Notice_Player]
@Input= @msg,
@CharName=@CharName
-- update player key
UPDATE PS_GameLog.dbo.ActivedPlayer SET CTime=GETDATE(),PlayerKey=@Key WHERE CharID=@CharID
END
-- else kick
ELSE
BEGIN
SET @msg=N'/kickcn '+@CharName
EXEC [PS_Agent].[dbo].[Command]
@serviceName = N'ps_game',
@cmmd = @msg
-- delete active player tablo
DELETE FROM PS_GameLog.dbo.ActivedPlayer WHERE CharID=@CharID
END
END
