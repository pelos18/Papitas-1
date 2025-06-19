-- =====================================================
-- PROBAR QUE LOS TRIGGERS FUNCIONAN CORRECTAMENTE
-- =====================================================

PROMPT '🧪 === PROBANDO TRIGGERS DE VALOR_INVENTARIO ==='
PROMPT ''

-- Mostrar valores antes de la prueba
PROMPT '📊 ANTES DE LA PRUEBA:'
SELECT 
    nombre,
    stock_actual,
    costo_total,
    valor_inventario
FROM PRODUCTOS 
WHERE id_producto = 1;

-- Actualizar stock de un producto para probar el trigger
UPDATE PRODUCTOS 
SET stock_actual = stock_actual + 10
WHERE id_producto = 1;

-- Mostrar valores después de la actualización
PROMPT ''
PROMPT '📊 DESPUÉS DE ACTUALIZAR STOCK (+10 unidades):'
SELECT 
    nombre,
    stock_actual,
    costo_total,
    valor_inventario,
    CASE 
        WHEN valor_inventario = (stock_actual * costo_total) THEN '✅ TRIGGER FUNCIONÓ'
        ELSE '❌ TRIGGER NO FUNCIONÓ'
    END as resultado_prueba
FROM PRODUCTOS 
WHERE id_producto = 1;

-- Probar inserción de movimiento de inventario
INSERT INTO MOVIMIENTOS_INVENTARIO (
    id_producto, tipo_movimiento, cantidad, costo_unitario,
    motivo, id_usuario, observaciones
) VALUES (
    1, 'ENTRADA', 5, 12.50, 'COMPRA', 1, 'Prueba de trigger valor_inventario'
);

COMMIT;

PROMPT ''
PROMPT '📦 DESPUÉS DE MOVIMIENTO DE INVENTARIO (+5 unidades):'
SELECT 
    nombre,
    stock_actual,
    costo_total,
    valor_inventario
FROM PRODUCTOS 
WHERE id_producto = 1;

PROMPT ''
PROMPT '✅ PRUEBAS COMPLETADAS - Verificar que valor_inventario se actualiza automáticamente'
