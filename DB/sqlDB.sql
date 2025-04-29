CREATE TABLE rolUniversitario (
    idRolUniversitario INT IDENTITY(1,1) PRIMARY KEY,
    nombreRolUniversitario VARCHAR(100) NOT NULL
);

CREATE TABLE tipoDocumento (
    idTipoDocumento INT IDENTITY(1,1) PRIMARY KEY,
    abreviaturaTipoDocumento CHAR(3) NOT NULL,
    nombreTipoDocumento VARCHAR(150) NOT NULL
);

CREATE TABLE cliente (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    idTipoDocumento INT NOT NULL,
    nIdentificacionCliente VARCHAR(15) NOT NULL,
    nombresCliente VARCHAR(100) NOT NULL,
    apellidosCliente VARCHAR(100) NOT NULL,
    nCelularCliente VARCHAR(10) NOT NULL,
    correoECliente VARCHAR(150) NOT NULL,
    direccionCliente VARCHAR(150) NOT NULL,
    idRolUniversitario INT NOT NULL,
    CONSTRAINT FK_C_tipoDocumento FOREIGN KEY (idTipoDocumento) REFERENCES tipoDocumento(idTipoDocumento),    
    CONSTRAINT FK_C_rolUniversitario FOREIGN KEY (idRolUniversitario) REFERENCES rolUniversitario(idRolUniversitario)
);

CREATE TABLE combinacionesDias (
    idCombinacionesDias INT IDENTITY(1,1) PRIMARY KEY,
    descripcionCombinacionDias VARCHAR(250)
);

CREATE TABLE restaurante (
    idRestaurante INT IDENTITY(1,1) PRIMARY KEY,
    nIdentificacionRestaurante VARCHAR(15) NOT NULL,
    nombreRestaurante VARCHAR(100) NOT NULL,
    nCelularRestaurante VARCHAR(10) NOT NULL,
    correoERestaurante VARCHAR(150) NOT NULL,
    direccionRestaurante VARCHAR(150) NOT NULL,
    disponibilidadRestaurante INT NOT NULL,
    horaAperturaRestaurante TIME(0) NOT NULL,
    horaCierreRestaurante TIME(0) NOT NULL,
    CONSTRAINT FK_R_combinacionesDias FOREIGN KEY (disponibilidadRestaurante) REFERENCES combinacionesDias(idCombinacionesDias)
);

CREATE TABLE opcionPago (
    idOpcionPago INT IDENTITY(1,1) PRIMARY KEY,
    nombreOpcionPago VARCHAR(100) NOT NULL
);

CREATE TABLE metodoPago (
    idMetodoPago INT IDENTITY(1,1) PRIMARY KEY,
    idRestaurante INT NOT NULL,
    idOpcionPago INT NOT NULL,
    descripcionMetodoPago VARCHAR(250) NOT NULL,
    CONSTRAINT FK_mP_restaurante FOREIGN KEY (idRestaurante) REFERENCES restaurante(idRestaurante),
    CONSTRAINT FK_mP_opcionPago FOREIGN KEY (idOpcionPago) REFERENCES opcionPago(idOpcionPago)
);

CREATE TABLE categoriaComida (
    idCategoriaComida INT IDENTITY(1,1) PRIMARY KEY,
    nombreCategoriaComida VARCHAR(100) NOT NULL,
    descripcionCategoriaComida VARCHAR(250) NOT NULL
);

CREATE TABLE menuComida (
    idMenuComida INT IDENTITY(1,1) PRIMARY KEY,
    idRestaurante INT NOT NULL,
    nombreMenuComida VARCHAR(100) NOT NULL,
    descripcionMenuComida VARCHAR(250) NOT NULL,
    disponibilidadMenuComida INT NOT NULL,
    idCategoriaComida INT NOT NULL,
    CONSTRAINT FK_mC_idRestaurante FOREIGN KEY (idRestaurante) REFERENCES restaurante(idRestaurante),
    CONSTRAINT FK_mC_combinacionesDias FOREIGN KEY (disponibilidadMenuComida) REFERENCES combinacionesDias(idCombinacionesDias),
    CONSTRAINT FK_mC_idCategoriaComida FOREIGN KEY (idCategoriaComida) REFERENCES categoriaComida(idCategoriaComida)
);

