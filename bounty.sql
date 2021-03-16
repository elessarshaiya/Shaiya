USE [PS_GameLog]
GO

/****** Object:  Table [dbo].[TBounty]    Script Date: 16.03.2021 22:17:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TBounty](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Charname] [varchar](max) NOT NULL,
	[TotalBounty] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO





*********************** usp_Insert_Action_Log_E part ***********************	







-- Bounty Part
IF (@ActionType = '104' and @MapID <> 40)
BEGIN
DECLARE @TextChange varchar(max), @CharnameChange varchar(max)
SET @ActionType = '10'
SET @TextChange = @Text1
SET @CharnameChange = @CharName
SET @Text1 = @CharnameChange
SET @CharName = @TextChange
SET @UserUID = (SELECT Top 1 UserUID FROM PS_GameData.dbo.Chars WHERE Charname = @CharName)
SET @CharID = (SELECT Top 1 CharID FROM PS_GameData.dbo.Chars WHERE Charname = @CharName)
SET @UserID = (SELECT Top 1 UserID FROM PS_GameData.dbo.Chars WHERE Charname = @CharName)
END

IF (@ActionType = '10')
BEGIN 
Update PS_GameData.dbo.Chars Set OwnKill+=1 Where CharID=@CharID

DECLARE @CheckKills varchar(max)

-- SELECT how many the player killed

 SET @CheckKills = (SELECT OwnKill FROM PS_GameData.dbo.Chars WHERE CharID = @CharID)

-- If player killed 5 or 10 or ... players

 IF (@CheckKills = '10' or @CheckKills = '15' or @CheckKills = '20' or @CheckKills = '30' or @CheckKills = '40' or @CheckKills = '50')
 
 BEGIN 

 DECLARE @CheckNotice varchar(max), @CheckPvPFaction varchar(max), @Sentence varchar(max)

-- select the country of the player
 SET @CheckPvPFaction = (SELECT Country FROM PS_GameData.dbo.UserMaxGrow WHERE UserUID = @UserUID)

 -- if country = 0 then Light, if country = 1 then dark
 IF (@CheckPvPFaction = '0') BEGIN SET @CheckPvPFaction = '(Alliance of Light)' END
 IF (@CheckPvPFaction = '1') BEGIN SET @CheckPvPFaction = '(Union of Fury)' END

-- put a nice sentence
-- IF (@CheckKills = '5') BEGIN SET @Sentence = 'Dangerous Mode!' END
 IF (@CheckKills = '10') BEGIN SET @Sentence = 'Deadly Mode!' END
 IF (@CheckKills = '15') BEGIN SET @Sentence = 'Fearless Mode!' END
 IF (@CheckKills = '20') BEGIN SET @Sentence = 'Bloodthirsty Mode!' END
 IF (@CheckKills = '30') BEGIN SET @Sentence = 'Ruthless Mode!' END
 IF (@CheckKills = '40') BEGIN SET @Sentence = 'Risky Mode!' END
 IF (@CheckKills = '50') BEGIN SET @Sentence = 'God Mode!' END

-- if you want to do it if there is a bounty then: (20 and 21)
-- if (SELECT Top 1 Charname FROM PS_GameLog.dbo.Bounty WHERE Charname = @Charname) IS NOT NULL
DECLARE @BountyPointsReward varchar(max), @BountyPointToAdd varchar (max)

SET @BountyPointToAdd = '250'

-- 1 add point to the bounty

IF (SELECT Charname FROM PS_GameLog.dbo.TBounty WHERE Charname = @Charname) IS NULL
BEGIN
INSERT INTO PS_GameLog.dbo.TBounty
          (Charname, TotalBounty)
VALUES (@Charname, 0)
END

BEGIN
UPDATE PS_GameLog.dbo.TBounty SET TotalBounty = TotalBounty + @BountyPointToAdd WHERE Charname = @Charname
END

-- fine or need to change smt i change it later i think xD oka
SET @BountyPointsReward = (SELECT TotalBounty FROM PS_GameLog.dbo.TBounty WHERE Charname = @Charname)
SET @Sentence = @Sentence + ' Ödül: '+ @BountyPointsReward 


 SET @CheckNotice = N'/nt ' + @Charname + ' ' + @CheckPvPFaction + ' killed ' + @CheckKills + ' players without dying! ' + @Sentence
		EXEC [PS_Agent].[dbo].[Command]
		@serviceName = N'ps_game',
		@cmmd = @CheckNotice
	
		
 END
 END 
  
-- Bounty Part

IF (@ActionType = '10')
BEGIN
IF (SELECT Charname FROM PS_GameLog.dbo.TBounty WHERE Charname = @Text1) IS NOT NULL
BEGIN
IF (@Charname != @Text1)
BEGIN
DECLARE @CheckBounty varchar(max), @BountyNotice varchar(max), @BountyPoints varchar(max)

SET @BountyPoints = (SELECT TotalBounty FROM PS_GameLog.dbo.TBounty WHERE Charname = @Text1)

BEGIN
UPDATE PS_UserData.dbo.Users_Master SET Point = Point + @BountyPoints WHERE UserUID = @UserUID
END

BEGIN
DELETE FROM PS_GameLog.dbo.TBounty WHERE Charname = @Text1
END

SET @CheckBounty = (SELECT Charname FROM PS_GameLog.dbo.TBounty WHERE Charname = @Text1)
SET @BountyNotice = N'/nt ' + @Charname + ' killed ' + @Text1 + '. ' + @Charname + ' gets the ' + @BountyPoints + ' points.'
		EXEC [PS_Agent].[dbo].[Command]
		@serviceName = N'ps_game',
		@cmmd = @BountyNotice

END
END
END
