/* 1.1. Напишите код проверки выполнения правила ограничения цен.
Поскольку перед вводом ограничения в БД необходимо убедиться, что текущие данные
удовлетворяют введенному правилу Вам необходимо написать код, который бы возвращал список
товаров (все столбцы из таблицы Product), которые нарушают указанное правило. Если такие товары
обнаружатся – необходимо вывести надпись ‘Правило 20-кратной разницы в цене нарушено у
<количество> товаров’, в противном случае вывести 'Правило 20-кратной разницы в цене
соблюдено' */
--------------------------------------------------------------------------------------------------------------------------------------------
--SELECT * FROM SalesLT.Product
SELECT * FROM SalesLT.Product AS p
WHERE (ListPrice > (SELECT 20 * MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID))
	OR (ListPrice * 20 < (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID))
DECLARE @Count AS INT = @@ROWCOUNT
IF (@Count > 0)
	PRINT 'Правило 20-кратной разницы в цене нарушено у ' + CAST(@Count AS NVARCHAR(4)) + ' товаров'
ELSE 
	PRINT 'Правило 20-кратной разницы в цене соблюдено'
GO
--------------------------------------------------------------------------------------------------------------------------------------------
/* 1.2. Создайте триггер для обеспечения правила 20-кратной разницы в отпускной цене.
Вам поручили написать триггер с именем SalesLT.TriggerProductListPriceRules, который должен
поддерживать в БД правило 20-кратной разницы в отпускной цене товаров из одной рубрики.
Основное назначение триггера – отменять изменения данных, которые нарушают правило 20-кратной
разницы в цене, оповещая при этом пользователя выбрасыванием ошибки номером 50001 и
сообщением ‘Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной
рубрики (слишком дешево)’ или ‘Вносимые изменения нарушают правило 20-кратной разницы в цене
товаров из одной рубрики (слишком дорого)’ */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER SalesLT.TriggerProductListPriceRules
ON SalesLT.Product
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted AS ins WHERE (ListPrice > (SELECT 20 * MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = ins.ProductCategoryID)))
	BEGIN
		ROLLBACK;
		THROW 50001, 'Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной рубрики (слишком дорого)', 1
	END
	IF EXISTS(SELECT * FROM inserted AS ins WHERE (ListPrice * 20 < (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = ins.ProductCategoryID)))
	BEGIN
		ROLLBACK;
		THROW 50001, 'Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной рубрики (слишком дешево)', 1
	END
END
GO
--DROP TRIGGER SalesLT.TriggerProductListPriceRules
--------------------------------------------------------------------------------------------------------------------------------------------
/* 2.1. Создание триггеров.
Вам необходимо создать два AFTER-триггера TriggerProduct и TriggerProductCategory: по одному для
каждой из таблиц Product и ProductCategory для поддержания ссылочной целостности между этими
таблицами по полю ProductCategoryID. Соответственно, триггеры должны выбрасывать ошибку 50002
с описанием ‘Ошибка: попытка нарушения ссылочной целостности между таблицами Product и
ProductCategory, транзакция отменена’ (в TriggerProduct состояние 0, в TriggerProductCategory –
состояние 1) */
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER TriggerProduct
ON SalesLT.Product
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	IF (SELECT ProductCategoryID FROM inserted) NOT IN (SELECT ProductCategoryID FROM SalesLT.ProductCategory)
	BEGIN
		ROLLBACK;
		THROW 50002, 'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, транзакция отменена', 0
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
		THROW 50002, 'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, транзакция отменена', 1
	END
END
GO
--DROP TRIGGER TriggerProductCategory
--------------------------------------------------------------------------------------------------------------------------------------------
/*2.2. Тестирование триггеров
Для тестирования триггеров Вы временно отключаете проверку ограничения на основе внешнего
ключа (после обновления диаграммы связь между таблицами становится пунктирной): */
ALTER TABLE SalesLT.Product NOCHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
/* Необходимо попытаться добавить запись о любом новом товаре с ProductCategoryID=-1 в таблицу
Product и убедиться, что Вы получите сообщение об ошибке из триггера. Затем Вам нужно попытаться
удалить запись о категории с ProductCategoryID=5 из таблицы ProductCategory и убедиться, что Вы
также получите сообщение об ошибке из триггера */
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
/* 3. Восстановление внешнего ключа и отключение триггеров.
Прочитав в документации, что поддержание ссылочной целостности на основе триггеров работает
медленнее, вы решаете восстановить проверку внешнего ключа и отключить созданные триггеры
(сделать их неактивными): */
-- включение проверки внешнего ключа
ALTER TABLE SalesLT.Product CHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
-- отключение триггеров
DISABLE TRIGGER SalesLT.TriggerProduct ON SalesLT.Product;
DISABLE TRIGGER SalesLT.TriggerProductCategory ON SalesLT.ProductCategory;
--ENABLE TRIGGER SalesLT.TriggerProduct ON SalesLT.Product;
--ENABLE TRIGGER SalesLT.TriggerProductCategory ON SalesLT.ProductCategory;
/* После это еще раз попытайтесь выполнить добавление товара и удаление категории, как в
предыдущем задании и убедитесь, что внешний ключ поддерживает целостность */
UPDATE SalesLT.Product
SET ProductCategoryID = -1
WHERE ProductID = 680