CREATE TABLE precioComida (
    idPrecioComida INT IDENTITY(1,1) PRIMARY KEY,
    idMenuComida INT NOT NULL,
    fechaActualizacionPrecioComida DATE NOT NULL,
    precioPrecioComida DECIMAL(18,2),
    CONSTRAINT FK_pC_idMenuComida FOREIGN KEY (idMenuComida) REFERENCES menuComida(idMenuComida)
);

CREATE TABLE menuBebida (
    idMenuBebida INT IDENTITY(1,1) PRIMARY KEY,
    idRestaurante INT NOT NULL,
    nombreMenuBebida VARCHAR(100) NOT NULL,
    descripcionMenuBebida VARCHAR(250) NOT NULL,
    disponibilidadMenuBebida INT NOT NULL,
    idCategoriaComida INT NOT NULL,
    CONSTRAINT FK_mB_idRestaurante FOREIGN KEY (idRestaurante) REFERENCES restaurante(idRestaurante),
    CONSTRAINT FK_mB_combinacionesDias FOREIGN KEY (disponibilidadMenuBebida) REFERENCES combinacionesDias(idCombinacionesDias),
    CONSTRAINT FK_mB_idCategoriaComida FOREIGN KEY (idCategoriaComida) REFERENCES categoriaComida(idCategoriaComida)
);

CREATE TABLE precioBebida (
    idPrecioBebida INT IDENTITY(1,1) PRIMARY KEY,
    idMenuBebida INT NOT NULL,
    fechaActualizacionPrecioBebida DATE NOT NULL,
    precioPrecioBebida DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_pB_idMenuBebida FOREIGN KEY (idMenuBebida) REFERENCES menuBebida(idMenuBebida)
);

CREATE TABLE estadoServicio (
    idEstadoServicio INT IDENTITY(1,1) PRIMARY KEY,
    nombreEstadoServicio VARCHAR(100) NOT NULL,
    descripcionEstadoServicio VARCHAR(250) NOT NULL
);

CREATE TABLE descuentoRol (
    idDescuentoRol INT IDENTITY(1,1) PRIMARY KEY,
    idRolUniversitario INT NOT NULL,
    porcentajeDescuentoRol DECIMAL(5,2) NOT NULL,
    fechaInicioDescuentoRol DATE NOT NULL,
    fechaFinDescuentoRol DATE NOT NULL,
    CONSTRAINT FK_dR_idRolUniversitario FOREIGN KEY (idRolUniversitario) REFERENCES rolUniversitario(idRolUniversitario)
);

CREATE TABLE ordenServicio (
    idOrdenServicio INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idRestaurante INT NOT NULL,
    idEstadoServicio INT NOT NULL,
    fechaOrdenServicio DATE NOT NULL,
    horaOrdenServicio TIME(7) NOT NULL,
    horaEntregaOrdenServicio TIME(0) NOT NULL,
    direccionOrdenServicio VARCHAR(250) NOT NULL,
    descricionOrdenServicio VARCHAR(500) NOT NULL,
    estadoPago BIT NOT NULL,
    idMetodoPago INT NOT NULL,
    sumaSubtotal DECIMAL(18,2) NOT NULL,
    idDescuentoRol INT NOT NULL,
    totalCobrado DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_oS_Cliente FOREIGN KEY (idCliente) REFERENCES cliente(idCliente),
    CONSTRAINT FK_oS_Restaurante FOREIGN KEY (idRestaurante) REFERENCES restaurante(idRestaurante),
    CONSTRAINT FK_oS_EstadoServicio FOREIGN KEY (idEstadoServicio) REFERENCES estadoServicio(idEstadoServicio),
    CONSTRAINT FK_oS_MetodoPago FOREIGN KEY (idMetodoPago) REFERENCES metodoPago(idMetodoPago),
    CONSTRAINT FK_rD_idDescuentoRol FOREIGN KEY (idDescuentoRol) REFERENCES descuentoRol(idDescuentoRol)
);

