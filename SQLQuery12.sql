/* 1.1. �������� ��� ��� ��������� ���� ��������� �������� � ������� �������.
��������� ������ ������ ��� ���������� ������ � ��������� �������� �������, ��� ����������
�������� ������ ���� �������� �������� �� ��������� ����� (char, nchar, varchar, nvarchar, text,
ntext) �� ������� �������. ��������� �� ������ �������� ���, ��������� ��� ������ ������ �
����� ��������, �� ���������� ������� �� ������������� �������� ������� � �������� �����
�� �� ��������� ����������). � ���������� �� ������ ������� ������� �� ���������
ColumnName (�������� �������) � Type (��� ������ �������), ���������� ������ ���������
�������. �������� ������ ��� ������� SalesLT.Product. */
--------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @Name AS NVARCHAR(20) = 'Product'
DECLARE @Schema AS NVARCHAR(20) = 'SalesLT'
--PRINT @Name
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE (DATA_TYPE = 'nvarchar' OR DATA_TYPE ='char' OR DATA_TYPE ='nchar' OR DATA_TYPE ='varchar' OR DATA_TYPE ='nvarchar' OR DATA_TYPE ='text' OR DATA_TYPE = 'ntext')
AND TABLE_NAME = @Name AND table_schema = @Schema
GO
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2. �������� ���, ��� ������ �������� � ��������� �������� �������.
�� ����������� ������� ��� ����� �������� ��� ��������� ������� �������, � ������� ����
������������ �����. ������ �� ������� �������� SQL-������ ��� �������� ������ SQL-�������,
������� ��������� �� �� ������ �� �������, ������� �������� ������� �������� � �����
��������� �������. ���� �� ������ ������ �� ����������� �������, �������� SQL-������ ���
������ ������������� �������� (��������� � �������� ��� ������ ���������� �������� �����
����������) � ��������� ������� (������) ������������ ������� (�������������� ������ ������
���������� ��� ������� �� �������). �� ������� ������������ �� ������� � ��� ����� ���
���������� ������� ����� ��������������� SQL-������� �� ����� � ������� ��������� PRINT.
��� ������������ ����������������� ������������� �������� ��������� ����� �������� �Bike�
� ������� SalesLT.Product.*/
--------------------------------------------------------------------------------------------------------------------------------------------
USE AdventureWorksLT
GO

DECLARE @Name AS NVARCHAR(20) = 'Product'
DECLARE @Schema AS NVARCHAR(20) = 'SalesLT'
DECLARE @column AS NVARCHAR(2000)
DECLARE @Ask AS NVARCHAR(2000)
DECLARE @stringToFind AS NVARCHAR(2000) = 'Bike'

DECLARE c1 CURSOR LOCAL FAST_FORWARD
FOR
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
	WHERE (DATA_TYPE = 'nvarchar' or DATA_TYPE ='char' or DATA_TYPE ='nchar' or DATA_TYPE ='varchar' or DATA_TYPE ='nvarchar' or DATA_TYPE ='text' or DATA_TYPE = 'ntext')
	AND TABLE_NAME = @Name AND table_schema = @Schema
OPEN c1
WHILE (1=1)
BEGIN
	FETCH c1 INTO @column
	IF @@FETCH_STATUS <> 0 BREAK
	SET @Ask = 'select ['+ @column + '] from ['+@Schema+'].['+ @Name+ '] where ['+@column+'] like '+ '''%' + @stringToFind + '%'''
	EXECUTE (@Ask)
END
CLOSE c1
DEALLOCATE c1
GO
--------------------------------------------------------------------------------------------------------------------------------------------
/* 2.1. �������� �������� ���������.
�� ������� �������� ���������, ���������� � ������ ������, � ���� �������� ��������� �
������ SalesLT.uspFindStringInTable. �� ���� ��������� ������ ��������� ��� ���������
���������.
� �������� ���������� �������� ��������� ������ ���������� ����� ������, ��������� �� ����
�������� ������� � �����, � ������� ���� ������� �������� ���������. ������������� ��������
��������� ������ ���������� � �������� ���� �������� (RETURN) ���������� ����� �
�������������� �������. ������������� �������� ��������� � ������� �� ������� 1.2. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SalesLT.uspFindStringInTable
	@schema SYSNAME, @table SYSNAME, @stringToFind NVARCHAR(2000)
AS
DECLARE @count INT = 0
DECLARE @column AS NVARCHAR(2000)
DECLARE @Ask AS NVARCHAR(2000)

DECLARE c1 CURSOR LOCAL FAST_FORWARD
FOR
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
	WHERE (DATA_TYPE = 'nvarchar' OR DATA_TYPE ='char' OR DATA_TYPE ='nchar' OR DATA_TYPE ='varchar' OR DATA_TYPE ='nvarchar' OR DATA_TYPE ='text' OR DATA_TYPE = 'ntext')
	AND TABLE_NAME = @table AND table_schema = @Schema
OPEN c1
WHILE (1=1)
BEGIN
	FETCH c1 INTO @column
	IF @@FETCH_STATUS <> 0 BREAK
	SET @Ask = 'select ['+ @column + '] from ['+@Schema+'].['+ @table+ '] where ['+@column+'] like '+ '''%' + @stringToFind + '%'''
	EXECUTE (@Ask)
	SET @count = @count + @@ROWCOUNT
END
CLOSE c1
DEALLOCATE c1
RETURN @count

DECLARE @a INT
EXECUTE @a = SalesLT.uspFindStringInTable 'SalesLT', 'Product', 'Bike'
PRINT @a
GO
--------------------------------------------------------------------------------------------------------------------------------------------
/* 2.2. �������� ������ �� ������ �������� � ��.
������ �������� ��������� ��� ������ ��������� � ������� �� ������ �� ���� �������������
���������� �������� �������� �� �� ������ ���� ������ �� ���� ������ � ������ ��������� ����� ��
���� ��������. ���������� ������ �� ���� �� ���� ���������� ������ ������������ � ���������
����: ��� ������ �� ������, � ������� �� ����� ���������, � ������ ������ ��������� ���� ��
������� (������������ PRINT) */
--------------------------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT ON

DECLARE @schema NVARCHAR(2000)
DECLARE @tablename NVARCHAR(2000)

DECLARE @search NVARCHAR(2000) = 'Bike'

DECLARE @rowscount INT
DECLARE c2 CURSOR LOCAL FAST_FORWARD
FOR
	SELECT DISTINCT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS

OPEN c2
WHILE (1=1)
BEGIN
	FETCH c2 INTO @schema, @tablename
	IF @@FETCH_STATUS <> 0 BREAK
	BEGIN TRY
		EXECUTE @rowscount = SalesLT.uspFindStringInTable @schema, @tablename, @search
	END TRY
	BEGIN CATCH
		PRINT '������ �������';
		PRINT ERROR_MESSAGE();
	END CATCH;
	IF @rowscount <> 0
		PRINT '� ������� '+@schema+'.'+@tablename+' ������� �����: '+ CAST(@rowscount AS NVARCHAR(2000))
	IF @rowscount = 0
		PRINT '� ������� '+@schema+'.'+@tablename+' �� ������� ����� ����������'
END
CLOSE c2
DEALLOCATE c2

SELECT * FROM dbo.BuildVersion