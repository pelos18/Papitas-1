-- =====================================================
-- TRIGGER PARA OFERTAS_ESPECIALES
-- Aplicación automática de ofertas especiales
-- =====================================================

PROMPT '🔥 === CREANDO TRIGGER PARA OFERTAS_ESPECIALES ==='
PROMPT ''

CREATE OR REPLACE TRIGGER TRG_APLICACION_OFERTAS_ESPECIALES
    BEFORE INSERT OR UPDATE ON DETALLE_VENTAS
    FOR EACH ROW
DECLARE
    v_oferta_activa NUMBER := 0;
    v_descuento_porcentaje NUMBER(5,2);
    v_monto_minimo NUMBER(12,2);
    v_tipo_oferta VARCHAR2(30);
    v_id_categoria NUMBER;
    v_subtotal_venta NUMBER(12,2);
    v_hora_actual VARCHAR2(8);
    v_dia_semana NUMBER;
BEGIN
    -- Obtener información del producto
    SELECT id_categoria INTO v_id_categoria
    FROM PRODUCTOS 
    WHERE id_producto = :NEW.id_producto;
    
    -- Obtener hora actual y día de la semana
    v_hora_actual := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    v_dia_semana := TO_NUMBER(TO_CHAR(SYSDATE, 'D')); -- 1=Domingo, 2=Lunes, etc.
    
    -- Buscar ofertas especiales activas
    FOR oferta IN (
        SELECT tipo_oferta, descuento_porcentaje, monto_minimo_compra, 
               hora_inicio, hora_fin, dias_semana
        FROM OFERTAS_ESPECIALES 
        WHERE activa = 1
          AND SYSDATE BETWEEN fecha_inicio AND fecha_fin
          AND (
              (tipo_oferta = 'DESCUENTO_CATEGORIA' AND id_categoria = v_id_categoria) OR
              (tipo_oferta = 'HAPPY_HOUR' AND v_hora_actual BETWEEN hora_inicio AND hora_fin) OR
              (tipo_oferta = 'COMPRA_MINIMA')
          )
    ) LOOP
        
        -- Verificar día de la semana (si aplica)
        IF oferta.dias_semana IS NOT NULL AND 
           oferta.dias_semana NOT LIKE '%' || v_dia_semana || '%' THEN
            CONTINUE;
        END IF;
        
        -- Para ofertas de compra mínima, verificar el total de la venta
        IF oferta.tipo_oferta = 'COMPRA_MINIMA' THEN
            SELECT NVL(SUM(subtotal), 0) INTO v_subtotal_venta
            FROM DETALLE_VENTAS 
            WHERE id_venta = :NEW.id_venta;
            
            IF (v_subtotal_venta + :NEW.subtotal) < oferta.monto_minimo_compra THEN
                CONTINUE;
            END IF;
        END IF;
        
        -- Aplicar descuento
        v_oferta_activa := 1;
        v_descuento_porcentaje := oferta.descuento_porcentaje;
        
        -- Calcular descuento
        :NEW.descuento_linea := :NEW.descuento_linea + 
                               (:NEW.precio_unitario * v_descuento_porcentaje / 100) * :NEW.cantidad;
        
        -- Recalcular subtotal
        :NEW.subtotal := (:NEW.precio_unitario * :NEW.cantidad) - :NEW.descuento_linea;
        
        -- Solo aplicar la primera oferta que coincida
        EXIT;
    END LOOP;
    
    -- Crear notificación si se aplicó oferta especial
    IF v_oferta_activa = 1 THEN
        INSERT INTO NOTIFICACIONES (
            id_notificacion, tipo_notificacion, titulo, mensaje,
            prioridad, id_usuario_destinatario, fecha_notificacion
        ) VALUES (
            seq_notificaciones.NEXTVAL,
            'PROMOCION',
            'Oferta Especial Aplicada',
            '🎉 Se aplicó descuento del ' || v_descuento_porcentaje || '% en producto ID: ' || :NEW.id_producto,
            'BAJA',
            1, -- Admin
            SYSDATE
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        -- En caso de error, continuar sin aplicar oferta
        NULL;
END;
/

PROMPT '✅ Trigger TRG_APLICACION_OFERTAS_ESPECIALES creado!'
