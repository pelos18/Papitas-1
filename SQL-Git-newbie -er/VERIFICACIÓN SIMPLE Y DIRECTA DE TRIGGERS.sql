-- ========================================
-- VERIFICACIÓN SIMPLE Y DIRECTA DE TRIGGERS
-- ========================================

PROMPT '🔍 === VERIFICACIÓN SIMPLE DE TODOS LOS TRIGGERS ==='
PROMPT ''

-- Ver todos los triggers del sistema
PROMPT '📋 TODOS LOS TRIGGERS CREADOS:'
SELECT 
    trigger_name as "TRIGGER",
    status as "ESTADO",
    table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name LIKE 'TRG_%'
ORDER BY trigger_name;

PROMPT ''
PROMPT '📊 CONTEO SIMPLE:'
SELECT 
    COUNT(*) as "TOTAL_TRIGGERS_CREADOS",
    COUNT(CASE WHEN status = 'ENABLED' THEN 1 END) as "FUNCIONANDO",
    COUNT(CASE WHEN status != 'ENABLED' THEN 1 END) as "CON_PROBLEMAS"
FROM user_triggers 
WHERE trigger_name LIKE 'TRG_%';

PROMPT ''
PROMPT '🎯 TRIGGERS POR ESTADO:'
SELECT 
    status as "ESTADO",
    COUNT(*) as "CANTIDAD"
FROM user_triggers 
WHERE trigger_name LIKE 'TRG_%'
GROUP BY status
ORDER BY status;
