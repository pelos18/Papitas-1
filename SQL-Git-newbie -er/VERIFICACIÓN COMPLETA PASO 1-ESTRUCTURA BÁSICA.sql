-- =====================================================
-- VERIFICACIÓN COMPLETA PASO 1: ESTRUCTURA BÁSICA
-- =====================================================

PROMPT '🔍 === VERIFICACIÓN COMPLETA DEL SISTEMA === 🔍'
PROMPT 'Paso 1: Estructura básica de la base de datos'
PROMPT ''

-- 1. VERIFICAR TODAS LAS TABLAS
PROMPT '📋 1. TODAS LAS TABLAS EN LA BASE DE DATOS:'
SELECT 
    table_name as "TABLA",
    num_rows as "FILAS_APROX",
    CASE 
        WHEN table_name IN (
            'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
            'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
            'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
            'OFERTAS_ESPECIALES', 'CAJA', 'CORTES_CAJA', 'REPORTES_GENERADOS',
            'AUDITORIA', 'DEVOLUCIONES'
        ) THEN '✅ PRINCIPAL'
        ELSE '📋 AUXILIAR'
    END as "TIPO"
FROM user_tables 
WHERE table_name NOT LIKE 'BIN$%'  -- Excluir papelera de reciclaje
ORDER BY 
    CASE WHEN table_name IN (
        'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
        'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
        'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
        'OFERTAS_ESPECIALES', 'CAJA', 'CORTES_CAJA', 'REPORTES_GENERADOS',
        'AUDITORIA', 'DEVOLUCIONES'
    ) THEN 1 ELSE 2 END,
    table_name;

PROMPT ''
PROMPT '🔢 2. TODAS LAS SECUENCIAS:'
SELECT 
    sequence_name as "SECUENCIA",
    last_number as "ÚLTIMO_NÚMERO",
    increment_by as "INCREMENTO"
FROM user_sequences 
ORDER BY sequence_name;

PROMPT ''
PROMPT '📊 3. RESUMEN DE OBJETOS:'
SELECT 
    object_type as "TIPO_OBJETO",
    COUNT(*) as "CANTIDAD",
    COUNT(CASE WHEN status = 'VALID' THEN 1 END) as "VÁLIDOS",
    COUNT(CASE WHEN status != 'VALID' THEN 1 END) as "CON_ERRORES"
FROM user_objects 
WHERE object_type IN ('TABLE', 'SEQUENCE', 'TRIGGER', 'VIEW', 'PROCEDURE', 'FUNCTION')
GROUP BY object_type
ORDER BY object_type;
