/* 1.1 �������� Adventure Works ������ ��������� ����� �����. �������� ��� � ������� SalesLT.Product,
��������� �������� �� ��������� ��� NULL ��� ����������� �������� (����������� ��������� � ����
���������� ������� ��������): */
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) VALUES ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE())
--SELECT IDENT_CURRENT('SalesLT.Product')
--SELECT * FROM SalesLT.Product
--SELECT SCOPE_IDENTITY()
/* ����� ����, ��� �� �������� �����, �������� � ��������� ������, ����� ���������� ��������
ProductID, ������� ���� ������������� (������ ������ ���������� ������ ������� ProductID). �����
�������� � ��������� ������, ����� ����������� ��� ������ ������� (��� �������) ��� ������������
���� ������ � ������� SalesLT.Product. */
SELECT ProductID FROM SalesLT.Product WHERE ProductCategoryID = IDENT_CURRENT('SalesLT.Product')
SELECT * FROM SalesLT.Product WHERE ProductCategoryID = IDENT_CURRENT('SalesLT.Product')
-------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2 �������� Adventure Works ��������� � ���� ������� ��������� ������� �Bells and Horns�.
������������� ������������ ��������� ��� ����� ��������� = 4 (Accessories). ��� ����� ���������
�������� � ���� ��� ����� ������.
�������� ������, ����� �������� ����� ��������� ������� �Bells and Horns�, � ����� �������� ���
����� ������ � ��������������� ��������� ProductCategoryID (���������� ����������
������������� ��������� �Bells and Horns� �� ����� ������� � ����� ����������� ��� ��� ����������
����� �������; ����������� ��������� � ����� ��������� ���� ��������).*/
INSERT INTO SalesLT.ProductCategory (Name, ParentProductCategoryID) VALUES ('Bells and Horns', 4)

DECLARE @id int = IDENT_CURRENT('SalesLT.ProductCategory')
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) 
VALUES ('Bicycle Bell', 'BB-RING', 2.47, 4.99, @id, GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @id, GETDATE())

/* ����� ����, ��� �� �������� ������, �������� ���� ������ � ���� �������� SalesLT.Product �
SalesLT.ProductCategory, ����� ���������, ��� ������ ���� ��������� �������. */
SELECT p.Name, p.ProductNumber, p.StandardCost, p.ListPrice, p.ProductCategoryID, p.SellStartDate, c.ProductCategoryID, c.ParentProductCategoryID 
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS c
ON c.ProductCategoryID = p.ProductCategoryID
WHERE (ParentProductCategoryID = IDENT_CURRENT('SalesLT.Product'))
-------------------------------------------------------------------------------------------------------------------------------------------
/* 2.1. �������� �� �������� � �������� Adventure Works ������ ������� �� 10 % �������� ���� ��� ����
������� �� ��������� �Bells and Horns�. �������� ������ � ������� SalesLT.Product ��� ���� �������,
����� ��������� �� ���� (������� ListPrice) �� 10% (���������� �� ��������� ������� �� ��������). */
UPDATE SalesLT.Product
SET ListPrice = 1.1*(ListPrice)
WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns')
-------------------------------------------------------------------------------------------------------------------------------------------
/* 2.2. ����� ����� �LED Lights�, ������� �� �������� ������ ������, ������ �������� ��� ����������
�������� ��������. �������� ������� SalesLT.Product, ����� ���������� �������� ��������� � ����
DiscontinuedDate ��� ���� ������� � ��������� �Lights� (���������� ����� ProductCategoryID = 37),
����� ������ �LED Lights�, ������� �� �������� ����� (���������� ����� ProductNumber �LT-L123�). */
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ((ProductCategoryID = 37) AND (ProductNumber != 'LT-L123'))
-------------------------------------------------------------------------------------------------------------------------------------------
/* 3.1. ������� ������ ��������� �Bells and Horns� � �� �������. �� ������ ���������, ��� �� �������� ������
�� ������ � ���������� �������, ����� �������� ��������� ����������� �������� ����� (����������
�� ��������� ������� �� �����). */
DELETE FROM SalesLT.Product WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns')
DELETE FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns'
-------------------------------------------------------------------------------------------------------------------------------------------