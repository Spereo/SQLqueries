/* Задача 1: Извлечение данных по клиентам
--1.1 Получить сведения о клиентах */
SELECT * FROM SalesLT.Customer

--1.2 Получить данные по имени клиента
SELECT Title, FirstName, MiddleName, LastName, Suffix FROM SalesLT.Customer

--1.3  Получить имена клиентов и номера телефонов
SELECT SalesPerson, Title+' '+LastName as CustomerName, Phone FROM SalesLT.Customer

/* Задача 2: Получение данных о клиентах и продажах
2.1 Получить список компаний-клиентов */
SELECT CAST(CustomerID AS nvarchar) + ': ' + CompanyName AS CustomerCompany FROM SalesLT.Customer

--2.2 Получить список изменений заказа клиента
SELECT CAST (SalesOrderID AS nvarchar) +' '+' ('+ CAST (RevisionNumber AS nvarchar)+')' AS OrderRevision, CONVERT (nvarchar, OrderDate,102) AS OrderDate FROM SalesLT.SalesOrderHeader

/*Задача 3: Получить контактную информацию клиента
3.1 Получить имена контактов с отчествами, если они известны */
SELECT FirstName+ ' ' +  ISNULL(MiddleName + ' ', '')+ LastName AS CustomerName FROM SalesLT.Customer

--3.2 Получить первичные контактные данные
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;
SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact FROM SalesLT.Customer

--3.3 Получить статус доставки
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

SELECT SalesOrderID, OrderDate, 
		CASE
			WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
			ELSE 'Shipped'
			END AS ShippingStatus
			FROM SalesLT.SalesOrderHeader