CREATE TABLE registroMenu (
    idOrdenServicio INT,
    idMenuBebida INT,
    idPrecioBebida INT,
    idMenuComida INT,
    idPrecioComida INT,
    cantidadRegistroMenu INT NOT NULL,
    subTotalRegistroMenu DECIMAL(18,2),
    CONSTRAINT FK_rM_idOrdenServicio FOREIGN KEY (idOrdenServicio) REFERENCES ordenServicio(idOrdenServicio),
    CONSTRAINT FK_rM_idMenuBebida FOREIGN KEY (idMenuBebida) REFERENCES menuBebida(idMenuBebida),
    CONSTRAINT FK_rM_idPrecioBebida FOREIGN KEY (idPrecioBebida) REFERENCES precioBebida(idPrecioBebida),
    CONSTRAINT FK_rM_idMenuComida FOREIGN KEY (idMenuComida) REFERENCES menuComida(idMenuComida),
    CONSTRAINT FK_rM_idPrecioComida FOREIGN KEY (idPrecioComida) REFERENCES precioComida(idPrecioComida)
);




-- Insertar roles universitarios
INSERT INTO rolUniversitario (nombreRolUniversitario) VALUES 
('Estudiante'), ('Profesor'), ('Administrador');

-- Insertar tipos de documento
INSERT INTO tipoDocumento (abreviaturaTipoDocumento, nombreTipoDocumento) VALUES 
('CC', 'Cédula de Ciudadanía'),
('TI', 'Tarjeta de Identidad'),
('PAS', 'Pasaporte'),
('CE', 'Cédula de Extranjería');

-- Insertar clientes
INSERT INTO cliente (idTipoDocumento, nIdentificacionCliente, nombresCliente, apellidosCliente, nCelularCliente, correoECliente, direccionCliente, idRolUniversitario) VALUES 

(1, '1001001001', 'Carlos', 'Ramírez', '3001001001', 'carlos.ramirez@email.com', 'Calle 10 #45-67', 1),  
(2, '2002002002', 'Laura', 'Fernández', '3102002002', 'laura.fernandez@email.com', 'Carrera 5 #12-34', 2),  
(1, '3003003003', 'Andrés', 'Gómez', '3203003003', 'andres.gomez@email.com', 'Avenida Siempre Viva 742', 3),  
(3, '4004004004', 'Diana', 'López', '3304004004', 'diana.lopez@email.com', 'Diagonal 20 #8-55', 2),  
(2, '5005005005', 'Sofía', 'Martínez', '3405005005', 'sofia.martinez@email.com', 'Transversal 15 #6-78', 1),  
(1, '6006006006', 'Pedro', 'García', '3506006006', 'pedro.garcia@email.com', 'Calle 50 #22-10', 2),  
(3, '7007007007', 'Mariana', 'Torres', '3607007007', 'mariana.torres@email.com', 'Carrera 8 #30-99', 3),  
(2, '8008008008', 'Felipe', 'Mendoza', '3708008008', 'felipe.mendoza@email.com', 'Calle 14 #88-23', 1),  
(1, '9009009009', 'Camila', 'Rodríguez', '3809009009', 'camila.rodriguez@email.com', 'Avenida 7 #19-45', 1),  
(3, '1010101010', 'David', 'Silva', '3901010101', 'david.silva@email.com', 'Carrera 9 #21-54', 2),  
(1, '1111111111', 'Natalia', 'Ríos', '3011111111', 'natalia.rios@email.com', 'Diagonal 5 #43-87', 3),  
(2, '1212121212', 'Sebastián', 'Morales', '3112121212', 'sebastian.morales@email.com', 'Transversal 22 #9-12', 1),  
(3, '1313131313', 'Valentina', 'Pérez', '3213131313', 'valentina.perez@email.com', 'Calle 9 #12-78', 1),  
(1, '1414141414', 'Javier', 'Hernández', '3314141414', 'javier.hernandez@email.com', 'Avenida 3 #45-90', 2),  
(2, '1515151515', 'Carolina', 'Ortiz', '3415151515', 'carolina.ortiz@email.com', 'Carrera 1 #33-21', 3),  
(3, '1616161616', 'Tomás', 'Vargas', '3516161616', 'tomas.vargas@email.com', 'Diagonal 11 #66-43', 3),  
(1, '1717171717', 'Andrea', 'Ramírez', '3617171717', 'andrea.ramirez@email.com', 'Calle 15 #10-76', 1),  
(2, '1818181818', 'Ricardo', 'Salazar', '3718181818', 'ricardo.salazar@email.com', 'Carrera 7 #88-12', 2),  
(3, '1919191919', 'Fernanda', 'Delgado', '3819191919', 'fernanda.delgado@email.com', 'Avenida 2 #17-65', 3),  
(1, '2020202020', 'Manuel', 'Castro', '3920202020', 'manuel.castro@email.com', 'Transversal 14 #9-34', 3);  


