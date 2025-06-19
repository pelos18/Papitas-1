-- =====================================================
-- GRUPO 2: TRIGGERS DE AUDITORÍA AUTOMÁTICA
-- Registran todos los cambios en tablas críticas
-- =====================================================

PROMPT '🚀 === EJECUTANDO GRUPO 2: TRIGGERS DE AUDITORÍA ==='
PROMPT ''

-- TRIGGER 5: Auditoría de PRODUCTOS
PROMPT '🔥 5/18 - Creando trigger de auditoría para PRODUCTOS...'

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_PRODUCTOS
    AFTER INSERT OR UPDATE OR DELETE ON PRODUCTOS
    FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_usuario_actual VARCHAR2(100);
    v_ip_usuario VARCHAR2(50);
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
    
    -- Obtener IP (simulada por ahora)
    v_ip_usuario := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    
    -- Auditoría para INSERT
    IF INSERTING THEN
        INSERT INTO auditoria (
            id_auditoria, tabla_afectada, operacion, campo_modificado,
            valor_anterior, valor_nuevo, id_registro_afectado,
            id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
        ) VALUES (
            seq_auditoria.NEXTVAL, 'PRODUCTOS', v_operacion, 'REGISTRO_COMPLETO',
            NULL, 'Nuevo producto: ' || :NEW.nombre,
            :NEW.id_producto, 1, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            v_ip_usuario, 'Producto creado: ' || :NEW.codigo_interno
        );
    END IF;
    
    -- Auditoría para UPDATE (campos críticos)
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
                :NEW.id_producto, 1, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de precio: ' || :NEW.nombre
            );
        END IF;
        
        -- Cambio en stock_actual
        IF NVL(:OLD.stock_actual, 0) != NVL(:NEW.stock_actual, 0) THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'PRODUCTOS', v_operacion, 'stock_actual',
                TO_CHAR(:OLD.stock_actual), TO_CHAR(:NEW.stock_actual),
                :NEW.id_producto, 1, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de stock: ' || :NEW.nombre
            );
        END IF;
        
        -- Cambio en activo (activar/desactivar producto)
        IF NVL(:OLD.activo, 1) != NVL(:NEW.activo, 1) THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'PRODUCTOS', v_operacion, 'activo',
                CASE :OLD.activo WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END,
                CASE :NEW.activo WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END,
                :NEW.id_producto, 1, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de estado: ' || :NEW.nombre
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
            :OLD.id_producto, 1, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            v_ip_usuario, 'Producto eliminado: ' || :OLD.codigo_interno
        );
    END IF;
END;
/

PROMPT '✅ 5/18 - Trigger de auditoría PRODUCTOS creado!'

-- TRIGGER 6: Auditoría de VENTAS
PROMPT '🔥 6/18 - Creando trigger de auditoría para VENTAS...'

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_VENTAS
    AFTER INSERT OR UPDATE OR DELETE ON VENTAS
    FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_usuario_actual VARCHAR2(100);
    v_ip_usuario VARCHAR2(50);
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
    
    -- Auditoría para INSERT (nueva venta)
    IF INSERTING THEN
        INSERT INTO auditoria (
            id_auditoria, tabla_afectada, operacion, campo_modificado,
            valor_anterior, valor_nuevo, id_registro_afectado,
            id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
        ) VALUES (
            seq_auditoria.NEXTVAL, 'VENTAS', v_operacion, 'REGISTRO_COMPLETO',
            NULL, 'Nueva venta: $' || TO_CHAR(:NEW.total, '999,999.99'),
            :NEW.id_venta, NVL(:NEW.id_usuario, 1), SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            v_ip_usuario, 'Venta creada: ' || :NEW.folio || ' - ' || :NEW.metodo_pago
        );
    END IF;
    
    -- Auditoría para UPDATE (cambios críticos)
    IF UPDATING THEN
        -- Cambio en estado de venta
        IF NVL(:OLD.estado, 'PENDIENTE') != NVL(:NEW.estado, 'PENDIENTE') THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'VENTAS', v_operacion, 'estado',
                :OLD.estado, :NEW.estado,
                :NEW.id_venta, NVL(:NEW.id_usuario, 1), SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de estado venta: ' || :NEW.folio
            );
        END IF;
        
        -- Cambio en total (muy crítico)
        IF NVL(:OLD.total, 0) != NVL(:NEW.total, 0) THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'VENTAS', v_operacion, 'total',
                TO_CHAR(:OLD.total, '999,999.99'), TO_CHAR(:NEW.total, '999,999.99'),
                :NEW.id_venta, NVL(:NEW.id_usuario, 1), SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, '⚠️ CAMBIO CRÍTICO - Total venta: ' || :NEW.folio
            );
        END IF;
        
        -- Cambio en descuento
        IF NVL(:OLD.descuento, 0) != NVL(:NEW.descuento, 0) THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'VENTAS', v_operacion, 'descuento',
                TO_CHAR(:OLD.descuento, '999,999.99'), TO_CHAR(:NEW.descuento, '999,999.99'),
                :NEW.id_venta, NVL(:NEW.id_usuario, 1), SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de descuento: ' || :NEW.folio
            );
        END IF;
    END IF;
    
    -- Auditoría para DELETE (cancelación/eliminación)
    IF DELETING THEN
        INSERT INTO auditoria (
            id_auditoria, tabla_afectada, operacion, campo_modificado,
            valor_anterior, valor_nuevo, id_registro_afectado,
            id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
        ) VALUES (
            seq_auditoria.NEXTVAL, 'VENTAS', v_operacion, 'REGISTRO_COMPLETO',
            'Venta eliminada: $' || TO_CHAR(:OLD.total, '999,999.99'), NULL,
            :OLD.id_venta, NVL(:OLD.id_usuario, 1), SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            v_ip_usuario, '🚨 VENTA ELIMINADA: ' || :OLD.folio
        );
    END IF;
