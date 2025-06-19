-- =====================================================
-- GRUPO 4: TRIGGERS DE VENTAS (3)
-- Cálculos automáticos y control de ventas
-- =====================================================

PROMPT '🚀 === EJECUTANDO GRUPO 4: TRIGGERS DE VENTAS ==='
PROMPT ''

-- =====================================================
-- TRIGGER 12: Cálculos automáticos de VENTAS
-- =====================================================
PROMPT '🔥 12/18 - Creando trigger de cálculos automáticos de VENTAS...'

CREATE OR REPLACE TRIGGER TRG_CALCULOS_VENTAS
    BEFORE INSERT OR UPDATE ON VENTAS
    FOR EACH ROW
BEGIN
    -- Generar folio automático si no existe
    IF :NEW.folio IS NULL THEN
        :NEW.folio := 'V' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(seq_ventas.NEXTVAL, 6, '0');
    END IF;
    
    -- Calcular impuestos (16% IVA)
    IF :NEW.impuestos IS NULL OR :NEW.impuestos = 0 THEN
        :NEW.impuestos := :NEW.subtotal * 0.16;
    END IF;
    
    -- Calcular total
    :NEW.total := :NEW.subtotal - NVL(:NEW.descuento, 0) + NVL(:NEW.impuestos, 0);
    
    -- Calcular ganancia de la venta
    IF :NEW.costo_total_venta > 0 THEN
        :NEW.ganancia_venta := :NEW.total - :NEW.costo_total_venta;
    END IF;
    
    -- Actualizar fecha de última venta en productos (se hará en trigger de detalle)
    -- Aquí solo preparamos los cálculos principales
END;
/

PROMPT '✅ 12/18 - Trigger de cálculos automáticos de VENTAS creado!'

-- =====================================================
-- TRIGGER 13: Cálculos de DETALLE_VENTAS
-- =====================================================
PROMPT '🔥 13/18 - Creando trigger de cálculos de DETALLE_VENTAS...'

CREATE OR REPLACE TRIGGER TRG_CALCULOS_DETALLE_VENTAS
    BEFORE INSERT OR UPDATE ON DETALLE_VENTAS
    FOR EACH ROW
DECLARE
    v_costo_producto NUMBER(10,2);
    v_precio_producto NUMBER(10,2);
BEGIN
    -- Obtener costo y precio del producto
    SELECT costo_total, precio_venta 
    INTO v_costo_producto, v_precio_producto
    FROM productos 
    WHERE id_producto = :NEW.id_producto;
    
    -- Si no se especifica costo unitario, usar el del producto
    IF :NEW.costo_unitario IS NULL OR :NEW.costo_unitario = 0 THEN
        :NEW.costo_unitario := v_costo_producto;
    END IF;
    
    -- Si no se especifica precio unitario, usar el del producto
    IF :NEW.precio_unitario IS NULL OR :NEW.precio_unitario = 0 THEN
        :NEW.precio_unitario := v_precio_producto;
    END IF;
    
    -- Calcular subtotal
    :NEW.subtotal := :NEW.cantidad * :NEW.precio_unitario;
    
    -- Aplicar descuento de línea si existe
    IF :NEW.descuento_linea > 0 THEN
        :NEW.subtotal := :NEW.subtotal - :NEW.descuento_linea;
    END IF;
    
    -- Calcular ganancia por línea
    :NEW.ganancia_linea := (:NEW.precio_unitario - :NEW.costo_unitario) * :NEW.cantidad;
    
    -- Si hay descuento, ajustar ganancia
    IF :NEW.descuento_linea > 0 THEN
        :NEW.ganancia_linea := :NEW.ganancia_linea - :NEW.descuento_linea;
    END IF;
END;
/

-- Trigger AFTER para actualizar totales de venta
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_TOTALES_VENTA
    AFTER INSERT OR UPDATE OR DELETE ON DETALLE_VENTAS
    FOR EACH ROW
DECLARE
    v_id_venta NUMBER;
    v_subtotal NUMBER(10,2);
    v_costo_total NUMBER(10,2);
    v_numero_productos NUMBER;
