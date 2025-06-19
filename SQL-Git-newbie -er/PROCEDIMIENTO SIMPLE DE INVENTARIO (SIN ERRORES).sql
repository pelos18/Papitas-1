-- =====================================================
-- PROCEDIMIENTO SIMPLE DE INVENTARIO (SIN ERRORES)
-- =====================================================

PROMPT '📊 === CREANDO PROCEDIMIENTO SIMPLE ==='
PROMPT ''

CREATE OR REPLACE PROCEDURE SP_INVENTARIO_SIMPLE AS
    v_total_productos NUMBER;
    v_valor_total NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('📊 === REPORTE SIMPLE DE INVENTARIO ===');
    DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Estadísticas básicas
    SELECT 
        COUNT(*),
        NVL(SUM(valor_inventario), 0)
    INTO v_total_productos, v_valor_total
    FROM PRODUCTOS 
    WHERE activo = 1;
    
    DBMS_OUTPUT.PUT_LINE('📈 ESTADÍSTICAS:');
    DBMS_OUTPUT.PUT_LINE('Total de productos: ' || v_total_productos);
    DBMS_OUTPUT.PUT_LINE('Valor total inventario: $' || TO_CHAR(v_valor_total, '999,999,999.99'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Top 5 productos
    DBMS_OUTPUT.PUT_LINE('💰 TOP 5 PRODUCTOS POR VALOR:');
    FOR rec IN (
        SELECT nombre, stock_actual, valor_inventario
        FROM PRODUCTOS 
        WHERE activo = 1 AND valor_inventario > 0
        ORDER BY valor_inventario DESC
        FETCH FIRST 5 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || rec.nombre || ': $' || TO_CHAR(rec.valor_inventario, '999,999.99'));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✅ Reporte completado');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
END;
/

PROMPT '✅ Procedimiento SP_INVENTARIO_SIMPLE creado exitosamente'

-- Ejecutar el procedimiento
PROMPT ''
PROMPT '🧪 === EJECUTANDO REPORTE SIMPLE ==='
BEGIN
    SP_INVENTARIO_SIMPLE;
END;
/
