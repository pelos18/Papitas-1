-- =====================================================
-- TRIGGER: Control automático de caja (CORREGIDO)
-- Actualiza totales de caja con cada venta
-- =====================================================

PROMPT '🔥 Corrigiendo trigger para control de caja...'

CREATE OR REPLACE TRIGGER TRG_CONTROL_CAJA
    AFTER INSERT OR UPDATE ON VENTAS
    FOR EACH ROW
DECLARE
    v_caja_abierta NUMBER;
    v_id_caja NUMBER;
BEGIN
    -- Solo procesar ventas completadas
    IF :NEW.estado = 'COMPLETADA' THEN
        
        -- Buscar caja abierta del día (SINTAXIS CORREGIDA)
        BEGIN
            SELECT id_caja INTO v_id_caja
            FROM caja
            WHERE TRUNC(fecha) = TRUNC(SYSDATE)  -- ✅ CORREGIDO
            AND estado = 'ABIERTA'
            AND ROWNUM = 1;
            
            v_caja_abierta := 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_caja_abierta := 0;
        END;
        
        -- Si no hay caja abierta, crear una nueva
        IF v_caja_abierta = 0 THEN
            INSERT INTO caja (
                id_caja, fecha, hora_apertura, saldo_inicial,
                ingresos_efectivo, ingresos_tarjeta, ingresos_transferencia,
                egresos, saldo_teorico, saldo_fisico, diferencia,
                id_usuario_apertura, estado, fecha_creacion, numero_ventas,
                ganancia_dia
            ) VALUES (
                seq_caja.NEXTVAL,
                SYSDATE,
                TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                0, 0, 0, 0, 0, 0, 0, 0,
                :NEW.id_usuario,
                'ABIERTA',
                SYSDATE,
                0,
                0
            );
            
            v_id_caja := seq_caja.CURRVAL;
        END IF;
        
        -- Actualizar totales de caja según método de pago
        IF :NEW.metodo_pago = 'EFECTIVO' THEN
            UPDATE caja 
            SET ingresos_efectivo = ingresos_efectivo + :NEW.total,
                numero_ventas = numero_ventas + 1,
                saldo_teorico = saldo_inicial + ingresos_efectivo + ingresos_tarjeta + ingresos_transferencia - egresos,
                ganancia_dia = ganancia_dia + NVL(:NEW.ganancia_venta, 0)
            WHERE id_caja = v_id_caja;
            
        ELSIF :NEW.metodo_pago = 'TARJETA' THEN
            UPDATE caja 
            SET ingresos_tarjeta = ingresos_tarjeta + :NEW.total,
                numero_ventas = numero_ventas + 1,
                saldo_teorico = saldo_inicial + ingresos_efectivo + ingresos_tarjeta + ingresos_transferencia - egresos,
                ganancia_dia = ganancia_dia + NVL(:NEW.ganancia_venta, 0)
            WHERE id_caja = v_id_caja;
            
        ELSIF :NEW.metodo_pago = 'TRANSFERENCIA' THEN
            UPDATE caja 
            SET ingresos_transferencia = ingresos_transferencia + :NEW.total,
                numero_ventas = numero_ventas + 1,
                saldo_teorico = saldo_inicial + ingresos_efectivo + ingresos_tarjeta + ingresos_transferencia - egresos,
                ganancia_dia = ganancia_dia + NVL(:NEW.ganancia_venta, 0)
            WHERE id_caja = v_id_caja;
        END IF;
    END IF;
END;
/

PROMPT '✅ Trigger de control de caja corregido exitosamente!'
