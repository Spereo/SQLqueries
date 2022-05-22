/* 1.1. Напишите запрос, который извлекает название компании, первую строку адреса улицы (т.е.
AddressLine1), город (City) и столбец с именем AddressType со значением «Billing» для клиентов,
где тип адреса в таблице SalesLT.CustomerAddress является «Main Office». */
SELECT cu.CompanyName, ad.AddressLine1, ad.City, 'Billing' AS AddressType FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID)
WHERE ca.AddressType = 'Main Office'

/* 1.2. Напишите аналогичный запрос, который извлекает название компании, первую строку адреса,
город и столбец с именем AddressType со значением «Shipping» для клиентов, где тип адреса в
таблице SalesLT.CustomerAddress равен «Shipping». */
SELECT cu.CompanyName, ad.AddressLine1, ad.City, 'Shipping' AS AddressType FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID)
WHERE ca.AddressType = 'Shipping'

/* 1.3. Объедините результаты, возвращаемые двумя предыдущими запросами, чтобы создать список
всех адресов клиентов, отсортированных по названию компании, а затем по типу адреса. */
SELECT cu.CompanyName, ad.AddressLine1, ad.City, 'Billing' AS AddressType FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID)
WHERE ca.AddressType = 'Main Office'
UNION
SELECT cu.CompanyName, ad.AddressLine1, ad.City, 'Shipping' AS AddressType FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID)
WHERE ca.AddressType = 'Shipping'
ORDER BY cu.CompanyName

/* 2.1. Напишите запрос, который возвращает название компании (CompanyName) для каждой
компании, которая отображается в таблице клиентов с типом адреса «Main Office», но не в
таблице клиентов с типом адреса «Shipping». */


