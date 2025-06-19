-- =====================================================
-- CORREGIR TRIGGER DE AUDITORÍA
-- Para que no falle cuando no encuentra usuario
-- =====================================================

PROMPT '🔧 === CORRIGIENDO TRIGGER DE AUDITORÍA ==='
PROMPT ''

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_PRODUCTOS
    AFTER INSERT OR UPDATE OR DELETE ON PRODUCTOS
    FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_usuario_actual VARCHAR2(100);
    v_ip_usuario VARCHAR2(50);
    v_id_usuario NUMBER := 1; -- Usuario por defecto
BEGIN
    -- Determinar tipo de operación
    IF INSERTING THEN
        v_operacion := 'INSERT';
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
    END IF;
    
    -- Obtener información del usuario actual
    SELECT USER INTO v_usuario_actual FROM DUAL;
    v_ip_usuario := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    
    -- Verificar que existe un usuario válido para auditoría
    BEGIN
        SELECT id_usuario INTO v_id_usuario 
        FROM USUARIOS 
        WHERE id_usuario = 1 AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Si no existe usuario 1, usar NULL y continuar
            v_id_usuario := NULL;
    END;
    
    -- Solo hacer auditoría si tenemos un usuario válido
    IF v_id_usuario IS NOT NULL THEN
        -- Auditoría para INSERT
        IF INSERTING THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'PRODUCTOS', v_operacion, 'REGISTRO_COMPLETO',
                NULL, 'Nuevo producto: ' || :NEW.nombre,
                :NEW.id_producto, v_id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Producto creado: ' || NVL(:NEW.codigo_interno, 'SIN_CODIGO')
            );
        END IF;
        
        -- Auditoría para UPDATE (solo cambios importantes)
        IF UPDATING THEN
            -- Cambio en precio_venta
            IF NVL(:OLD.precio_venta, 0) != NVL(:NEW.precio_venta, 0) THEN
                INSERT INTO auditoria (
                    id_auditoria, tabla_afectada, operacion, campo_modificado,
                    valor_anterior, valor_nuevo, id_registro_afectado,
                    id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
                ) VALUES (
                    seq_auditoria.NEXTVAL, 'PRODUCTOS', v_operacion, 'precio_venta',
                    TO_CHAR(:OLD.precio_venta), TO_CHAR(:NEW.precio_venta),
                    :NEW.id_producto, v_id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                    v_ip_usuario, 'Cambio de precio: ' || :NEW.nombre
                );
            END IF;
        END IF;
        
        -- Auditoría para DELETE
        IF DELETING THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'PRODUCTOS', v_operacion, 'REGISTRO_COMPLETO',
                'Producto eliminado: ' || :OLD.nombre, NULL,
                :OLD.id_producto, v_id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Producto eliminado: ' || NVL(:OLD.codigo_interno, 'SIN_CODIGO')
            );
        END IF;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        -- En caso de cualquier error en auditoría, no fallar la operación principal
        NULL;
END;
/

PROMPT '✅ Trigger de auditoría corregido para manejar usuarios faltantes'
