



CREATE PROCEDURE sp_ActualizarPrecios
    @TipoMenu VARCHAR(10), -- 'Comida' o 'Bebida'
    @IdMenu INT,          -- ID del menú a actualizar (idMenuComida o idMenuBebida)
    @NuevoPrecio DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FechaActual DATE = GETDATE();
    DECLARE @MensajeError NVARCHAR(500);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validamos que el tipo de menú sea válido
        IF @TipoMenu NOT IN ('Comida', 'Bebida')
        BEGIN
            SET @MensajeError = 'El tipo de menú debe ser "Comida" o "Bebida"';
            THROW 50000, @MensajeError, 1;
        END
        
        -- Validamos que el precio sea mayor que cero
        IF @NuevoPrecio <= 0
        BEGIN
            SET @MensajeError = 'El precio debe ser mayor que cero';
            THROW 50001, @MensajeError, 1;
        END
        
        -- Actualizamos precio de comida
        IF @TipoMenu = 'Comida'
        BEGIN
            -- Verificamos que el menú de comida existe
            IF NOT EXISTS (SELECT 1 FROM menuComida WHERE idMenuComida = @IdMenu)
            BEGIN
                SET @MensajeError = 'El ID de menú de comida no existe';
                THROW 50002, @MensajeError, 1;
            END
            
            -- Insertamos nuevo registro de precio
            INSERT INTO precioComida (idMenuComida, fechaActualizacionPrecioComida, precioPrecioComida)
            VALUES (@IdMenu, @FechaActual, @NuevoPrecio);
            
            SELECT 'Precio de comida actualizado correctamente. ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) AS Resultado;
        END
        -- Actualizamos precio de bebida
        ELSE IF @TipoMenu = 'Bebida'
        BEGIN
            -- Verificamos que el menú de bebida existe
            IF NOT EXISTS (SELECT 1 FROM menuBebida WHERE idMenuBebida = @IdMenu)
            BEGIN
                SET @MensajeError = 'El ID de menú de bebida no existe';
                THROW 50003, @MensajeError, 1;
            END
            
            -- Insertamos nuevo registro de precio
            INSERT INTO precioBebida (idMenuBebida, fechaActualizacionPrecioBebida, precioPrecioBebida)
            VALUES (@IdMenu, @FechaActual, @NuevoPrecio);
            
            SELECT 'Precio de bebida actualizado correctamente. ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) AS Resultado;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Mostrar información del error
        SELECT 
            ERROR_NUMBER() AS ErrorNumero,
            ERROR_SEVERITY() AS ErrorSeveridad,
            ERROR_STATE() AS ErrorEstado,
            ERROR_PROCEDURE() AS ErrorProcedimiento,
            ERROR_LINE() AS ErrorLinea,
            ERROR_MESSAGE() AS MensajeError;
    END CATCH;
END;






--QUERY DE EXECT

-- Para actualizar precio de una comida
EXEC sp_ActualizarPrecios 'Comida', 1, 15000.00

-- Para actualizar precio de una bebida
EXEC sp_ActualizarPrecios 'Bebida', 3, 5000.00


--EVIDENCIAR CAMBIOS EN EL MODELO DE BASE DE DATOS RELACIONAL QUE CONSTRUIMOS  EN COMIDA 
SELECT mc.nombreMenuComida, pc.precioPrecioComida, pc.fechaActualizacionPrecioComida
FROM precioComida pc
JOIN menuComida mc ON pc.idMenuComida = mc.idMenuComida
WHERE mc.idMenuComida = 1  -- El mismo ID que usaste en el procedimiento
ORDER BY pc.fechaActualizacionPrecioComida DESC;  -- Muestra el más reciente primero

--ESTE POR EL AMBITO DE BEBIDA

SELECT mb.nombreMenuBebida, pb.precioPrecioBebida, pb.fechaActualizacionPrecioBebida
FROM precioBebida pb
JOIN menuBebida mb ON pb.idMenuBebida = mb.idMenuBebida
WHERE mb.idMenuBebida = 3  -- El mismo ID que usaste en el procedimiento
ORDER BY pb.fechaActualizacionPrecioBebida DESC;  -- Muestra el más reciente primero