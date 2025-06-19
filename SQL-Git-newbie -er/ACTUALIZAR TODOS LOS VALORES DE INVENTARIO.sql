-- =====================================================
-- ACTUALIZAR TODOS LOS VALORES DE INVENTARIO
-- =====================================================

PROMPT '🔄 === ACTUALIZANDO TODOS LOS VALORES ==='
PROMPT ''

-- Actualizar productos que tienen NULL en costo_total
UPDATE PRODUCTOS 
SET costo_total = costo_base + NVL(gastos_adicionales, 0)
WHERE costo_total IS NULL;

-- Actualizar todos los valores de inventario
UPDATE PRODUCTOS 
SET valor_inventario = stock_actual * costo_total
WHERE stock_actual IS NOT NULL AND costo_total IS NOT NULL;

-- Actualizar productos que siguen en 0
UPDATE PRODUCTOS 
SET valor_inventario = stock_actual * costo_base
WHERE valor_inventario = 0 AND stock_actual > 0 AND costo_base > 0;

COMMIT;

PROMPT '✅ Todos los valores actualizados'

-- Verificar resultados
PROMPT ''
PROMPT '📊 RESULTADOS DESPUÉS DE LA ACTUALIZACIÓN:'
SELECT 
    nombre,
    stock_actual,
    costo_base,
    costo_total,
    valor_inventario,
    TO_CHAR(valor_inventario, '999,999.99') as valor_formateado
FROM PRODUCTOS 
WHERE ROWNUM <= 5
ORDER BY valor_inventario DESC;
