CREATE OR ALTER PROCEDURE sp_InsertarOrdenServicio
    @idCliente INT,
    @idRestaurante INT,
    @idMetodoPago INT,
    @direccionOrdenServicio VARCHAR(250),
    @descricionOrdenServicio VARCHAR(500),
    @sumaSubtotal DECIMAL(18,2),
    @idDescuentoRol INT,
    @totalCobrado DECIMAL(18,2),
    @idEstadoServicio INT = 1, -- Estado inicial, por ejemplo "pendiente"
    @idOrdenServicio INT OUTPUT,
    @mensaje NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO ordenServicio (
            idCliente,
            idRestaurante,
            idEstadoServicio,
            fechaOrdenServicio,
            horaOrdenServicio,
            horaEntregaOrdenServicio,
            direccionOrdenServicio,
            descricionOrdenServicio,
            estadoPago,
            idMetodoPago,
            sumaSubtotal,
            idDescuentoRol,
            totalCobrado
        )
        VALUES (
            @idCliente,
            @idRestaurante,
            @idEstadoServicio,
            CAST(GETDATE() AS DATE),
            CAST(GETDATE() AS TIME(7)),
            DATEADD(MINUTE, 30, CAST(GETDATE() AS TIME(0))),
            @direccionOrdenServicio,
            @descricionOrdenServicio,
            0, -- No pagado aún
            @idMetodoPago,
            @sumaSubtotal,
            @idDescuentoRol,
            @totalCobrado
        );

        -- Recuperar el último ID insertado
        SET @idOrdenServicio = SCOPE_IDENTITY();
        SET @mensaje = 'Orden de servicio registrada exitosamente.';

    END TRY
    BEGIN CATCH
        SET @idOrdenServicio = 0;
        SET @mensaje = 'Error al registrar la orden de servicio: ' + ERROR_MESSAGE();
    END CATCH
END
