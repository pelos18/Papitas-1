-- =====================================================
-- SOLUCIÓN: EJECUTAR EN EL ORDEN CORRECTO
-- 1. Primero agregar la columna
-- 2. Después crear los triggers
-- =====================================================

PROMPT '🔧 === PASO 1: AGREGANDO COLUMNA VALOR_INVENTARIO ==='
PROMPT ''

-- Verificar si la columna ya existe
SELECT COUNT(*) as columna_existe 
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' 
AND column_name = 'VALOR_INVENTARIO';

-- Agregar la columna valor_inventario
ALTER TABLE PRODUCTOS 
ADD valor_inventario NUMBER(15,2) DEFAULT 0;

-- Agregar comentario
COMMENT ON COLUMN PRODUCTOS.valor_inventario IS 'Valor total del inventario: stock_actual * costo_total';

-- Crear índice para optimizar consultas
CREATE INDEX IDX_PRODUCTOS_VALOR_INV ON PRODUCTOS(valor_inventario);

PROMPT '✅ Columna valor_inventario agregada exitosamente!'

-- Calcular valores iniciales para productos existentes
UPDATE PRODUCTOS 
SET valor_inventario = stock_actual * costo_total
WHERE valor_inventario = 0;

COMMIT;

PROMPT '📊 Valores iniciales calculados para productos existentes'

PROMPT ''
PROMPT '🔧 === PASO 2: CREANDO TRIGGERS ==='
PROMPT ''

-- Ahora crear el trigger (la columna ya existe)
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_VALOR_INVENTARIO
    BEFORE INSERT OR UPDATE ON PRODUCTOS
    FOR EACH ROW
BEGIN
    -- Calcular valor_inventario automáticamente
    :NEW.valor_inventario := :NEW.stock_actual * :NEW.costo_total;
    
    -- Log para debugging
    DBMS_OUTPUT.PUT_LINE('📊 Valor inventario actualizado: ' || :NEW.nombre || 
                        ' = ' || :NEW.stock_actual || ' x ' || :NEW.costo_total || 
                        ' = $' || TO_CHAR(:NEW.valor_inventario, '999,999,999.99'));
END;
/

PROMPT '✅ Trigger TRG_ACTUALIZAR_VALOR_INVENTARIO creado correctamente!'

-- También actualizar cuando hay movimientos de inventario
CREATE OR REPLACE TRIGGER TRG_VALOR_INV_MOVIMIENTOS
    AFTER INSERT OR UPDATE ON MOVIMIENTOS_INVENTARIO
    FOR EACH ROW
BEGIN
    -- Actualizar valor_inventario del producto afectado
    UPDATE PRODUCTOS 
    SET valor_inventario = stock_actual * costo_total
    WHERE id_producto = :NEW.id_producto;
    
    DBMS_OUTPUT.PUT_LINE('📦 Valor inventario recalculado por movimiento: Producto ID ' || :NEW.id_producto);
END;
/

PROMPT '✅ Trigger TRG_VALOR_INV_MOVIMIENTOS creado correctamente!'
