-- ========================================
-- SOLUCIÓN PARA TRIGGER MUTANTE
-- ========================================

PROMPT '🔧 === SOLUCIONANDO TRIGGER MUTANTE ==='
PROMPT ''

-- Deshabilitar temporalmente el trigger problemático
ALTER TRIGGER TRG_ACTUALIZAR_TOTALES_VENTA DISABLE;

PROMPT '⚠️ Trigger TRG_ACTUALIZAR_TOTALES_VENTA deshabilitado temporalmente'

-- Limpiar ventas anteriores
DELETE FROM DETALLE_VENTAS;
DELETE FROM VENTAS;

-- Insertar venta de prueba sin trigger
INSERT INTO VENTAS (ID_VENTA, FOLIO, FECHA_VENTA, SUBTOTAL, DESCUENTO, TOTAL, ID_USUARIO, ESTADO, METODO_PAGO) 
VALUES (1, 'V20241218-000001', SYSDATE, 36.00, 0.00, 36.00, 1, 'COMPLETADA', 'EFECTIVO');

-- Insertar detalle de venta
INSERT INTO DETALLE_VENTAS (ID_DETALLE, ID_VENTA, ID_PRODUCTO, CANTIDAD, PRECIO_UNITARIO, COSTO_UNITARIO, SUBTOTAL)
VALUES (1, 1, 1, 2, 18.00, 14.00, 36.00);

COMMIT;

-- Rehabilitar el trigger
ALTER TRIGGER TRG_ACTUALIZAR_TOTALES_VENTA ENABLE;

PROMPT '✅ Trigger rehabilitado'
PROMPT '✅ Venta de prueba insertada exitosamente'
