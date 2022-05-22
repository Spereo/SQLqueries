/* 1.1. Отдел продаж планирует ввести для клиентов ряд новых акций, которые зависят от потраченной
клиентом суммы. Поэтому Вас просят написать функцию с именем fn_GetOrdersTotalDueForCustomer,
принимающую один входной параметр @CustomerID (идентификатор клиента) и возвращающую
общую сумму, потраченную клиентом на оплату всех заказов (т.е. сумму TotalDue). Приведите
примеры использования написанной функции для клиентов с идентификаторами 1 и 30113. */
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
/* 1.2. Отдел продаж проводит ревизию адресов клиентов и Вам поручили создать представление
vAllAddresses для отображения всех типов адресов всех клиентов. Представление должно содержать
следующие атрибуты: CustomerID, AddressType, AddressID, AddressLine1, AddressLine2, City,
StateProvince, CountryRegion, PostalCode. Протестируйте созданное представление. */
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
/* 1.3. Вам необходимо для оформления карточки клиента реализовать функцию
fn_GetAddressesForCustomer, возвращающую все адреса для конкретного клиента (входной параметр
@CustomerID – идентификатор клиента) из ранее созданного представления vAllAddresses.
Возвращаемый набор данных должен содержать все доступные атрибуты из представления.
Протестируйте созданную функцию – напишите запрос, возвращающий адреса клиентов в виде
одного набора данных для клиентов с идентификаторами 0, 29502 и 29503. */
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
/* 1.4. Для получения статистики по продажам товаров компании Вас просят создать функцию
fn_GetMinMaxOrderPricesForProduct, принимающую на вход идентификатор товара @ProductID и
возвращающую строку с двумя столбцами: MinUnitPrice и MaxUnitPrice, содержащий соответственно
минимальную и максимальную цену (из столбца UnitPrice) за которую был продан данный товар.
Провести тестирование функции для товаров с идентификаторами 0 и 711. */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION SalesLT.fn_GetMinMaxOrderPricesForProduct(@ProductID int)
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @MinUnitPrice nvarchar(10), @MaxUnitPrice nvarchar(10)
	SELECT @MinUnitPrice = (SELECT CONVERT(nvarchar(10), MIN(UnitPrice)) FROM SalesLT.SalesOrderDetail WHERE ProductID = @ProductID)
	SELECT @MaxUnitPrice = (SELECT CONVERT(nvarchar(10), MAX(UnitPrice)) FROM SalesLT.SalesOrderDetail WHERE ProductID = @ProductID)
	RETURN 'Минимальная цена: ' + @MinUnitPrice + ', максимальная цена: ' + @MaxUnitPrice
END;
GO

SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(0)
SELECT SalesLT.fn_GetMinMaxOrderPricesForProduct(711)
GO
--DROP FUNCTION SalesLT.fn_GetMinMaxOrderPricesForProduct
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.5. Отдел маркетинга хочет удостовериться, что все описания продаваемых товаров четко описывают
информацию. Вас просят написать функцию fn_GetAllDescriptionsForProduct, которая возвращает все
описания для товара. Функция принимает на вход идентификатор товара @ProductID и возвращает
все найденные для данного товара описания в виде кортежей со следующими атрибутами: ProductID,
Name, MinUnitPrice, MaxUnitPrice, ListPrice, ProductModel, Culture, Description. Здесь Name –
наименование товара, MinUnitPrice, MaxUnitPrice – результат для товара из функции
fn_GetMinMaxOrderPricesForProduct, ListPrice – розничная цена, ProductModel – поле Name из
таблицы ProductModel, Culture – язык описания из таблицы ProductModelProductDescription,
Description – описание из таблицы ProductDescription. Подсказка: используйте представление
vProductAndDescription для сокращения количества соединений в запросе и улучшении его
читаемости. Провести тестирование функции для товаров с идентификаторами 0 и 711. */
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
/* 2.1. Вы ожидаете бурный рост числа клиентов, а значит и их адресов в базу данных. Вместе с этим
приходит понимание, что некоторые часто используемые представления могут быть оптимизированы
для улучшения скорости доступа к данным. Вы решаете создать уникальный кластерный индекс на
представлении vAllAddresses из задания о получении всех типов адресов клиентов. */
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