-- Insertar combinaciones de días
INSERT INTO combinacionesDias (descripcionCombinacionDias) VALUES
('Lunes'),
('Martes'),
('Miércoles'),
('Jueves'),
('Viernes'),
('Sábado'),
('Domingo'),
('Lunes, Martes'),
('Lunes, Miércoles'),
('Lunes, Jueves'),
('Lunes, Viernes'),
('Lunes, Sábado'),
('Lunes, Domingo'),
('Martes, Miércoles'),
('Martes, Jueves'),
('Martes, Viernes'),
('Martes, Sábado'),
('Martes, Domingo'),
('Miércoles, Jueves'),
('Miércoles, Viernes'),
('Miércoles, Sábado'),
('Miércoles, Domingo'),
('Jueves, Viernes'),
('Jueves, Sábado'),
('Jueves, Domingo'),
('Viernes, Sábado'),
('Viernes, Domingo'),
('Sábado, Domingo'),
('Lunes, Martes, Miércoles'),
('Lunes, Martes, Jueves'),
('Lunes, Martes, Viernes'),
('Lunes, Martes, Sábado'),
('Lunes, Martes, Domingo'),
('Lunes, Miércoles, Jueves'),
('Lunes, Miércoles, Viernes'),
('Lunes, Miércoles, Sábado'),
('Lunes, Miércoles, Domingo'),
('Lunes, Jueves, Viernes'),
('Lunes, Jueves, Sábado'),
('Lunes, Jueves, Domingo'),
('Lunes, Viernes, Sábado'),
('Lunes, Viernes, Domingo'),
('Lunes, Sábado, Domingo'),
('Martes, Miércoles, Jueves'),
('Martes, Miércoles, Viernes'),
('Martes, Miércoles, Sábado'),
('Martes, Miércoles, Domingo'),
('Martes, Jueves, Viernes'),
('Martes, Jueves, Sábado'),
('Martes, Jueves, Domingo'),
('Martes, Viernes, Sábado'),
('Martes, Viernes, Domingo'),
('Martes, Sábado, Domingo'),
('Miércoles, Jueves, Viernes'),
('Miércoles, Jueves, Sábado'),
('Miércoles, Jueves, Domingo'),
('Miércoles, Viernes, Sábado'),
('Miércoles, Viernes, Domingo'),
('Miércoles, Sábado, Domingo'),
('Jueves, Viernes, Sábado'),
('Jueves, Viernes, Domingo'),
('Jueves, Sábado, Domingo'),
('Viernes, Sábado, Domingo'),
('Lunes, Martes, Miércoles, Jueves'),
('Lunes, Martes, Miércoles, Viernes'),
('Lunes, Martes, Miércoles, Sábado'),
('Lunes, Martes, Miércoles, Domingo'),
('Lunes, Martes, Jueves, Viernes'),
('Lunes, Martes, Jueves, Sábado'),
('Lunes, Martes, Jueves, Domingo'),
('Lunes, Martes, Viernes, Sábado'),
('Lunes, Martes, Viernes, Domingo'),
('Lunes, Martes, Sábado, Domingo'),
('Lunes, Miércoles, Jueves, Viernes'),
('Lunes, Miércoles, Jueves, Sábado'),
('Lunes, Miércoles, Jueves, Domingo'),
('Lunes, Miércoles, Viernes, Sábado'),
('Lunes, Miércoles, Viernes, Domingo'),
('Lunes, Miércoles, Sábado, Domingo'),
('Lunes, Jueves, Viernes, Sábado'),
('Lunes, Jueves, Viernes, Domingo'),
('Lunes, Jueves, Sábado, Domingo'),
('Lunes, Viernes, Sábado, Domingo'),
('Martes, Miércoles, Jueves, Viernes'),
('Martes, Miércoles, Jueves, Sábado'),
('Martes, Miércoles, Jueves, Domingo'),
('Martes, Miércoles, Viernes, Sábado'),
('Martes, Miércoles, Viernes, Domingo'),
('Martes, Miércoles, Sábado, Domingo'),
('Martes, Jueves, Viernes, Sábado'),
('Martes, Jueves, Viernes, Domingo'),
('Martes, Jueves, Sábado, Domingo'),
('Martes, Viernes, Sábado, Domingo'),
('Miércoles, Jueves, Viernes, Sábado'),
('Miércoles, Jueves, Viernes, Domingo'),
('Miércoles, Jueves, Sábado, Domingo'),
('Miércoles, Viernes, Sábado, Domingo'),
('Jueves, Viernes, Sábado, Domingo'),
('Lunes, Martes, Miércoles, Jueves, Viernes'),
('Lunes, Martes, Miércoles, Jueves, Sábado'),
('Lunes, Martes, Miércoles, Jueves, Domingo'),
('Lunes, Martes, Miércoles, Viernes, Sábado'),
('Lunes, Martes, Miércoles, Viernes, Domingo'),
('Lunes, Martes, Miércoles, Sábado, Domingo'),
('Lunes, Martes, Jueves, Viernes, Sábado'),
('Lunes, Martes, Jueves, Viernes, Domingo'),
('Lunes, Martes, Jueves, Sábado, Domingo'),
('Lunes, Martes, Viernes, Sábado, Domingo'),
('Lunes, Miércoles, Jueves, Viernes, Sábado'),
('Lunes, Miércoles, Jueves, Viernes, Domingo'),
('Lunes, Miércoles, Jueves, Sábado, Domingo'),
('Lunes, Miércoles, Viernes, Sábado, Domingo'),
('Lunes, Jueves, Viernes, Sábado, Domingo'),
('Martes, Miércoles, Jueves, Viernes, Sábado'),
('Martes, Miércoles, Jueves, Viernes, Domingo'),
('Martes, Miércoles, Jueves, Sábado, Domingo'),
('Martes, Miércoles, Viernes, Sábado, Domingo'),
('Martes, Jueves, Viernes, Sábado, Domingo'),
('Miércoles, Jueves, Viernes, Sábado, Domingo'),
('Lunes, Martes, Miércoles, Jueves, Viernes, Sábado'),
('Lunes, Martes, Miércoles, Jueves, Viernes, Domingo'),
('Lunes, Martes, Miércoles, Jueves, Sábado, Domingo'),
('Lunes, Martes, Miércoles, Viernes, Sábado, Domingo'),
('Lunes, Martes, Jueves, Viernes, Sábado, Domingo'),
('Lunes, Miércoles, Jueves, Viernes, Sábado, Domingo'),
('Martes, Miércoles, Jueves, Viernes, Sábado, Domingo'),
('Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo');


