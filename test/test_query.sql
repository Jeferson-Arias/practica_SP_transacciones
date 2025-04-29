-- Parámetros válidos
DECLARE @cantidad INT;
DECLARE @sumaTotal DECIMAL(18,2);

EXEC sp_HistorialPedidosCliente
    @nIdentificacionCliente = '1001',
    @fechaInicio = '2025-01-01',
    @fechaFin = '2025-04-28',
    @cantidadPedidos = @cantidad OUTPUT,
    @sumaTotalPedidos = @sumaTotal OUTPUT;

-- Mostramos los outputs
PRINT 'Cantidad de pedidos: ' + CAST(@cantidad AS VARCHAR);
PRINT 'Suma total cobrada: ' + CAST(@sumaTotal AS VARCHAR);
--Nota: El cliente existe y tiene pedidos en el rango de fechas especificado


-- Parámetros inválidos
DECLARE @cantidadInvalido INT;
DECLARE @sumaTotalInvalido DECIMAL(18,2);

EXEC sp_HistorialPedidosCliente
    @nIdentificacionCliente = '000000000',
    @fechaInicio = '2025-01-01',
    @fechaFin = '2025-04-28',
    @cantidadPedidos = @cantidadInvalido OUTPUT,
    @sumaTotalPedidos = @sumaTotalInvalido OUTPUT;

-- Mostrar resultados
PRINT 'Cantidad de pedidos: ' + CAST(@cantidadInvalido AS VARCHAR);
PRINT 'Suma total cobrada: ' + CAST(@sumaTotalInvalido AS VARCHAR);
-- Nota: El cliente no existe
-- Nota: Se sugiere reestructurar el SP para manejar este caso

-- Sin resultados
DECLARE @cantidadSinResultados INT;
DECLARE @sumaTotalSinResultados DECIMAL(18,2);

EXEC sp_HistorialPedidosCliente
    @nIdentificacionCliente = '1001',
    @fechaInicio = '2024-01-01',
    @fechaFin = '2024-01-31',
    @cantidadPedidos = @cantidadSinResultados OUTPUT,
    @sumaTotalPedidos = @sumaTotalSinResultados OUTPUT;

-- Mostrar resultados
PRINT 'Sin resultados';
PRINT 'Cantidad de pedidos: ' + CAST(@cantidadSinResultados AS VARCHAR);
PRINT 'Suma total cobrada: ' + CAST(@sumaTotalSinResultados AS VARCHAR);
-- Nota: El cliente existe pero no tiene pedidos en el rango de fechas especificado
-- Nota: Se sugiere reestructurar el SP para manejar este caso