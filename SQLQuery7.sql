/* 1.1. Получите идентификатор товара, название товара (столбец ProductName), название модели товара (столбец
ProductModel) и описание модели товара (столбец Summary) для каждого товара из таблицы SalesLT.Product и
отображения SalesLT.vProductModelCatalogDescription, упорядочив результаты по идентификатору товара. */
SELECT pr.ProductID, pr.Name AS ProductName, descr.Name AS ProductModel, descr.Summary FROM SalesLT.Product AS pr
INNER JOIN SalesLT.vProductModelCatalogDescription AS descr
ON pr.ProductModelID = descr.ProductModelID
ORDER BY pr.ProductID


/* 1.2. Создайте табличную переменную и заполните ее списком уникальных цветов из таблицы SalesLT.Product. Затем
используйте табличную переменную, чтобы отфильтровать запрос, который возвращает идентификатор товара,
название товара (столбец ProductName) и цвет (столбец Color) из таблицы SalesLT.Product, упорядочивая по
цветам так, чтобы возвращались только те товары, цвета которых перечислены в табличной переменной. */
DECLARE @DColors TABLE (Color varchar(15))
INSERT INTO @DColors SELECT DISTINCT Color FROM SalesLT.Product

SELECT ProductID, Name AS ProductName, Color FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @DColors)
ORDER BY Color


/* 1.3. Создайте временную таблицу и заполните ее списком уникальных размеров из таблицы SalesLT.Product. Затем
используйте временную таблицу, чтобы отфильтровать запрос, который возвращает идентификатор товара,
название товара (столбец ProductName) и размер (столбец Size) из таблицы SalesLT.Product, упорядочивая по
размерам по убыванию так, чтобы возвращались только те товары, размеры которых перечислены во временной
таблице. */
CREATE TABLE #DSizes (Size varchar(5))
INSERT INTO #DSizes SELECT DISTINCT Size FROM SalesLT.Product

SELECT ProductID, Name AS ProductName, Color FROM SalesLT.Product
WHERE Size IN (SELECT Size FROM #DSizes)
ORDER BY Size


/* 1.4. БД AdventureWorksLT содержит табличную функцию dbo.ufnGetAllCategories, которая возвращает таблицу
товарных категорий (например «Road Bikes») и их родительских категорий (например «Bikes»). Напишите запрос,
которых использует эту функцию, чтобы вернуть список всех товаров (столбцы ProductID, ProductName) включая их
родительские категории (столбец ParentCategory) и категории (столбец Category), упорядоченные по
соответствующему полному пути категорий (т.е. названию категории, включая название родительской категории)
и названию товара. */
SELECT pr.ProductID, pr.Name AS ProductName, gac.ParentProductCategoryName AS ParentCategory,
gac.ProductCategoryName AS Category FROM SalesLT.Product AS pr
INNER JOIN dbo.ufnGetAllCategories() AS gac
ON pr.ProductCategoryID = gac.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName


/* 2.1. Получите список клиентов в формате “Название_Компании (Имя_Контакта Фамилия_Контакта)” в столбце
CompanyContact (например, значение может быть “Action Bicycle Specialists (Terry Eminhizer)”), значение
полученной выручки (сумма значений TotalDue) для этого клиента (столбец Revenue). Используйте производную
таблицу, чтобы получить сведения по каждому заказу и затем постройте запрос к полученной производной
таблице, чтобы сгруппировать данные. Результаты должны быть упорядочены по значениям в CompanyContact. */
SELECT CompanyContact, SUM(TotalDue) AS Revenue FROM
(SELECT (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') AS CompanyContact, TotalDue FROM SalesLT.Customer AS cus
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON cus.CustomerID = soh.CustomerID) AS cn
GROUP BY CompanyContact
ORDER BY CompanyContact;


/* 2.2. Перепишите предыдущий запрос с помощью CTE (обобщенного табличного выражения) вместо производных таблиц. */
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