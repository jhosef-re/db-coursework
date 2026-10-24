-- =====================================================================
-- Script de creación de base de datos: Inventory_Jh
-- Motor: MySQL
-- Convención de nombres: snake_case (minúsculas, palabras separadas por _)
-- =====================================================================

DROP DATABASE IF EXISTS inventory_jh;
CREATE DATABASE inventory_jh
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE inventory_jh;

-- ---------------------------------------------------------------------
-- Tabla: producto
-- ---------------------------------------------------------------------
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT,
    nombre      VARCHAR(150) NOT NULL,
    PRIMARY KEY (id_producto)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: inventario
-- (relación 1:1 con producto, cada producto tiene un registro de inventario)
-- ---------------------------------------------------------------------
CREATE TABLE inventario (
    id_inventario      INT AUTO_INCREMENT,
    id_producto        INT NOT NULL UNIQUE,
    precio             DECIMAL(10,2) NOT NULL,
    existencia_actual  INT NOT NULL DEFAULT 0,
    existencia_minima  INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_inventario),
    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    UNIQUE KEY uq_inventario_producto (id_producto)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: cliente
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT,
    nombre     VARCHAR(150) NOT NULL,
    nit        VARCHAR(20)  NOT NULL,
    correo     VARCHAR(150),
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uq_cliente_nit (nit)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: factura
-- ---------------------------------------------------------------------
CREATE TABLE factura (
    id_factura INT AUTO_INCREMENT,
    fecha      DATE NOT NULL,
    id_cliente INT NOT NULL,
    PRIMARY KEY (id_factura),
    CONSTRAINT fk_factura_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: det_fac (detalle de factura)
-- Llave primaria compuesta: id_factura + id_producto
-- ---------------------------------------------------------------------
CREATE TABLE det_fac (
    id_factura  INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad    INT NOT NULL,
    PRIMARY KEY (id_factura, id_producto),
    CONSTRAINT fk_detfac_factura
        FOREIGN KEY (id_factura) REFERENCES factura (id_factura)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_detfac_producto
        FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;