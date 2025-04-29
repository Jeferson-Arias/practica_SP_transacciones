-- Parámetros válidos

EXEC sp_EliminarElementoMenu 'Comida', 1, 0  -- Marcar comida como no disponible
EXEC sp_EliminarElementoMenu 'Bebida', 3, 1  -- Eliminar bebida permanentemente

-- Parámetros inválidos
EXEC sp_EliminarElementoMenu 'Postre', 1, 0  -- Tipo de menú inválido
EXEC sp_EliminarElementoMenu 'Comida', 999, 1  -- ID de menú inexistente
EXEC sp_EliminarElementoMenu 'Bebida', 3, 1  -- Error si la bebida está en órdenes activas


-- Sin resultados
EXEC sp_EliminarElementoMenu 'Comida', 1, 0  -- No hay resultados si ya fue marcado como no disponible
EXEC sp_EliminarElementoMenu 'Bebida', 3, 1  -- No hay resultados si ya fue eliminado

-- Gran volumen de datos


-- Para probar con muchos registros:
DECLARE @contador INT = 1;
WHILE @contador <= 20
BEGIN
    -- Suponiendo que existen IDs del 1 al 20
    EXEC sp_EliminarElementoMenu 'Comida', @contador, 0;
    SET @contador = @contador + 1;
END