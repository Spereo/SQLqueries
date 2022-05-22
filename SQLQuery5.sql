/* 1.1. Напишите запрос, который возвращает идентификатор для каждого товара вместе с наименованием
товара, преобразованным к верхнему регистру в столбце ProductName и столбец с именем ApproxWeight с
весом каждого товара, округленным до ближайшего целого. */
SELECT pr.ProductID, UPPER(pr.Name) AS ProductName, CEILING(ROUND(pr.Weight, 0)) AS ApproxWeight FROM SalesLT.Product AS pr

/* 1.2. Расширьте свой запрос, чтобы включить столбцы с именами SellStartYear и SellStartMonth, содержащие год
и месяц, в которых Adventure Works начала продавать каждый товар. Месяц должен отображать название
месяца (например, «January»). */
SELECT pr.ProductID,
	UPPER(pr.Name) AS ProductName,
	ROUND(pr.Weight, 0) AS ApproxWeight,
	YEAR(pr.SellStartDate) AS SellStartYear,
	DATENAME(mm, pr.SellStartDate) AS SellStartMonth
FROM SalesLT.Product AS pr

/* 1.3. Расширьте свой запрос, чтобы включить столбец с именем ProductType, который содержит самые левые
два символа из номера товара (столбец ProductNumber). */
SELECT pr.ProductID,
	UPPER(pr.Name) AS ProductName,
	ROUND(pr.Weight, 0) AS ApproxWeight,
	YEAR(pr.SellStartDate) AS SellStartYear,
	DATENAME(mm, pr.SellStartDate) AS SellStartMonth,
	SUBSTRING(pr.ProductNumber, 1, 2) AS ProductType
FROM SalesLT.Product AS pr

/* 1.4. Расширьте свой запрос отфильтровав возвращаемые товары, чтобы включить только те из них, которые
имеют числовой размер. */
SELECT pr.ProductID,
	UPPER(pr.Name) AS ProductName,
	ROUND(pr.Weight, 0) AS ApproxWeight,
	YEAR(pr.SellStartDate) AS SellStartYear,
	DATENAME(mm, pr.SellStartDate) AS SellStartMonth,
	LEFT(pr.ProductNumber, 2) AS ProductType --ИЛИ SUBSTRING(pr.ProductNumber, 1, 2) AS ProductType
FROM SalesLT.Product AS pr
WHERE ISNUMERIC(pr.Size) = 1

/* 2.1. Напишите запрос, который возвращает список названий компаний (столбец CompanyName) и TotalDue (в
столбце Revenue) и ранг (по уменьшению значений TotalDue) из таблицы SalesOrderHeader в столбце
RankByRevenue. */
SELECT cu.CompanyName, 
	soh.TotalDue AS Revenue,
	DENSE_RANK() OVER (ORDER BY TotalDue DESC) RankByRevenue
FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.SalesOrderHeader AS soh ON (cu.CustomerID = soh.CustomerID)

/* 3.1. Напишите запрос для извлечения списка наименований товаров (столбец Name) и итоговой суммы
(столбец TotalRevenue), рассчитанной как сумма LineTotal из таблицы SalesLT.SalesOrderDetail. Результаты
отсортируйте по убыванию общей выручки. */
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue FROM SalesLT.Product AS pr
INNER JOIN SalesLT.SalesOrderDetail AS sod ON (pr.ProductID = sod.ProductID)
GROUP BY Name

/* 3.2. Измените предыдущий запрос так, чтобы он включал только итоговые сведения по товарам, цена на
которые превышает 1000 долларов США. */
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue FROM SalesLT.Product AS pr
INNER JOIN SalesLT.SalesOrderDetail AS sod ON (pr.ProductID = sod.ProductID)
WHERE sod.LineTotal > 1000
GROUP BY Name

/* 3.3. Измените предыдущий запрос, чтобы он включал только те группы товаров, общая стоимость продаж
которых превышает 20 000 долларов. */
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue FROM SalesLT.Product AS pr
INNER JOIN SalesLT.SalesOrderDetail AS sod ON (pr.ProductID = sod.ProductID)
WHERE sod.LineTotal > 1000
GROUP BY Name
HAVING SUM(sod.LineTotal) > 20000