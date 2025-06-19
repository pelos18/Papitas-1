-- ========================================
-- GRUPO 5: TRIGGERS DE PROMOCIONES (2)
-- ========================================

PROMPT '🚀 === EJECUTANDO GRUPO 5: TRIGGERS DE PROMOCIONES ==='
PROMPT ''

-- ========================================
-- TRIGGER 15: Aplicación automática de promociones
-- ========================================
PROMPT '🔥 15/18 - Creando trigger de aplicación automática de promociones...'

CREATE OR REPLACE TRIGGER TRG_APLICACION_PROMOCIONES
    BEFORE INSERT OR UPDATE ON DETALLE_VENTAS
    FOR EACH ROW
DECLARE
    v_promocion_activa NUMBER;
    v_precio_promocion NUMBER(10,2);
    v_descuento_porcentaje NUMBER(5,2);
    v_tipo_promocion VARCHAR2(20);
BEGIN
    -- Verificar si el producto tiene promoción activa
    SELECT COUNT(*), MAX(id_promocion), MAX(precio_promocion), 
           MAX(porcentaje_descuento), MAX(tipo_promocion)
    INTO v_promocion_activa, :NEW.id_promocion, v_precio_promocion, 
         v_descuento_porcentaje, v_tipo_promocion
    FROM PROMOCIONES 
    WHERE id_producto = :NEW.id_producto 
      AND activa = 1
      AND SYSDATE BETWEEN fecha_inicio AND fecha_fin
      AND (hora_inicio IS NULL OR TO_CHAR(SYSDATE, 'HH24:MI:SS') >= hora_inicio)
      AND (hora_fin IS NULL OR TO_CHAR(SYSDATE, 'HH24:MI:SS') <= hora_fin);
    
    -- Aplicar promoción si existe
    IF v_promocion_activa > 0 THEN
        :NEW.es_promocion := 1;
        
        -- Aplicar según tipo de promoción
        IF v_tipo_promocion = 'PRECIO_FIJO' THEN
            :NEW.precio_unitario := v_precio_promocion;
            :NEW.descuento_linea := (:NEW.precio_unitario - v_precio_promocion) * :NEW.cantidad;
        ELSIF v_tipo_promocion = 'DESCUENTO' THEN
            :NEW.descuento_linea := (:NEW.precio_unitario * v_descuento_porcentaje / 100) * :NEW.cantidad;
        END IF;
        
        -- Recalcular subtotal
        :NEW.subtotal := (:NEW.precio_unitario * :NEW.cantidad) - :NEW.descuento_linea;
    ELSE
        :NEW.es_promocion := 0;
        :NEW.id_promocion := NULL;
    END IF;
    
    -- Calcular ganancia de línea
    :NEW.ganancia_linea := :NEW.subtotal - (:NEW.costo_unitario * :NEW.cantidad);
    
EXCEPTION
    WHEN OTHERS THEN
        -- En caso de error, continuar sin promoción
        :NEW.es_promocion := 0;
        :NEW.id_promocion := NULL;
        :NEW.descuento_linea := 0;
        :NEW.subtotal := :NEW.precio_unitario * :NEW.cantidad;
        :NEW.ganancia_linea := :NEW.subtotal - (:NEW.costo_unitario * :NEW.cantidad);
END;
/

PROMPT '✅ 15/18 - Trigger de aplicación automática de promociones creado!'

-- ========================================
-- TRIGGER 16: Control de COMBOS
-- ========================================
PROMPT '🔥 16/18 - Creando trigger de control de COMBOS...'

CREATE OR REPLACE TRIGGER TRG_CONTROL_COMBOS
    AFTER INSERT OR UPDATE OR DELETE ON DETALLE_COMBOS
    FOR EACH ROW
DECLARE
    v_precio_individual_total NUMBER(10,2) := 0;
    v_ahorro_total NUMBER(10,2);
    v_precio_combo NUMBER(10,2);
BEGIN
    -- Obtener precio del combo
    IF INSERTING OR UPDATING THEN
        SELECT precio_combo INTO v_precio_combo
        FROM COMBOS 
        WHERE id_combo = :NEW.id_combo;
        
        -- Calcular precio individual total del combo
        SELECT SUM(p.precio_venta * dc.cantidad_requerida)
        INTO v_precio_individual_total
        FROM DETALLE_COMBOS dc
        JOIN PRODUCTOS p ON dc.id_producto = p.id_producto
        WHERE dc.id_combo = :NEW.id_combo;
        
    ELSIF DELETING THEN
        SELECT precio_combo INTO v_precio_combo
        FROM COMBOS 
        WHERE id_combo = :OLD.id_combo;
        
        -- Calcular precio individual total del combo (sin el producto eliminado)
        SELECT NVL(SUM(p.precio_venta * dc.cantidad_requerida), 0)
        INTO v_precio_individual_total
        FROM DETALLE_COMBOS dc
        JOIN PRODUCTOS p ON dc.id_producto = p.id_producto
        WHERE dc.id_combo = :OLD.id_combo
          AND dc.id_producto != :OLD.id_producto;
    END IF;
    
    -- Calcular ahorro
    v_ahorro_total := v_precio_individual_total - v_precio_combo;
    
    -- Actualizar tabla COMBOS
    IF INSERTING OR UPDATING THEN
        UPDATE COMBOS 
        SET precio_individual_total = v_precio_individual_total,
            ahorro_total = v_ahorro_total
        WHERE id_combo = :NEW.id_combo;
    ELSIF DELETING THEN
        UPDATE COMBOS 
        SET precio_individual_total = v_precio_individual_total,
            ahorro_total = v_ahorro_total
        WHERE id_combo = :OLD.id_combo;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Continuar en caso de error
END;
/

PROMPT '✅ 16/18 - Trigger de control de COMBOS creado!'

PROMPT ''
PROMPT '🎉 === GRUPO 5 COMPLETADO: 2 TRIGGERS DE PROMOCIONES ==='
PROMPT '✅ TRG_APLICACION_PROMOCIONES - Aplicación automática de promociones'
PROMPT '✅ TRG_CONTROL_COMBOS - Control automático de combos'
PROMPT ''
