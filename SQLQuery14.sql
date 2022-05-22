/* 1.1. ����� ������ ��������� ������ ��� �������� ��� ����� �����, ������� ������� �� �����������
�������� �����. ������� ��� ������ �������� ������� � ������ fn_GetOrdersTotalDueForCustomer,
����������� ���� ������� �������� @CustomerID (������������� �������) � ������������
����� �����, ����������� �������� �� ������ ���� ������� (�.�. ����� TotalDue). ���������
������� ������������� ���������� ������� ��� �������� � ���������������� 1 � 30113. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION SalesLT.fn_GetOrdersTotalDueForCustomer(@CustomerID int)
RETURNS int
AS
BEGIN
	DECLARE @TotalDue int 
	SELECT @TotalDue = (SELECT SUM(TotalDue) From SalesLT.SalesOrderHeader WHERE CustomerID = @CustomerID)
	RETURN @TotalDue
END;
GO

SELECT SalesLT.fn_GetOrdersTotalDueForCustomer(1)
SELECT SalesLT.fn_GetOrdersTotalDueForCustomer(30113)
GO
--DROP FUNCTION SalesLT.fn_GetOrdersTotalDueForCustomer
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2. ����� ������ �������� ������� ������� �������� � ��� �������� ������� �������������
vAllAddresses ��� ����������� ���� ����� ������� ���� ��������. ������������� ������ ���������
��������� ��������: CustomerID, AddressType, AddressID, AddressLine1, AddressLine2, City,
StateProvince, CountryRegion, PostalCode. ������������� ��������� �������������. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW SalesLT.vAllAddresses
AS
	SELECT CustomerID, AddressType, ad.AddressID, ad.AddressLine1,  ad.AddressLine2, City, StateProvince, CountryRegion, PostalCode
	FROM SalesLT.CustomerAddress AS cad
	INNER JOIN SalesLT.Address AS ad ON cad.AddressID = ad.AddressID;
GO

SELECT * FROM SalesLT.vAllAddresses
GO
--DROP VIEW SalesLT.vAllAddresses
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.3. ��� ���������� ��� ���������� �������� ������� ����������� �������
fn_GetAddressesForCustomer, ������������ ��� ������ ��� ����������� ������� (������� ��������
@CustomerID � ������������� �������) �� ����� ���������� ������������� vAllAddresses.
������������ ����� ������ ������ ��������� ��� ��������� �������� �� �������������.
������������� ��������� ������� � �������� ������, ������������ ������ �������� � ����
������ ������ ������ ��� �������� � ���������������� 0, 29502 � 29503. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION SalesLT.fn_GetAddressesForCustomer(@CustomerID int)
RETURNS nvarchar(300)
AS
BEGIN
	DECLARE @Address nvarchar(300);
	SELECT @Address = (SELECT CONVERT(nvarchar(10), CustomerID) + AddressType + CONVERT(nvarchar(10), ad.AddressID) + ad.AddressLine1
		+ ad.AddressLine2 + City + StateProvince + CountryRegion + PostalCode FROM SalesLT.CustomerAddress AS cad
	INNER JOIN SalesLT.Address AS ad ON cad.AddressID = ad.AddressID WHERE CustomerID = @CustomerID)
	RETURN @Address
END;
GO

SELECT SalesLT.fn_GetAddressesForCustomer(0)
SELECT SalesLT.fn_GetAddressesForCustomer(29502)
SELECT SalesLT.fn_GetAddressesForCustomer(29503)
GO
--DROP FUNCTION SalesLT.fn_GetAddressesForCustomer
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.4. ��� ��������� ���������� �� �������� ������� �������� ��� ������ ������� �������
fn_GetMinMaxOrderPricesForProduct, ����������� �� ���� ������������� ������ @ProductID �
������������ ������ � ����� ���������: MinUnitPrice � MaxUnitPrice, ���������� ��������������
����������� � ������������ ���� (�� ������� UnitPrice) �� ������� ��� ������ ������ �����.
�������� ������������ ������� ��� ������� � ���������������� 0 � 711. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION SalesLT.fn_GetMinMaxOrderPricesForProduct(@ProductID int)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @MinUnitPrice nvarchar(10), @MaxUnitPrice nvarchar(10)
	SELECT @MinUnitPrice = (SELECT CONVERT(nvarchar(10), MIN(UnitPrice)) FROM SalesLT.SalesOrderDetail WHERE ProductID = @ProductID)
	SELECT @MaxUnitPrice = (SELECT CONVERT(nvarchar(10), MAX(UnitPrice)) FROM SalesLT.SalesOrderDetail WHERE ProductID = @ProductID)
	RETURN '����������� ����: ' + @MinUnitPrice + ', ������������ ����: ' + @MaxUnitPrice
END;
GO

SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(0)
SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(711)
GO
--DROP FUNCTION SalesLT.fn_GetMinMaxOrderPricesForProduct
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.5. ����� ���������� ����� ��������������, ��� ��� �������� ����������� ������� ����� ���������
����������. ��� ������ �������� ������� fn_GetAllDescriptionsForProduct, ������� ���������� ���
�������� ��� ������. ������� ��������� �� ���� ������������� ������ @ProductID � ����������
��� ��������� ��� ������� ������ �������� � ���� �������� �� ���������� ����������: ProductID,
Name, MinUnitPrice, MaxUnitPrice, ListPrice, ProductModel, Culture, Description. ����� Name �
������������ ������, MinUnitPrice, MaxUnitPrice � ��������� ��� ������ �� �������
fn_GetMinMaxOrderPricesForProduct, ListPrice � ��������� ����, ProductModel � ���� Name ��
������� ProductModel, Culture � ���� �������� �� ������� ProductModelProductDescription,
Description � �������� �� ������� ProductDescription. ���������: ����������� �������������
vProductAndDescription ��� ���������� ���������� ���������� � ������� � ��������� ���
����������. �������� ������������ ������� ��� ������� � ���������������� 0 � 711. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION SalesLT.fn_GetAllDescriptionsForProduct(@ProductID int)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @Result nvarchar(1000), @R1 nvarchar(1000), @R2 nvarchar(300)
	SELECT @R1 = (SELECT CONVERT(nvarchar(10), ProductID) + Name + ProductModel + Culture + Description
	FROM SalesLT.vProductAndDescription WHERE @ProductID = ProductID)
	SELECT @R2 = (SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(@ProductID))
	SET @Result = @R1 + @R2
	RETURN @Result
END;
GO

SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(0)
SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(771)
GO
--DROP FUNCTION SalesLT.fn_GetAllDescriptionsForProduct
--------------------------------------------------------------------------------------------------------------------------------------------
/* 2.1. �� �������� ������ ���� ����� ��������, � ������ � �� ������� � ���� ������. ������ � ����
�������� ���������, ��� ��������� ����� ������������ ������������� ����� ���� ��������������
��� ��������� �������� ������� � ������. �� ������� ������� ���������� ���������� ������ ��
������������� vAllAddresses �� ������� � ��������� ���� ����� ������� ��������. */
--------------------------------------------------------------------------------------------------------------------------------------------
--SELECT * FROM SalesLT.vAllAddresses
ALTER VIEW SalesLT.vAllAddresses
WITH SCHEMABINDING
AS
SELECT CustomerID, AddressType, ad.AddressID, ad.AddressLine1,  ad.AddressLine2, City, StateProvince, CountryRegion, PostalCode
FROM SalesLT.CustomerAddress AS cad
INNER JOIN SalesLT.Address AS ad ON cad.AddressID = ad.AddressID;
GO

CREATE UNIQUE CLUSTERED INDEX UIX_vAllAddresses
	ON SalesLT.vAllAddresses(CustomerID, AddressType, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode);
GO

SELECT * FROM SalesLT.vAllAddresses WITH (NOEXPAND)