-- =====================================================
-- VERIFICACIÓN COMPLETA PASO 3: DATOS EN PRODUCTOS
-- =====================================================

PROMPT ''
PROMPT '🔍 === PASO 3: VERIFICACIÓN DE DATOS EN PRODUCTOS ==='
PROMPT ''

-- 1. CONTAR REGISTROS EN PRODUCTOS
PROMPT '📊 1. ESTADÍSTICAS BÁSICAS DE PRODUCTOS:'
SELECT 
    COUNT(*) as "TOTAL_PRODUCTOS",
    COUNT(CASE WHEN activo = 1 THEN 1 END) as "PRODUCTOS_ACTIVOS",
    COUNT(CASE WHEN activo = 0 THEN 1 END) as "PRODUCTOS_INACTIVOS",
    COUNT(CASE WHEN valor_inventario IS NOT NULL THEN 1 END) as "CON_VALOR_INVENTARIO",
    COUNT(CASE WHEN valor_inventario IS NULL THEN 1 END) as "SIN_VALOR_INVENTARIO",
    COUNT(CASE WHEN valor_inventario > 0 THEN 1 END) as "CON_VALOR_POSITIVO"
FROM PRODUCTOS;

PROMPT ''
PROMPT '💰 2. ANÁLISIS DE VALOR_INVENTARIO:'
SELECT 
    MIN(valor_inventario) as "VALOR_MÍNIMO",
    MAX(valor_inventario) as "VALOR_MÁXIMO",
    AVG(valor_inventario) as "VALOR_PROMEDIO",
    SUM(valor_inventario) as "VALOR_TOTAL",
    COUNT(CASE WHEN valor_inventario = 0 THEN 1 END) as "PRODUCTOS_EN_CERO",
    COUNT(CASE WHEN valor_inventario IS NULL THEN 1 END) as "PRODUCTOS_NULL"
FROM PRODUCTOS;

PROMPT ''
PROMPT '📋 3. PRIMEROS 10 PRODUCTOS CON TODOS SUS DATOS:'
SELECT 
    id_producto as "ID",
    nombre as "NOMBRE",
    stock_actual as "STOCK",
    costo_base as "COSTO_BASE",
    costo_total as "COSTO_TOTAL",
    precio_venta as "PRECIO_VENTA",
    valor_inventario as "VALOR_INV",
    CASE 
        WHEN valor_inventario IS NULL THEN '❌ NULL'
        WHEN valor_inventario = 0 THEN '⚠️ CERO'
        WHEN valor_inventario = (stock_actual * costo_total) THEN '✅ CORRECTO'
        ELSE '❓ REVISAR'
    END as "VALIDACIÓN"
FROM PRODUCTOS 
WHERE ROWNUM <= 10
ORDER BY id_producto;

PROMPT ''
PROMPT '🔍 4. PRODUCTOS CON PROBLEMAS (SI LOS HAY):'
SELECT 
    id_producto,
    nombre,
    stock_actual,
    costo_total,
    valor_inventario,
    'VALOR_INVENTARIO ES NULL' as "PROBLEMA"
FROM PRODUCTOS 
WHERE valor_inventario IS NULL AND ROWNUM <= 5
UNION ALL
SELECT 
    id_producto,
    nombre,
    stock_actual,
    costo_total,
    valor_inventario,
    'CÁLCULO INCORRECTO' as "PROBLEMA"
FROM PRODUCTOS 
WHERE valor_inventario != (stock_actual * costo_total) 
AND valor_inventario IS NOT NULL 
AND stock_actual IS NOT NULL 
AND costo_total IS NOT NULL
AND ROWNUM <= 5;
