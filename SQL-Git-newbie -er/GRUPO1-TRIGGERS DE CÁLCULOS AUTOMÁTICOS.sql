-- =====================================================
-- GRUPO 1: TRIGGERS DE CÁLCULOS AUTOMÁTICOS
-- Ejecutar estos 4 triggers primero
-- =====================================================

PROMPT '🚀 === EJECUTANDO GRUPO 1: TRIGGERS DE CÁLCULOS ==='
PROMPT ''

-- TRIGGER 1: Cálculos automáticos en PRODUCTOS
PROMPT '🔥 1/4 - Creando trigger para cálculos automáticos en PRODUCTOS...'

CREATE OR REPLACE TRIGGER TRG_PRODUCTOS_CALCULOS
    BEFORE INSERT OR UPDATE ON PRODUCTOS
    FOR EACH ROW
BEGIN
    -- Calcular costo total
    :NEW.costo_total := :NEW.costo_base + NVL(:NEW.gastos_adicionales, 0);
    
    -- Calcular precio sugerido basado en margen
    IF :NEW.margen_ganancia IS NOT NULL THEN
        :NEW.precio_sugerido := :NEW.costo_total * (1 + :NEW.margen_ganancia/100);
    END IF;
    
    -- Si no hay precio_venta, usar el sugerido
    IF :NEW.precio_venta IS NULL OR :NEW.precio_venta <= 0 THEN
        :NEW.precio_venta := :NEW.precio_sugerido;
    END IF;
    
    -- Calcular ganancia unitaria
    :NEW.ganancia_unitaria := :NEW.precio_venta - :NEW.costo_total;
    
    -- Calcular margen real
    IF :NEW.precio_venta > 0 THEN
        :NEW.margen_real := ((:NEW.precio_venta - :NEW.costo_total) / :NEW.precio_venta) * 100;
    ELSE
        :NEW.margen_real := 0;
    END IF;
    
    -- Asignar ID si no existe
    IF :NEW.id_producto IS NULL THEN
        :NEW.id_producto := seq_productos.NEXTVAL;
    END IF;
    
    -- Generar código interno si no existe
    IF :NEW.codigo_interno IS NULL THEN
        :NEW.codigo_interno := 'PROD-' || LPAD(:NEW.id_producto, 6, '0');
    END IF;
END;
/

PROMPT '✅ 1/4 - Trigger de cálculos automáticos creado!'

-- TRIGGER 2: Control de stock automático
PROMPT '🔥 2/4 - Creando trigger para control de stock...'

CREATE OR REPLACE TRIGGER TRG_STOCK_CONTROL
    AFTER INSERT OR UPDATE ON DETALLE_VENTAS
    FOR EACH ROW
DECLARE
    v_stock_actual NUMBER;
    v_stock_minimo NUMBER;
    v_nombre_producto VARCHAR2(200);
BEGIN
    -- Solo procesar ventas completadas
    IF INSERTING OR (:OLD.cantidad != :NEW.cantidad) THEN
        
        -- Actualizar stock del producto
        UPDATE productos 
        SET stock_actual = stock_actual - :NEW.cantidad,
            fecha_ultima_venta = SYSDATE
        WHERE id_producto = :NEW.id_producto;
        
        -- Registrar movimiento de inventario
        INSERT INTO movimientos_inventario (
            id_movimiento, id_producto, tipo_movimiento, cantidad,
            costo_unitario, motivo, referencia, id_usuario, fecha_movimiento
        ) VALUES (
            seq_movimientos_inventario.NEXTVAL,
            :NEW.id_producto,
            'SALIDA',
            :NEW.cantidad,
            :NEW.costo_unitario,
            'VENTA',
            'VENTA-' || :NEW.id_venta,
            1, -- Se asignará el usuario correcto después
            SYSDATE
        );
        
        -- Verificar stock mínimo y generar alerta
        SELECT stock_actual, stock_minimo, nombre
        INTO v_stock_actual, v_stock_minimo, v_nombre_producto
        FROM productos
        WHERE id_producto = :NEW.id_producto;
        
        IF v_stock_actual <= v_stock_minimo THEN
            INSERT INTO alertas_sistema (
                id_alerta, tipo_alerta, nivel_prioridad, id_producto,
                mensaje, accion_sugerida, procesada, fecha_generacion
            ) VALUES (
                seq_alertas_sistema.NEXTVAL,
                'STOCK_BAJO',
                CASE WHEN v_stock_actual = 0 THEN 'CRITICA' ELSE 'ALTA' END,
                :NEW.id_producto,
                'Stock bajo para ' || v_nombre_producto || '. Stock actual: ' || v_stock_actual,
                'Reabastecer inventario inmediatamente',
                0,
                SYSDATE
            );
        END IF;
    END IF;
