-- disable gm commands,login,logout
-- usp_Insert_Action_Log_E
SET @Sql = N'
IF (@ActionType NOT IN (180, 108, 107))
BEGIN
INSERT INTO PS_GameLog.dbo.ActionLog
(UserID, UserUID, CharID, CharName, CharLevel, CharExp, MapID,  PosX, PosY, PosZ, ActionTime, ActionType, 
Value1, Value2, Value3, Value4, Value5, Value6, Value7, Value8, Value9, Value10, Text1, Text2, Text3, Text4)
VALUES(@UserID, @UserUID, @CharID, @CharName, @CharLevel, @CharExp, @MapID, @PosX, @PosY, @PosZ, @ActionTime, @ActionType, 
@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Text1, @Text2, @Text3, @Text4)
END'


USE [PS_Chatlog]
GO

/****** Object:  Table [dbo].[RaidCommandLog]    Script Date: 29.11.2024 22:38:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RaidCommandLog](
	[row] [int] IDENTITY(1,1) NOT NULL,
	[UserUID] [char](10) NULL,
	[CharID] [char](10) NULL,
	[ChatType] [char](10) NULL,
	[ChatData] [char](100) NULL,
	[MapID] [char](10) NULL,
	[ChatTime] [char](10) NULL
) ON [PRIMARY]

GO


-- usp_Insert_Chat_Log_E
IF (@ChatType=4)
BEGIN
INSERT INTO PS_ChatLog.dbo.RaidCommandLog
(UserUID, CharID, ChatType,ChatData, MapID, ChatTime)
VALUES(@UserUID, @CharID, @ChatType, @ChatData, @MapID, @ChatTime)
END
ELSE
BEGIN
INSERT INTO PS_ChatLog.dbo.ChatLog
(UserUID, CharID, ChatType, TargetName, ChatData, MapID, ChatTime)
VALUES(@UserUID, @CharID, @ChatType, @TargetName, @ChatData, @MapID, @ChatTime)
END
