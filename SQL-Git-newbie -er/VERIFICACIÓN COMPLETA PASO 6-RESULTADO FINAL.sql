-- =====================================================
-- VERIFICACIÓN COMPLETA PASO 6: RESULTADO FINAL
-- =====================================================

PROMPT ''
PROMPT '🔍 === PASO 6: RESULTADO FINAL DE VERIFICACIÓN ==='
PROMPT ''

-- 1. RESUMEN EJECUTIVO
PROMPT '📊 1. RESUMEN EJECUTIVO DEL SISTEMA:'

WITH verificacion AS (
    SELECT 
        COUNT(*) as total_tablas
    FROM user_tables 
    WHERE table_name IN (
        'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
        'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
        'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
        'OFERTAS_ESPECIALES', 'CAJA', 'CORTES_CAJA', 'REPORTES_GENERADOS',
        'AUDITORIA', 'DEVOLUCIONES'
    )
),
triggers_ok AS (
    SELECT COUNT(*) as triggers_funcionando
    FROM user_triggers 
    WHERE trigger_name LIKE 'TRG_%' AND status = 'ENABLED'
),
productos_ok AS (
    SELECT 
        COUNT(*) as total_productos,
        COUNT(CASE WHEN valor_inventario IS NOT NULL THEN 1 END) as con_valor
    FROM PRODUCTOS
),
columna_ok AS (
    SELECT COUNT(*) as columna_existe
    FROM user_tab_columns 
    WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO'
)
SELECT 
    v.total_tablas as "TABLAS_PRINCIPALES",
    t.triggers_funcionando as "TRIGGERS_ACTIVOS", 
    p.total_productos as "PRODUCTOS_TOTAL",
    p.con_valor as "PRODUCTOS_CON_VALOR",
    c.columna_existe as "COLUMNA_VALOR_INV_EXISTE",
    CASE 
        WHEN v.total_tablas >= 15 
         AND t.triggers_funcionando >= 10 
         AND c.columna_existe = 1 
         AND p.con_valor > 0
        THEN '✅ SISTEMA COMPLETAMENTE FUNCIONAL'
        ELSE '⚠️ REVISAR PROBLEMAS'
    END as "ESTADO_GENERAL"
FROM verificacion v, triggers_ok t, productos_ok p, columna_ok c;

PROMPT ''
PROMPT '🎯 2. VERIFICACIÓN DE VALOR_INVENTARIO:'
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ COLUMNA EXISTE'
        ELSE '❌ COLUMNA NO EXISTE'
    END as "COLUMNA_VALOR_INVENTARIO",
    CASE 
        WHEN (SELECT COUNT(*) FROM PRODUCTOS WHERE valor_inventario IS NOT NULL) > 0 
        THEN '✅ TIENE DATOS'
        ELSE '❌ SIN DATOS'
    END as "DATOS_EN_COLUMNA",
    CASE 
        WHEN (SELECT COUNT(*) FROM user_triggers WHERE trigger_name LIKE '%VALOR%' AND status = 'ENABLED') > 0
        THEN '✅ TRIGGERS ACTIVOS'
        ELSE '❌ TRIGGERS INACTIVOS'
    END as "TRIGGERS_VALOR_INV"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO';

PROMPT ''
PROMPT '🏆 3. RESULTADO FINAL:'

-- Limpiar producto de prueba
DELETE FROM MOVIMIENTOS_INVENTARIO 
WHERE observaciones = 'Prueba de verificación completa';

DELETE FROM PRODUCTOS 
WHERE nombre = 'PRODUCTO PRUEBA VERIFICACIÓN';

COMMIT;

SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM user_tab_columns WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO') = 1
         AND (SELECT COUNT(*) FROM user_triggers WHERE trigger_name LIKE 'TRG_%' AND status = 'ENABLED') >= 10
         AND (SELECT COUNT(*) FROM PRODUCTOS WHERE valor_inventario IS NOT NULL) > 0
        THEN '🎉 ¡SISTEMA 100% FUNCIONAL!'
        ELSE '⚠️ HAY PROBLEMAS QUE RESOLVER'
    END as "VEREDICTO_FINAL"
FROM dual;

PROMPT ''
PROMPT '🎯 === VERIFICACIÓN COMPLETA TERMINADA ==='
PROMPT 'Ejecuta todos estos scripts en orden para ver el estado completo'
PROMPT ''