-- Insertar restaurantes
INSERT INTO restaurante (nIdentificacionRestaurante, nombreRestaurante, nCelularRestaurante, correoERestaurante, direccionRestaurante, disponibilidadRestaurante, horaAperturaRestaurante, horaCierreRestaurante)
VALUES
(1, 'El Buen Sabor', '3001234567', 'contacto@elbuen.com', 'Calle 10 #25-30', 1, '08:00:00', '22:00:00'),
(2, 'Pizzería La Roca', '3007654321', 'info@laroca.com', 'Carrera 15 #12-50', 2, '12:00:00', '23:30:00'),
(3, 'Parrilla Don Pepe', '3209876543', 'reservas@donpepe.com', 'Av. Principal #45-78', 3, '11:00:00', '00:00:00'),
(4, 'Sushi Samurai', '3105678901', 'hello@sushisamurai.com', 'Cra 9 #34-56', 4, '13:00:00', '22:30:00'),
(5, 'Veggie Delight', '3054321987', 'hola@veggiedelight.com', 'Calle 20 #6-10', 5, '09:00:00', '21:00:00'),
(6, 'Burguer Kingstown', '3112233445', 'info@kingstown.com', 'Cra 40 #23-19', 6, '10:00:00', '02:00:00'),
(7, 'Tacos El Patrón', '3006785432', 'contacto@elpatron.com', 'Carrera 7 #14-22', 7, '17:00:00', '01:00:00'),
(8, 'La Casa del Marisco', '3201122334', 'reserva@casamarisco.com', 'Calle 8 #50-32', 8, '12:30:00', '22:00:00'),
(9, 'Café Central', '3123344556', 'info@cafecentral.com', 'Av. Libertador #5-21', 9, '07:00:00', '20:00:00'),
(10, 'Asadero Los Llanos', '3109988776', 'asadero@losllanos.com', 'Cra 25 #17-44', 10, '11:30:00', '23:45:00');

