-- =====================================================
-- VERIFICACIÓN COMPLETA PASO 4: TRIGGERS
-- =====================================================

PROMPT ''
PROMPT '🔍 === PASO 4: VERIFICACIÓN DE TRIGGERS ==='
PROMPT ''

-- 1. TODOS LOS TRIGGERS DEL SISTEMA
PROMPT '⚡ 1. TODOS LOS TRIGGERS DEL SISTEMA:'
SELECT 
    trigger_name as "TRIGGER",
    table_name as "TABLA",
    triggering_event as "EVENTO",
    status as "ESTADO",
    CASE 
        WHEN status = 'ENABLED' THEN '✅'
        ELSE '❌'
    END as "OK"
FROM user_triggers 
WHERE trigger_name LIKE 'TRG_%'
ORDER BY trigger_name;

PROMPT ''
PROMPT '📊 2. RESUMEN DE TRIGGERS POR ESTADO:'
SELECT 
    status as "ESTADO",
    COUNT(*) as "CANTIDAD"
FROM user_triggers 
WHERE trigger_name LIKE 'TRG_%'
GROUP BY status;

PROMPT ''
PROMPT '🔍 3. TRIGGERS ESPECÍFICOS PARA VALOR_INVENTARIO:'
SELECT 
    trigger_name as "TRIGGER",
    table_name as "TABLA",
    status as "ESTADO",
    triggering_event as "EVENTO"
FROM user_triggers 
WHERE trigger_name LIKE '%VALOR%' 
OR trigger_body LIKE '%valor_inventario%'
OR trigger_name IN (
    'TRG_ACTUALIZAR_VALOR_INVENTARIO',
    'TRG_VALOR_INV_MOVIMIENTOS',
    'TRG_PRODUCTOS_CALCULOS'
);

PROMPT ''
PROMPT '❌ 4. TRIGGERS CON ERRORES (SI LOS HAY):'
SELECT 
    object_name as "TRIGGER_CON_ERROR",
    object_type as "TIPO",
    status as "ESTADO"
FROM user_objects 
WHERE object_type = 'TRIGGER' 
AND status != 'VALID'
AND object_name LIKE 'TRG_%';
