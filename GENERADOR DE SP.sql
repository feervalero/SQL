SET NOCOUNT ON;
USE [ECommerce];
DECLARE @DatabaseName	NVARCHAR(100) = 'ECommerce',
		@SchemaName		NVARCHAR(100) = 'dbo',
		@tableNames		NVARCHAR(100) = 'Category'
SELECT c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH
	INTO #COLUMNS
	FROM INFORMATION_SCHEMA.Columns c
		 INNER JOIN INFORMATION_SCHEMA.Tables t ON c.TABLE_NAME = t.TABLE_NAME
	WHERE t.Table_Catalog = @DatabaseName
	  AND t.TABLE_TYPE = 'BASE TABLE'
	  AND t.TABLE_SCHEMA = @SchemaName
	ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION

DECLARE TableCol Cursor FOR
	SELECT C.TABLE_SCHEMA, C.TABLE_NAME
	FROM #COLUMNS C
	WHERE C.TABLE_NAME = @tableNames
	GROUP BY C.TABLE_SCHEMA, C.TABLE_NAME


OPEN TableCol  

DECLARE @TableName	VARCHAR(100),
		@Schema		VARCHAR(100)

DECLARE @Script		VARCHAR(8000)

FETCH NEXT FROM TableCol   
INTO @Schema, @TableName  

WHILE @@FETCH_STATUS = 0  
BEGIN 

DECLARE @StrValues VARCHAR(8000)
SELECT @StrValues = COALESCE(@StrValues + ', [', '[') +  LTRIM(RTRIM(CONVERT(varchar(100), C.[COLUMN_NAME]))) + ']'
	FROM #Columns C
	WHERE C.[TABLE_SCHEMA] = @Schema
		AND C.[TABLE_NAME] = @TableName
		AND C.[COLUMN_NAME] != 'Id'
		AND C.[COLUMN_NAME] != 'RowVersion'

SELECT @Script = '
DROP PROCEDURE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '_Add]
GO
-- =============================================
-- Author:		Fernando Valero Niño
-- Create date: ' + CONVERT(VARCHAR(10), GETDATE(), 112) + '
-- Description:	Add
-- =============================================

CREATE PROCEDURE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '_Add]'

SELECT @Script = @Script + CHAR(10) + CHAR(9) + '@' + LTRIM(RTRIM(C.COLUMN_NAME)) + ' ' + UPPER(LTRIM(RTRIM(DATA_TYPE))) + '' 
		+ CASE WHEN UPPER(LTRIM(RTRIM(DATA_TYPE))) IN ('VARCHAR')
			THEN '(' + LTRIM(RTRIM(STR(C.[CHARACTER_MAXIMUM_LENGTH]))) + ')'
			ELSE ''
		END
		+ ','
	FROM #Columns C
	WHERE C.[TABLE_SCHEMA] = @Schema
		AND C.[TABLE_NAME] = @TableName
		AND C.[COLUMN_NAME] != 'Id'
		AND C.[COLUMN_NAME] != 'RowVersion'

SELECT @Script = SUBSTRING(@Script, 0, LEN(@Script)) + CHAR(10)

SELECT @Script = @Script +
'AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Ids TABLE (
		Id		UNIQUEIDENTIFIER
	);

	INSERT INTO [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '] (' + @StrValues + ')
		OUTPUT	INSERTED.Id
			INTO	@Ids
		VALUES	(' + REPLACE(REPLACE(@StrValues, '[', '@'), ']', '') + ')

	SELECT	Id
		FROM @Ids

	SET NOCOUNT OFF;
END
GO


DROP PROCEDURE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '_Del]
GO
'

SELECT @Script = @Script +
'-- =============================================
-- Author:		Fernando Valero Niño
-- Create date: 2017-09-27
-- Description:	Del
-- =============================================
CREATE PROCEDURE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '_Del]
	@Id			UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	DELETE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + ']
		WHERE [Id] = @Id

	SET NOCOUNT OFF;
END
GO


DROP PROCEDURE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '_Upd]
GO

'

SELECT @Script = @Script +
'-- =============================================
-- Author:  Fernando Valero Niño
-- Create date: ' + CONVERT(VARCHAR(10), GETDATE(), 112) + '
-- Description: Update
-- =============================================
CREATE PROCEDURE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '_Upd]'

SELECT @Script = @Script + CHAR(10) +CHAR(9) +
	'@' 
	+  convert(nvarchar,COLUMN_NAME)+'	'
	+ convert(nvarchar,DATA_TYPE)
	+ CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NULL THEN '' ELSE '(' +convert(nvarchar,CHARACTER_MAXIMUM_LENGTH)+')' END+','
  FROM #Columns C
  WHERE C.[TABLE_SCHEMA] = @Schema
    AND C.[TABLE_NAME] = @TableName
    AND C.[COLUMN_NAME] != 'RowVersion'
SELECT @Script = SUBSTRING(@Script, 0, LEN(@Script)) 
SELECT @Script = @Script +'
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [' + LTRIM(RTRIM(@Schema)) + '].[' + LTRIM(RTRIM(@TableName)) + '] SET'
	SELECT @Script = @Script + CHAR(10)+ CHAR(9)+ CHAR(9) + '['+  convert(nvarchar,COLUMN_NAME)+'] = '
	+'@'+  convert(nvarchar,COLUMN_NAME)
	+ ','
	FROM #Columns C
  WHERE C.[TABLE_SCHEMA] = @Schema
    AND C.[TABLE_NAME] = @TableName
	AND C.[COLUMN_NAME] != 'Id'
    AND C.[COLUMN_NAME] != 'RowVersion'
SELECT @Script = SUBSTRING(@Script, 0, LEN(@Script)) 
SELECT @Script = @Script + CHAR(10) + CHAR(9) + 'WHERE [Id] = @'+convert(nvarchar,COLUMN_NAME)
FROM #Columns C
  WHERE C.[TABLE_SCHEMA] = @Schema
    AND C.[TABLE_NAME] = @TableName
	AND C.[COLUMN_NAME] = 'Id'
SELECT @Script = @Script + '
	
	SET NOCOUNT OFF;
END
GO


'
PRINT @Script
	FETCH NEXT FROM TableCol   
	INTO @Schema, @TableName  
END   
CLOSE TableCol;  
DEALLOCATE TableCol;

DROP TABLE #COLUMNS