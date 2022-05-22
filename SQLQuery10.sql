SET XACT_ABORT, NOCOUNT ON
/* 1.1. ��� ������ ��� ���������� ��������� ������ ������ ��������� ������������� ��������� ��������
��� ���� ������ (������� OrderDate), ����� ������� (������� DueDate) � �������������� �������
(������� CustomerID). ������������� SalesOrderID ������ ���� ������������ ������������� �
���������� ������������ ��������� �������� ��� ������������������
SalesLT.SalesOrderNumber � ������������� ����������. ����� ������ ������ �������� ������ �
������� SalesLT.SalesOrderHeader � �������������� ���� �������� � ������
�������������������� �������� �CARGO TRANSPORT 5� ��� ������� �������� � �� ���������� ��
��������� ��� NULL ��� ���� ��������� ��������.
����� ����, ��� ������ ������� ������, �� ������ ���������� �������������� ��������
SalesOrderID � ������� ������� PRINT. */
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
/* 1.2. ������ ��� ���������� ������ � ����� ������ ��������� ��������� ������������� ������,
������������� ������, ��������� ���������� ������ � ���� �� ������� ������. ����� ������
������ ���������, ���������� �� ��������� ������������� ������ � �������
SalesLT.SalesOrderHeader. ���� ����������, �� ������ ������ �������� ������ �� ������ � �������
SalesLT.SalesOrderDetail (��������� �������� �� ��������� ��� NULL ��� ����������� ��������).
���� ������������� ������ �� ���������� � ������� SalesLT.SalesOrderHeader, �� ������ ������
�������� ��������� ������ �� ����������. �� ������ ��������� ������� ������ � ������� �
�������������� ��������� EXISTS. */
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
	PRINT '����� �� ����������'
END
SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID=@SalesOrderID

ROLLBACK TRANSACTION
---------------------------------------------------------------------------------------------------
/* 2.1. �������� ���� WHILE, ����� �������� ���� �� ����������. */
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
--������ ���������� ����� WHILE
BEGIN
UPDATE SalesLT.Product SET ListPrice = 1.1*ListPrice WHERE ProductCategoryID in (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes')
END
--����� ���������� ����� WHILE

DECLARE @NewMaxPrice MONEY = (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID IN (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes'))
DECLARE @NewAvgPrice MONEY = (SELECT AVG(ListPrice) FROM SalesLT.Product AS p 
WHERE (SELECT ParentProductCategoryName FROM SalesLT.vGetAllCategories AS v 
WHERE v.ProductCategoryID = p.ProductCategoryID) = 'Bikes')

PRINT @NewMaxPrice
PRINT @NewAvgPrice

ROLLBACK TRANSACTION