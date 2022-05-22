/* 1.1. �������� ������������� ������, �������� ������ (������� ProductName), �������� ������ ������ (�������
ProductModel) � �������� ������ ������ (������� Summary) ��� ������� ������ �� ������� SalesLT.Product �
����������� SalesLT.vProductModelCatalogDescription, ���������� ���������� �� �������������� ������. */
SELECT pr.ProductID, pr.Name AS ProductName, descr.Name AS ProductModel, descr.Summary FROM SalesLT.Product AS pr
INNER JOIN SalesLT.vProductModelCatalogDescription AS descr
ON pr.ProductModelID = descr.ProductModelID
ORDER BY pr.ProductID


/* 1.2. �������� ��������� ���������� � ��������� �� ������� ���������� ������ �� ������� SalesLT.Product. �����
����������� ��������� ����������, ����� ������������� ������, ������� ���������� ������������� ������,
�������� ������ (������� ProductName) � ���� (������� Color) �� ������� SalesLT.Product, ������������ ��
������ ���, ����� ������������ ������ �� ������, ����� ������� ����������� � ��������� ����������. */
DECLARE @DColors TABLE (Color varchar(15))
INSERT INTO @DColors SELECT DISTINCT Color FROM SalesLT.Product

SELECT ProductID, Name AS ProductName, Color FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @DColors)
ORDER BY Color


/* 1.3. �������� ��������� ������� � ��������� �� ������� ���������� �������� �� ������� SalesLT.Product. �����
����������� ��������� �������, ����� ������������� ������, ������� ���������� ������������� ������,
�������� ������ (������� ProductName) � ������ (������� Size) �� ������� SalesLT.Product, ������������ ��
�������� �� �������� ���, ����� ������������ ������ �� ������, ������� ������� ����������� �� ���������
�������. */
CREATE TABLE #DSizes (Size varchar(5))
INSERT INTO #DSizes SELECT DISTINCT Size FROM SalesLT.Product

SELECT ProductID, Name AS ProductName, Color FROM SalesLT.Product
WHERE Size IN (SELECT Size FROM #DSizes)
ORDER BY Size


/* 1.4. �� AdventureWorksLT �������� ��������� ������� dbo.ufnGetAllCategories, ������� ���������� �������
�������� ��������� (�������� �Road Bikes�) � �� ������������ ��������� (�������� �Bikes�). �������� ������,
������� ���������� ��� �������, ����� ������� ������ ���� ������� (������� ProductID, ProductName) ������� ��
������������ ��������� (������� ParentCategory) � ��������� (������� Category), ������������� ��
���������������� ������� ���� ��������� (�.�. �������� ���������, ������� �������� ������������ ���������)
� �������� ������. */
SELECT pr.ProductID, pr.Name AS ProductName, gac.ParentProductCategoryName AS ParentCategory,
gac.ProductCategoryName AS Category FROM SalesLT.Product AS pr
INNER JOIN dbo.ufnGetAllCategories() AS gac
ON pr.ProductCategoryID = gac.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName


/* 2.1. �������� ������ �������� � ������� ���������_�������� (���_�������� �������_��������)� � �������
CompanyContact (��������, �������� ����� ���� �Action Bicycle Specialists (Terry Eminhizer)�), ��������
���������� ������� (����� �������� TotalDue) ��� ����� ������� (������� Revenue). ����������� �����������
�������, ����� �������� �������� �� ������� ������ � ����� ��������� ������ � ���������� �����������
�������, ����� ������������� ������. ���������� ������ ���� ����������� �� ��������� � CompanyContact. */
SELECT CompanyContact, SUM(TotalDue) AS Revenue FROM
(SELECT (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') AS CompanyContact, TotalDue FROM SalesLT.Customer AS cus
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON cus.CustomerID = soh.CustomerID) AS cn
GROUP BY CompanyContact
ORDER BY CompanyContact;


/* 2.2. ���������� ���������� ������ � ������� CTE (����������� ���������� ���������) ������ ����������� ������. */
WITH Client (CompanyContact, TotalDue)
AS
(
	SELECT (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') AS CompanyContact, soh.TotalDue FROM SalesLT.Customer AS cus
	INNER JOIN SalesLT.SalesOrderHeader AS soh
	ON cus.CustomerID = soh.CustomerID
)
SELECT CompanyContact, SUM(TotalDue) AS Revenue FROM Client
GROUP BY CompanyContact
ORDER BY CompanyContact