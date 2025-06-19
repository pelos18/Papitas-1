-- =====================================================
-- GRUPO 3: TRIGGERS DE NOTIFICACIONES AUTOMÁTICAS
-- Generan alertas inteligentes del sistema
-- =====================================================

PROMPT '🚀 === EJECUTANDO GRUPO 3: TRIGGERS DE NOTIFICACIONES ==='
PROMPT ''

-- TRIGGER 8: Notificaciones de stock bajo
PROMPT '🔥 8/18 - Creando trigger de notificaciones de stock bajo...'

CREATE OR REPLACE TRIGGER TRG_NOTIFICACIONES_STOCK
    AFTER UPDATE OF stock_actual ON PRODUCTOS
    FOR EACH ROW
    WHEN (NEW.stock_actual <= NEW.stock_minimo AND OLD.stock_actual > OLD.stock_minimo)
DECLARE
    v_mensaje VARCHAR2(500);
    v_accion_sugerida VARCHAR2(300);
    v_prioridad VARCHAR2(10);
BEGIN
    -- Determinar prioridad según el nivel de stock
    IF :NEW.stock_actual = 0 THEN
        v_prioridad := 'CRITICA';
        v_mensaje := '🚨 PRODUCTO AGOTADO: ' || :NEW.nombre || ' (Stock: 0)';
        v_accion_sugerida := 'REABASTECER INMEDIATAMENTE - Contactar proveedor urgente';
    ELSIF :NEW.stock_actual <= (:NEW.stock_minimo * 0.5) THEN
        v_prioridad := 'ALTA';
        v_mensaje := '⚠️ STOCK CRÍTICO: ' || :NEW.nombre || ' (Stock: ' || :NEW.stock_actual || ')';
        v_accion_sugerida := 'Realizar pedido urgente al proveedor';
    ELSE
        v_prioridad := 'MEDIA';
        v_mensaje := '📦 STOCK BAJO: ' || :NEW.nombre || ' (Stock: ' || :NEW.stock_actual || ')';
        v_accion_sugerida := 'Programar reabastecimiento próximo';
    END IF;
    
    -- Crear notificación en NOTIFICACIONES
    INSERT INTO notificaciones (
        id_notificacion, tipo_notificacion, titulo, mensaje, prioridad,
        leida, id_producto, id_usuario_destinatario, id_usuario_origen,
        fecha_notificacion, accion_sugerida, url_accion, requiere_accion
    ) VALUES (
        seq_notificaciones.NEXTVAL, 'STOCK_BAJO', 'Stock Bajo Detectado',
        v_mensaje, v_prioridad, 0, :NEW.id_producto, 1, 1,
        SYSDATE, v_accion_sugerida, '/inventario/productos/reabastecer/' || :NEW.id_producto, 1
    );
    
    -- Crear alerta en ALERTAS_SISTEMA
    INSERT INTO alertas_sistema (
        id_alerta, tipo_alerta, nivel_prioridad, id_producto,
        mensaje, accion_sugerida, procesada, fecha_generacion
    ) VALUES (
        seq_alertas_sistema.NEXTVAL, 'STOCK_BAJO', v_prioridad, :NEW.id_producto,
        v_mensaje, v_accion_sugerida, 0, SYSDATE
    );
    
    -- Log para debugging
    DBMS_OUTPUT.PUT_LINE('🔔 Notificación stock bajo creada para: ' || :NEW.nombre);
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log del error pero no fallar la transacción principal
        DBMS_OUTPUT.PUT_LINE('❌ Error en notificación stock: ' || SQLERRM);
END;
/

PROMPT '✅ 8/18 - Trigger de notificaciones de stock bajo creado!'

-- TRIGGER 9: Notificaciones de caducidad
PROMPT '🔥 9/18 - Creando trigger de notificaciones de caducidad...'

CREATE OR REPLACE TRIGGER TRG_NOTIFICACIONES_CADUCIDAD
    AFTER INSERT OR UPDATE OF fecha_caducidad ON PRODUCTOS
    FOR EACH ROW
    WHEN (NEW.fecha_caducidad IS NOT NULL AND NEW.es_perecedero = 1)