-- Insertar opciones de pago
INSERT INTO opcionPago (nombreOpcionPago) VALUES 
('Efectivo'), ('Tarjeta de crédito'), ('Nequi'), ('Bancolombia');

-- Insertar métodos de pago para los restaurantes
INSERT INTO metodoPago (idRestaurante, idOpcionPago, descripcionMetodoPago) 
VALUES 
(3, 3, 'Número Nequi: 3201234567'),
(9, 4, 'Cuenta Bancolombia: 123456789'),
(1, 1, 'Pagar Sencillo'),
(2, 1, 'Pagar sencillo'),
(4, 1, 'Pagar sencillo'),
(5, 1, 'Pagar sencillo'),
(6, 1, 'Pagar sencillo'),
(7, 1, 'Pagar sencillo'),
(8, 1, 'Pagar sencillo'),
(10, 1, 'Pagar sencillo');


-- Insertar categorías de comida
INSERT INTO categoriaComida (nombreCategoriaComida, descripcionCategoriaComida) VALUES 
('Desayuno', 'Platos para la mañana'), 
('Almuerzo', 'Platos principales'),
('Cena', 'Comida ligera para la noche');

-- Insertar menús de comida
INSERT INTO menuComida (idRestaurante, nombreMenuComida, descripcionMenuComida, disponibilidadMenuComida, idCategoriaComida) VALUES 
(3, 'Bandeja Paisa', 'Arroz, frijoles, chicharrón, carne molida, huevo, plátano', 1, 2),
(4, 'Hamburguesa Clásica', 'Pan, carne, lechuga, tomate, queso, salsas', 2, 2),
(3, 'Empanadas de Carne', 'Empanadas rellenas con carne y papa', 1, 3),
(4, 'Sushi Especial', 'Rollos de sushi con salmón, aguacate y queso crema', 1, 2),
(5, 'Ensalada Vegana', 'Lechuga, tomate, zanahoria, quinoa, aderezo especial', 1, 2),
(6, 'Tacos al Pastor', 'Tortillas de maíz con cerdo marinado, piña y cilantro', 2, 2),
(7, 'Ceviche Mixto', 'Pescado y mariscos marinados en limón con cebolla morada', 1, 3),
(8, 'Pizza Margarita', 'Masa, salsa de tomate, mozzarella y albahaca', 2, 3),
(9, 'Pasta Carbonara', 'Espaguetis con salsa de huevo, panceta y queso parmesano', 1, 3),
(10, 'Pollo a la Brasa', 'Pollo asado acompañado de papas fritas y ensalada', 2, 2);


