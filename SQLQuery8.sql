/* 1.1. Вам необходимо изменить запрос, чтобы результаты включали общую сумму всех доходов от продаж и
промежуточную сумму для каждой страны/региона в дополнение к промежуточным суммам по
штатам/провинциям, которые уже возвращены. */
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY 
ROLLUP (a.CountryRegion, a.StateProvince)
--GROUPING SETS (a.CountryRegion, (a.CountryRegion, a.StateProvince), ())
ORDER BY a.CountryRegion, a.StateProvince;

/* 1.2. Измените свой предыдущий запрос, чтобы включить столбец с именем «Level», который указывает, на каком уровне
в иерархии отображается показатель дохода в строке: итоговом, страна/регион и штат/провинция. Например,
общая итоговая строка должна содержать значение «Total», строка, показывающая промежуточный итог для
Соединенных Штатов, должна содержать значение «United States Subtotal», а строка, показывающая
промежуточный итог для Калифорнии, должна содержать значение «California Subtotal». */
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

/* 1.3. Расширьте свой предыдущий запрос, чтобы включить столбец «City» (после столбца StateProvince) и группировку
для отдельных городов. Измените правила для столбца «Level» так, чтобы строка, показывающая промежуточный
итог для города Лондон, содержала значение «London Subtotal». Добавьте столбец City в выражение сортировки
результатов. */
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

/* 2.1. Получите список названий компаний-клиентов (столбец CompanyName), их общий доход (сумма значений LineTotal
в таблице SalesLT.SalesOrderDetail) для каждой родительской категории в разделах Accessories, Bikes, Clothing и
Components (в соответствующих столбцах Accessories, Bikes, Clothing и Components). Отсортируйте результаты
запроса по названию компании. */
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