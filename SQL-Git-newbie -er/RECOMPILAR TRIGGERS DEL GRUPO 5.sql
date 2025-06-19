-- ========================================
-- RECOMPILAR TRIGGERS DEL GRUPO 5
-- ========================================

PROMPT '🔧 === RECOMPILANDO TRIGGERS DEL GRUPO 5 ==='
PROMPT ''

-- Recompilar trigger de promociones
PROMPT '🔥 Recompilando TRG_APLICACION_PROMOCIONES...'
ALTER TRIGGER TRG_APLICACION_PROMOCIONES COMPILE;

-- Recompilar trigger de combos
PROMPT '🔥 Recompilando TRG_CONTROL_COMBOS...'
ALTER TRIGGER TRG_CONTROL_COMBOS COMPILE;

PROMPT ''
PROMPT '✅ === TRIGGERS DEL GRUPO 5 RECOMPILADOS ==='

-- Verificar estado
PROMPT '🔍 Verificando estado de triggers:'

SELECT trigger_name as "TRIGGER", 
       status as "ESTADO",
       table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_APLICACION_PROMOCIONES',
    'TRG_CONTROL_COMBOS'
)
ORDER BY trigger_name;