END;
/

PROMPT '✅ 6/18 - Trigger de auditoría VENTAS creado!'

-- TRIGGER 7: Auditoría de USUARIOS
PROMPT '🔥 7/18 - Creando trigger de auditoría para USUARIOS...'

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_USUARIOS
    AFTER INSERT OR UPDATE OR DELETE ON USUARIOS
    FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_usuario_actual VARCHAR2(100);
    v_ip_usuario VARCHAR2(50);
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
    
    -- Auditoría para INSERT (nuevo usuario)
    IF INSERTING THEN
        INSERT INTO auditoria (
            id_auditoria, tabla_afectada, operacion, campo_modificado,
            valor_anterior, valor_nuevo, id_registro_afectado,
            id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
        ) VALUES (
            seq_auditoria.NEXTVAL, 'USUARIOS', v_operacion, 'REGISTRO_COMPLETO',
            NULL, 'Nuevo usuario: ' || :NEW.usuario || ' (' || :NEW.rol || ')',
            :NEW.id_usuario, :NEW.id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            v_ip_usuario, 'Usuario creado: ' || :NEW.nombre || ' ' || :NEW.apellidos
        );
    END IF;
    
    -- Auditoría para UPDATE (cambios críticos)
    IF UPDATING THEN
        -- Cambio en rol (muy crítico)
        IF NVL(:OLD.rol, 'EMPLEADO') != NVL(:NEW.rol, 'EMPLEADO') THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'USUARIOS', v_operacion, 'rol',
                :OLD.rol, :NEW.rol,
                :NEW.id_usuario, :NEW.id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, '🚨 CAMBIO CRÍTICO - Rol usuario: ' || :NEW.usuario
            );
        END IF;
        
        -- Cambio en permisos
        IF NVL(:OLD.permisos, 'N/A') != NVL(:NEW.permisos, 'N/A') THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'USUARIOS', v_operacion, 'permisos',
                'Permisos modificados', 'Nuevos permisos asignados',
                :NEW.id_usuario, :NEW.id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de permisos: ' || :NEW.usuario
            );
        END IF;
        
        -- Cambio en estado activo
        IF NVL(:OLD.activo, 1) != NVL(:NEW.activo, 1) THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'USUARIOS', v_operacion, 'activo',
                CASE :OLD.activo WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END,
                CASE :NEW.activo WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END,
                :NEW.id_usuario, :NEW.id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio de estado: ' || :NEW.usuario
            );
        END IF;
        
        -- Cambio en límite de descuento
        IF NVL(:OLD.limite_descuento, 0) != NVL(:NEW.limite_descuento, 0) THEN
            INSERT INTO auditoria (
                id_auditoria, tabla_afectada, operacion, campo_modificado,
                valor_anterior, valor_nuevo, id_registro_afectado,
                id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
            ) VALUES (
                seq_auditoria.NEXTVAL, 'USUARIOS', v_operacion, 'limite_descuento',
                TO_CHAR(:OLD.limite_descuento), TO_CHAR(:NEW.limite_descuento),
                :NEW.id_usuario, :NEW.id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                v_ip_usuario, 'Cambio límite descuento: ' || :NEW.usuario
            );
        END IF;
    END IF;
    
    -- Auditoría para DELETE (eliminación de usuario)
    IF DELETING THEN
        INSERT INTO auditoria (
            id_auditoria, tabla_afectada, operacion, campo_modificado,
            valor_anterior, valor_nuevo, id_registro_afectado,
            id_usuario, fecha_operacion, hora_operacion, ip_usuario, observaciones
        ) VALUES (
            seq_auditoria.NEXTVAL, 'USUARIOS', v_operacion, 'REGISTRO_COMPLETO',
            'Usuario eliminado: ' || :OLD.usuario || ' (' || :OLD.rol || ')', NULL,
            :OLD.id_usuario, :OLD.id_usuario, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            v_ip_usuario, '🚨 USUARIO ELIMINADO: ' || :OLD.nombre || ' ' || :OLD.apellidos
        );
    END IF;
END;
/

PROMPT '✅ 7/18 - Trigger de auditoría USUARIOS creado!'

PROMPT ''
PROMPT '🎉 === GRUPO 2 COMPLETADO: 3 TRIGGERS DE AUDITORÍA ==='
PROMPT '✅ TRG_AUDITORIA_PRODUCTOS - Audita cambios en productos'
PROMPT '✅ TRG_AUDITORIA_VENTAS - Audita operaciones de venta'  
PROMPT '✅ TRG_AUDITORIA_USUARIOS - Audita gestión de usuarios'
PROMPT ''
