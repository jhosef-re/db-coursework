-- =====================================================================
-- Script para poblar la base de datos: inventory_jh
-- Ejecutar después de 01_create_database.sql
-- =====================================================================

USE inventory_jh;

-- ---------------------------------------------------------------------
-- Datos: producto
-- ---------------------------------------------------------------------
INSERT INTO producto (nombre) VALUES
    ('Laptop HP 15'),
    ('Mouse inalámbrico Logitech'),
    ('Teclado mecánico Redragon'),
    ('Monitor Samsung 24"'),
    ('Impresora Epson L3250'),
    ('Disco duro externo 1TB'),
    ('Memoria USB 32GB'),
    ('Silla ergonómica de oficina'),
    ('Router TP-Link AC1200'),
    ('Webcam Logitech C920');

-- ---------------------------------------------------------------------
-- Datos: inventario (uno por producto)
-- ---------------------------------------------------------------------
INSERT INTO inventario (id_producto, precio, existencia_actual, existencia_minima) VALUES
    (1, 4500.00, 15, 5),
    (2, 120.50, 50, 10),
    (3, 350.00, 30, 8),
    (4, 1200.00, 20, 5),
    (5, 950.75, 12, 4),
    (6, 480.00, 25, 6),
    (7, 65.00, 100, 20),
    (8, 850.00, 10, 3),
    (9, 275.00, 18, 5),
    (10, 320.00, 22, 6);

-- ---------------------------------------------------------------------
-- Datos: cliente
-- ---------------------------------------------------------------------
INSERT INTO cliente (nombre, nit, correo) VALUES
    ('Juan Pérez', '1234567-8', 'juan.perez@correo.com'),
    ('María López', '2345678-9', 'maria.lopez@correo.com'),
    ('Carlos Ramírez', '3456789-0', 'carlos.ramirez@correo.com'),
    ('Ana Gómez', '4567890-1', 'ana.gomez@correo.com'),
    ('Distribuidora El Progreso, S.A.', '5678901-2', 'contacto@elprogreso.com'),
    ('Luis Morales', '6789012-3', 'luis.morales@correo.com');

-- ---------------------------------------------------------------------
-- Datos: factura
-- ---------------------------------------------------------------------
INSERT INTO factura (fecha, id_cliente) VALUES
    ('2026-08-01', 1),
    ('2026-08-03', 2),
    ('2026-08-05', 3),
    ('2026-08-10', 1),
    ('2026-08-15', 4),
    ('2026-08-20', 5),
    ('2026-08-25', 6),
    ('2026-09-01', 2);

-- ---------------------------------------------------------------------
-- Datos: det_fac (detalle de cada factura)
-- ---------------------------------------------------------------------
INSERT INTO det_fac (id_factura, id_producto, cantidad) VALUES
    (1, 1, 1),
    (1, 2, 2),
    (2, 3, 1),
    (2, 4, 1),
    (3, 5, 1),
    (3, 7, 5),
    (4, 6, 2),
    (4, 9, 1),
    (5, 8, 1),
    (5, 10, 1),
    (6, 2, 3),
    (6, 7, 10),
    (7, 4, 2),
    (7, 1, 1),
    (8, 3, 2),
    (8, 6, 1);
