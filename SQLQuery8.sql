/* 1.1. ��� ���������� �������� ������, ����� ���������� �������� ����� ����� ���� ������� �� ������ �
������������� ����� ��� ������ ������/������� � ���������� � ������������� ������ ��
������/����������, ������� ��� ����������. */
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY 
ROLLUP (a.CountryRegion, a.StateProvince)
--GROUPING SETS (a.CountryRegion, (a.CountryRegion, a.StateProvince), ())
ORDER BY a.CountryRegion, a.StateProvince;

/* 1.2. �������� ���� ���������� ������, ����� �������� ������� � ������ �Level�, ������� ���������, �� ����� ������
� �������� ������������ ���������� ������ � ������: ��������, ������/������ � ����/���������. ��������,
����� �������� ������ ������ ��������� �������� �Total�, ������, ������������ ������������� ���� ���
����������� ������, ������ ��������� �������� �United States Subtotal�, � ������, ������������
������������� ���� ��� ����������, ������ ��������� �������� �California Subtotal�. */
SELECT a.CountryRegion, a.StateProvince,
CHOOSE(GROUPING_ID(a.CountryRegion, a.StateProvince), a.CountryRegion + ' Subtotal', a.StateProvince + ' Subtotal', 'Total') as Level,
SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY 
GROUPING SETS (a.CountryRegion, a.StateProvince, ())
ORDER BY a.CountryRegion, a.StateProvince;

/* 1.3. ��������� ���� ���������� ������, ����� �������� ������� �City� (����� ������� StateProvince) � �����������
��� ��������� �������. �������� ������� ��� ������� �Level� ���, ����� ������, ������������ �������������
���� ��� ������ ������, ��������� �������� �London Subtotal�. �������� ������� City � ��������� ����������
�����������. */
SELECT a.CountryRegion, a.StateProvince, City, 
IIF(GROUPING_ID(a.CountryRegion, a.StateProvince, City) = 7, 'Total', IIF(GROUPING_ID(a.CountryRegion, a.StateProvince, City) = 5, a.StateProvince + ' Subtotal', IIF(GROUPING_ID(a.CountryRegion, a.StateProvince, City) = 3, a.CountryRegion + ' Subtotal', IIF(GROUPING_ID(a.CountryRegion, a.StateProvince, City) = 6, a.City + ' Subtotal', NULL)))) as Level,
--GROUPING_ID(a.CountryRegion, a.StateProvince, City) AS Level,
SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY 
GROUPING SETS (a.CountryRegion, a.StateProvince, City, ())
ORDER BY a.CountryRegion, a.StateProvince, City;

/* 2.1. �������� ������ �������� ��������-�������� (������� CompanyName), �� ����� ����� (����� �������� LineTotal
� ������� SalesLT.SalesOrderDetail) ��� ������ ������������ ��������� � �������� Accessories, Bikes, Clothing �
Components (� ��������������� �������� Accessories, Bikes, Clothing � Components). ������������ ����������
������� �� �������� ��������. */
SELECT CompanyName, Bikes, Accessories, Clothing
FROM
(SELECT c.CompanyName AS CompanyName, SUM(sod.LineTotal) AS Sum, v.ParentProductCategoryName AS Category FROM SalesLT.Customer AS c
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN SalesLT.Product AS p
ON sod.ProductID = p.ProductID
INNER JOIN SalesLT.vGetAllCategories AS v
ON p.ProductCategoryID = v.ProductCategoryID
GROUP BY v.ParentProductCategoryName, c.CompanyName) 
AS sales
PIVOT (SUM(Sum) FOR Category IN([Bikes], [Accessories], [Clothing])) AS pvt