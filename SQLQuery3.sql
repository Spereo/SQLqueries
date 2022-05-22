SELECT * FROM SalesLT.Customer
SELECT * FROM SalesLT.SalesOrderHeader
SELECT * FROM SalesLT.Address
SELECT * FROM SalesLT.CustomerAddress

/* 1.1. В качестве первого шага по созданию отчета по счетам напишите запрос, который возвращает название компании (CompanyName) из таблицы SalesLT.Customer,
а также идентификатор заказа (SalesOrderID) и итоговую стоимость (TotalDue) из таблицы SalesLT.SalesOrderHeader. */
SELECT cu.CompanyName, soh.SalesOrderID, soh.TotalDue FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)

/* 1.2. Расширьте свой предыдущий запрос по заказам клиентов, чтобы включить в него адрес главного офиса для каждого клиента,
включая полный адрес (столбцы AddressLine1 и AddressLine2), город (City), штат или провинцию (StateProvince), почтовый индекс (PostalCode) и страну/регион (CountryRegion). */
SELECT cu.CompanyName, soh.SalesOrderID, soh.TotalDue, ad.AddressLine1, ad.AddressLine2, ad.City, ad.StateProvince, ad.PostalCode, ad.CountryRegion FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID AND ca.AddressType = 'Main Office')

/* 2.1. Менеджер по продажам просит составить список всех компаний-клиентов (CompanyName) с их именами и контактами (имя и фамилия – FirstName и LastName),
который бы показывал идентификатор заказа (SalesOrderID) и общую сумму (TotalDue) за каждый заказ, который разместили клиенты. Клиенты, которые не разместили заказы,
должны быть включены в нижней части списка со значениями NULL для идентификатора заказа и общей суммы. */
SELECT cu.CompanyName, cu.FirstName, cu.LastName, soh.SalesOrderID, soh.TotalDue FROM SalesLT.Customer AS cu
LEFT JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)
ORDER BY
	CASE
		WHEN soh.SalesOrderID IS NULL THEN 1
		ELSE 0
	END
--Или ORDER BY ordh.CustomerID DESC

/* 2.2. Сотрудник отдела продаж заметил, что Adventure Works не имеет информации по адресам для всех клиентов.
Вы должны написать запрос, который возвращает список идентификаторов клиентов, названий компаний, имен контактов (имя и фамилия) и номера телефонов для клиентов, не имеющих адреса. */
SELECT cu.CustomerID, cu.CompanyName, cu.FirstName, cu.LastName, cu.Phone FROM SalesLT.Customer AS cu
LEFT JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
WHERE ca.AddressType IS NULL

/* 2.3. Некоторые клиенты никогда не размещали заказы, а некоторые товары никогда не заказывались.
Создайте запрос, который возвращает столбец идентификаторов клиентов (CustomerID) для клиентов, которые никогда не размещали заказы,
и столбец идентификаторов товаров (ProductID) для товаров, которые никогда не были заказаны. Каждая строка с идентификатором клиента
должна иметь идентификатор продукта NULL (поскольку клиент никогда не заказывал продукт),
и каждая строка с идентификатором товара должна иметь идентификатор клиента NULL (поскольку товар никогда не заказывался клиентом). */
