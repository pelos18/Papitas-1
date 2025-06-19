-- =====================================================
-- VERIFICAR GRUPO 3: TRIGGERS DE NOTIFICACIONES
-- =====================================================

PROMPT '🔍 Verificando triggers del GRUPO 3...'

SELECT 
    trigger_name as "TRIGGER",
    status as "ESTADO",
    table_name as "TABLA"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_NOTIFICACIONES_STOCK',
    'TRG_NOTIFICACIONES_CADUCIDAD', 
    'TRG_NOTIFICACIONES_VENTAS',
    'TRG_NOTIFICACIONES_SISTEMA'
)
ORDER BY trigger_name;

PROMPT ''
PROMPT '📊 Resumen del GRUPO 3:'
SELECT 
    COUNT(*) as "TRIGGERS_NOTIFICACIONES_CREADOS"
FROM user_triggers 
WHERE trigger_name IN (
    'TRG_NOTIFICACIONES_STOCK',
    'TRG_NOTIFICACIONES_CADUCIDAD', 
    'TRG_NOTIFICACIONES_VENTAS',
    'TRG_NOTIFICACIONES_SISTEMA'
);

PROMPT ''
PROMPT '🔔 Verificando tablas de notificaciones:'
SELECT 'NOTIFICACIONES' as TABLA, COUNT(*) as REGISTROS FROM notificaciones
UNION ALL
SELECT 'ALERTAS_SISTEMA' as TABLA, COUNT(*) as REGISTROS FROM alertas_sistema;
