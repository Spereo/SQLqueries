/* 1.1. Получите идентификатор товара, наименование и прейскурантную цену для каждого товара, чья
прейскурантная цена выше средней цены за единицу товара для всех проданных товаров. */
SELECT ProductID, Name, ListPrice FROM SalesLT.Product
WHERE ListPrice > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail)

/* 1.2. Получить идентификатор товара, наименование и прейскурантную цену для каждого товара, чья
прейскурантная цена составляет $100 или более, а товар продан менее чем за $100. */
SELECT ProductID, Name, ListPrice FROM SalesLT.Product
WHERE (ListPrice >= 100) AND ProductID IN (SELECT ProductID FROM SalesLT.SalesOrderDetail
WHERE UnitPrice < 100)

/* 1.3. Получите идентификатор товара, наименование, себестоимость (столбец StandardCost) и прейскурантную
цену для каждого товара из таблицы Products вместе со средней ценой продажи единицы данного товара
в столбце AvgSellingPrice. */
SELECT pr.ProductID, pr.Name, pr.StandardCost, pr.ListPrice, 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail 
WHERE pr.ProductID=ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS pr

/* 1.4. Отфильтруйте предыдущий запрос так, чтобы включить только товары, где себестоимость выше средней
цены продажи товара. */
SELECT pr.ProductID, pr.Name, pr.StandardCost, pr.ListPrice, 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail 
WHERE pr.ProductID=ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS pr
WHERE (pr.StandardCost > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail))

/* 2.1. Получите идентификатор заказа, идентификатор клиента, имя, фамилию и общую сумму (TotalDue) для
всех заказов из таблицы SalesLT.SalesOrderHeader и функции dbo.ufnGetCustomerInformation.
Необходимо отсортировать результаты по SalesOrderID. */
SELECT soh.SalesOrderID, p.CustomerID, p.FirstName, p.LastName, soh.TotalDue FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS P

/* 2.2. Получите идентификатор клиента, имя, фамилию, адресную строку 1 и город для всех клиентов из таблиц
SalesLT.Address и SalesLT.CustomerAddress и функции dbo.ufnGetCustomerInformation. Необходимо
отсортировать результаты по CustomerID. */
SELECT ca.CustomerID, p.FirstName, p.LastName, ad.AddressLine1, ad.City
FROM  SalesLT.CustomerAddress AS ca
INNER JOIN SalesLT.Address AS ad
ON ca.AddressID = ad.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS P
ORDER BY p.CustomerID