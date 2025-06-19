-- =====================================================
-- 📚 GUÍA DE USO DEL SISTEMA LA MODERNA
-- =====================================================

PROMPT '📚 === GUÍA RÁPIDA DE USO DEL SISTEMA ==='
PROMPT ''

PROMPT '🛍️ === CÓMO USAR EL SISTEMA ==='
PROMPT ''
PROMPT '1️⃣ PRODUCTOS:'
PROMPT '   • INSERT INTO PRODUCTOS → Cálculos automáticos de precios'
PROMPT '   • UPDATE stock_actual → Alertas automáticas si stock bajo'
PROMPT '   • UPDATE fecha_caducidad → Alertas de caducidad automáticas'
PROMPT ''
PROMPT '2️⃣ VENTAS:'
PROMPT '   • INSERT INTO VENTAS → Control automático de caja'
PROMPT '   • INSERT INTO DETALLE_VENTAS → Descuento stock automático'
PROMPT '   • Promociones aplicadas automáticamente'
PROMPT ''
PROMPT '3️⃣ CONSULTAS ÚTILES:'
PROMPT '   • SELECT * FROM V_INVENTARIO_SIMPLE → Ver inventario valorizado'
PROMPT '   • SELECT * FROM ALERTAS_SISTEMA → Ver alertas pendientes'
PROMPT '   • SELECT * FROM NOTIFICACIONES → Ver notificaciones'
PROMPT '   • SELECT * FROM AUDITORIA → Ver historial de cambios'
PROMPT ''
PROMPT '4️⃣ REPORTES:'
PROMPT '   • EXEC SP_INVENTARIO_SIMPLE → Reporte de inventario'
PROMPT '   • SELECT * FROM PRODUCTOS WHERE stock_actual <= stock_minimo'
PROMPT '   • SELECT * FROM PRODUCTOS WHERE fecha_caducidad <= SYSDATE + 7'
PROMPT ''

-- Ejemplos prácticos
PROMPT '🧪 === EJEMPLOS PRÁCTICOS ==='
PROMPT ''

-- Ejemplo 1: Agregar un producto nuevo
PROMPT '📝 EJEMPLO 1: Agregar producto nuevo'
PROMPT 'INSERT INTO PRODUCTOS (nombre, costo_base, precio_venta, stock_actual, id_categoria, id_proveedor)'
PROMPT 'VALUES (''Nuevo Producto'', 10.00, 15.00, 100, 1, 1);'
PROMPT '→ Resultado: Cálculos automáticos + valor_inventario calculado'
PROMPT ''

-- Ejemplo 2: Realizar una venta
PROMPT '💰 EJEMPLO 2: Realizar una venta'
PROMPT 'INSERT INTO VENTAS (subtotal, total, id_cliente, id_usuario, estado, metodo_pago)'
PROMPT 'VALUES (50.00, 50.00, 1, 1, ''COMPLETADA'', ''EFECTIVO'');'
PROMPT '→ Resultado: Control automático de caja + auditoría'
PROMPT ''

-- Ejemplo 3: Ver alertas
PROMPT '🚨 EJEMPLO 3: Ver alertas del sistema'
PROMPT 'SELECT tipo_alerta, mensaje, fecha_generacion FROM ALERTAS_SISTEMA WHERE procesada = 0;'
PROMPT '→ Resultado: Alertas de stock bajo, caducidad, etc.'
PROMPT ''
