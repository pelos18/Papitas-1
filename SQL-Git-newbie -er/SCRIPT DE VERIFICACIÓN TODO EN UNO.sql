-- =====================================================
-- SCRIPT DE VERIFICACIÓN TODO EN UNO
-- Ejecuta este script para ver TODO de una vez
-- =====================================================

PROMPT '🔍🔍🔍 === VERIFICACIÓN COMPLETA TODO EN UNO === 🔍🔍🔍'
PROMPT ''

-- SECCIÓN 1: TABLAS
PROMPT '📋 === SECCIÓN 1: TODAS LAS TABLAS ==='
SELECT table_name as "TABLA", num_rows as "FILAS" FROM user_tables ORDER BY table_name;

PROMPT ''
PROMPT '🔢 === SECCIÓN 2: TODAS LAS SECUENCIAS ==='
SELECT sequence_name as "SECUENCIA", last_number as "ÚLTIMO_NUM" FROM user_sequences ORDER BY sequence_name;

PROMPT ''
PROMPT '⚡ === SECCIÓN 3: TODOS LOS TRIGGERS ==='
SELECT trigger_name as "TRIGGER", table_name as "TABLA", status as "ESTADO" FROM user_triggers WHERE trigger_name LIKE 'TRG_%' ORDER BY trigger_name;

PROMPT ''
PROMPT '🏗️ === SECCIÓN 4: ESTRUCTURA DE PRODUCTOS ==='
SELECT column_name as "COLUMNA", data_type as "TIPO", nullable as "NULO" FROM user_tab_columns WHERE table_name = 'PRODUCTOS' ORDER BY column_id;

PROMPT ''
PROMPT '💰 === SECCIÓN 5: DATOS DE PRODUCTOS ==='
SELECT nombre, stock_actual, costo_total, valor_inventario FROM PRODUCTOS WHERE ROWNUM <= 5;

PROMPT ''
PROMPT '🎯 === SECCIÓN 6: VERIFICACIÓN VALOR_INVENTARIO ==='
SELECT 
    CASE WHEN COUNT(*) > 0 THEN '✅ EXISTE' ELSE '❌ NO EXISTE' END as "COLUMNA_EXISTE"
FROM user_tab_columns WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO';

PROMPT ''
PROMPT '📊 === RESUMEN FINAL ==='
SELECT 
    (SELECT COUNT(*) FROM user_tables) as "TOTAL_TABLAS",
    (SELECT COUNT(*) FROM user_triggers WHERE status = 'ENABLED') as "TRIGGERS_OK",
    (SELECT COUNT(*) FROM PRODUCTOS) as "PRODUCTOS",
    (SELECT COUNT(*) FROM user_tab_columns WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO') as "COLUMNA_VALOR_INV"
FROM dual;

PROMPT ''
PROMPT '🏆 ¡VERIFICACIÓN COMPLETA TERMINADA!'
