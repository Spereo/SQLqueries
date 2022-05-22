SELECT SalesOrderID FROM SalesLT.SalesOrderDetail
/* 1.1. �������� ��� ���, ����� ��������� ������������� ������ � ��������� ���������������,
������ ��� �������� ��� �������. ���� ����� �� ����������, �� ��� ��� ������ ��������� ������:
������ #<SalesOrderID> �� ����������. � ��������� ������ �� ������ ������� ������ �� ������. */
DECLARE @SalesOrderID INT = 666
BEGIN TRANSACTION
IF (EXISTS(SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID))
BEGIN
	DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
	DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
	COMMIT TRANSACTION
END
ELSE
BEGIN
	DECLARE @ErrorMessage VARCHAR(24) = '����� ' + CAST(@SalesOrderID AS VARCHAR) + ' �� ����������'
	RAISERROR (@ErrorMessage, 16, 0)
	ROLLBACK TRANSACTION
END
---------------------------------------------------------------------------------------------------
/* 1.2. ������ ��� ��� ����������� ������, ���� ��������� ����� �� ����������. ������ �� ������
�������� ���� ���, ����� ������� ��� (��� ����� ������) ������ � ������� ��������� �� ������ �
���������������� ��������� � ������� ������� PRINT. */
DECLARE @SalesOrderID INT = 666
BEGIN TRANSACTION
BEGIN TRY
	IF (EXISTS(SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID))
	BEGIN
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @ErrorMessage VARCHAR(24) = '����� ' + CAST(@SalesOrderID AS VARCHAR) + ' �� ����������'
		RAISERROR (@ErrorMessage, 16, 1)
		ROLLBACK TRANSACTION
	END
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	THROW 50001, @ErrorMessage, 1;
END CATCH
---------------------------------------------------------------------------------------------------
/* 2.1. ���������������� ��� ���, ��������� � ���������� �������, ����� ��� ��������� DELETE
��������������� ��� ������ ����������. � ����������� ������ �������� ��� ���, �����, ����
���������� ��������� � �������� ����������, ��� �� ����������, � ������ �������������� �
���������� ����������. ���� ���������� �� �����������, �� ���������� ������ ������ ������
���������� ��������� �� ������ (PRINT). */
DECLARE @SalesOrderID INT = 71782
BEGIN TRANSACTION
BEGIN TRY
	IF (EXISTS(SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID))
	BEGIN
		BEGIN TRANSACTION
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		THROW 50002, '��������� ���������� �������. ������ ���������!', 2;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
		COMMIT TRANSACTION
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @ErrorMessage VARCHAR(24) = '����� ' + CAST(@SalesOrderID AS VARCHAR) + ' �� ����������'
		RAISERROR (@ErrorMessage, 16, 3)
		ROLLBACK TRANSACTION
	END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT ERROR_MESSAGE();
	THROW 50003, @ErrorMessage, 3
END CATCH
---------------------------------------------------------------------------------------------------