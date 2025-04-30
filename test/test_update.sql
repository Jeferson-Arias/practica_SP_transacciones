-- Parámetros válidos
DECLARE @mensaje NVARCHAR(250);

EXEC sp_ActualizarRestaurante
    @idRestaurante = 1,
    @nIdentificacionRestaurante = '900384729',
    @nombreRestaurante = 'Sazón de la Abuela Actualizado',
    @nCelularRestaurante = '3201234567',
    @correoERestaurante = 'abuela.actualizado@restaurante.com',
    @direccionRestaurante = 'Calle 80 #72-14 Local 102',
    @disponibilidadRestaurante = 99,
    @horaAperturaRestaurante = '07:00:00',
    @horaCierreRestaurante = '17:00:00',
    @mensaje = @mensaje OUTPUT;

PRINT @mensaje;

-- Parámetros inválidos
DECLARE @mensaje NVARCHAR(250);

EXEC sp_ActualizarRestaurante
    @idRestaurante = 2,
    @nIdentificacionRestaurante = '901627384',
    @nombreRestaurante = 'La Cosecha Criolla',
    @nCelularRestaurante = '315123456789',  -- Inválido (11 caracteres)
    @correoERestaurante = 'error@restaurante.com',
    @direccionRestaurante = 'Nueva Dirección',
    @disponibilidadRestaurante = 84,
    @horaAperturaRestaurante = '08:00:00',
    @horaCierreRestaurante = '17:00:00',
    @mensaje = @mensaje OUTPUT;

PRINT @mensaje;

-- Sin resultados
DECLARE @mensaje NVARCHAR(250);

EXEC sp_ActualizarRestaurante
    @idRestaurante = 9999,
    @nIdentificacionRestaurante = '900000000',
    @nombreRestaurante = 'Inexistente',
    @nCelularRestaurante = '3000000000',
    @correoERestaurante = 'noexiste@restaurante.com',
    @direccionRestaurante = 'Dirección falsa',
    @disponibilidadRestaurante = 10,
    @horaAperturaRestaurante = '09:00:00',
    @horaCierreRestaurante = '17:00:00',
    @mensaje = @mensaje OUTPUT;

PRINT @mensaje;
