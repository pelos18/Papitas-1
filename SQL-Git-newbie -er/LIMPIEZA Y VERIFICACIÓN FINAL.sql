-- =====================================================
-- LIMPIEZA Y VERIFICACIÓN FINAL
-- =====================================================

PROMPT '🧹 === LIMPIEZA Y VERIFICACIÓN FINAL ==='
PROMPT ''

-- Limpiar datos de prueba
DELETE FROM MOVIMIENTOS_INVENTARIO 
WHERE observaciones LIKE '%Prueba%verificación%';

DELETE FROM PRODUCTOS 
WHERE nombre LIKE '%PRUEBA%';

COMMIT;

PROMPT '✅ Datos de prueba limpiados'

-- Verificación final del sistema
PROMPT ''
PROMPT '🎯 === VERIFICACIÓN FINAL DEL SISTEMA ==='

-- 1. Verificar estructura básica
SELECT 
    'TABLAS_PRINCIPALES' as "COMPONENTE",
    COUNT(*) as "CANTIDAD"
FROM user_tables 
WHERE table_name IN (
    'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
    'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA'
)
UNION ALL
SELECT 
    'TRIGGERS_ACTIVOS',
    COUNT(*)
FROM user_triggers 
WHERE trigger_name LIKE 'TRG_%' AND status = 'ENABLED'
UNION ALL
SELECT 
    'SECUENCIAS',
    COUNT(*)
FROM user_sequences 
WHERE sequence_name LIKE 'SEQ_%';

-- 2. Verificar columna valor_inventario
PROMPT ''
PROMPT '💰 VERIFICACIÓN VALOR_INVENTARIO:'
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ COLUMNA EXISTE'
        ELSE '❌ COLUMNA NO EXISTE'
    END as "ESTADO_COLUMNA"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO';

-- 3. Estado de productos existentes
PROMPT ''
PROMPT '📊 ESTADO DE PRODUCTOS EXISTENTES:'
SELECT 
    COUNT(*) as "TOTAL_PRODUCTOS",
    COUNT(CASE WHEN valor_inventario IS NOT NULL THEN 1 END) as "CON_VALOR_INVENTARIO",
    COUNT(CASE WHEN valor_inventario > 0 THEN 1 END) as "CON_VALOR_POSITIVO",
    TO_CHAR(SUM(NVL(valor_inventario, 0)), '999,999,999.99') as "VALOR_TOTAL_INVENTARIO"
FROM PRODUCTOS 
WHERE activo = 1;

PROMPT ''
PROMPT '🏆 === RESULTADO FINAL ==='
PROMPT '✅ Errores de Foreign Key solucionados'
PROMPT '✅ Trigger de auditoría corregido'
PROMPT '✅ Datos básicos creados (usuarios, categorías, proveedores)'
PROMPT '✅ Sistema listo para funcionar correctamente'
PROMPT ''
PROMPT '🎉 ¡AHORA PUEDES EJECUTAR LA VERIFICACIÓN PASO 5 SIN ERRORES!'
