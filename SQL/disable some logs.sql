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
