IF OBJECT_ID('sp_ActualizarRestaurante') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_ActualizarRestaurante
END
GO

CREATE OR ALTER PROCEDURE sp_ActualizarRestaurante
    @idRestaurante INT,
    @nIdentificacionRestaurante VARCHAR(15),
    @nombreRestaurante VARCHAR(100),
    @nCelularRestaurante VARCHAR(10),
    @correoERestaurante VARCHAR(150),
    @direccionRestaurante VARCHAR(150),
    @disponibilidadRestaurante INT,
    @horaAperturaRestaurante TIME(0),
    @horaCierreRestaurante TIME(0),
    @mensaje NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM restaurante WHERE idRestaurante = @idRestaurante)
        BEGIN
            UPDATE restaurante
            SET
                nIdentificacionRestaurante = @nIdentificacionRestaurante,
                nombreRestaurante = @nombreRestaurante,
                nCelularRestaurante = @nCelularRestaurante,
                correoERestaurante = @correoERestaurante,
                direccionRestaurante = @direccionRestaurante,
                disponibilidadRestaurante = @disponibilidadRestaurante,
                horaAperturaRestaurante = @horaAperturaRestaurante,
                horaCierreRestaurante = @horaCierreRestaurante
            WHERE idRestaurante = @idRestaurante;

            SET @mensaje = 'Restaurante actualizado correctamente.';
        END
        ELSE
        BEGIN
            SET @mensaje = 'No se encontró un restaurante con ese ID.';
        END
    END TRY
    BEGIN CATCH
        SET @mensaje = 'Error al actualizar restaurante: ' + ERROR_MESSAGE();
    END CATCH
END;
GO