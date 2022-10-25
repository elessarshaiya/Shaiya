USE [PS_GameDefs]
GO
/****** Object:  Trigger [dbo].[GM_Reroll]    Script Date: 25.10.2022 03:55:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[GM_Reroll] ON [dbo].[Items] FOR INSERT

AS

BEGIN

----RR System----
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=1 where ItemID=100202
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=2 where ItemID=100203
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=3 where ItemID=100204
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=4 where ItemID=100205
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=5 where ItemID=100206
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=6 where ItemID=100207
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=7 where ItemID=100208
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=8 where ItemID=100209
Update PS_GameDefs.dbo.Items Set ConstStr=2 , ConstDex=9 where ItemID=100210

--Remove RR System--
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=1 where ItemID=100211
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=2 where ItemID=100212
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=3 where ItemID=100213
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=4 where ItemID=100214
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=5 where ItemID=100215
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=6 where ItemID=100216
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=7 where ItemID=100217
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=8 where ItemID=100218
Update PS_GameDefs.dbo.Items Set ConstStr=1 , ConstDex=9 where ItemID=100219


END
