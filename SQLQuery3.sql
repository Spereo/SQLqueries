SELECT * FROM SalesLT.Customer
SELECT * FROM SalesLT.SalesOrderHeader
SELECT * FROM SalesLT.Address
SELECT * FROM SalesLT.CustomerAddress

/* 1.1. � �������� ������� ���� �� �������� ������ �� ������ �������� ������, ������� ���������� �������� �������� (CompanyName) �� ������� SalesLT.Customer,
� ����� ������������� ������ (SalesOrderID) � �������� ��������� (TotalDue) �� ������� SalesLT.SalesOrderHeader. */
SELECT cu.CompanyName, soh.SalesOrderID, soh.TotalDue FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)

/* 1.2. ��������� ���� ���������� ������ �� ������� ��������, ����� �������� � ���� ����� �������� ����� ��� ������� �������,
������� ������ ����� (������� AddressLine1 � AddressLine2), ����� (City), ���� ��� ��������� (StateProvince), �������� ������ (PostalCode) � ������/������ (CountryRegion). */
SELECT cu.CompanyName, soh.SalesOrderID, soh.TotalDue, ad.AddressLine1, ad.AddressLine2, ad.City, ad.StateProvince, ad.PostalCode, ad.CountryRegion FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID AND ca.AddressType = 'Main Office')

/* 2.1. �������� �� �������� ������ ��������� ������ ���� ��������-�������� (CompanyName) � �� ������� � ���������� (��� � ������� � FirstName � LastName),
������� �� ��������� ������������� ������ (SalesOrderID) � ����� ����� (TotalDue) �� ������ �����, ������� ���������� �������. �������, ������� �� ���������� ������,
������ ���� �������� � ������ ����� ������ �� ���������� NULL ��� �������������� ������ � ����� �����. */
SELECT cu.CompanyName, cu.FirstName, cu.LastName, soh.SalesOrderID, soh.TotalDue FROM SalesLT.Customer AS cu
LEFT JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)
ORDER BY
	CASE
		WHEN soh.SalesOrderID IS NULL THEN 1
		ELSE 0
	END
--��� ORDER BY ordh.CustomerID DESC

/* 2.2. ��������� ������ ������ �������, ��� Adventure Works �� ����� ���������� �� ������� ��� ���� ��������.
�� ������ �������� ������, ������� ���������� ������ ��������������� ��������, �������� ��������, ���� ��������� (��� � �������) � ������ ��������� ��� ��������, �� ������� ������. */
SELECT cu.CustomerID, cu.CompanyName, cu.FirstName, cu.LastName, cu.Phone FROM SalesLT.Customer AS cu
LEFT JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
WHERE ca.AddressType IS NULL

/* 2.3. ��������� ������� ������� �� ��������� ������, � ��������� ������ ������� �� ������������.
�������� ������, ������� ���������� ������� ��������������� �������� (CustomerID) ��� ��������, ������� ������� �� ��������� ������,
� ������� ��������������� ������� (ProductID) ��� �������, ������� ������� �� ���� ��������. ������ ������ � ��������������� �������
������ ����� ������������� �������� NULL (��������� ������ ������� �� ��������� �������),
� ������ ������ � ��������������� ������ ������ ����� ������������� ������� NULL (��������� ����� ������� �� ����������� ��������). */
