/* 1.1. �������� ��� �������� ���������� ������� ����������� ���.
��������� ����� ������ ����������� � �� ���������� ���������, ��� ������� ������
������������� ���������� ������� ��� ���������� �������� ���, ������� �� ��������� ������
������� (��� ������� �� ������� Product), ������� �������� ��������� �������. ���� ����� ������
����������� � ���������� ������� ������� �������� 20-������� ������� � ���� �������� �
<����������> �������, � ��������� ������ ������� '������� 20-������� ������� � ����
���������' */
--------------------------------------------------------------------------------------------------------------------------------------------
--SELECT * FROM SalesLT.Product
SELECT * FROM SalesLT.Product AS p
WHERE (ListPrice > (SELECT 20 * MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID))
	OR (ListPrice * 20 < (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID))
DECLARE @Count AS INT = @@ROWCOUNT
IF (@Count > 0)
	PRINT '������� 20-������� ������� � ���� �������� � ' + CAST(@Count AS NVARCHAR(4)) + ' �������'
ELSE 
	PRINT '������� 20-������� ������� � ���� ���������'
GO
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2. �������� ������� ��� ����������� ������� 20-������� ������� � ��������� ����.
��� �������� �������� ������� � ������ SalesLT.TriggerProductListPriceRules, ������� ������
������������ � �� ������� 20-������� ������� � ��������� ���� ������� �� ����� �������.
�������� ���������� �������� � �������� ��������� ������, ������� �������� ������� 20-�������
������� � ����, �������� ��� ���� ������������ ������������� ������ ������� 50001 �
���������� ��������� ��������� �������� ������� 20-������� ������� � ���� ������� �� �����
������� (������� ������)� ��� ��������� ��������� �������� ������� 20-������� ������� � ����
������� �� ����� ������� (������� ������)� */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER SalesLT.TriggerProductListPriceRules
ON SalesLT.Product
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted AS ins WHERE (ListPrice > (SELECT 20 * MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = ins.ProductCategoryID)))
	BEGIN
		ROLLBACK;
		THROW 50001, '�������� ��������� �������� ������� 20-������� ������� � ���� ������� �� ����� ������� (������� ������)', 1
	END
	IF EXISTS(SELECT * FROM inserted AS ins WHERE (ListPrice * 20 < (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = ins.ProductCategoryID)))
	BEGIN
		ROLLBACK;
		THROW 50001, '�������� ��������� �������� ������� 20-������� ������� � ���� ������� �� ����� ������� (������� ������)', 1
	END
END
GO
--DROP TRIGGER SalesLT.TriggerProductListPriceRules
--------------------------------------------------------------------------------------------------------------------------------------------
/* 2.1. �������� ���������.
��� ���������� ������� ��� AFTER-�������� TriggerProduct � TriggerProductCategory: �� ������ ���
������ �� ������ Product � ProductCategory ��� ����������� ��������� ����������� ����� �����
��������� �� ���� ProductCategoryID. ��������������, �������� ������ ����������� ������ 50002
� ��������� �������: ������� ��������� ��������� ����������� ����� ��������� Product �
ProductCategory, ���������� ��������� (� TriggerProduct ��������� 0, � TriggerProductCategory �
��������� 1) */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER TriggerProduct
ON SalesLT.Product
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	IF (SELECT ProductCategoryID FROM inserted) NOT IN (SELECT ProductCategoryID FROM SalesLT.ProductCategory)
	BEGIN
		ROLLBACK;
		THROW 50002, '������: ������� ��������� ��������� ����������� ����� ��������� Product � ProductCategory, ���������� ��������', 0
	END
END
GO
--DROP TRIGGER TriggerProduct

CREATE TRIGGER TriggerProductCategory
ON SalesLT.ProductCategory
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	IF (SELECT ProductCategoryID FROM inserted) NOT IN (SELECT ProductCategoryID FROM SalesLT.Product)
	BEGIN
		ROLLBACK;
		THROW 50002, '������: ������� ��������� ��������� ����������� ����� ��������� Product � ProductCategory, ���������� ��������', 1
	END
END
GO
--DROP TRIGGER TriggerProductCategory
--------------------------------------------------------------------------------------------------------------------------------------------
/*2.2. ������������ ���������
��� ������������ ��������� �� �������� ���������� �������� ����������� �� ������ ��������
����� (����� ���������� ��������� ����� ����� ��������� ���������� ����������): */
ALTER TABLE SalesLT.Product NOCHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
/* ���������� ���������� �������� ������ � ����� ����� ������ � ProductCategoryID=-1 � �������
Product � ���������, ��� �� �������� ��������� �� ������ �� ��������. ����� ��� ����� ����������
������� ������ � ��������� � ProductCategoryID=5 �� ������� ProductCategory � ���������, ��� ��
����� �������� ��������� �� ������ �� �������� */
--------------------------------------------------------------------------------------------------------------------------------------------
--SELECT * FROM SalesLT.Product
UPDATE SalesLT.Product
SET ProductCategoryID = -1
WHERE ProductID = 680

--SELECT * FROM SalesLT.ProductCategory
BEGIN TRANSACTION
	DELETE FROM SalesLT.ProductCategory WHERE ProductCategoryID = 6
ROLLBACK TRANSACTION
--------------------------------------------------------------------------------------------------------------------------------------------
/* 3. �������������� �������� ����� � ���������� ���������.
�������� � ������������, ��� ����������� ��������� ����������� �� ������ ��������� ��������
���������, �� ������� ������������ �������� �������� ����� � ��������� ��������� ��������
(������� �� �����������): */
-- ��������� �������� �������� �����
ALTER TABLE SalesLT.Product CHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
-- ���������� ���������
DISABLE TRIGGER SalesLT.TriggerProduct ON SalesLT.Product;
DISABLE TRIGGER SalesLT.TriggerProductCategory ON SalesLT.ProductCategory;
--ENABLE TRIGGER SalesLT.TriggerProduct ON SalesLT.Product;
--ENABLE TRIGGER SalesLT.TriggerProductCategory ON SalesLT.ProductCategory;
/* ����� ��� ��� ��� ����������� ��������� ���������� ������ � �������� ���������, ��� �
���������� ������� � ���������, ��� ������� ���� ������������ ����������� */
UPDATE SalesLT.Product
SET ProductCategoryID = -1
WHERE ProductID = 680