END;
/

PROMPT '✅ 2/4 - Trigger de control de stock creado!'

-- TRIGGER 3: Alertas de caducidad
PROMPT '🔥 3/4 - Creando trigger para alertas de caducidad...'

CREATE OR REPLACE TRIGGER TRG_ALERTAS_CADUCIDAD
    BEFORE INSERT OR UPDATE OF fecha_caducidad ON PRODUCTOS
    FOR EACH ROW
DECLARE
    v_dias_restantes NUMBER;
BEGIN
    IF :NEW.fecha_caducidad IS NOT NULL THEN
        v_dias_restantes := :NEW.fecha_caducidad - SYSDATE;
        
        -- Alerta crítica si caduca en menos de 7 días
        IF v_dias_restantes <= 7 AND v_dias_restantes > 0 THEN
            INSERT INTO alertas_sistema (
                id_alerta, tipo_alerta, nivel_prioridad, id_producto,
                mensaje, accion_sugerida, procesada, fecha_generacion
            ) VALUES (
                seq_alertas_sistema.NEXTVAL,
                'CADUCIDAD',
                'CRITICA',
                :NEW.id_producto,
                'Producto ' || :NEW.nombre || ' caduca en ' || v_dias_restantes || ' días',
                'Crear promoción urgente o retirar del inventario',
                0,
                SYSDATE
            );
        -- Alerta alta si caduca en menos de 15 días
        ELSIF v_dias_restantes <= 15 AND v_dias_restantes > 7 THEN
            INSERT INTO alertas_sistema (
                id_alerta, tipo_alerta, nivel_prioridad, id_producto,
                mensaje, accion_sugerida, procesada, fecha_generacion
            ) VALUES (
                seq_alertas_sistema.NEXTVAL,
                'CADUCIDAD',
                'ALTA',
                :NEW.id_producto,
                'Producto ' || :NEW.nombre || ' caduca en ' || v_dias_restantes || ' días',
                'Considerar promoción para acelerar venta',
                0,
                SYSDATE
            );
        -- Producto ya caducado
        ELSIF v_dias_restantes <= 0 THEN
            INSERT INTO alertas_sistema (
                id_alerta, tipo_alerta, nivel_prioridad, id_producto,
                mensaje, accion_sugerida, procesada, fecha_generacion
            ) VALUES (
                seq_alertas_sistema.NEXTVAL,
                'CADUCIDAD',
                'CRITICA',
                :NEW.id_producto,
                'Producto ' || :NEW.nombre || ' YA CADUCÓ',
                'RETIRAR INMEDIATAMENTE del inventario',
                0,
                SYSDATE
            );
        END IF;
    END IF;
END;
/

PROMPT '✅ 3/4 - Trigger de alertas de caducidad creado!'

-- TRIGGER 4: Control de caja automático
PROMPT '🔥 4/4 - Creando trigger para control de caja...'

CREATE OR REPLACE TRIGGER TRG_CONTROL_CAJA
    AFTER INSERT OR UPDATE ON VENTAS
    FOR EACH ROW
DECLARE
    v_caja_abierta NUMBER;
    v_id_caja NUMBER;
BEGIN
    -- Solo procesar ventas completadas
    IF :NEW.estado = 'COMPLETADA' THEN
        
        -- Buscar caja abierta del día
        BEGIN
            SELECT id_caja INTO v_id_caja
            FROM caja
            WHERE TRUNC(fecha) = TRUNC(SYSDATE)
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
                id_usuario_apertura, estado, fecha_creacion, numero_ventas, ganancia_dia
            ) VALUES (
                seq_caja.NEXTVAL,
                SYSDATE,
                TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                0, 0, 0, 0, 0, 0, 0, 0,
                :NEW.id_usuario,
                'ABIERTA',
                SYSDATE,
                0, 0
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

PROMPT '✅ 4/4 - Trigger de control de caja creado!'

PROMPT ''
PROMPT '🎉 === GRUPO 1 COMPLETADO: 4 TRIGGERS DE CÁLCULOS ==='
PROMPT '✅ TRG_PRODUCTOS_CALCULOS - Cálculos automáticos'
PROMPT '✅ TRG_STOCK_CONTROL - Control de inventario'  
PROMPT '✅ TRG_ALERTAS_CADUCIDAD - Alertas de vencimiento'
PROMPT '✅ TRG_CONTROL_CAJA - Control de caja automático'
PROMPT ''
