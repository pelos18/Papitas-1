-- =====================================================
-- TABLA: MOVIMIENTOS_INVENTARIO
-- Descripción: Control detallado de entradas y salidas de inventario
-- =====================================================

PROMPT 'Creando tabla MOVIMIENTOS_INVENTARIO...'

CREATE TABLE MOVIMIENTOS_INVENTARIO (
    id_movimiento           NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    tipo_movimiento         VARCHAR2(20)    NOT NULL CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA', 'AJUSTE', 'MERMA')),
    cantidad                NUMBER(10)      NOT NULL,
    costo_unitario          NUMBER(10,2)    NOT NULL,
    motivo                  VARCHAR2(30)    NOT NULL CHECK (motivo IN ('COMPRA', 'VENTA', 'CADUCIDAD', 'ROBO', 'AJUSTE')),
    referencia              VARCHAR2(100),  -- Folio de venta, factura, etc
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_movimiento        DATE            DEFAULT SYSDATE NOT NULL,
    observaciones           VARCHAR2(500),
    
    -- Constraints
    CONSTRAINT PK_MOVIMIENTOS_INVENTARIO PRIMARY KEY (id_movimiento),
    CONSTRAINT FK_MOVIMIENTOS_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_MOVIMIENTOS_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_MOVIMIENTOS_CANTIDAD CHECK (cantidad > 0),
    CONSTRAINT CHK_MOVIMIENTOS_COSTO CHECK (costo_unitario >= 0)
);

-- Índices para optimización
CREATE INDEX IDX_MOVIMIENTOS_PRODUCTO ON MOVIMIENTOS_INVENTARIO(id_producto);
CREATE INDEX IDX_MOVIMIENTOS_FECHA ON MOVIMIENTOS_INVENTARIO(fecha_movimiento);
CREATE INDEX IDX_MOVIMIENTOS_TIPO ON MOVIMIENTOS_INVENTARIO(tipo_movimiento);

-- Comentarios
COMMENT ON TABLE MOVIMIENTOS_INVENTARIO IS 'Registro detallado de todos los movimientos de inventario';
COMMENT ON COLUMN MOVIMIENTOS_INVENTARIO.tipo_movimiento IS 'ENTRADA, SALIDA, AJUSTE, MERMA';
COMMENT ON COLUMN MOVIMIENTOS_INVENTARIO.motivo IS 'COMPRA, VENTA, CADUCIDAD, ROBO, AJUSTE';
COMMENT ON COLUMN MOVIMIENTOS_INVENTARIO.referencia IS 'Folio de venta, factura, número de ajuste';

PROMPT 'Tabla MOVIMIENTOS_INVENTARIO creada exitosamente.'
