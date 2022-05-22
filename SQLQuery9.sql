/* 1.1 Компания Adventure Works начала продавать новый товар. Добавьте его в таблицу SalesLT.Product,
используя значения по умолчанию или NULL для неуказанных столбцов (используйте синтаксис с явно
указанными именами столбцов): */
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) VALUES ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE())
--SELECT IDENT_CURRENT('SalesLT.Product')
--SELECT * FROM SalesLT.Product
--SELECT SCOPE_IDENTITY()
/* После того, как вы добавили товар, напишите и выполните запрос, чтобы определить значение
ProductID, которое было сгенерировано (запрос должен возвращать только столбец ProductID). Затем
напишите и выполните запрос, чтобы просмотреть все строку целиком (все столбцы) для добавленного
вами товара в таблице SalesLT.Product. */
SELECT ProductID FROM SalesLT.Product WHERE ProductCategoryID = IDENT_CURRENT('SalesLT.Product')
SELECT * FROM SalesLT.Product WHERE ProductCategoryID = IDENT_CURRENT('SalesLT.Product')
-------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2 Компания Adventure Works добавляет в свой каталог категорию товаров «Bells and Horns».
Идентификатор родительской категории для новой категории = 4 (Accessories). Эта новая категория
включает в себя два новых товара.
Напишите запрос, чтобы добавить новую категорию товаров «Bells and Horns», а затем добавьте два
новых товара с соответствующим значением ProductCategoryID (программно определите
идентификатор категории «Bells and Horns» во время вставки и далее используйте его для добавления
новых товаров; используйте синтаксис с явным указанием имен столбцов).*/
INSERT INTO SalesLT.ProductCategory (Name, ParentProductCategoryID) VALUES ('Bells and Horns', 4)

DECLARE @id int = IDENT_CURRENT('SalesLT.ProductCategory')
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) 
VALUES ('Bicycle Bell', 'BB-RING', 2.47, 4.99, @id, GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @id, GETDATE())

/* После того, как вы добавили товары, напишите один запрос к двум таблицам SalesLT.Product и
SalesLT.ProductCategory, чтобы убедиться, что данные были вставлены успешно. */
SELECT p.Name, p.ProductNumber, p.StandardCost, p.ListPrice, p.ProductCategoryID, p.SellStartDate, c.ProductCategoryID, c.ParentProductCategoryID 
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS c
ON c.ProductCategoryID = p.ProductCategoryID
WHERE (ParentProductCategoryID = IDENT_CURRENT('SalesLT.Product'))
-------------------------------------------------------------------------------------------------------------------------------------------
/* 2.1. Менеджер по продажам в компании Adventure Works принял решение на 10 % повысить цены для всех
товаров из категории «Bells and Horns». Обновите строки в таблице SalesLT.Product для этих товаров,
чтобы увеличить их цену (столбец ListPrice) на 10% (ссылайтесь на категорию товаров по названию). */
UPDATE SalesLT.Product
SET ListPrice = 1.1*(ListPrice)
WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns')
-------------------------------------------------------------------------------------------------------------------------------------------
/* 2.2. Новый товар «LED Lights», который вы добавили первой задаче, должен заменить все предыдущие
световые продукты. Обновите таблицу SalesLT.Product, чтобы установить значение «сегодня» в поле
DiscontinuedDate для всех товаров в категории «Lights» (ссылайтесь через ProductCategoryID = 37),
кроме товара «LED Lights», который вы добавили ранее (ссылайтесь через ProductNumber «LT-L123»). */
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ((ProductCategoryID = 37) AND (ProductNumber != 'LT-L123'))
-------------------------------------------------------------------------------------------------------------------------------------------
/* 3.1. Удалите записи категории «Bells and Horns» и ее товаров. Вы должны убедиться, что вы удаляете записи
из таблиц в правильном порядке, чтобы избежать нарушения ограничений внешнего ключа (ссылайтесь
на категорию товаров по имени). */
DELETE FROM SalesLT.Product WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns')
DELETE FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns'
-------------------------------------------------------------------------------------------------------------------------------------------