DECLARE
    v_dias_restantes NUMBER;
    v_mensaje VARCHAR2(500);
    v_accion_sugerida VARCHAR2(300);
    v_prioridad VARCHAR2(10);
    v_titulo VARCHAR2(100);
BEGIN
    -- Calcular días restantes hasta caducidad
    v_dias_restantes := :NEW.fecha_caducidad - SYSDATE;
    
    -- Solo procesar si está próximo a caducar o ya caducó
    IF v_dias_restantes <= 30 THEN
        
        -- Determinar prioridad y mensaje según días restantes
        IF v_dias_restantes < 0 THEN
            v_prioridad := 'CRITICA';
            v_titulo := 'Producto Caducado';
            v_mensaje := '🚨 PRODUCTO CADUCADO: ' || :NEW.nombre || 
                        ' (Caducó hace ' || ABS(v_dias_restantes) || ' días)';
            v_accion_sugerida := 'RETIRAR INMEDIATAMENTE del inventario y registrar merma';
            
        ELSIF v_dias_restantes = 0 THEN
            v_prioridad := 'CRITICA';
            v_titulo := 'Producto Caduca Hoy';
            v_mensaje := '🚨 CADUCA HOY: ' || :NEW.nombre || ' - Revisar inmediatamente';
            v_accion_sugerida := 'Verificar estado y decidir: vender con descuento o retirar';
            
        ELSIF v_dias_restantes <= 3 THEN
            v_prioridad := 'ALTA';
            v_titulo := 'Caducidad Inminente';
            v_mensaje := '⚠️ CADUCA EN ' || v_dias_restantes || ' DÍAS: ' || :NEW.nombre;
            v_accion_sugerida := 'Aplicar descuento del 30-50% para liquidar rápidamente';
            
        ELSIF v_dias_restantes <= 7 THEN
            v_prioridad := 'ALTA';
            v_titulo := 'Próximo a Caducar';
            v_mensaje := '📅 CADUCA EN ' || v_dias_restantes || ' DÍAS: ' || :NEW.nombre;
            v_accion_sugerida := 'Aplicar descuento del 20% y promocionar';
            
        ELSIF v_dias_restantes <= 15 THEN
            v_prioridad := 'MEDIA';
            v_titulo := 'Caducidad Próxima';
            v_mensaje := '📆 CADUCA EN ' || v_dias_restantes || ' DÍAS: ' || :NEW.nombre;
            v_accion_sugerida := 'Considerar promoción especial del 10-15%';
            
        ELSE -- 16-30 días
            v_prioridad := 'BAJA';
            v_titulo := 'Monitorear Caducidad';
            v_mensaje := '📋 CADUCA EN ' || v_dias_restantes || ' DÍAS: ' || :NEW.nombre;
            v_accion_sugerida := 'Monitorear y planificar estrategia de venta';
        END IF;
        
        -- Crear notificación
        INSERT INTO notificaciones (
            id_notificacion, tipo_notificacion, titulo, mensaje, prioridad,
            leida, id_producto, id_usuario_destinatario, id_usuario_origen,
            fecha_notificacion, accion_sugerida, url_accion, requiere_accion
        ) VALUES (
            seq_notificaciones.NEXTVAL, 'CADUCIDAD', v_titulo,
            v_mensaje, v_prioridad, 0, :NEW.id_producto, 1, 1,
            SYSDATE, v_accion_sugerida, '/inventario/productos/caducidad/' || :NEW.id_producto, 1
        );
        
        -- Crear alerta en sistema
        INSERT INTO alertas_sistema (
            id_alerta, tipo_alerta, nivel_prioridad, id_producto,
            mensaje, accion_sugerida, procesada, fecha_generacion
        ) VALUES (
            seq_alertas_sistema.NEXTVAL, 'CADUCIDAD', v_prioridad, :NEW.id_producto,
            v_mensaje, v_accion_sugerida, 0, SYSDATE
        );
        
        -- Si es crítico, crear promoción automática
        IF v_prioridad = 'CRITICA' AND v_dias_restantes >= 0 THEN
            INSERT INTO promociones (
                id_promocion, nombre_promocion, descripcion, id_producto,
                tipo_promocion, porcentaje_descuento, fecha_inicio, fecha_fin,
                motivo, activa, automatica, id_usuario, fecha_creacion
            ) VALUES (
                seq_promociones.NEXTVAL, 
                'LIQUIDACIÓN - Próximo a Caducar',
                'Descuento automático por proximidad de caducidad',
                :NEW.id_producto, 'DESCUENTO', 50,
                SYSDATE, :NEW.fecha_caducidad,
                'CADUCIDAD', 1, 1, 1, SYSDATE
            );
            
            -- Marcar producto en promoción
            UPDATE productos 
            SET en_promocion = 1 
            WHERE id_producto = :NEW.id_producto;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('🔔 Notificación caducidad creada: ' || :NEW.nombre || ' (' || v_dias_restantes || ' días)');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error en notificación caducidad: ' || SQLERRM);
