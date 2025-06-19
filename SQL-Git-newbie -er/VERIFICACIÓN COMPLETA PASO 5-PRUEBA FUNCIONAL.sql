-- =====================================================
-- VERIFICACIÓN COMPLETA PASO 5: PRUEBA FUNCIONAL
-- =====================================================

PROMPT ''
PROMPT '🔍 === PASO 5: PRUEBA FUNCIONAL COMPLETA ==='
PROMPT ''

-- 1. PROBAR INSERCIÓN DE PRODUCTO
PROMPT '🧪 1. PROBANDO INSERCIÓN DE PRODUCTO NUEVO:'

-- Insertar producto de prueba
INSERT INTO PRODUCTOS (
    nombre, descripcion, marca, costo_base, precio_venta, 
    stock_actual, stock_minimo, id_categoria, id_proveedor, activo
) VALUES (
    'PRODUCTO PRUEBA VERIFICACIÓN', 
    'Producto para verificar que todo funciona', 
    'MARCA PRUEBA',
    25.00, 
    35.00, 
    50, 
    10, 
    1, 
    1, 
    1
);

-- Verificar que se insertó correctamente
SELECT 
    id_producto,
    nombre,
    costo_base,
    gastos_adicionales,
    costo_total,
    stock_actual,
    valor_inventario,
    CASE 
        WHEN valor_inventario = (stock_actual * costo_total) THEN '✅ CÁLCULO CORRECTO'
        ELSE '❌ CÁLCULO INCORRECTO'
    END as "RESULTADO_PRUEBA"
FROM PRODUCTOS 
WHERE nombre = 'PRODUCTO PRUEBA VERIFICACIÓN';

COMMIT;

PROMPT ''
PROMPT '🧪 2. PROBANDO ACTUALIZACIÓN DE STOCK:'

-- Actualizar stock del producto de prueba
UPDATE PRODUCTOS 
SET stock_actual = stock_actual + 25
WHERE nombre = 'PRODUCTO PRUEBA VERIFICACIÓN';

-- Verificar que valor_inventario se actualizó
SELECT 
    nombre,
    stock_actual,
    costo_total,
    valor_inventario,
    CASE 
        WHEN valor_inventario = (stock_actual * costo_total) THEN '✅ TRIGGER FUNCIONÓ'
        ELSE '❌ TRIGGER NO FUNCIONÓ'
    END as "RESULTADO_TRIGGER"
FROM PRODUCTOS 
WHERE nombre = 'PRODUCTO PRUEBA VERIFICACIÓN';

COMMIT;

PROMPT ''
PROMPT '🧪 3. PROBANDO INSERCIÓN DE MOVIMIENTO:'

-- Insertar movimiento de inventario
INSERT INTO MOVIMIENTOS_INVENTARIO (
    id_producto, tipo_movimiento, cantidad, costo_unitario,
    motivo, id_usuario, observaciones
) VALUES (
    (SELECT id_producto FROM PRODUCTOS WHERE nombre = 'PRODUCTO PRUEBA VERIFICACIÓN'),
    'ENTRADA', 
    10, 
    25.00, 
    'COMPRA', 
    1, 
    'Prueba de verificación completa'
);

COMMIT;

-- Verificar que el stock se actualizó
SELECT 
    p.nombre,
    p.stock_actual,
    p.valor_inventario,
    m.cantidad as "CANTIDAD_MOVIMIENTO",
    m.fecha_movimiento
FROM PRODUCTOS p
JOIN MOVIMIENTOS_INVENTARIO m ON p.id_producto = m.id_producto
WHERE p.nombre = 'PRODUCTO PRUEBA VERIFICACIÓN'
AND m.observaciones = 'Prueba de verificación completa';
