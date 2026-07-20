-- ══════════════════════════════════════════
-- BodegaTech — Script de Inventario
-- Autora: Gilda Frías
-- Fecha: 14 de julio de 2026
-- Motor objetivo: PostgreSQL (sintaxis validada también contra SQL Server;
-- se aclara en comentarios el único tipo de dato que se adaptó)
-- ══════════════════════════════════════════

-- ── SECCIÓN DDL ──────────────────────────

-- DROP TABLE: permite volver a ejecutar el script sin error de
-- "la tabla ya existe" cada vez que se corre de nuevo.
DROP TABLE IF EXISTS inventario;

-- CREATE TABLE
CREATE TABLE inventario (
    id_producto       INT PRIMARY KEY,
    -- Número entero simple, identificador único de cada producto.
    -- PRIMARY KEY impide filas duplicadas o sin id.

    nombre_producto   VARCHAR(100) NOT NULL,
    categoria         VARCHAR(50) NOT NULL,

    precio_unitario   DECIMAL(10,2) NOT NULL,
    -- DECIMAL(10,2) y no FLOAT: el precio de venta necesita precisión
    -- exacta de 2 decimales; FLOAT puede introducir errores de
    -- redondeo binario inaceptables al trabajar con dinero.

    stock_actual      INT NOT NULL,
    stock_minimo      INT NOT NULL,
    -- Ambos son cantidades de unidades, siempre números enteros:
    -- no tiene sentido un stock de "3.5 unidades", así que no se
    -- usa DECIMAL ni FLOAT para estas dos columnas.

    fecha_ingreso     DATE NOT NULL,
    -- Solo fecha, sin hora: alcanza con saber el día en que el
    -- producto ingresó al inventario.

    activo            SMALLINT NOT NULL DEFAULT 1
    -- 1 = disponible, 0 = descontinuado. La consigna sugiere
    -- TINYINT(1), pero ese tipo con parámetro es específico de
    -- MySQL y no existe así ni en PostgreSQL ni en SQL Server; se
    -- usa SMALLINT en su lugar porque es un número pequeño válido
    -- en ambos motores y respeta la misma lógica de 0 y 1.
);

-- ── SECCIÓN DML ──────────────────────────

-- INSERT INTO: carga de los 10 productos actuales del inventario.
INSERT INTO inventario
    (id_producto, nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES
    (1,  'Laptop Pro 15',        'Computación',     1200.00, 15, 3,  '2024-01-10', 1),
    (2,  'Mouse Inalámbrico',    'Accesorios',        28.00, 80, 10, '2024-01-10', 1),
    (3,  'Monitor 4K 27"',       'Computación',      450.00, 12, 2,  '2024-01-15', 1),
    (4,  'Teclado Mecánico',     'Accesorios',        95.00, 40, 5,  '2024-01-15', 1),
    (5,  'Laptop Basic 14',      'Computación',      650.00, 20, 3,  '2024-02-01', 1),
    (6,  'Auriculares BT Pro',   'Audio',            120.00, 35, 5,  '2024-02-01', 1),
    (7,  'Hub USB-C 7 puertos',  'Accesorios',        45.00, 60, 10, '2024-02-10', 1),
    (8,  'Webcam HD 1080p',      'Accesorios',        85.00, 25, 5,  '2024-02-10', 1),
    (9,  'SSD Externo 1TB',      'Almacenamiento',   130.00, 18, 3,  '2024-03-01', 1),
    (10, 'Parlante Bluetooth',   'Audio',             60.00, 45, 8,  '2024-03-01', 1);

-- UPDATE ventas del día: se descuenta del stock_actual lo vendido hoy.
-- Cada UPDATE lleva su propio WHERE id_producto = X para no tocar el
-- resto de las filas.
UPDATE inventario SET stock_actual = stock_actual - 3  WHERE id_producto = 1;  -- Laptop Pro 15: 15 - 3  = 12
UPDATE inventario SET stock_actual = stock_actual - 12 WHERE id_producto = 2;  -- Mouse Inalámbrico: 80 - 12 = 68
UPDATE inventario SET stock_actual = stock_actual - 5  WHERE id_producto = 6;  -- Auriculares BT Pro: 35 - 5  = 30

-- UPDATE producto descontinuado: la Webcam HD 1080p (id 8) deja de
-- estar disponible porque el proveedor la discontinuó.
UPDATE inventario SET activo = 0 WHERE id_producto = 8;

-- SELECT de validación
-- Ver la tabla completa para confirmar que los datos se cargaron
-- correctamente (10 productos, stocks actualizados, Webcam inactiva).
SELECT * FROM inventario;
