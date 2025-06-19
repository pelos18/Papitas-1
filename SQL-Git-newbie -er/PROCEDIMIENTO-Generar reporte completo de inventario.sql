-- =====================================================
-- PROCEDIMIENTO: Generar reporte completo de inventario
-- Incluye valor_inventario y análisis detallado
-- =====================================================

PROMPT '📊 === CREANDO PROCEDIMIENTO DE REPORTE INVENTARIO ==='
PROMPT ''

CREATE OR REPLACE PROCEDURE SP_REPORTE_INVENTARIO_VALORIZADO(
    p_incluir_inactivos IN NUMBER DEFAULT 0,
    p_solo_criticos IN NUMBER DEFAULT 0
) AS
    v_total_productos NUMBER;
    v_valor_total NUMBER;
    v_productos_criticos NUMBER;
    v_productos_caducados NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('📊 === REPORTE DE INVENTARIO VALORIZADO ===');
    DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Estadísticas generales
    SELECT 
        COUNT(*),
        NVL(SUM(valor_inventario), 0),
        COUNT(CASE WHEN stock_actual <= stock_minimo THEN 1 END),
        COUNT(CASE WHEN fecha_caducidad <= SYSDATE THEN 1 END)
    INTO v_total_productos, v_valor_total, v_productos_criticos, v_productos_caducados
    FROM PRODUCTOS 
    WHERE (p_incluir_inactivos = 1 OR activo = 1);
    
    DBMS_OUTPUT.PUT_LINE('📈 ESTADÍSTICAS GENERALES:');
    DBMS_OUTPUT.PUT_LINE('Total de productos: ' || v_total_productos);
    DBMS_OUTPUT.PUT_LINE('Valor total inventario: $' || TO_CHAR(v_valor_total, '999,999,999.99'));
    DBMS_OUTPUT.PUT_LINE('Productos con stock crítico: ' || v_productos_criticos);
    DBMS_OUTPUT.PUT_LINE('Productos caducados: ' || v_productos_caducados);
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Top 10 productos por valor
    DBMS_OUTPUT.PUT_LINE('💰 TOP 10 PRODUCTOS POR VALOR DE INVENTARIO:');
    FOR rec IN (
        SELECT nombre, stock_actual, costo_total, valor_inventario,
               TO_CHAR(valor_inventario, '999,999,999.99') as valor_fmt
        FROM PRODUCTOS 
        WHERE (p_incluir_inactivos = 1 OR activo = 1)
        AND (p_solo_criticos = 0 OR stock_actual <= stock_minimo)
        ORDER BY valor_inventario DESC
        FETCH FIRST 10 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || rec.nombre || ': ' || rec.stock_actual || 
                           ' unidades x $' || rec.costo_total || ' = $' || rec.valor_fmt);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✅ Reporte completado exitosamente');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error generando reporte: ' || SQLERRM);
END;
/

PROMPT '✅ Procedimiento SP_REPORTE_INVENTARIO_VALORIZADO creado!'

-- Ejecutar ejemplo del reporte
PROMPT ''
PROMPT '🧪 === EJECUTANDO REPORTE DE EJEMPLO ==='
BEGIN
    SP_REPORTE_INVENTARIO_VALORIZADO(0, 0);
END;
/
