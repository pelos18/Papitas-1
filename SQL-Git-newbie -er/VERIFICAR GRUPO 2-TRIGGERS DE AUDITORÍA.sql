-- =====================================================
-- VERIFICAR GRUPO 2: TRIGGERS DE AUDITORÍA
-- =====================================================

PROMPT '🔍 Verificando triggers del GRUPO 2...'

SELECT 
    trigger_name as "TRIGGER",
    status as "ESTADO",
    table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_AUDITORIA_PRODUCTOS',
    'TRG_AUDITORIA_VENTAS', 
    'TRG_AUDITORIA_USUARIOS'
)
ORDER BY trigger_name;

PROMPT ''
PROMPT '📊 Resumen del GRUPO 2:'
SELECT 
    COUNT(*) as "TRIGGERS_AUDITORIA_CREADOS"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_AUDITORIA_PRODUCTOS',
    'TRG_AUDITORIA_VENTAS', 
    'TRG_AUDITORIA_USUARIOS'
);

PROMPT ''
PROMPT '🔐 Verificando tabla AUDITORIA:'
SELECT COUNT(*) as "REGISTROS_AUDITORIA" FROM auditoria;
