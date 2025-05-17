
GO

-- Primero, si ya existe una versión anterior del trigger, la eliminamos para evitar errores.
-- Asegurándonos que el nombre en DROP y CREATE sea el mismo.
IF OBJECT_ID('TRIGGER_Aviso_PedidoCambioEstadoCliente', 'TR') IS NOT NULL
    DROP TRIGGER TRIGGER_Aviso_PedidoCambioEstadoCliente;
GO

CREATE TRIGGER TRIGGER_Aviso_PedidoCambioEstadoCliente
ON ordenServicio
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    
    IF UPDATE(idEstadoServicio)
    BEGIN
        DECLARE @todosLosMensajes NVARCHAR(MAX); -- Usar NVARCHAR(MAX) para mensajes potencialmente largos

        -- Construir una sola cadena con todos los mensajes individuales para que todos sus atributos se impriman de forma elegante visualmente
       
        SELECT @todosLosMensajes = STRING_AGG(CAST(mensaje_individual.texto AS NVARCHAR(MAX)), CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10))
        FROM (
            SELECT
                (
                    '------------------------------------------------------------' + CHAR(13) + CHAR(10) +
                    ' ¡ATENCIÓN! Actualización de Pedido ' + CHAR(13) + CHAR(10) +
                    '------------------------------------------------------------' + CHAR(13) + CHAR(10) +
                    'Estimado(a) ' + LTRIM(RTRIM(ISNULL(c.nombresCliente + ' ' + c.apellidosCliente, 'Cliente'))) + ',' + CHAR(13) + CHAR(10) +
                    'Tu pedido N° ' + CAST(i.idOrdenServicio AS VARCHAR(10)) +
                    ' del restaurante "' + ISNULL(r.nombreRestaurante, 'Restaurante Desconocido') + '"' + CHAR(13) + CHAR(10) +
                    'ha cambiado de estado:' + CHAR(13) + CHAR(10) +
                    '   Estado Anterior: [' + ISNULL(es_ant.nombreEstadoServicio, 'No definido') + ']' + CHAR(13) + CHAR(10) +
                    '    Nuevo Estado:  [' + ISNULL(es_nue.nombreEstadoServicio, 'No definido') + '] ' + CHAR(13) + CHAR(10) +
                    'Fecha de actualización: ' + CONVERT(VARCHAR, GETDATE(), 103) + ' ' + CONVERT(VARCHAR, GETDATE(), 108) + CHAR(13) + CHAR(10) + -- DD/MM/YYYY HH:MM:SS
                    '------------------------------------------------------------'
                ) AS texto
            FROM
                inserted i
            INNER JOIN
                deleted d ON i.idOrdenServicio = d.idOrdenServicio
            INNER JOIN
                cliente c ON i.idCliente = c.idCliente
            INNER JOIN
                restaurante r ON i.idRestaurante = r.idRestaurante
            LEFT JOIN -- Usar LEFT JOIN por si un estado no tuviera nombre (aunque no debería pasar con FKs)
                estadoServicio es_ant ON d.idEstadoServicio = es_ant.idEstadoServicio
            LEFT JOIN
                estadoServicio es_nue ON i.idEstadoServicio = es_nue.idEstadoServicio
            WHERE
                i.idEstadoServicio <> d.idEstadoServicio -- Clave: Solo si el estado realmente cambió
        ) AS mensaje_individual;

        -- Imprimir la cadena consolidada de mensajes si se generó alguno
        IF @todosLosMensajes IS NOT NULL AND LEN(@todosLosMensajes) > 0
        BEGIN
            PRINT @todosLosMensajes;
        END
    END
END;
GO





-------------------------------------------------------




-- Disparamos el trigger para que se vea el aviso de que el estado de 
--la orden ha cambiado por ende el ciente va a saber 
--que ya tiene un nuevo estado en su orden
UPDATE ordenServicio
SET 
    idEstadoServicio =  --estado al que quiero llegar 
WHERE 
    idOrdenServicio = --id de la orden que quiero cambiar en mi db; 
GO


select * from estadoServicio;
select * from ordenServicio;
