-- =====================================================
-- VISTA: Inventario valorizado completo
-- Para reportes y consultas de valor de inventario
-- =====================================================

PROMPT '📊 === CREANDO VISTA DE INVENTARIO VALORIZADO ==='
PROMPT ''

CREATE OR REPLACE VIEW V_INVENTARIO_VALORIZADO AS
SELECT 
    p.id_producto,
    p.codigo_barras,
    p.codigo_interno,
    p.nombre,
    p.marca,
    c.nombre as categoria,
    pr.empresa as proveedor,
    p.stock_actual,
    p.stock_minimo,
    p.stock_maximo,
    p.costo_base,
    p.gastos_adicionales,
    p.costo_total,
    p.precio_venta,
    p.valor_inventario,
    p.ganancia_unitaria,
    p.margen_real,
    CASE 
        WHEN p.stock_actual <= p.stock_minimo THEN 'CRÍTICO'
        WHEN p.stock_actual <= (p.stock_minimo * 1.5) THEN 'BAJO'
        WHEN p.stock_actual >= p.stock_maximo THEN 'EXCESO'
        ELSE 'NORMAL'
    END as estado_stock,
    CASE 
        WHEN p.fecha_caducidad IS NOT NULL AND p.fecha_caducidad <= SYSDATE + 7 THEN 'PRÓXIMO A CADUCAR'
        WHEN p.fecha_caducidad IS NOT NULL AND p.fecha_caducidad <= SYSDATE THEN 'CADUCADO'
        ELSE 'VIGENTE'
    END as estado_caducidad,
    p.fecha_caducidad,
    p.fecha_ultima_venta,
    p.activo
FROM PRODUCTOS p
JOIN CATEGORIAS c ON p.id_categoria = c.id_categoria
JOIN PROVEEDORES pr ON p.id_proveedor = pr.id_proveedor;

-- Crear vista de resumen por categoría
CREATE OR REPLACE VIEW V_INVENTARIO_POR_CATEGORIA AS
SELECT 
    c.nombre as categoria,
    COUNT(p.id_producto) as total_productos,
    SUM(p.stock_actual) as total_unidades,
    SUM(p.valor_inventario) as valor_total,
    AVG(p.margen_real) as margen_promedio,
    COUNT(CASE WHEN p.stock_actual <= p.stock_minimo THEN 1 END) as productos_criticos
FROM PRODUCTOS p
JOIN CATEGORIAS c ON p.id_categoria = c.id_categoria
WHERE p.activo = 1
GROUP BY c.id_categoria, c.nombre
ORDER BY valor_total DESC;

PROMPT '✅ Vistas de inventario valorizado creadas!'

-- Mostrar ejemplo de uso
PROMPT ''
PROMPT '📋 EJEMPLO DE INVENTARIO VALORIZADO:'
SELECT * FROM V_INVENTARIO_VALORIZADO WHERE ROWNUM <= 3;

PROMPT ''
PROMPT '📊 RESUMEN POR CATEGORÍA:'
SELECT * FROM V_INVENTARIO_POR_CATEGORIA;
