-- ========================================
-- RECOMPILAR TRIGGER DE REPORTES (FINAL)
-- ========================================

PROMPT '🔧 === RECOMPILANDO TRIGGER DE REPORTES ==='
PROMPT ''

-- Recompilar trigger de reportes
PROMPT '🔥 Recompilando TRG_GENERACION_REPORTES...'
ALTER TRIGGER TRG_GENERACION_REPORTES COMPILE;

PROMPT ''
PROMPT '✅ === TRIGGER DE REPORTES RECOMPILADO ==='

-- Verificar estado final
PROMPT '🔍 Verificando estado final de GRUPO 6:'

SELECT trigger_name as "TRIGGER", 
       status as "ESTADO",
       table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_GENERACION_REPORTES',
    'TRG_CONTROL_SESIONES'
)
ORDER BY trigger_name;

PROMPT ''
PROMPT '🎯 Verificando tablas necesarias:'
SELECT 'CORTES_CAJA' as TABLA, COUNT(*) as EXISTE FROM user_tables WHERE table_name = 'CORTES_CAJA'
UNION ALL
SELECT 'REPORTES_GENERADOS' as TABLA, COUNT(*) as EXISTE FROM user_tables WHERE table_name = 'REPORTES_GENERADOS';
