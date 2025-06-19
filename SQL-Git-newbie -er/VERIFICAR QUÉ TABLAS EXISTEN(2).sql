-- =====================================================
-- VERIFICAR QUÉ TABLAS EXISTEN
-- =====================================================

SELECT table_name 
FROM user_tables 
WHERE table_name IN (
    'CATEGORIAS', 'PROVEEDORES', 'USUARIOS', 'CLIENTES', 'PRODUCTOS',
    'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA', 'VENTAS'
)
ORDER BY table_name;

PROMPT '=== SECUENCIAS EXISTENTES ==='
SELECT sequence_name 
FROM user_sequences 
WHERE sequence_name LIKE 'SEQ_%'
ORDER BY sequence_name;
