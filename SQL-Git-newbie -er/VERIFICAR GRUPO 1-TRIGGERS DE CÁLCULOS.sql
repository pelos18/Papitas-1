-- =====================================================
-- VERIFICAR GRUPO 1: TRIGGERS DE CÁLCULOS
-- =====================================================

PROMPT '🔍 Verificando triggers del GRUPO 1...'

SELECT 
    trigger_name as "TRIGGER",
    status as "ESTADO",
    table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_PRODUCTOS_CALCULOS',
    'TRG_STOCK_CONTROL', 
    'TRG_ALERTAS_CADUCIDAD',
    'TRG_CONTROL_CAJA'
)
ORDER BY trigger_name;

PROMPT ''
PROMPT '📊 Resumen del GRUPO 1:'
SELECT 
    COUNT(*) as "TRIGGERS_CREADOS"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_PRODUCTOS_CALCULOS',
    'TRG_STOCK_CONTROL', 
    'TRG_ALERTAS_CADUCIDAD',
    'TRG_CONTROL_CAJA'
);
