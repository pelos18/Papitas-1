-- =====================================================
-- VERIFICACIÓN COMPLETA PASO 2: ESTRUCTURA DE PRODUCTOS
-- =====================================================

PROMPT ''
PROMPT '🔍 === PASO 2: VERIFICACIÓN DETALLADA DE PRODUCTOS ==='
PROMPT ''

-- 1. ESTRUCTURA COMPLETA DE LA TABLA PRODUCTOS
PROMPT '🏗️ 1. ESTRUCTURA COMPLETA DE PRODUCTOS:'
SELECT 
    column_id as "#",
    column_name as "COLUMNA",
    data_type as "TIPO",
    CASE 
        WHEN data_type LIKE '%NUMBER%' THEN data_type || '(' || NVL(data_precision,38) || 
             CASE WHEN data_scale > 0 THEN ',' || data_scale ELSE '' END || ')'
        WHEN data_type LIKE '%VARCHAR%' THEN data_type || '(' || data_length || ')'
        ELSE data_type
    END as "TIPO_COMPLETO",
    CASE WHEN nullable = 'Y' THEN 'SÍ' ELSE 'NO' END as "NULO",
    data_default as "DEFAULT"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS'
ORDER BY column_id;

PROMPT ''
PROMPT '🔍 2. VERIFICAR COLUMNA VALOR_INVENTARIO ESPECÍFICAMENTE:'
SELECT 
    column_name as "COLUMNA",
    data_type as "TIPO",
    data_precision as "PRECISIÓN",
    data_scale as "ESCALA",
    nullable as "PERMITE_NULO",
    data_default as "VALOR_DEFAULT"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' 
AND column_name = 'VALOR_INVENTARIO';

-- Verificar si la columna existe
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ COLUMNA VALOR_INVENTARIO EXISTE'
        ELSE '❌ COLUMNA VALOR_INVENTARIO NO EXISTE'
    END as "ESTADO_COLUMNA"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' 
AND column_name = 'VALOR_INVENTARIO';

PROMPT ''
PROMPT '🔒 3. CONSTRAINTS DE LA TABLA PRODUCTOS:'
SELECT 
    constraint_name as "CONSTRAINT",
    constraint_type as "TIPO",
    CASE constraint_type
        WHEN 'P' THEN 'PRIMARY KEY'
        WHEN 'R' THEN 'FOREIGN KEY'
        WHEN 'C' THEN 'CHECK'
        WHEN 'U' THEN 'UNIQUE'
        ELSE constraint_type
    END as "DESCRIPCIÓN",
    status as "ESTADO"
FROM user_constraints 
WHERE table_name = 'PRODUCTOS'
ORDER BY constraint_type, constraint_name;
