-- =====================================================================
-- LAB VENTAS - MySQL 8.x
-- Script completo: base de datos, tablas, datos, triggers, vistas,
-- procedimiento almacenado y pruebas opcionales.
--
-- ADVERTENCIA: este script elimina y vuelve a crear lab_ventas_mysql.
-- Ejecutar en MySQL 8.x con un usuario que tenga permisos CREATE/DROP.
-- =====================================================================

DROP DATABASE IF EXISTS lab_ventas_mysql;

CREATE DATABASE lab_ventas_mysql
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE lab_ventas_mysql;

SELECT VERSION() AS version_mysql;

-- ---------------------------------------------------------------------
-- 1. TABLAS
-- ---------------------------------------------------------------------

CREATE TABLE cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE producto (
  producto_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
  stock INT NOT NULL CHECK (stock >= 0),
  actualizado_en DATETIME(6) NOT NULL
    DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB;

CREATE TABLE venta (
  venta_id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_venta_cliente
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
) ENGINE=InnoDB;

CREATE TABLE detalle_venta (
  venta_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),
  PRIMARY KEY (venta_id, producto_id),
  CONSTRAINT fk_detalle_venta
    FOREIGN KEY (venta_id) REFERENCES venta(venta_id),
  CONSTRAINT fk_detalle_producto
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. DATOS INICIALES
-- ---------------------------------------------------------------------

INSERT INTO cliente (nombre, email) VALUES
  ('Ana Lopez',      'ana@ejemplo.test'),
  ('Luis Sagastume', 'luis@ejemplo.test');

INSERT INTO producto (nombre, precio, stock) VALUES
  ('Teclado', 100.00, 10),
  ('Mouse',    50.00, 20),
  ('Monitor', 1000.00, 8);

-- ---------------------------------------------------------------------
-- 3. TRIGGERS
-- ---------------------------------------------------------------------

DELIMITER $$

-- 3.1 Antes de insertar una línea:
--     obtiene el precio del catálogo, valida stock y lo descuenta.
CREATE TRIGGER trg_detalle_venta_bi
BEFORE INSERT ON detalle_venta
FOR EACH ROW
BEGIN
  DECLARE v_precio DECIMAL(10,2) DEFAULT NULL;
  DECLARE v_stock INT DEFAULT NULL;

  SELECT precio, stock
    INTO v_precio, v_stock
    FROM producto
   WHERE producto_id = NEW.producto_id
   FOR UPDATE;

  IF v_precio IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El producto no existe';
  END IF;

  IF NEW.cantidad > v_stock THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Stock insuficiente para la cantidad solicitada';
  END IF;

  SET NEW.precio_unitario = v_precio;

  UPDATE producto
     SET stock = stock - NEW.cantidad,
         actualizado_en = CURRENT_TIMESTAMP(6)
   WHERE producto_id = NEW.producto_id;
END$$

-- 3.2 Al eliminar una línea, devuelve las unidades al stock.
CREATE TRIGGER trg_detalle_venta_ad
AFTER DELETE ON detalle_venta
FOR EACH ROW
BEGIN
  UPDATE producto
     SET stock = stock + OLD.cantidad,
         actualizado_en = CURRENT_TIMESTAMP(6)
   WHERE producto_id = OLD.producto_id;
END$$

-- 3.3 Al cambiar la cantidad, ajusta el stock por la diferencia.
CREATE TRIGGER trg_detalle_venta_bu
BEFORE UPDATE ON detalle_venta
FOR EACH ROW
BEGIN
  DECLARE v_stock INT DEFAULT NULL;
  DECLARE v_dif INT DEFAULT 0;

  IF NEW.venta_id <> OLD.venta_id
     OR NEW.producto_id <> OLD.producto_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No se puede cambiar la venta ni el producto de una línea; elimínela y cree otra';
  END IF;

  -- Conserva el precio histórico de la venta.
  SET NEW.precio_unitario = OLD.precio_unitario;
  SET v_dif = NEW.cantidad - OLD.cantidad;

  IF v_dif > 0 THEN
    SELECT stock
      INTO v_stock
      FROM producto
     WHERE producto_id = NEW.producto_id
     FOR UPDATE;

    IF v_stock IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto no existe';
    END IF;

    IF v_dif > v_stock THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para aumentar la cantidad';
    END IF;
  END IF;

  IF v_dif <> 0 THEN
    UPDATE producto
       SET stock = stock - v_dif,
           actualizado_en = CURRENT_TIMESTAMP(6)
     WHERE producto_id = NEW.producto_id;
  END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- 4. VISTAS
-- ---------------------------------------------------------------------

-- 4.1 Detalle de ventas, subtotales y total por venta.
CREATE OR REPLACE VIEW vw_ventas_detalle AS
SELECT
  v.venta_id,
  v.fecha,
  c.cliente_id,
  c.nombre AS cliente,
  p.producto_id,
  p.nombre AS producto,
  d.cantidad,
  d.precio_unitario,
  d.cantidad * d.precio_unitario AS subtotal,
  SUM(d.cantidad * d.precio_unitario)
    OVER (PARTITION BY v.venta_id) AS total_venta
FROM venta AS v
JOIN cliente AS c
  ON c.cliente_id = v.cliente_id
JOIN detalle_venta AS d
  ON d.venta_id = v.venta_id
JOIN producto AS p
  ON p.producto_id = d.producto_id;

-- 4.2 Productos con menos de 6 unidades disponibles.
CREATE OR REPLACE VIEW vw_productos_stock_bajo AS
SELECT producto_id, nombre, precio, stock, actualizado_en
FROM producto
WHERE stock < 6;

-- ---------------------------------------------------------------------
-- 5. PROCEDIMIENTO ALMACENADO
-- Registra una venta de un producto. El trigger valida y descuenta stock.
-- ---------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE sp_registrar_venta (
  IN p_cliente_id INT,
  IN p_producto_id INT,
  IN p_cantidad INT,
  OUT p_venta_id INT
)
BEGIN
  DECLARE v_precio DECIMAL(10,2) DEFAULT NULL;
  DECLARE v_cliente_id INT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La cantidad debe ser mayor que cero';
  END IF;

  START TRANSACTION;

  SELECT cliente_id
    INTO v_cliente_id
    FROM cliente
   WHERE cliente_id = p_cliente_id;

  IF v_cliente_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El cliente no existe';
  END IF;

  SELECT precio
    INTO v_precio
    FROM producto
   WHERE producto_id = p_producto_id;

  IF v_precio IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El producto no existe';
  END IF;

  INSERT INTO venta (cliente_id)
  VALUES (p_cliente_id);

  SET p_venta_id = LAST_INSERT_ID();

  INSERT INTO detalle_venta
    (venta_id, producto_id, cantidad, precio_unitario)
  VALUES
    (p_venta_id, p_producto_id, p_cantidad, v_precio);

  COMMIT;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- 6. CONSULTAS DE VERIFICACIÓN
-- ---------------------------------------------------------------------
-- Estas consultas no registran ventas ni modifican los datos.
SELECT * FROM cliente ORDER BY cliente_id;
SELECT * FROM producto ORDER BY producto_id;
SELECT * FROM vw_productos_stock_bajo;
SELECT * FROM vw_ventas_detalle;

-- ---------------------------------------------------------------------
-- 7. EJEMPLO DE USO DEL PROCEDIMIENTO (OPCIONAL)
-- ---------------------------------------------------------------------
-- Descomenta estas líneas si deseas registrar una venta de 2 teclados:
--
-- SET @venta_nueva = NULL;
-- CALL sp_registrar_venta(1, 1, 2, @venta_nueva);
-- SELECT @venta_nueva AS venta_id_generada;
-- SELECT * FROM vw_ventas_detalle WHERE venta_id = @venta_nueva;
-- SELECT * FROM producto WHERE producto_id = 1;
--
-- NOTA: el procedimiento inicia y confirma su propia transacción.
-- No lo llames dentro de una transacción que necesites conservar.