BEGIN
    -- Determinar ID de venta
    v_id_venta := COALESCE(:NEW.id_venta, :OLD.id_venta);
    
    -- Calcular totales de la venta
    SELECT 
        NVL(SUM(subtotal), 0),
        NVL(SUM(costo_unitario * cantidad), 0),
        COUNT(*)
    INTO v_subtotal, v_costo_total, v_numero_productos
    FROM detalle_ventas
    WHERE id_venta = v_id_venta;
    
    -- Actualizar venta
    UPDATE ventas 
    SET subtotal = v_subtotal,
        costo_total_venta = v_costo_total,
        numero_productos = v_numero_productos
    WHERE id_venta = v_id_venta;
END;
/

PROMPT '✅ 13/18 - Trigger de cálculos de DETALLE_VENTAS creado!'

-- =====================================================
-- TRIGGER 14: Control de DEVOLUCIONES
-- =====================================================
PROMPT '🔥 14/18 - Creando trigger de control de DEVOLUCIONES...'

CREATE OR REPLACE TRIGGER TRG_CONTROL_DEVOLUCIONES
    AFTER INSERT OR UPDATE ON DEVOLUCIONES
    FOR EACH ROW
DECLARE
    v_precio_unitario NUMBER(10,2);
    v_stock_actual NUMBER(10);
BEGIN
    -- Solo procesar devoluciones aprobadas
    IF :NEW.estado = 'APROBADA' THEN
        
        -- Obtener precio unitario del producto en la venta original
        SELECT precio_unitario INTO v_precio_unitario
        FROM detalle_ventas dv
        JOIN ventas v ON dv.id_venta = v.id_venta
        WHERE v.id_venta = :NEW.id_venta_original
        AND dv.id_producto = :NEW.id_producto
        AND ROWNUM = 1;
        
        -- Calcular monto a devolver si no está especificado
        IF :NEW.monto_devuelto IS NULL OR :NEW.monto_devuelto = 0 THEN
            UPDATE devoluciones 
            SET monto_devuelto = :NEW.cantidad_devuelta * v_precio_unitario
            WHERE id_devolucion = :NEW.id_devolucion;
        END IF;
        
        -- Devolver stock al inventario
        UPDATE productos 
        SET stock_actual = stock_actual + :NEW.cantidad_devuelta,
            fecha_ultima_venta = SYSDATE
        WHERE id_producto = :NEW.id_producto;
        
        -- Registrar movimiento de inventario
        INSERT INTO movimientos_inventario (
            id_movimiento, id_producto, tipo_movimiento, cantidad,
            costo_unitario, motivo, referencia, id_usuario, fecha_movimiento,
            observaciones
        ) VALUES (
            seq_movimientos_inventario.NEXTVAL,
            :NEW.id_producto,
            'ENTRADA',
            :NEW.cantidad_devuelta,
            v_precio_unitario,
            'DEVOLUCION',
            'DEV-' || :NEW.id_devolucion,
            :NEW.id_usuario_autoriza,
            SYSDATE,
            'Devolución: ' || :NEW.motivo
        );
        
        -- Crear notificación de devolución
        INSERT INTO notificaciones (
            id_notificacion, tipo_notificacion, titulo, mensaje,
            prioridad, id_producto, id_usuario_destinatario,
            fecha_notificacion, requiere_accion
        ) VALUES (
            seq_notificaciones.NEXTVAL,
            'DEVOLUCION',
            'Devolución Procesada',
            'Se procesó devolución de ' || :NEW.cantidad_devuelta || ' unidades del producto ID: ' || :NEW.id_producto,
            'MEDIA',
            :NEW.id_producto,
            :NEW.id_usuario_autoriza,
            SYSDATE,
            0
        );
    END IF;
END;
/

PROMPT '✅ 14/18 - Trigger de control de DEVOLUCIONES creado!'

PROMPT ''
PROMPT '🎉 === GRUPO 4 COMPLETADO: 3 TRIGGERS DE VENTAS ==='
PROMPT '✅ TRG_CALCULOS_VENTAS - Cálculos automáticos de ventas'
PROMPT '✅ TRG_CALCULOS_DETALLE_VENTAS - Cálculos de detalle y totales'
PROMPT '✅ TRG_CONTROL_DEVOLUCIONES - Control automático de devoluciones'
PROMPT ''
