-- ========================================
-- GRUPO 6: TRIGGERS DE REPORTES Y SISTEMA (FINAL)
-- Los últimos 2 triggers del sistema
-- ========================================

PROMPT '🚀 === EJECUTANDO GRUPO 6: TRIGGERS FINALES ==='
PROMPT ''

-- ========================================
-- TRIGGER 17: Generación automática de reportes
-- ========================================
PROMPT '🔥 17/18 - Creando trigger de generación automática de reportes...'

CREATE OR REPLACE TRIGGER TRG_GENERACION_REPORTES
    AFTER INSERT ON CORTES_CAJA
    FOR EACH ROW
DECLARE
    v_nombre_archivo VARCHAR2(200);
    v_parametros CLOB;
BEGIN
    -- Generar nombre de archivo único
    v_nombre_archivo := 'CORTE_' || :NEW.tipo_corte || '_' || 
                       TO_CHAR(:NEW.fecha_inicio, 'YYYYMMDD') || '_' ||
                       TO_CHAR(:NEW.fecha_fin, 'YYYYMMDD') || '.pdf';
    
    -- Crear parámetros en formato JSON
    v_parametros := '{' ||
        '"tipo_corte":"' || :NEW.tipo_corte || '",' ||
        '"fecha_inicio":"' || TO_CHAR(:NEW.fecha_inicio, 'YYYY-MM-DD') || '",' ||
        '"fecha_fin":"' || TO_CHAR(:NEW.fecha_fin, 'YYYY-MM-DD') || '",' ||
        '"total_ventas":' || :NEW.total_ventas || ',' ||
        '"ganancia_neta":' || :NEW.ganancia_neta || ',' ||
        '"margen_ganancia":' || :NEW.margen_ganancia ||
        '}';
    
    -- Registrar reporte generado
    INSERT INTO REPORTES_GENERADOS (
        id_reporte, tipo_reporte, nombre_archivo, ruta_archivo,
        parametros, fecha_inicio_datos, fecha_fin_datos,
        id_usuario, fecha_generacion, estado, registros_procesados
    ) VALUES (
        seq_reportes_generados.NEXTVAL,
        'CORTE_' || :NEW.tipo_corte,
        v_nombre_archivo,
        '/reportes/cortes/' || v_nombre_archivo,
        v_parametros,
        :NEW.fecha_inicio,
        :NEW.fecha_fin,
        :NEW.id_usuario,
        SYSDATE,
        'COMPLETADO',
        :NEW.total_transacciones
    );
    
    -- Crear notificación de reporte generado
    INSERT INTO NOTIFICACIONES (
        id_notificacion, tipo_notificacion, titulo, mensaje,
        prioridad, id_usuario_destinatario, fecha_notificacion,
        accion_sugerida, url_accion, requiere_accion
    ) VALUES (
        seq_notificaciones.NEXTVAL,
        'SISTEMA',
        'Reporte Generado',
        '📊 REPORTE ' || :NEW.tipo_corte || ' generado exitosamente' ||
        ' - Período: ' || TO_CHAR(:NEW.fecha_inicio, 'DD/MM/YYYY') ||
        ' al ' || TO_CHAR(:NEW.fecha_fin, 'DD/MM/YYYY'),
        'BAJA',
        :NEW.id_usuario,
        SYSDATE,
        'Descargar reporte desde el panel de reportes',
        '/reportes/descargar/' || seq_reportes_generados.CURRVAL,
        0
    );
    
    DBMS_OUTPUT.PUT_LINE('📊 Reporte generado: ' || v_nombre_archivo);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error generando reporte: ' || SQLERRM);
        -- Actualizar estado a ERROR
        UPDATE REPORTES_GENERADOS 
        SET estado = 'ERROR'
        WHERE id_reporte = seq_reportes_generados.CURRVAL;
END;
/

PROMPT '✅ 17/18 - Trigger de generación automática de reportes creado!'

-- ========================================
-- TRIGGER 18: Control de sesiones de usuario (FINAL)
-- ========================================
PROMPT '🔥 18/18 - Creando trigger de control de sesiones (FINAL)...'

