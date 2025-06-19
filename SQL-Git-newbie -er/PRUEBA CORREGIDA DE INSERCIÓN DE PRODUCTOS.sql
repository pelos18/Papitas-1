-- =====================================================
-- PRUEBA CORREGIDA DE INSERCIÓN DE PRODUCTOS
-- =====================================================

PROMPT '🧪 === PRUEBA CORREGIDA DE PRODUCTOS ==='
PROMPT ''

-- Limpiar cualquier producto de prueba anterior
DELETE FROM PRODUCTOS WHERE nombre LIKE '%PRUEBA%';
COMMIT;

-- PASO 1: Verificar datos necesarios
PROMPT '🔍 PASO 1: Verificando datos necesarios...'
SELECT 'USUARIOS' as tabla, COUNT(*) as registros FROM USUARIOS
UNION ALL
SELECT 'CATEGORIAS', COUNT(*) FROM CATEGORIAS  
UNION ALL
SELECT 'PROVEEDORES', COUNT(*) FROM PROVEEDORES;

-- PASO 2: Insertar producto de prueba
PROMPT ''
PROMPT '🧪 PASO 2: Insertando producto de prueba...'

INSERT INTO PRODUCTOS (
    nombre, descripcion, marca, costo_base, precio_venta, 
    stock_actual, stock_minimo, id_categoria, id_proveedor, activo
) VALUES (
    'PRODUCTO PRUEBA CORREGIDA', 
    'Producto para verificar que todo funciona correctamente', 
    'MARCA PRUEBA',
    25.00, 
    35.00, 
    50, 
    10, 
    1, 
    1, 
    1
);

COMMIT;

-- Verificar que se insertó correctamente
PROMPT ''
PROMPT '📊 RESULTADO DE LA INSERCIÓN:'
SELECT 
    id_producto,
    nombre,
    costo_base,
    gastos_adicionales,
    costo_total,
    stock_actual,
    valor_inventario,
    CASE 
        WHEN valor_inventario IS NOT NULL AND costo_total IS NOT NULL 
             AND valor_inventario = (stock_actual * costo_total) 
        THEN '✅ CÁLCULO CORRECTO'
        WHEN valor_inventario IS NULL 
        THEN '⚠️ VALOR_INVENTARIO ES NULL'
        WHEN costo_total IS NULL 
        THEN '⚠️ COSTO_TOTAL ES NULL'
        ELSE '❌ CÁLCULO INCORRECTO'
    END as "RESULTADO_PRUEBA"
FROM PRODUCTOS 
WHERE nombre = 'PRODUCTO PRUEBA CORREGIDA';

-- PASO 3: Probar actualización
PROMPT ''
PROMPT '🧪 PASO 3: Probando actualización de stock...'

UPDATE PRODUCTOS 
SET stock_actual = stock_actual + 25
WHERE nombre = 'PRODUCTO PRUEBA CORREGIDA';

COMMIT;

-- Verificar actualización
SELECT 
    nombre,
    stock_actual,
    costo_total,
    valor_inventario,
    CASE 
        WHEN valor_inventario = (stock_actual * costo_total) 
        THEN '✅ TRIGGER FUNCIONÓ'
        ELSE '❌ TRIGGER NO FUNCIONÓ'
    END as "RESULTADO_TRIGGER"
FROM PRODUCTOS 
WHERE nombre = 'PRODUCTO PRUEBA CORREGIDA';

-- PASO 4: Probar movimiento de inventario
PROMPT ''
PROMPT '🧪 PASO 4: Probando movimiento de inventario...'

DECLARE
    v_id_producto NUMBER;
BEGIN
    -- Obtener ID del producto
    SELECT id_producto INTO v_id_producto 
    FROM PRODUCTOS 
    WHERE nombre = 'PRODUCTO PRUEBA CORREGIDA';
    
    -- Insertar movimiento
    INSERT INTO MOVIMIENTOS_INVENTARIO (
        id_producto, tipo_movimiento, cantidad, costo_unitario,
        motivo, id_usuario, observaciones
    ) VALUES (
        v_id_producto,
        'ENTRADA', 
        10, 
        25.00, 
        'COMPRA', 
        1, 
        'Prueba corregida de verificación'
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('✅ Movimiento insertado correctamente');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error en movimiento: ' || SQLERRM);
END;
/

-- Verificar resultado final
PROMPT ''
PROMPT '📊 RESULTADO FINAL:'
SELECT 
    p.nombre,
    p.stock_actual,
    p.valor_inventario,
    COUNT(m.id_movimiento) as "MOVIMIENTOS_REGISTRADOS"
FROM PRODUCTOS p
LEFT JOIN MOVIMIENTOS_INVENTARIO m ON p.id_producto = m.id_producto
WHERE p.nombre = 'PRODUCTO PRUEBA CORREGIDA'
GROUP BY p.nombre, p.stock_actual, p.valor_inventario;
