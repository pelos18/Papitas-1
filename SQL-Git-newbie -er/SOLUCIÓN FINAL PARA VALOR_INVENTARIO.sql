-- =====================================================
-- SOLUCIÓN FINAL PARA VALOR_INVENTARIO
-- Corregir los problemas menores
-- =====================================================

PROMPT '🔧 === SOLUCIONANDO PROBLEMAS FINALES ==='
PROMPT ''

-- PASO 1: Calcular valores para productos existentes
PROMPT '📊 PASO 1: Calculando valores de inventario...'

UPDATE PRODUCTOS 
SET valor_inventario = stock_actual * costo_total
WHERE costo_total IS NOT NULL AND stock_actual IS NOT NULL;

COMMIT;

PROMPT '✅ Valores de inventario calculados para productos existentes'

-- PASO 2: Verificar que el trigger de movimientos tiene secuencia
PROMPT ''
PROMPT '🔧 PASO 2: Corrigiendo trigger de movimientos...'

-- Verificar si existe la secuencia
SELECT sequence_name 
FROM user_sequences 
WHERE sequence_name = 'SEQ_MOVIMIENTOS_INVENTARIO';

-- Crear trigger corregido para movimientos
CREATE OR REPLACE TRIGGER TRG_MOVIMIENTOS_ID
    BEFORE INSERT ON MOVIMIENTOS_INVENTARIO
    FOR EACH ROW
BEGIN
    IF :NEW.id_movimiento IS NULL THEN
        :NEW.id_movimiento := SEQ_MOVIMIENTOS_INVENTARIO.NEXTVAL;
    END IF;
END;
/

PROMPT '✅ Trigger de ID automático para movimientos corregido'

-- PASO 3: Probar inserción de movimiento
PROMPT ''
PROMPT '🧪 PASO 3: Probando inserción de movimiento...'

INSERT INTO MOVIMIENTOS_INVENTARIO (
    id_producto, tipo_movimiento, cantidad, costo_unitario,
    motivo, id_usuario, observaciones
) VALUES (
    1, 'ENTRADA', 5, 12.50, 'COMPRA', 1, 'Prueba corregida de trigger valor_inventario'
);

COMMIT;

PROMPT '✅ Movimiento insertado correctamente'
