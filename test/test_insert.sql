-- Parámetros válidos

EXEC sp_InsertarPrecios 'Comida', 1, 15000.00
EXEC sp_InsertarPrecios 'Bebida', 3, 5000.00

-- Parámetros inválidos

EXEC sp_InsertarPrecios 'Postre', 1, 5000.00  -- Tipo de menú inválido para ingresar en la el ssp
EXEC sp_InsertarPrecios 'Comida', 1, -500.00  -- Precio negativo esto no esta programado para que sea logico ante el sistema estructurado que creamos de la DB
EXEC sp_InsertarPrecios 'Comida', 999, 5000.00  -- ID de menú inexistente por ende nunca va a entrar al procedimiento si no existe en la tabla.

-- Sin resultados


-- Gran volumen de datos

-- Gran volumen de datos.Para probar con muchos registros, se podría crear un bucle o script que ejecute el procedimiento múltiples veces:

DECLARE @contador INT = 1;
WHILE @contador <= 5
BEGIN
    EXEC sp_InsertarPrecios 'Comida', @contador, 15000.00;
    SET @contador = @contador + 1;
END