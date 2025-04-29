-- Eliminamos la versión anterior si existe
IF OBJECT_ID('sp_HistorialPedidosCliente', 'P') IS NOT NULL
    DROP PROCEDURE sp_HistorialPedidosCliente;
GO

CREATE PROCEDURE sp_HistorialPedidosCliente
    -- Variables de entrada
    @nIdentificacionCliente VARCHAR(15),
    @fechaInicio DATE,
    @fechaFin DATE,

    -- Variables de salida
    @cantidadPedidos INT OUTPUT,
    @sumaTotalPedidos DECIMAL(18,2) OUTPUT

    -- Variables internas
AS
BEGIN
    SET NOCOUNT ON;

    -- Inicializamos los outputs
    SET @cantidadPedidos = 0;
    SET @sumaTotalPedidos = 0;

    -- Tabla temporal para capturar resultados
    DECLARE @tablaResultados TABLE (
        NombreCompletoCliente VARCHAR(200),
        CorreoCliente VARCHAR(150),
        Restaurante VARCHAR(100),
        FechaOrden DATE,
        HoraOrden TIME(7),
        EstadoServicio VARCHAR(100),
        TotalCobrado DECIMAL(18,2),
        EstadoPago VARCHAR(20)
    );

    -- Insertamos los resultados en la tabla temporal
    INSERT INTO @tablaResultados
    SELECT 
        c.nombresCliente + ' ' + c.apellidosCliente AS NombreCompletoCliente,
        c.correoECliente AS CorreoCliente,
        r.nombreRestaurante AS Restaurante,
        os.fechaOrdenServicio AS FechaOrden,
        os.horaOrdenServicio AS HoraOrden,
        es.nombreEstadoServicio AS EstadoServicio,
        os.totalCobrado AS TotalCobrado,
        CASE 
            WHEN os.estadoPago = 1 THEN 'Pagado'
            ELSE 'Pendiente'
        END AS EstadoPago
    FROM 
        ordenServicio os
        INNER JOIN cliente c ON os.idCliente = c.idCliente
        INNER JOIN restaurante r ON os.idRestaurante = r.idRestaurante
        INNER JOIN estadoServicio es ON os.idEstadoServicio = es.idEstadoServicio
    WHERE 
        c.nIdentificacionCliente = @nIdentificacionCliente
        AND os.fechaOrdenServicio BETWEEN @fechaInicio AND @fechaFin;

    -- Asignamos a los parámetros OUTPUT
    SELECT 
        @cantidadPedidos = COUNT(*),
        @sumaTotalPedidos = ISNULL(SUM(TotalCobrado), 0)
    FROM 
        @tablaResultados;

    -- Mostramos los resultados al usuario
    SELECT * FROM @tablaResultados;

END;
GO