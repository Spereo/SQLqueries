SET XACT_ABORT, NOCOUNT ON
/* 1.1. Ваш скрипт для добавления заголовка заказа должен позволять пользователям указывать значения
для даты заказа (столбец OrderDate), срока платежа (столбец DueDate) и идентификатора клиента
(столбец CustomerID). Идентификатор SalesOrderID должен быть сгенерирован автоматически –
необходимо использовать следующее значение для последовательности
SalesLT.SalesOrderNumber и присваиваться переменной. Затем скрипт должен добавить запись в
таблицу SalesLT.SalesOrderHeader с использованием этих значений и жестко
запрограммированного значения «CARGO TRANSPORT 5» для способа доставки и со значениями по
умолчанию или NULL для всех остальных столбцов.
После того, как скрипт добавил запись, он должен отобразить использованное значение
SalesOrderID с помощью команды PRINT. */
BEGIN TRANSACTION

DECLARE @OrderDate DATETIME = GETDATE()
DECLARE @DueDate DATETIME = DATEADD(d, 7, GETDATE())
DECLARE @CustomerID INT = 1
DECLARE @ID INT = NEXT VALUE FOR SalesLT.SalesOrderNumber

INSERT INTO SalesLT.SalesOrderHeader (SalesOrderID, CustomerID, OrderDate, DueDate, ShipMethod) 
VALUES (@ID, @CustomerID, @OrderDate, @DueDate, 'CARGO TRANSPORT 5')
SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID=@ID
PRINT @ID

ROLLBACK TRANSACTION
--SELECT * FROM SalesLT.SalesOrderHeader
---------------------------------------------------------------------------------------------------
/* 1.2. Скрипт для добавления товара в заказ должен позволять указывать идентификатор заказа,
идентификатор товара, проданное количество товара и цену за единицу товара. Затем скрипт
должен проверить, существует ли указанный идентификатор заказа в таблице
SalesLT.SalesOrderHeader. Если существует, то скрипт должен добавить данные по товару в таблицу
SalesLT.SalesOrderDetail (используя значения по умолчанию или NULL для неуказанных столбцов).
Если идентификатор заказа не существует в таблице SalesLT.SalesOrderHeader, то скрипт должен
выводить сообщение «Заказ не существует». Вы можете проверить наличие записи в таблице с
использованием предиката EXISTS. */
BEGIN TRANSACTION

DECLARE @SalesOrderID INT = @ID
DECLARE @ProductID INT = 760
DECLARE @OrderQty INT = 1
DECLARE @UnitPrice MONEY = 782.99

IF EXISTS (SELECT SalesOrderID FROM SalesLT.SalesOrderHeader WHERE SalesOrderID=@SalesOrderID)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice) VALUES (@SalesOrderID, @ProductID, @OrderQty, @UnitPrice)
END
ELSE
BEGIN
	PRINT 'Заказ не существует'
END
SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID=@SalesOrderID

ROLLBACK TRANSACTION
---------------------------------------------------------------------------------------------------
/* 2.1. Напишите цикл WHILE, чтобы обновить цены на велосипеды. */
--SELECT * FROM SalesLT.vGetAllCategories
BEGIN TRANSACTION

DECLARE @MaxPrice MONEY = 5000
DECLARE @AvgPrice MONEY = 2000

WHILE 
(@AvgPrice > (SELECT AVG(ListPrice) FROM SalesLT.Product
WHERE ProductCategoryID IN (SELECT ProductCategoryID FROM SalesLT.vGetAllCategories
WHERE ParentProductCategoryName = 'Bikes')))
AND
(@MaxPrice > (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID in (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes')))
--Начало выполнения блока WHILE
BEGIN
UPDATE SalesLT.Product SET ListPrice = 1.1*ListPrice WHERE ProductCategoryID in (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes')
END
--Конец выполнения блока WHILE

DECLARE @NewMaxPrice MONEY = (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID IN (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes'))
DECLARE @NewAvgPrice MONEY = (SELECT AVG(ListPrice) FROM SalesLT.Product AS p 
WHERE (SELECT ParentProductCategoryName FROM SalesLT.vGetAllCategories AS v 
WHERE v.ProductCategoryID = p.ProductCategoryID) = 'Bikes')

PRINT @NewMaxPrice
PRINT @NewAvgPrice

ROLLBACK TRANSACTION