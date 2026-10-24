-- MySQL dump 10.13  Distrib 8.4.10, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: liga_universitaria_valle
-- ------------------------------------------------------
-- Server version	8.4.10
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;

/*!50503 SET NAMES utf8mb4 */;

/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;

/*!40103 SET TIME_ZONE='+00:00' */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `equipo`
--
DROP TABLE IF EXISTS `equipo`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `equipo` (
  `equipo_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  PRIMARY KEY (`equipo_id`),
  UNIQUE KEY `uq_equipo_nombre` (`nombre`)
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipo`
--
LOCK TABLES `equipo` WRITE;

/*!40000 ALTER TABLE `equipo` DISABLE KEYS */;

INSERT INTO
  `equipo` (`equipo_id`, `nombre`)
VALUES
  (12, 'Academia del Este'),
  (3, 'Atlético Norte'),
  (1, 'Aurora FC'),
  (2, 'Deportivo Ceiba'),
  (6, 'Deportivo Lago'),
  (7, 'Estrella del Sur'),
  (8, 'Juventud Central'),
  (10, 'Municipal Bosque'),
  (9, 'Racing del Puerto'),
  (5, 'Real Montaña'),
  (11, 'Sporting del Sol'),
  (4, 'Unión del Valle');

/*!40000 ALTER TABLE `equipo` ENABLE KEYS */;

UNLOCK TABLES;

--
-- Table structure for table `jornada`
--
DROP TABLE IF EXISTS `jornada`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `jornada` (
  `numero` TINYINT UNSIGNED NOT NULL,
  `dia` date NOT NULL,
  PRIMARY KEY (`numero`),
  UNIQUE KEY `uq_jornada_dia` (`dia`),
  CONSTRAINT `ck_jornada_numero` CHECK ((`numero` BETWEEN 1 AND 22))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jornada`
--
LOCK TABLES `jornada` WRITE;

/*!40000 ALTER TABLE `jornada` DISABLE KEYS */;

INSERT INTO
  `jornada` (`numero`, `dia`)
VALUES
  (1, '2026-08-01'),
  (2, '2026-08-08'),
  (3, '2026-08-15'),
  (4, '2026-08-22'),
  (5, '2026-08-29'),
  (6, '2026-09-05'),
  (7, '2026-09-12'),
  (8, '2026-09-19'),
  (9, '2026-09-26'),
  (10, '2026-10-03'),
  (11, '2026-10-10'),
  (12, '2026-10-17'),
  (13, '2026-10-24'),
  (14, '2026-10-31'),
  (15, '2026-11-07'),
  (16, '2026-11-14'),
  (17, '2026-11-21'),
  (18, '2026-11-28'),
  (19, '2026-12-05'),
  (20, '2026-12-12'),
  (21, '2026-12-19'),
  (22, '2026-12-26');

/*!40000 ALTER TABLE `jornada` ENABLE KEYS */;

UNLOCK TABLES;

--
-- Table structure for table `partido`
--
DROP TABLE IF EXISTS `partido`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `partido` (
  `partido_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jornada_numero` TINYINT UNSIGNED NOT NULL,
  `local_id` INT UNSIGNED NOT NULL,
  `visitante_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`partido_id`),
  UNIQUE KEY `uq_partido_jornada_local` (`jornada_numero`, `local_id`),
  UNIQUE KEY `uq_partido_jornada_visitante` (`jornada_numero`, `visitante_id`),
  UNIQUE KEY `uq_partido_cruce` (`local_id`, `visitante_id`),
  KEY `fk_partido_visitante` (`visitante_id`),
  CONSTRAINT `fk_partido_jornada` FOREIGN KEY (`jornada_numero`) REFERENCES `jornada` (`numero`),
  CONSTRAINT `fk_partido_local` FOREIGN KEY (`local_id`) REFERENCES `equipo` (`equipo_id`),
  CONSTRAINT `fk_partido_visitante` FOREIGN KEY (`visitante_id`) REFERENCES `equipo` (`equipo_id`),
  CONSTRAINT `ck_partido_equipos_distintos` CHECK ((`local_id` <> `visitante_id`))
) ENGINE = InnoDB AUTO_INCREMENT = 133 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partido`
--
LOCK TABLES `partido` WRITE;

/*!40000 ALTER TABLE `partido` DISABLE KEYS */;

INSERT INTO
  `partido` (
    `partido_id`,
    `jornada_numero`,
    `local_id`,
    `visitante_id`
  )
VALUES
  (1, 1, 1, 12),
  (2, 1, 11, 2),
  (3, 1, 3, 10),
  (4, 1, 9, 4),
  (5, 1, 5, 8),
  (6, 1, 7, 6),
  (7, 2, 11, 1),
  (8, 2, 12, 10),
  (9, 2, 9, 2),
  (10, 2, 3, 8),
  (11, 2, 7, 4),
  (12, 2, 5, 6),
  (13, 3, 1, 10),
  (14, 3, 9, 11),
  (15, 3, 12, 8),
  (16, 3, 7, 2),
  (17, 3, 3, 6),
  (18, 3, 5, 4),
  (19, 4, 9, 1),
  (20, 4, 10, 8),
  (21, 4, 7, 11),
  (22, 4, 12, 6),
  (23, 4, 5, 2),
  (24, 4, 3, 4),
  (25, 5, 1, 8),
  (26, 5, 7, 9),
  (27, 5, 10, 6),
  (28, 5, 5, 11),
  (29, 5, 12, 4),
  (30, 5, 3, 2),
  (31, 6, 7, 1),
  (32, 6, 8, 6),
  (33, 6, 5, 9),
  (34, 6, 10, 4),
  (35, 6, 3, 11),
  (36, 6, 12, 2),
  (37, 7, 1, 6),
  (38, 7, 5, 7),
  (39, 7, 8, 4),
  (40, 7, 3, 9),
  (41, 7, 10, 2),
  (42, 7, 12, 11),
  (43, 8, 5, 1),
  (44, 8, 6, 4),
  (45, 8, 3, 7),
  (46, 8, 8, 2),
  (47, 8, 12, 9),
  (48, 8, 10, 11),
  (49, 9, 1, 4),
  (50, 9, 3, 5),
  (51, 9, 6, 2),
  (52, 9, 12, 7),
  (53, 9, 8, 11),
  (54, 9, 10, 9),
  (55, 10, 3, 1),
  (56, 10, 4, 2),
  (57, 10, 12, 5),
  (58, 10, 6, 11),
  (59, 10, 10, 7),
  (60, 10, 8, 9),
  (61, 11, 1, 2),
  (62, 11, 12, 3),
  (63, 11, 4, 11),
  (64, 11, 10, 5),
  (65, 11, 6, 9),
  (66, 11, 8, 7),
  (67, 12, 12, 1),
  (68, 12, 2, 11),
  (69, 12, 10, 3),
  (70, 12, 4, 9),
  (71, 12, 8, 5),
  (72, 12, 6, 7),
  (73, 13, 1, 11),
  (74, 13, 10, 12),
  (75, 13, 2, 9),
  (76, 13, 8, 3),
  (77, 13, 4, 7),
  (78, 13, 6, 5),
  (79, 14, 10, 1),
  (80, 14, 11, 9),
  (81, 14, 8, 12),
  (82, 14, 2, 7),
  (83, 14, 6, 3),
  (84, 14, 4, 5),
  (85, 15, 1, 9),
  (86, 15, 8, 10),
  (87, 15, 11, 7),
  (88, 15, 6, 12),
  (89, 15, 2, 5),
  (90, 15, 4, 3),
  (91, 16, 8, 1),
  (92, 16, 9, 7),
  (93, 16, 6, 10),
  (94, 16, 11, 5),
  (95, 16, 4, 12),
  (96, 16, 2, 3),
  (97, 17, 1, 7),
  (98, 17, 6, 8),
  (99, 17, 9, 5),
  (100, 17, 4, 10),
  (101, 17, 11, 3),
  (102, 17, 2, 12),
  (103, 18, 6, 1),
  (104, 18, 7, 5),
  (105, 18, 4, 8),
  (106, 18, 9, 3),
  (107, 18, 2, 10),
  (108, 18, 11, 12),
  (109, 19, 1, 5),
  (110, 19, 4, 6),
  (111, 19, 7, 3),
  (112, 19, 2, 8),
  (113, 19, 9, 12),
  (114, 19, 11, 10),
  (115, 20, 4, 1),
  (116, 20, 5, 3),
  (117, 20, 2, 6),
  (118, 20, 7, 12),
  (119, 20, 11, 8),
  (120, 20, 9, 10),
  (121, 21, 1, 3),
  (122, 21, 2, 4),
  (123, 21, 5, 12),
  (124, 21, 11, 6),
  (125, 21, 7, 10),
  (126, 21, 9, 8),
  (127, 22, 2, 1),
  (128, 22, 3, 12),
  (129, 22, 11, 4),
  (130, 22, 5, 10),
  (131, 22, 9, 6),
  (132, 22, 7, 8);

/*!40000 ALTER TABLE `partido` ENABLE KEYS */;

UNLOCK TABLES;

--
-- Table structure for table `resultado`
--
DROP TABLE IF EXISTS `resultado`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `resultado` (
  `partido_id` INT UNSIGNED NOT NULL,
  `goles_local` SMALLINT UNSIGNED NOT NULL,
  `goles_visitante` SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (`partido_id`),
  CONSTRAINT `fk_resultado_partido` FOREIGN KEY (`partido_id`) REFERENCES `partido` (`partido_id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resultado`
--
LOCK TABLES `resultado` WRITE;

/*!40000 ALTER TABLE `resultado` DISABLE KEYS */;

INSERT INTO
  `resultado` (`partido_id`, `goles_local`, `goles_visitante`)
VALUES
  (1, 0, 0),
  (2, 2, 1),
  (3, 0, 2),
  (4, 1, 2),
  (5, 3, 0),
  (6, 2, 2),
  (7, 2, 2),
  (8, 2, 0),
  (9, 2, 1),
  (10, 0, 2),
  (11, 0, 1),
  (12, 1, 1),
  (13, 1, 3),
  (14, 3, 3),
  (15, 1, 2),
  (16, 2, 0),
  (17, 1, 1),
  (18, 2, 0),
  (19, 2, 1),
  (20, 1, 0),
  (21, 2, 2),
  (22, 0, 1),
  (23, 0, 2),
  (24, 4, 1),
  (25, 3, 0),
  (26, 3, 1),
  (27, 3, 0),
  (28, 0, 3),
  (29, 2, 0),
  (30, 2, 1),
  (31, 0, 4),
  (32, 2, 1),
  (33, 1, 2),
  (34, 0, 0),
  (35, 0, 1),
  (36, 1, 4),
  (37, 2, 1),
  (38, 4, 1),
  (39, 3, 3),
  (40, 1, 1),
  (41, 3, 0),
  (42, 1, 1),
  (43, 2, 4),
  (44, 1, 1),
  (45, 0, 1),
  (46, 2, 0),
  (47, 1, 0),
  (48, 1, 1);

/*!40000 ALTER TABLE `resultado` ENABLE KEYS */;

UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-27  9:38:39