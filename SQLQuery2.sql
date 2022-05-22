/* Задача 1: Получение данных для транспортных отчетов
1. Получите список городов */
SELECT DISTINCT City, StateProvince FROM SalesLT.Address

--2. Получите самые тяжелые товары
SELECT TOP 10 PERCENT Name FROM SalesLT.Product ORDER BY Weight DESC

--3. Извлеките самые тяжелые 100 товаров, не включая десять самых тяжелых
SELECT Name FROM SalesLT.Product ORDER BY Weight DESC offset 10 ROWS FETCH NEXT 100 ROWS only

/*Задача 2: Получение данных о товаре
1. Получите информацию о товаре для модели 1 */
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID = 1

--2. Отфильтруйте товары по цвету и размеру
SELECT ProductNumber, Name FROM SalesLT.Product WHERE color IN ('black' , 'red' , 'white') AND size IN ('S' , 'M')

--3. Отфильтруйте товары по номерам товаров
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-%'

--4. Получите определенные товары по товарному номеру
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'