-- Insertar precios de comida
INSERT INTO precioComida (idMenuComida, fechaActualizacionPrecioComida, precioPrecioComida) VALUES 
(1, '2025-03-23', 25000),
(2, '2025-03-23', 18000),
(3, '2025-03-23', 7000),
(4, '2025-03-23', 32000),
(5, '2025-03-23', 15000),
(6, '2025-03-23', 20000),
(7, '2025-03-23', 28000),
(8, '2025-03-23', 22000),
(9, '2025-03-23', 24000),
(10, '2025-03-23', 21000),
(6, '2025-03-24', 20500),
(7, '2025-03-24', 28500),
(8, '2025-03-24', 22500);



-- Insertar precios de bebidas
INSERT INTO menuBebida (idRestaurante, nombreMenuBebida, descripcionMenuBebida, disponibilidadMenuBebida, idCategoriaComida) VALUES 
(3, 'Jugo de Naranja', 'Jugo natural recién exprimido', 1, 3),
(4, 'Café Americano', 'Café negro sin azúcar', 2, 3),
(5, 'Té Verde', 'Infusión de té verde caliente', 1, 3),
(6, 'Limonada Natural', 'Limonada preparada con limón fresco', 1, 3),
(7, 'Chocolate Caliente', 'Bebida caliente de cacao con leche', 2, 3),
(8, 'Batido de Fresa', 'Batido cremoso con leche y fresas naturales', 1, 3),
(9, 'Mojito sin Alcohol', 'Refrescante mezcla de menta, limón y soda', 1, 3),
(9, 'Refresco de Cola', 'Bebida gaseosa clásica', 2, 3),
(1, 'Jugo de Mango', 'Jugo natural de mango', 1, 3),
(3, 'Agua de Coco', 'Agua de coco natural servida fría', 1, 3),
(7, 'Malteada de Chocolate', 'Malteada espesa con helado de chocolate', 2, 3),
(8, 'Jugo de Zanahoria', 'Jugo natural de zanahoria con un toque de naranja', 1, 3),
(6, 'Soda de Maracuyá', 'Soda burbujeante con esencia de maracuyá', 1, 3);

INSERT INTO precioBebida (idMenuBebida, fechaActualizacionPrecioBebida, precioPrecioBebida) VALUES 
(1, '2025-03-23', 5000.00),
(2, '2025-03-23', 4500.00),
(3, '2025-03-23', 5500.00),
(4, '2025-03-23', 6000.00),
(5, '2025-03-23', 5200.00),
(6, '2025-03-23', 4800.00),
(7, '2025-03-23', 4500.00),
(8, '2025-03-23', 5500.00),
(9, '2025-03-23', 6000.00),
(10, '2025-03-23', 5200.00),
(11, '2025-03-23', 4800.00),
(12, '2025-03-23', 4500.00),
(13, '2025-03-23', 5500.00),
(8, '2025-03-24', 6500.00),
(3, '2025-03-24', 5900.00),
(11, '2025-03-24', 5200.00);



