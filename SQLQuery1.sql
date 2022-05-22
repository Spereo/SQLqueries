/* ������ 1: ���������� ������ �� ��������
--1.1 �������� �������� � �������� */
SELECT * FROM SalesLT.Customer

--1.2 �������� ������ �� ����� �������
SELECT Title, FirstName, MiddleName, LastName, Suffix FROM SalesLT.Customer

--1.3  �������� ����� �������� � ������ ���������
SELECT SalesPerson, Title+' '+LastName as CustomerName, Phone FROM SalesLT.Customer

/* ������ 2: ��������� ������ � �������� � ��������
2.1 �������� ������ ��������-�������� */
SELECT CAST(CustomerID AS nvarchar) + ': ' + CompanyName AS CustomerCompany FROM SalesLT.Customer

--2.2 �������� ������ ��������� ������ �������
SELECT CAST (SalesOrderID AS nvarchar) +' '+' ('+ CAST (RevisionNumber AS nvarchar)+')' AS OrderRevision, CONVERT (nvarchar, OrderDate,102) AS OrderDate FROM SalesLT.SalesOrderHeader

/*������ 3: �������� ���������� ���������� �������
3.1 �������� ����� ��������� � ����������, ���� ��� �������� */
SELECT FirstName+ ' ' +  ISNULL(MiddleName + ' ', '')+ LastName AS CustomerName FROM SalesLT.Customer

--3.2 �������� ��������� ���������� ������
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;
SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact FROM SalesLT.Customer

--3.3 �������� ������ ��������
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

SELECT SalesOrderID, OrderDate, 
		CASE
			WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
			ELSE 'Shipped'
			END AS ShippingStatus
			FROM SalesLT.SalesOrderHeader


