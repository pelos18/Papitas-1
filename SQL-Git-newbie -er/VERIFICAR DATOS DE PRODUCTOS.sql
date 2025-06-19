-- =====================================================
-- VERIFICAR DATOS DE PRODUCTOS
-- =====================================================

PROMPT '🔍 === VERIFICANDO DATOS DE PRODUCTOS ==='
PROMPT ''

-- Ver estructura de la tabla
PROMPT '📋 COLUMNAS RELACIONADAS CON INVENTARIO:'
SELECT 
    column_name as "COLUMNA",
    data_type as "TIPO",
    nullable as "NULO"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' 
AND column_name IN ('STOCK_ACTUAL', 'COSTO_TOTAL', 'VALOR_INVENTARIO')
ORDER BY column_id;

-- Ver datos de productos
PROMPT ''
PROMPT '📊 PRODUCTOS CON SUS VALORES:'
SELECT 
    id_producto,
    nombre,
    stock_actual,
    costo_total,
    valor_inventario,
    CASE 
        WHEN valor_inventario IS NULL THEN '❌ NULL'
        WHEN valor_inventario = 0 THEN '⚠️ CERO'
        WHEN valor_inventario = (stock_actual * costo_total) THEN '✅ CORRECTO'
        ELSE '❓ REVISAR'
    END as estado
FROM PRODUCTOS 
WHERE ROWNUM <= 10
ORDER BY id_producto;

-- Estadísticas generales
PROMPT ''
PROMPT '📈 ESTADÍSTICAS:'
SELECT 
    COUNT(*) as "TOTAL_PRODUCTOS",
    COUNT(CASE WHEN valor_inventario > 0 THEN 1 END) as "CON_VALOR",
    COUNT(CASE WHEN valor_inventario = 0 OR valor_inventario IS NULL THEN 1 END) as "SIN_VALOR",
    TO_CHAR(SUM(NVL(valor_inventario, 0)), '999,999,999.99') as "VALOR_TOTAL"
FROM PRODUCTOS;
