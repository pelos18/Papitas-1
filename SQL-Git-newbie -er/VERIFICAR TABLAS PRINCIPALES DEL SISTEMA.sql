-- ========================================
-- VERIFICAR TABLAS PRINCIPALES DEL SISTEMA
-- ========================================

PROMPT '🔍 === VERIFICACIÓN DE TABLAS PRINCIPALES ==='
PROMPT ''

-- Verificar que todas las tablas principales existen
PROMPT '📋 TABLAS PRINCIPALES:'
SELECT 
    table_name as "TABLA",
    'EXISTE' as "ESTADO"
FROM user_tables 
WHERE table_name IN (
    'CATEGORIAS', 'PROVEEDORES', 'USUARIOS', 'CLIENTES', 'PRODUCTOS',
    'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
    'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
    'CAJA', 'CORTES_CAJA', 'REPORTES_GENERADOS', 'AUDITORIA', 'DEVOLUCIONES'
)
ORDER BY table_name;

PROMPT ''
PROMPT '📊 CONTEO DE TABLAS:'
SELECT COUNT(*) as "TABLAS_PRINCIPALES_CREADAS"
FROM user_tables 
WHERE table_name IN (
    'CATEGORIAS', 'PROVEEDORES', 'USUARIOS', 'CLIENTES', 'PRODUCTOS',
    'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
    'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
    'CAJA', 'CORTES_CAJA', 'REPORTES_GENERADOS', 'AUDITORIA', 'DEVOLUCIONES'
);

PROMPT ''
PROMPT '🎯 RESULTADO ESPERADO: 18 tablas principales'
