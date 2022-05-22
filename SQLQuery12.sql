/* 1.1. Напишите код для получения всех текстовых столбцов в таблице товаров.
Поскольку искать данные Вам необходимо только в строковых столбцах таблицы, Вам необходимо
получить список всех названий столбцов со строковым типом (char, nchar, varchar, nvarchar, text,
ntext) из таблицы товаров. Поскольку Вы хотите написать код, пригодный для поиска данных в
любых таблицах, Вы принимаете решение об использовании названия таблицы и названия схемы
БД из локальных переменных). В результате Вы должны вернуть выборку со столбцами
ColumnName (название столбца) и Type (тип данных столбца), содержащую только текстовые
столбцы. Привести запрос для таблицы SalesLT.Product. */
--------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @Name AS NVARCHAR(20) = 'Product'
DECLARE @Schema AS NVARCHAR(20) = 'SalesLT'
--PRINT @Name
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE (DATA_TYPE = 'nvarchar' OR DATA_TYPE ='char' OR DATA_TYPE ='nchar' OR DATA_TYPE ='varchar' OR DATA_TYPE ='nvarchar' OR DATA_TYPE ='text' OR DATA_TYPE = 'ntext')
AND TABLE_NAME = @Name AND table_schema = @Schema
GO
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2. Напишите код, для поиска значения в текстовых столбцах таблицы.
Из предыдущего задания Вам стали известны для выбранной таблицы столбцы, в которых надо
осуществлять поиск. Теперь Вы решаете написать SQL-скрипт для создания строки SQL-запроса,
который возвращал бы те строки из таблицы, которые содержат искомое значение в любом
текстовом столбце. Взяв за основу запрос из предыдущего задания, напишите SQL-скрипт для
поиска произвольного значения (подстроки – значение для поиска необходимо задавать через
переменную) в текстовом столбце (строки) произвольной таблице (результирующий запрос должен
возвращать все столбцы из таблицы). Вы решаете позаботиться об отладке – для этого Вам
необходимо вывести текст сформированного SQL-запроса на экран с помощью оператора PRINT.
Для демонстрации работоспособности получившегося сценария выполните поиск значения «Bike»
в таблице SalesLT.Product.*/
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
/* 2.1. Создание хранимой процедуры.
Вы решаете оформить результат, полученный в первой задаче, в виде хранимой процедуры с
именем SalesLT.uspFindStringInTable. На вход процедура должна принимать три строковых
параметра.
В качестве результата хранимая процедура должна возвращать набор данных, состоящий из всех
столбцов таблицы и строк, в которых была найдена исходная подстрока. Дополнительно хранимая
процедура должна возвращать в качестве кода возврата (RETURN) количество строк в
результирующей выборке. Протестируйте хранимую процедуру с данными из задания 1.2. */
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
/* 2.2. Создание отчета по поиску значения в БД.
Создав хранимую процедуру для поиска подстроки в таблице Вы должны за счет использования
системного каталога получить из БД список всех таблиц во всех схемах и искать подстроку сразу во
всех таблицах. Результаты поиска по всей БД Ваше начальство просит предоставить в текстовом
виде: для каждой из таблиц, в которых Вы ищете подстроку, в отчете должна появиться одна из
записей (используется PRINT) */
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
		PRINT 'Ошибка доступа';
		PRINT ERROR_MESSAGE();
	END CATCH;
	IF @rowscount <> 0
		PRINT 'В таблице '+@schema+'.'+@tablename+' найдено строк: '+ CAST(@rowscount AS NVARCHAR(2000))
	IF @rowscount = 0
		PRINT 'В таблице '+@schema+'.'+@tablename+' не найдено строк совпадений'
END
CLOSE c2
DEALLOCATE c2

SELECT * FROM dbo.BuildVersion