-- Insertar estados de servicio
INSERT INTO estadoServicio (nombreEstadoServicio, descripcionEstadoServicio) VALUES 
('En proceso', 'Orden en preparación'),
('Entregado', 'Orden entregada al cliente'),
('Cancelado', 'Orden cancelada');


-- Insertar descuentos por rol universitario
INSERT INTO descuentoRol (idRolUniversitario, porcentajeDescuentoRol, fechaInicioDescuentoRol, fechaFinDescuentoRol) VALUES 
(1, 10, '2025-01-01', '2025-12-31'),
(2, 15, '2025-01-01', '2025-12-31');

-- Insertar órdenes de servicio
INSERT INTO ordenServicio (
    idCliente, idRestaurante, idEstadoServicio, fechaOrdenServicio, 
    horaOrdenServicio, horaEntregaOrdenServicio, direccionOrdenServicio, 
    descricionOrdenServicio, estadoPago, idMetodoPago, 
    sumaSubtotal, idDescuentoRol, totalCobrado
) VALUES 
(5, 3, 1, '2025-03-23', '12:30', '13:00', 'Universidad Minuto de Dios, Calle 80', 'Pedido especial sin cebolla', 1, 3, 25000, 1, 22500),
(6, 4, 2, '2025-03-23', '14:00', '14:30', 'Universidad Minuto de Dios, Calle 80', 'Sin picante', 1, 4, 18000, 2, 15300),
(7, 3, 1, '2025-03-23', '18:45', '19:15', 'Universidad Minuto de Dios, Calle 80', 'Agregar queso extra', 1, 3, 22000, 1, 19800),
(8, 4, 3, '2025-03-23', '20:10', '20:40', 'Universidad Minuto de Dios, Calle 80', 'Pedido sin gluten', 1, 3, 27000, 2, 22950),
(9, 5, 2, '2025-03-23', '11:20', '11:50', 'Universidad Minuto de Dios, Calle 80', 'Sin mayonesa', 0, 3, 15000, 1, 13500),
(10, 6, 1, '2025-03-23', '13:50', '14:20', 'Universidad Minuto de Dios, Calle 80', 'Extra salsa BBQ', 1, 4, 26000, 2, 20800),
(11, 7, 2, '2025-03-23', '16:30', '17:00', 'Universidad Minuto de Dios, Calle 80', 'Doble carne', 1, 3, 32000, 2, 27200),
(12, 8, 3, '2025-03-23', '19:00', '19:30', 'Universidad Minuto de Dios, Calle 80', 'Sin ajo', 0, 3, 17000, 1, 15300);




-- Insertar registros de menú en órdenes de servicio
INSERT INTO registroMenu (idOrdenServicio, idMenuBebida, idPrecioBebida, idMenuComida, idPrecioComida, cantidadRegistroMenu, subTotalRegistroMenu) VALUES 
(1, 1, 1, NULL, NULL, 1, 5000),
(2, 2, 2, NULL, NULL, 1, 4500),
(3, 3, 3, NULL, NULL, 2, 14000),
(4, 3, 3, NULL, NULL, 1, 27000),
(5, 4, 4, NULL, NULL, 3, 45000),
(6, 5, 6, NULL, NULL, 2, 52000),
(7, 5, 5, NULL, NULL, 1, 32000),
(8, 6, 6, NULL, NULL, 2, 34000),
(1, NULL, NULL, 7, 3, 1, 18300),
(2, NULL, NULL, 5, 8, 2, 14000),
(3, NULL, NULL, 9, 5, 1, 27000),
(4, NULL, NULL, 10, 6, 3, 45000),
(5, NULL, NULL, 2, 7, 2, 52000),
(6, NULL, NULL, 5, 8, 1, 32000),
(7, NULL, NULL, 9, 9, 2, 34000);