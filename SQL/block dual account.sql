USE [PS_GameLog]
GO

/****** Object:  Table [dbo].[LoginLog]    Script Date: 3.12.2021 17:39:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LoginLog](
	[UserID] [varchar](50) NOT NULL,
	[UserUID] [int] NOT NULL,
	[CharID] [int] NOT NULL,
	[CharName] [varchar](50) NOT NULL,
	[Faction] [int] NOT NULL,
	[ActionTime] [datetime] NOT NULL,
	[UserIP] [varchar](50) NOT NULL
) ON [PRIMARY]

GO


-----------------------------------------INSERT ACTION LOG PART----------------------------------------------

DECLARE @UserIPCheck INT

IF NOT EXISTS (Select CharID From LoginLog Where CharID=@CharID)
BEGIN
INSERT INTO LoginLog VALUES (@UserID, @UserUID, @CharID, @CharName, @StaffFaction, @ActionTime, @Text1)
END


SET @UserIPCheck=(SELECT COUNT(*) FROM LoginLog WHERE UserIP = @Text1)

IF (@UserIPCheck >=2)
BEGIN
    WAITFOR DELAY '00:00:20'
    SET @msg=N'/kickcn '+@CharName
    EXEC [PS_Agent].[dbo].[Command]
    @serviceName = N'ps_game',
    @cmmd = @msg
    END

