IF OBJECT_ID('sp_EliminarElementoMenu') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_EliminarElementoMenu
END
GO

CREATE OR ALTER PROCEDURE sp_EliminarElementoMenu
    @TipoMenu VARCHAR(10),   -- 'Comida' o 'Bebida'
    @IdMenu INT,             -- ID del elemento a eliminar
    @EliminarPermanente BIT = 0  -- 0: Marca como no disponible, 1: Elimina definitivamente
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MensajeError NVARCHAR(500);
    DECLARE @ExisteEnOrden BIT = 0;
    DECLARE @IdNoDisponible INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el tipo de menú sea válido
        IF @TipoMenu NOT IN ('Comida', 'Bebida')
        BEGIN
            SET @MensajeError = 'El tipo de menú debe ser "Comida" o "Bebida"';
            THROW 50000, @MensajeError, 1;
        END
        
        -- Verificamos si existe un valor para "No disponible" en combinacionesDias
        -- Si no existe, tomamos el primer ID como alternativa temporal
        SELECT TOP 1 @IdNoDisponible = idCombinacionesDias 
        FROM combinacionesDias 
        WHERE descripcionCombinacionDias LIKE '%No disponible%';
        
        IF @IdNoDisponible IS NULL
        BEGIN
            SELECT TOP 1 @IdNoDisponible = idCombinacionesDias 
            FROM combinacionesDias;
            
            IF @IdNoDisponible IS NULL
            BEGIN
                SET @MensajeError = 'No hay combinaciones de días disponibles en el sistema';
                THROW 50004, @MensajeError, 1;
            END
        END
        
        -- Verificar si el elemento está en alguna orden activa
        IF @TipoMenu = 'Comida'
        BEGIN
            IF EXISTS (
                SELECT 1 
                FROM registroMenu rm
                JOIN ordenServicio os ON rm.idOrdenServicio = os.idOrdenServicio
                WHERE rm.idMenuComida = @IdMenu
                AND os.idEstadoServicio IN (1, 2, 3)
            )
            BEGIN
                SET @ExisteEnOrden = 1;
            END
        END
        ELSE
        BEGIN
            IF EXISTS (
                SELECT 1 
                FROM registroMenu rm
                JOIN ordenServicio os ON rm.idOrdenServicio = os.idOrdenServicio
                WHERE rm.idMenuBebida = @IdMenu
                AND os.idEstadoServicio IN (1, 2, 3)
            )
            BEGIN
                SET @ExisteEnOrden = 1;
            END
        END
        
        -- Si existe en órdenes activas y se solicitó eliminación permanente
        IF @ExisteEnOrden = 1 AND @EliminarPermanente = 1
        BEGIN
            SET @MensajeError = 'No se puede eliminar permanentemente porque el elemento está en órdenes activas';
            THROW 50001, @MensajeError, 1;
        END
        
        -- Procesar elementos de comida
        IF @TipoMenu = 'Comida'
        BEGIN
            -- Verificar que el menú de comida existe
            IF NOT EXISTS (SELECT 1 FROM menuComida WHERE idMenuComida = @IdMenu)
            BEGIN
                SET @MensajeError = 'El ID de menú de comida no existe';
                THROW 50002, @MensajeError, 1;
            END
            
            -- Eliminar permanentemente o marcar como no disponible
            IF @EliminarPermanente = 1
            BEGIN
                -- Obtener los IDs de precios asociados a este menú
                DECLARE @PreciosComidaIds TABLE (IdPrecio INT);
                INSERT INTO @PreciosComidaIds
                SELECT idPrecioComida FROM precioComida WHERE idMenuComida = @IdMenu;
                
                -- Eliminar registros en registroMenu que referencian a estos precios
                UPDATE registroMenu 
                SET idPrecioComida = NULL
                WHERE idPrecioComida IN (SELECT IdPrecio FROM @PreciosComidaIds);
                
                -- Actualizar registros que referencian directamente al menú
                UPDATE registroMenu 
                SET idMenuComida = NULL
                WHERE idMenuComida = @IdMenu;
                
                -- Eliminar registros de precio asociados
                DELETE FROM precioComida WHERE idMenuComida = @IdMenu;
                
                -- Eliminar el elemento del menú
                DELETE FROM menuComida WHERE idMenuComida = @IdMenu;
                
                SELECT 'Elemento de comida y sus precios eliminados permanentemente' AS Resultado;
            END
            ELSE
            BEGIN
                -- Marcar como no disponible usando el ID obtenido
                UPDATE menuComida 
                SET disponibilidadMenuComida = @IdNoDisponible,
                    descripcionMenuComida = descripcionMenuComida + ' [NO DISPONIBLE]'
                WHERE idMenuComida = @IdMenu;
                
                -- También podríamos añadir una marca visual en la descripción
                
                SELECT 'Elemento de comida marcado como no disponible. ID combinación: ' + 
                       CAST(@IdNoDisponible AS VARCHAR) AS Resultado;
            END
        END
        -- Procesar elementos de bebida
        ELSE
        BEGIN
            -- Verificar que el menú de bebida existe
            IF NOT EXISTS (SELECT 1 FROM menuBebida WHERE idMenuBebida = @IdMenu)
            BEGIN
                SET @MensajeError = 'El ID de menú de bebida no existe';
                THROW 50003, @MensajeError, 1;
            END
            
            -- Eliminar permanentemente o marcar como no disponible
            IF @EliminarPermanente = 1
            BEGIN
                -- Obtener los IDs de precios asociados a este menú
                DECLARE @PreciosBebidaIds TABLE (IdPrecio INT);
                INSERT INTO @PreciosBebidaIds
                SELECT idPrecioBebida FROM precioBebida WHERE idMenuBebida = @IdMenu;
                
                -- Eliminar registros en registroMenu que referencian a estos precios
                UPDATE registroMenu 
                SET idPrecioBebida = NULL
                WHERE idPrecioBebida IN (SELECT IdPrecio FROM @PreciosBebidaIds);
                
                -- Actualizar registros que referencian directamente al menú
                UPDATE registroMenu 
                SET idMenuBebida = NULL
                WHERE idMenuBebida = @IdMenu;
                
                -- Eliminar registros de precio asociados
                DELETE FROM precioBebida WHERE idMenuBebida = @IdMenu;
                
                -- Eliminar el elemento del menú
                DELETE FROM menuBebida WHERE idMenuBebida = @IdMenu;
                
                SELECT 'Elemento de bebida y sus precios eliminados permanentemente' AS Resultado;
            END
            ELSE
            BEGIN
                -- Marcar como no disponible usando el ID obtenido
                UPDATE menuBebida 
                SET disponibilidadMenuBebida = @IdNoDisponible,
                    descripcionMenuBebida = descripcionMenuBebida + ' [NO DISPONIBLE]'
                WHERE idMenuBebida = @IdMenu;
                
                SELECT 'Elemento de bebida marcado como no disponible. ID combinación: ' + 
                       CAST(@IdNoDisponible AS VARCHAR) AS Resultado;
            END
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
            ERROR_MESSAGE() AS MensajeError,;
    END CATCH;
END;
GO

-- Para ver si un elemento de comida fue eliminado o marcado como no disponible
SELECT * FROM menuComida WHERE idMenuComida = 1;

-- Para ver si un elemento de bebida fue eliminado o marcado como no disponible
SELECT * FROM menuBebida WHERE idMenuBebida = 3;

-- Para verificar si los precios asociados fueron eliminados
SELECT * FROM precioComida WHERE idMenuComida = 1;
SELECT * FROM precioBebida WHERE idMenuBebida = 3;