END;
/

PROMPT '✅ 9/18 - Trigger de notificaciones de caducidad creado!'

-- TRIGGER 10: Notificaciones de ventas importantes
PROMPT '🔥 10/18 - Creando trigger de notificaciones de ventas importantes...'

CREATE OR REPLACE TRIGGER TRG_NOTIFICACIONES_VENTAS
    AFTER INSERT ON VENTAS
    FOR EACH ROW
DECLARE
    v_mensaje VARCHAR2(500);
    v_accion_sugerida VARCHAR2(300);
    v_prioridad VARCHAR2(10);
    v_titulo VARCHAR2(100);
    v_es_importante NUMBER := 0;
BEGIN
    -- Determinar si la venta es importante
    
    -- Venta de alto valor (>$1000)
    IF :NEW.total >= 1000 THEN
        v_es_importante := 1;
        v_prioridad := 'ALTA';
        v_titulo := 'Venta de Alto Valor';
        v_mensaje := '💰 VENTA IMPORTANTE: $' || TO_CHAR(:NEW.total, '999,999.99') || 
                    ' - Folio: ' || :NEW.folio;
        v_accion_sugerida := 'Verificar disponibilidad de productos y confirmar pago';
    
    -- Venta con descuento alto (>20%)
    ELSIF :NEW.descuento > 0 AND (:NEW.descuento / :NEW.subtotal) > 0.20 THEN
        v_es_importante := 1;
        v_prioridad := 'MEDIA';
        v_titulo := 'Venta con Descuento Alto';
        v_mensaje := '🎯 DESCUENTO APLICADO: ' || 
                    TO_CHAR((:NEW.descuento / :NEW.subtotal) * 100, '999.9') || 
                    '% - Folio: ' || :NEW.folio;
        v_accion_sugerida := 'Verificar autorización de descuento';
    
    -- Venta a crédito
    ELSIF :NEW.metodo_pago = 'CREDITO' THEN
        v_es_importante := 1;
        v_prioridad := 'MEDIA';
        v_titulo := 'Venta a Crédito';
        v_mensaje := '💳 VENTA A CRÉDITO: $' || TO_CHAR(:NEW.total, '999,999.99') || 
                    ' - Folio: ' || :NEW.folio;
        v_accion_sugerida := 'Verificar límite de crédito del cliente';
    
    -- Primera venta del día (si es muy temprano)
    ELSIF TO_CHAR(SYSDATE, 'HH24') < '08' THEN
        v_es_importante := 1;
        v_prioridad := 'BAJA';
        v_titulo := 'Primera Venta del Día';
        v_mensaje := '🌅 PRIMERA VENTA: $' || TO_CHAR(:NEW.total, '999,999.99') || 
                    ' - Folio: ' || :NEW.folio;
        v_accion_sugerida := 'Registrar apertura de caja si no se ha hecho';
    END IF;
    
    -- Crear notificación solo si es importante
    IF v_es_importante = 1 THEN
        INSERT INTO notificaciones (
            id_notificacion, tipo_notificacion, titulo, mensaje, prioridad,
            leida, id_producto, id_usuario_destinatario, id_usuario_origen,
            fecha_notificacion, accion_sugerida, url_accion, requiere_accion
        ) VALUES (
            seq_notificaciones.NEXTVAL, 'VENTA', v_titulo,
            v_mensaje, v_prioridad, 0, NULL, 1, :NEW.id_usuario,
            SYSDATE, v_accion_sugerida, '/ventas/detalle/' || :NEW.id_venta, 
            CASE WHEN v_prioridad IN ('CRITICA', 'ALTA') THEN 1 ELSE 0 END
        );
        
        DBMS_OUTPUT.PUT_LINE('🔔 Notificación venta importante: ' || :NEW.folio);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error en notificación venta: ' || SQLERRM);
