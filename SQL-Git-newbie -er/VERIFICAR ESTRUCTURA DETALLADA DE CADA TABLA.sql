-- =====================================================
-- VERIFICAR ESTRUCTURA DETALLADA DE CADA TABLA
-- =====================================================

PROMPT '🔍 === VERIFICACIÓN DETALLADA DE ESTRUCTURA ==='
PROMPT ''

-- Función para verificar columnas de cada tabla
PROMPT '📋 ESTRUCTURA DE TABLAS PRINCIPALES:'
PROMPT ''

PROMPT '1. CATEGORIAS:'
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'CATEGORIAS'
ORDER BY column_id;

PROMPT ''
PROMPT '2. PROVEEDORES:'
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'PROVEEDORES'
ORDER BY column_id;

PROMPT ''
PROMPT '3. PRODUCTOS:'
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS'
ORDER BY column_id;

PROMPT ''
PROMPT '4. USUARIOS:'
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'USUARIOS'
ORDER BY column_id;

PROMPT ''
PROMPT '5. VENTAS:'
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'VENTAS'
ORDER BY column_id;
