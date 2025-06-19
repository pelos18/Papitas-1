-- ========================================
-- VERIFICAR GRUPO 5: TRIGGERS DE PROMOCIONES
-- ========================================

PROMPT '🔍 Verificando triggers del GRUPO 5...'

SELECT trigger_name as "TRIGGER", 
       status as "ESTADO",
       table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_APLICACION_PROMOCIONES',
    'TRG_CONTROL_COMBOS'
)
ORDER BY trigger_name;

PROMPT ''
PROMPT '📊 Resumen del GRUPO 5:'

SELECT COUNT(*) as "TRIGGERS_CREADOS"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_APLICACION_PROMOCIONES',
    'TRG_CONTROL_COMBOS'
)
AND status = 'ENABLED';

PROMPT ''
PROMPT '🎯 Verificando tablas de promociones:'

SELECT table_name as "TABLA", 
       CASE WHEN table_name IN (
           SELECT table_name FROM user_tables 
           WHERE table_name IN ('PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS')
       ) THEN 'EXISTE' ELSE 'FALTA' END as "ESTADO"
FROM (
    SELECT 'PROMOCIONES' as table_name FROM dual
    UNION ALL
    SELECT 'COMBOS' as table_name FROM dual
    UNION ALL
    SELECT 'DETALLE_COMBOS' as table_name FROM dual
);
