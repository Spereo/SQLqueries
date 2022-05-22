/* 1.1. �������� ������������� ������, ������������ � �������������� ���� ��� ������� ������, ���
�������������� ���� ���� ������� ���� �� ������� ������ ��� ���� ��������� �������. */
SELECT ProductID, Name, ListPrice FROM SalesLT.Product
WHERE ListPrice > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail)

/* 1.2. �������� ������������� ������, ������������ � �������������� ���� ��� ������� ������, ���
�������������� ���� ���������� $100 ��� �����, � ����� ������ ����� ��� �� $100. */
SELECT ProductID, Name, ListPrice FROM SalesLT.Product
WHERE (ListPrice >= 100) AND ProductID IN (SELECT ProductID FROM SalesLT.SalesOrderDetail
WHERE UnitPrice < 100)

/* 1.3. �������� ������������� ������, ������������, ������������� (������� StandardCost) � ��������������
���� ��� ������� ������ �� ������� Products ������ �� ������� ����� ������� ������� ������� ������
� ������� AvgSellingPrice. */
SELECT pr.ProductID, pr.Name, pr.StandardCost, pr.ListPrice, 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail 
WHERE pr.ProductID=ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS pr

/* 1.4. ������������ ���������� ������ ���, ����� �������� ������ ������, ��� ������������� ���� �������
���� ������� ������. */
SELECT pr.ProductID, pr.Name, pr.StandardCost, pr.ListPrice, 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail 
WHERE pr.ProductID=ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS pr
WHERE (pr.StandardCost > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail))

/* 2.1. �������� ������������� ������, ������������� �������, ���, ������� � ����� ����� (TotalDue) ���
���� ������� �� ������� SalesLT.SalesOrderHeader � ������� dbo.ufnGetCustomerInformation.
���������� ������������� ���������� �� SalesOrderID. */
SELECT soh.SalesOrderID, p.CustomerID, p.FirstName, p.LastName, soh.TotalDue FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS P

/* 2.2. �������� ������������� �������, ���, �������, �������� ������ 1 � ����� ��� ���� �������� �� ������
SalesLT.Address � SalesLT.CustomerAddress � ������� dbo.ufnGetCustomerInformation. ����������
������������� ���������� �� CustomerID. */
SELECT ca.CustomerID, p.FirstName, p.LastName, ad.AddressLine1, ad.City
FROM  SalesLT.CustomerAddress AS ca
INNER JOIN SalesLT.Address AS ad
ON ca.AddressID = ad.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS P
ORDER BY p.CustomerID