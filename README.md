# DB Coursework · Scripts y evidencias de Base de Datos

Scripts de base de datos y evidencias de los parciales de la coursework de
Base de Datos (Universidad Mariano Gálvez, VMG).

Este repositorio es **independiente** del repositorio
[`db1_torneo`](https://github.com/jhosef-re/db1_torneo) (proyecto final del
Campeonato de Fútbol). Ahí vive la versión final y normalizada del schema
(`campeonato_futbol`, 9 tablas); aquí quedan los scripts de los parciales
anteriores y las evidencias graficas.

---

## Contenido

### `sql/01_lab_ventas_mysql.sql`

Script completo de la base `lab_ventas_mysql` (MySQL 8.x). Incluye:

- 4 tablas: `cliente`, `producto`, `venta`, `detalle_venta`
- 3 triggers: `trg_detalle_venta_bi`, `trg_detalle_venta_ad`, `trg_detalle_venta_bu`
- 1 procedimiento almacenado: `sp_registrar_venta`
- Vistas y pruebas opcionales

> **ADVERTENCIA:** el script ejecuta `DROP DATABASE IF EXISTS lab_ventas_mysql`
> y lo vuelve a crear. Ejecutar solo sobre una instancia de desarrollo.

### `sql/02_inventory_jh.sql`

Script de creacion de la base `inventory_jh` (MySQL). Convencion de nombres
`snake_case`. Tablas: `producto`, y las relacionadas.

### `sql/04_inventory_jh_poblado.sql`

Script de **poblado** de `inventory_jh`: inserta los datos de prueba en las
tablas creadas por `02_inventory_jh.sql`.

Ejecutar en este orden:

```bash
mysql -u root -p < sql/02_inventory_jh.sql
mysql -u root -p < sql/04_inventory_jh_poblado.sql
```

### `sql/03_dump_liga_universitaria_valle.sql`

Dump de MySQL 8.4.10 de la base `liga_universitaria_valle`. Contiene el
**schema de una version anterior** del proyecto del campeonato (4 tablas:
`equipo`, `jornada`, `partido`, `resultado`) **con los datos reales cargados**
(nombres de equipos, calendario de jornadas, resultados).

Se conserva porque:

- Es la version previa al schema final `campeonato_futbol` (9 tablas) del repo
  `db1_torneo`, y aporta los datos que el repo final no incluye.
- Sirve como evidencia del parcial 2.
- El diagrama ER en `docs/` corresponde a este schema.

> Este dump fue generado con `mysqldump` y usa backticks + el modo
> `SET NAMES utf8mb4`. Para restaurarlo:
> ```bash
> mysql -u root -p < sql/03_dump_liga_universitaria_valle.sql
> ```

### `docs/er_liga_universitaria_valle.png`

Diagrama entidad-relacion del schema `liga_universitaria_valle`
(1322 x 1370 px). Evidencia visual del parcial 2.

---

## Nota sobre duplicados

`sql/03_dump_liga_universitaria_valle.sql` estaba duplicado en el disco como
`9390-24-4816.sql` y `MySQLLocal-2026_09_27_09_38_39-dump.sql` (identicos
byte a byte). Se conserva una sola copia, renombrada con un nombre descriptivo
y con indice numerico para mantener el orden de lectura.

---

## Requisitos

- MySQL 8.0.16 o superior (para que se apliquen las restricciones `CHECK`).
- Charset `utf8mb4` en todas las bases.
