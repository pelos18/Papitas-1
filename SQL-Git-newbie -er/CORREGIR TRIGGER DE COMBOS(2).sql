-- ========================================
-- CORREGIR TRIGGER DE COMBOS
-- ========================================

PROMPT '🔧 === CORRIGIENDO TRIGGER DE COMBOS ==='
PROMPT ''

-- Eliminar trigger problemático
DROP TRIGGER TRG_CONTROL_COMBOS;

-- Recrear trigger con sintaxis corregida
PROMPT '🔥 Recreando TRG_CONTROL_COMBOS con sintaxis corregida...'

CREATE OR REPLACE TRIGGER TRG_CONTROL_COMBOS
    AFTER INSERT OR UPDATE OR DELETE ON DETALLE_COMBOS
    FOR EACH ROW
DECLARE
    v_precio_individual_total NUMBER(10,2) := 0;
    v_ahorro_total NUMBER(10,2);
    v_precio_combo NUMBER(10,2);
    v_id_combo NUMBER(10);
BEGIN
    -- Determinar ID del combo
    IF INSERTING OR UPDATING THEN
        v_id_combo := :NEW.id_combo;
    ELSE
        v_id_combo := :OLD.id_combo;
    END IF;
    
    -- Obtener precio del combo
    SELECT precio_combo 
    INTO v_precio_combo
    FROM COMBOS 
    WHERE id_combo = v_id_combo;
    
    -- Calcular precio individual total del combo
    SELECT NVL(SUM(p.precio_venta * dc.cantidad_requerida), 0)
    INTO v_precio_individual_total
    FROM DETALLE_COMBOS dc
    JOIN PRODUCTOS p ON dc.id_producto = p.id_producto
    WHERE dc.id_combo = v_id_combo;
    
    -- Calcular ahorro
    v_ahorro_total := v_precio_individual_total - v_precio_combo;
    
    -- Actualizar tabla COMBOS
    UPDATE COMBOS 
    SET precio_individual_total = v_precio_individual_total,
        ahorro_total = GREATEST(v_ahorro_total, 0)  -- No permitir ahorros negativos
    WHERE id_combo = v_id_combo;
    
    DBMS_OUTPUT.PUT_LINE('✅ Combo actualizado ID: ' || v_id_combo || 
                        ' - Ahorro: $' || TO_CHAR(v_ahorro_total, '999,999.99'));
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Combo no encontrado: ' || v_id_combo);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error en trigger combos: ' || SQLERRM);
        -- No fallar la transacción principal
        NULL;
END;
/

PROMPT '✅ Trigger TRG_CONTROL_COMBOS recreado exitosamente!'
