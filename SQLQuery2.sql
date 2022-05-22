/* ������ 1: ��������� ������ ��� ������������ �������
1. �������� ������ ������� */
SELECT DISTINCT City, StateProvince FROM SalesLT.Address

--2. �������� ����� ������� ������
SELECT TOP 10 PERCENT Name FROM SalesLT.Product ORDER BY Weight DESC

--3. ��������� ����� ������� 100 �������, �� ������� ������ ����� �������
SELECT Name FROM SalesLT.Product ORDER BY Weight DESC offset 10 ROWS FETCH NEXT 100 ROWS only

/*������ 2: ��������� ������ � ������
1. �������� ���������� � ������ ��� ������ 1 */
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID = 1

--2. ������������ ������ �� ����� � �������
SELECT ProductNumber, Name FROM SalesLT.Product WHERE color IN ('black' , 'red' , 'white') AND size IN ('S' , 'M')

--3. ������������ ������ �� ������� �������
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-%'

--4. �������� ������������ ������ �� ��������� ������
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'