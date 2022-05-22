/* 1.1. �������� ������, ������� ���������� ������������� ��� ������� ������ ������ � �������������
������, ��������������� � �������� �������� � ������� ProductName � ������� � ������ ApproxWeight �
����� ������� ������, ����������� �� ���������� ������. */
SELECT pr.ProductID, UPPER(pr.Name) AS ProductName, CEILING(ROUND(pr.Weight, 0)) AS ApproxWeight FROM SalesLT.Product AS pr

/* 1.2. ��������� ���� ������, ����� �������� ������� � ������� SellStartYear � SellStartMonth, ���������� ���
� �����, � ������� Adventure Works ������ ��������� ������ �����. ����� ������ ���������� ��������
������ (��������, �January�). */
SELECT pr.ProductID,
	UPPER(pr.Name) AS ProductName,
	ROUND(pr.Weight, 0) AS ApproxWeight,
	YEAR(pr.SellStartDate) AS SellStartYear,
	DATENAME(mm, pr.SellStartDate) AS SellStartMonth
FROM SalesLT.Product AS pr

/* 1.3. ��������� ���� ������, ����� �������� ������� � ������ ProductType, ������� �������� ����� �����
��� ������� �� ������ ������ (������� ProductNumber). */
SELECT pr.ProductID,
	UPPER(pr.Name) AS ProductName,
	ROUND(pr.Weight, 0) AS ApproxWeight,
	YEAR(pr.SellStartDate) AS SellStartYear,
	DATENAME(mm, pr.SellStartDate) AS SellStartMonth,
	SUBSTRING(pr.ProductNumber, 1, 2) AS ProductType
FROM SalesLT.Product AS pr

/* 1.4. ��������� ���� ������ ������������ ������������ ������, ����� �������� ������ �� �� ���, �������
����� �������� ������. */
SELECT pr.ProductID,
	UPPER(pr.Name) AS ProductName,
	ROUND(pr.Weight, 0) AS ApproxWeight,
	YEAR(pr.SellStartDate) AS SellStartYear,
	DATENAME(mm, pr.SellStartDate) AS SellStartMonth,
	LEFT(pr.ProductNumber, 2) AS ProductType --��� SUBSTRING(pr.ProductNumber, 1, 2) AS ProductType
FROM SalesLT.Product AS pr
WHERE ISNUMERIC(pr.Size) = 1

/* 2.1. �������� ������, ������� ���������� ������ �������� �������� (������� CompanyName) � TotalDue (�
������� Revenue) � ���� (�� ���������� �������� TotalDue) �� ������� SalesOrderHeader � �������
RankByRevenue. */
SELECT cu.CompanyName, 
	soh.TotalDue AS Revenue,
	DENSE_RANK() OVER (ORDER BY TotalDue DESC) RankByRevenue
FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)

/* 3.1. �������� ������ ��� ���������� ������ ������������ ������� (������� Name) � �������� �����
(������� TotalRevenue), ������������ ��� ����� LineTotal �� ������� SalesLT.SalesOrderDetail. ����������
������������ �� �������� ����� �������. */
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue FROM SalesLT.Product AS pr
INNER JOIN SalesLT.SalesOrderDetail AS sod ON (pr.ProductID = sod.ProductID)
GROUP BY Name

/* 3.2. �������� ���������� ������ ���, ����� �� ������� ������ �������� �������� �� �������, ���� ��
������� ��������� 1000 �������� ���. */
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue FROM SalesLT.Product AS pr
INNER JOIN SalesLT.SalesOrderDetail AS sod ON (pr.ProductID = sod.ProductID)
WHERE sod.LineTotal > 1000
GROUP BY Name

/* 3.3. �������� ���������� ������, ����� �� ������� ������ �� ������ �������, ����� ��������� ������
������� ��������� 20 000 ��������. */
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue FROM SalesLT.Product AS pr
INNER JOIN SalesLT.SalesOrderDetail AS sod ON (pr.ProductID = sod.ProductID)
WHERE sod.LineTotal > 1000
GROUP BY Name
HAVING SUM(sod.LineTotal) > 20000