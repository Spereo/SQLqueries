SELECT SalesOrderID FROM SalesLT.SalesOrderDetail
/* 1.1. Измените код так, чтобы проверить существование заказа с указанным идентификатором,
прежде чем пытаться его удалить. Если заказ не существует, то Ваш код должен выбросить ошибку:
«Заказ #<SalesOrderID> не существует». В противном случае он должен удалить данные по заказу. */
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
	DECLARE @ErrorMessage VARCHAR(24) = 'Заказ ' + CAST(@SalesOrderID AS VARCHAR) + ' не существует'
	RAISERROR (@ErrorMessage, 16, 0)
	ROLLBACK TRANSACTION
END
---------------------------------------------------------------------------------------------------
/* 1.2. Сейчас Ваш код выбрасывает ошибку, если указанный заказ не существует. Теперь Вы должны
дописать свой код, чтобы поймать эту (или любую другую) ошибку и вывести сообщение об ошибке в
пользовательский интерфейс с помощью команды PRINT. */
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
		DECLARE @ErrorMessage VARCHAR(24) = 'Заказ ' + CAST(@SalesOrderID AS VARCHAR) + ' не существует'
		RAISERROR (@ErrorMessage, 16, 1)
		ROLLBACK TRANSACTION
	END
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	THROW 50001, @ErrorMessage, 1;
END CATCH
---------------------------------------------------------------------------------------------------
/* 2.1. Усовершенствуйте Ваш код, созданный в предыдущем задании, чтобы два оператора DELETE
рассматривались как единая транзакция. В обработчике ошибок измените код так, чтобы, если
транзакция находится в процессе выполнения, она бы отменялась, и ошибка пробрасывалась в
клиентское приложение. Если транзакция не выполняется, то обработчик ошибок должен просто
напечатать сообщение об ошибке (PRINT). */
DECLARE @SalesOrderID INT = 71782
BEGIN TRANSACTION
BEGIN TRY
	IF (EXISTS(SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID))
	BEGIN
		BEGIN TRANSACTION
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		THROW 50002, 'Произошло отключение питания. Зовите сисадмина!', 2;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
		COMMIT TRANSACTION
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @ErrorMessage VARCHAR(24) = 'Заказ ' + CAST(@SalesOrderID AS VARCHAR) + ' не существует'
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