USE lunchUniminuto;
GO

-- Primero, si ya existe una versión anterior del trigger, la eliminamos para evitar errores.
IF OBJECT_ID('TRIGGER_Aviso_PedidoCambioEstadoCliente', 'TR') IS NOT NULL
    DROP TRIGGER TR_Aviso_PedidoCambioEstadoCliente;
GO

CREATE TRIGGER TRIGGER_Aviso_PedidoCambioEstadoCliente
ON ordenServicio
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Solo actuar si la columna 'idEstadoServicio' fue realmente actualizada.
    IF UPDATE(idEstadoServicio)
    BEGIN
        DECLARE @idOrden INT;
        DECLARE @idCliente INT;
        DECLARE @nombresCliente VARCHAR(100);
        DECLARE @apellidosCliente VARCHAR(100);
        DECLARE @nombreCompletoCliente VARCHAR(201); -- Suficiente para nombres + apellidos + espacio
        
        DECLARE @idRestaurante INT;
        DECLARE @nombreRestaurante VARCHAR(100);
        
        DECLARE @idEstadoAnterior INT;
        DECLARE @nombreEstadoAnterior VARCHAR(100);
        DECLARE @idEstadoNuevo INT;
        DECLARE @nombreEstadoNuevo VARCHAR(100);
        
        DECLARE @mensaje VARCHAR(1000); -- Aumentamos el tamaño para un mensaje más elaborado

        -- Usaremos un cursor para manejar el caso de que múltiples órdenes se actualicen
        -- en una sola sentencia. Así, generamos un aviso por cada una.
        DECLARE cur_ordenes_actualizadas CURSOR FOR
        SELECT 
            i.idOrdenServicio, 
            i.idCliente,
            i.idRestaurante,
            d.idEstadoServicio AS idEstadoAnterior, 
            i.idEstadoServicio AS idEstadoNuevo
        FROM 
            inserted i
        INNER JOIN 
            deleted d ON i.idOrdenServicio = d.idOrdenServicio
        WHERE 
            i.idEstadoServicio <> d.idEstadoServicio; -- Clave: Solo si el estado realmente cambió

        OPEN cur_ordenes_actualizadas;

        FETCH NEXT FROM cur_ordenes_actualizadas 
        INTO @idOrden, @idCliente, @idRestaurante, @idEstadoAnterior, @idEstadoNuevo;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el nombre del cliente
            SELECT 
                @nombresCliente = c.nombresCliente,
                @apellidosCliente = c.apellidosCliente
            FROM 
                cliente c
            WHERE 
                c.idCliente = @idCliente;
            
            SET @nombreCompletoCliente = ISNULL(@nombresCliente, '') + ' ' + ISNULL(@apellidosCliente, '');

            -- Obtener el nombre del restaurante
            SELECT
                @nombreRestaurante = r.nombreRestaurante
            FROM
                restaurante r
            WHERE
                r.idRestaurante = @idRestaurante;

            -- Obtener el nombre del estado anterior del servicio
            SELECT 
                @nombreEstadoAnterior = es.nombreEstadoServicio 
            FROM 
                estadoServicio es 
            WHERE 
                es.idEstadoServicio = @idEstadoAnterior;

            -- Obtener el nombre del nuevo estado del servicio
            SELECT 
                @nombreEstadoNuevo = es.nombreEstadoServicio 
            FROM 
                estadoServicio es 
            WHERE 
                es.idEstadoServicio = @idEstadoNuevo;

            -- Construir el mensaje creativo
            SET @mensaje = '------------------------------------------------------------' + CHAR(13) + CHAR(10) +
                           '📢 ¡ATENCIÓN! Actualización de Pedido 📢' + CHAR(13) + CHAR(10) +
                           '------------------------------------------------------------' + CHAR(13) + CHAR(10) +
                           'Estimado(a) ' + LTRIM(RTRIM(ISNULL(@nombreCompletoCliente, 'Cliente'))) + ',' + CHAR(13) + CHAR(10) +
                           'Tu pedido N° ' + CAST(@idOrden AS VARCHAR(10)) + 
                           ' del restaurante "' + ISNULL(@nombreRestaurante, 'Restaurante Desconocido') + '"' + CHAR(13) + CHAR(10) +
                           'ha cambiado de estado:' + CHAR(13) + CHAR(10) +
                           '   Estado Anterior: [' + ISNULL(@nombreEstadoAnterior, 'No definido') + ']' + CHAR(13) + CHAR(10) +
                           '   ✨ Nuevo Estado:  [' + ISNULL(@nombreEstadoNuevo, 'No definido') + '] ✨' + CHAR(13) + CHAR(10) +
                           'Fecha de actualización: ' + CONVERT(VARCHAR, GETDATE(), 103) + ' ' + CONVERT(VARCHAR, GETDATE(), 108) + CHAR(13) + CHAR(10) + -- DD/MM/YYYY HH:MM:SS
                           '------------------------------------------------------------';
            
            PRINT @mensaje;

            FETCH NEXT FROM cur_ordenes_actualizadas 
            INTO @idOrden, @idCliente, @idRestaurante, @idEstadoAnterior, @idEstadoNuevo;
        END

        CLOSE cur_ordenes_actualizadas;
        DEALLOCATE cur_ordenes_actualizadas;
    END
END;
GO