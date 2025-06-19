-- =====================================================
-- TABLA: MOVIMIENTOS_INVENTARIO (CORREGIDA)
-- =====================================================

PROMPT 'Creando tabla MOVIMIENTOS_INVENTARIO...'

CREATE TABLE MOVIMIENTOS_INVENTARIO (
    id_movimiento           NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    tipo_movimiento         VARCHAR2(20)    NOT NULL CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA', 'AJUSTE', 'MERMA')),
    cantidad                NUMBER(10)      NOT NULL,
    costo_unitario          NUMBER(10,2)    NOT NULL,
    motivo                  VARCHAR2(30)    NOT NULL CHECK (motivo IN ('COMPRA', 'VENTA', 'CADUCIDAD', 'ROBO', 'AJUSTE')),
    referencia              VARCHAR2(100),
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_movimiento        DATE            DEFAULT SYSDATE NOT NULL,
    observaciones           VARCHAR2(500),
    
    CONSTRAINT PK_MOVIMIENTOS_INVENTARIO PRIMARY KEY (id_movimiento),
    CONSTRAINT FK_MOVIMIENTOS_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_MOVIMIENTOS_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_MOVIMIENTOS_CANTIDAD CHECK (cantidad > 0),
    CONSTRAINT CHK_MOVIMIENTOS_COSTO CHECK (costo_unitario >= 0)
);

-- Trigger para ID automático
CREATE OR REPLACE TRIGGER TRG_MOVIMIENTOS_ID
    BEFORE INSERT ON MOVIMIENTOS_INVENTARIO
    FOR EACH ROW
BEGIN
    IF :NEW.id_movimiento IS NULL THEN
        :NEW.id_movimiento := SEQ_MOVIMIENTOS_INVENTARIO.NEXTVAL;
    END IF;
END;
/

-- Índices
CREATE INDEX IDX_MOVIMIENTOS_PRODUCTO ON MOVIMIENTOS_INVENTARIO(id_producto);
CREATE INDEX IDX_MOVIMIENTOS_FECHA ON MOVIMIENTOS_INVENTARIO(fecha_movimiento);
CREATE INDEX IDX_MOVIMIENTOS_TIPO ON MOVIMIENTOS_INVENTARIO(tipo_movimiento);

-- Comentarios
COMMENT ON TABLE MOVIMIENTOS_INVENTARIO IS 'Registro detallado de todos los movimientos de inventario';
COMMENT ON COLUMN MOVIMIENTOS_INVENTARIO.tipo_movimiento IS 'ENTRADA, SALIDA, AJUSTE, MERMA';
COMMENT ON COLUMN MOVIMIENTOS_INVENTARIO.motivo IS 'COMPRA, VENTA, CADUCIDAD, ROBO, AJUSTE';

COMMIT;
PROMPT '✅ Tabla MOVIMIENTOS_INVENTARIO creada exitosamente';
