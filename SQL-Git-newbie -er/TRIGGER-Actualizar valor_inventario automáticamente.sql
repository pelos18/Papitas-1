-- =====================================================
-- TRIGGER: Actualizar valor_inventario automáticamente
-- Se ejecuta cuando cambia stock o costo
-- =====================================================

PROMPT '🔥 === CREANDO TRIGGER PARA VALOR_INVENTARIO ==='
PROMPT ''

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

PROMPT '✅ Trigger TRG_ACTUALIZAR_VALOR_INVENTARIO creado!'

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

PROMPT '✅ Trigger TRG_VALOR_INV_MOVIMIENTOS creado!'