END;
/

PROMPT '✅ 10/18 - Trigger de notificaciones de ventas importantes creado!'

-- TRIGGER 11: Notificaciones de sistema
PROMPT '🔥 11/18 - Creando trigger de notificaciones de sistema...'

CREATE OR REPLACE TRIGGER TRG_NOTIFICACIONES_SISTEMA
    AFTER INSERT ON USUARIOS
    FOR EACH ROW
DECLARE
    v_mensaje VARCHAR2(500);
    v_accion_sugerida VARCHAR2(300);
    v_prioridad VARCHAR2(10);
    v_titulo VARCHAR2(100);
BEGIN
    -- Notificación por nuevo usuario creado
    v_prioridad := 'MEDIA';
    v_titulo := 'Nuevo Usuario Registrado';
    v_mensaje := '👤 NUEVO USUARIO: ' || :NEW.nombre || ' ' || :NEW.apellidos || 
                ' (' || :NEW.usuario || ') - Rol: ' || :NEW.rol;
    v_accion_sugerida := 'Verificar permisos asignados y configurar accesos';
    
    -- Ajustar prioridad según el rol
    IF :NEW.rol IN ('ADMIN', 'GERENTE') THEN
        v_prioridad := 'ALTA';
        v_mensaje := '🚨 ' || v_mensaje;
        v_accion_sugerida := 'REVISAR INMEDIATAMENTE - Usuario con permisos administrativos';
    END IF;
    
    -- Crear notificación para administradores
    INSERT INTO notificaciones (
        id_notificacion, tipo_notificacion, titulo, mensaje, prioridad,
        leida, id_producto, id_usuario_destinatario, id_usuario_origen,
        fecha_notificacion, accion_sugerida, url_accion, requiere_accion
    ) VALUES (
        seq_notificaciones.NEXTVAL, 'SISTEMA', v_titulo,
        v_mensaje, v_prioridad, 0, NULL, 1, :NEW.id_usuario,
        SYSDATE, v_accion_sugerida, '/usuarios/perfil/' || :NEW.id_usuario, 1
    );
    
    -- Crear notificación de bienvenida para el nuevo usuario
    INSERT INTO notificaciones (
        id_notificacion, tipo_notificacion, titulo, mensaje, prioridad,
        leida, id_producto, id_usuario_destinatario, id_usuario_origen,
        fecha_notificacion, accion_sugerida, url_accion, requiere_accion
    ) VALUES (
        seq_notificaciones.NEXTVAL, 'SISTEMA', 'Bienvenido al Sistema',
        '🎉 ¡Bienvenido ' || :NEW.nombre || '! Tu cuenta ha sido creada exitosamente.',
        'BAJA', 0, NULL, :NEW.id_usuario, 1,
        SYSDATE, 'Completar configuración de perfil', '/perfil/configurar', 0
    );
    
    DBMS_OUTPUT.PUT_LINE('🔔 Notificaciones sistema creadas para: ' || :NEW.usuario);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error en notificación sistema: ' || SQLERRM);
END;
/

PROMPT '✅ 11/18 - Trigger de notificaciones de sistema creado!'

PROMPT ''
PROMPT '🎉 === GRUPO 3 COMPLETADO: 4 TRIGGERS DE NOTIFICACIONES ==='
PROMPT '✅ TRG_NOTIFICACIONES_STOCK - Alertas de stock bajo'
PROMPT '✅ TRG_NOTIFICACIONES_CADUCIDAD - Alertas de caducidad'  
PROMPT '✅ TRG_NOTIFICACIONES_VENTAS - Alertas de ventas importantes'
PROMPT '✅ TRG_NOTIFICACIONES_SISTEMA - Alertas del sistema'
PROMPT ''