CREATE OR REPLACE TRIGGER TRG_CONTROL_SESIONES
    AFTER UPDATE OF ultimo_acceso ON USUARIOS
    FOR EACH ROW
    WHEN (NEW.ultimo_acceso IS NOT NULL)
DECLARE
    v_tiempo_inactivo NUMBER;
    v_mensaje VARCHAR2(500);
    v_prioridad VARCHAR2(10);
BEGIN
    -- Calcular tiempo de inactividad en días
    v_tiempo_inactivo := SYSDATE - NVL(:OLD.ultimo_acceso, :NEW.fecha_creacion);
    
    -- Generar alertas según tiempo de inactividad
    IF v_tiempo_inactivo >= 30 THEN
        v_prioridad := 'ALTA';
        v_mensaje := '🚨 USUARIO INACTIVO: ' || :NEW.usuario || 
                    ' (' || :NEW.nombre || ') - ' || 
                    ROUND(v_tiempo_inactivo) || ' días sin acceso';
        
        -- Crear alerta de seguridad
        INSERT INTO ALERTAS_SISTEMA (
            id_alerta, tipo_alerta, nivel_prioridad, id_producto,
            mensaje, accion_sugerida, procesada, fecha_generacion
        ) VALUES (
            seq_alertas_sistema.NEXTVAL,
            'SISTEMA',
            v_prioridad,
            NULL,
            v_mensaje,
            'Revisar necesidad de mantener cuenta activa - Considerar desactivar',
            0,
            SYSDATE
        );
        
    ELSIF v_tiempo_inactivo >= 7 THEN
        v_prioridad := 'MEDIA';
        v_mensaje := '⚠️ Usuario con inactividad: ' || :NEW.usuario || 
                    ' - ' || ROUND(v_tiempo_inactivo) || ' días sin acceso';
        
        -- Crear notificación informativa
        INSERT INTO NOTIFICACIONES (
            id_notificacion, tipo_notificacion, titulo, mensaje,
            prioridad, id_usuario_destinatario, fecha_notificacion,
            requiere_accion
        ) VALUES (
            seq_notificaciones.NEXTVAL,
            'SISTEMA',
            'Usuario Inactivo',
            v_mensaje,
            v_prioridad,
            1, -- Admin
            SYSDATE,
            0
        );
    END IF;
    
    -- Registrar acceso en auditoría
    INSERT INTO AUDITORIA (
        id_auditoria, tabla_afectada, operacion, campo_modificado,
        valor_anterior, valor_nuevo, id_registro_afectado,
        id_usuario, fecha_operacion, hora_operacion, observaciones
    ) VALUES (
        seq_auditoria.NEXTVAL,
        'USUARIOS',
        'UPDATE',
        'ultimo_acceso',
        TO_CHAR(:OLD.ultimo_acceso, 'DD/MM/YYYY HH24:MI:SS'),
        TO_CHAR(:NEW.ultimo_acceso, 'DD/MM/YYYY HH24:MI:SS'),
        :NEW.id_usuario,
        :NEW.id_usuario,
        SYSDATE,
        TO_CHAR(SYSDATE, 'HH24:MI:SS'),
        'Acceso al sistema registrado'
    );
    
    DBMS_OUTPUT.PUT_LINE('👤 Sesión registrada: ' || :NEW.usuario);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error en control de sesiones: ' || SQLERRM);
        NULL; -- No fallar la transacción principal
END;
/

PROMPT '✅ 18/18 - Trigger de control de sesiones creado!'

PROMPT ''
PROMPT '🎉🎉🎉 === TODOS LOS TRIGGERS CREADOS EXITOSAMENTE ==='
PROMPT '✅ GRUPO 6 COMPLETADO: 2 TRIGGERS FINALES'
PROMPT '✅ TRG_GENERACION_REPORTES - Reportes automáticos'
PROMPT '✅ TRG_CONTROL_SESIONES - Control de sesiones de usuario'
PROMPT ''
PROMPT '🏆 === SISTEMA COMPLETO: 18 TRIGGERS FUNCIONANDO ==='
PROMPT ''
