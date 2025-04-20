	SELECT 
	SkillID,
	MAX(SkillLevel) AS SkillLevel,
	MAX(Country) AS Country,
	MAX(Grow) AS Grow,
	MAX(Attackfighter) AS Attackfighter,
	MAX(Defensefighter) AS Defensefighter,
	MAX(Patrolrogue) AS Patrolrogue,
	MAX(Shootrogue) AS Shootrogue,
	MAX(Attackmage) AS Attackmage,
	MAX(Defensemage) AS Defensemage 
	INTO #Skills
	FROM PS_GameDefs.dbo.Skills
	WHERE 
	-- İstenmeyen: SkillLevel > 1 ama ReqLevel = 0 OLANLAR hariç.
	NOT (SkillLevel > 1 AND ReqLevel = 0)

	AND ReqLevel <= @Level
	AND SkillLevel < 100
	AND TypeShow > 0 

	AND ((@Job != 0 OR Attackfighter = 1) AND ((@Family != 0 OR Country IN (6,2,0)) AND (@Family != 3 OR Country IN (6,5,3))))
	AND ((@Job != 1 OR Defensefighter = 1) AND ((@Family != 0 OR Country IN (6,2,0)) AND (@Family != 3 OR Country IN (6,5,3))))
	AND ((@Job != 2 OR Patrolrogue = 1) AND ((@Family != 1 OR Country IN (6,2,1)) AND (@Family != 2 OR Country IN (6,5,4))))
	AND ((@Job != 3 OR Shootrogue = 1) AND ((@Family != 1 OR Country IN (6,2,1)) AND (@Family != 3 OR Country IN (6,5,3))))
	AND ((@Job != 4 OR Attackmage = 1) AND ((@Family != 1 OR Country IN (6,2,1)) AND (@Family != 2 OR Country IN (6,5,4))))
	AND ((@Job != 5 OR Defensemage = 1) AND ((@Family != 0 OR Country IN (6,2,0)) AND (@Family != 2 OR Country IN (6,5,4))))
	GROUP BY SkillID

	DECLARE @Count INT = (SELECT COUNT(SkillLevel) FROM #Skills)

	WHILE @Count > 0
	BEGIN
	INSERT INTO CharSkills
	SELECT TOP (1) @CharID, SkillID, SkillLevel, @Count, 0, GETDATE(), 0
	FROM #Skills
	DELETE TOP (1) FROM #Skills
	SET @Count -= 1
	END
	DROP TABLE #Skills
