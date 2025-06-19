-- =====================================================
-- VISTA SIMPLE DE INVENTARIO (SIN ERRORES)
-- =====================================================

PROMPT '👁️ === CREANDO VISTA SIMPLE DE INVENTARIO ==='
PROMPT ''

-- Vista básica que funciona
CREATE OR REPLACE VIEW V_INVENTARIO_SIMPLE AS
SELECT 
    p.id_producto,
    p.nombre,
    p.stock_actual,
    p.costo_total,
    p.valor_inventario,
    c.nombre as categoria,
    CASE 
        WHEN p.stock_actual <= p.stock_minimo THEN 'CRÍTICO'
        WHEN p.stock_actual <= (p.stock_minimo * 1.5) THEN 'BAJO'
        ELSE 'NORMAL'
    END as estado_stock
FROM PRODUCTOS p
LEFT JOIN CATEGORIAS c ON p.id_categoria = c.id_categoria
WHERE p.activo = 1;

PROMPT '✅ Vista V_INVENTARIO_SIMPLE creada exitosamente'

-- Probar la vista
PROMPT ''
PROMPT '📋 EJEMPLO DE LA VISTA:'
SELECT * FROM V_INVENTARIO_SIMPLE WHERE ROWNUM <= 3;
