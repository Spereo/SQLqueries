/* 1.1. �������� ������, ������� ��������� �������� ��������, ������ ������ ������ ����� (�.�.
AddressLine1), ����� (City) � ������� � ������ AddressType �� ��������� �Billing� ��� ��������,
��� ��� ������ � ������� SalesLT.CustomerAddress �������� �Main Office�. */
SELECT cu.CompanyName, ad.AddressLine1, ad.City, 'Billing' AS AddressType FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID)
WHERE ca.AddressType = 'Main Office'

/* 1.2. �������� ����������� ������, ������� ��������� �������� ��������, ������ ������ ������,
����� � ������� � ������ AddressType �� ��������� �Shipping� ��� ��������, ��� ��� ������ �
������� SalesLT.CustomerAddress ����� �Shipping�. */
SELECT cu.CompanyName, ad.AddressLine1, ad.City, 'Shipping' AS AddressType FROM SalesLT.Customer AS cu
INNER JOIN SalesLT.CustomerAddress AS ca ON (cu.CustomerID = ca.CustomerID)
INNER JOIN SalesLT.Address AS ad ON (ca.AddressID = ad.AddressID)
WHERE ca.AddressType = 'Shipping'

/* 1.3. ���������� ����������, ������������ ����� ����������� ���������, ����� ������� ������
���� ������� ��������, ��������������� �� �������� ��������, � ����� �� ���� ������. */
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

/* 2.1. �������� ������, ������� ���������� �������� �������� (CompanyName) ��� ������
��������, ������� ������������ � ������� �������� � ����� ������ �Main Office�, �� �� �
������� �������� � ����� ������ �Shipping�. */


