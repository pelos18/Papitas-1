-- =====================================================
-- TABLA: DETALLE_VENTAS
-- Descripción: Detalle de productos vendidos con análisis de rentabilidad
-- =====================================================

PROMPT 'Creando tabla DETALLE_VENTAS...'

CREATE TABLE DETALLE_VENTAS (
    id_detalle              NUMBER(10)      NOT NULL,
    id_venta                NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    cantidad                NUMBER(8,3)     NOT NULL,
    precio_unitario         NUMBER(10,2)    NOT NULL,
    costo_unitario          NUMBER(10,2)    NOT NULL, -- Para calcular ganancia
    subtotal                NUMBER(12,2)    NOT NULL,
    descuento_linea         NUMBER(12,2)    DEFAULT 0,
    ganancia_linea          NUMBER(12,2)    DEFAULT 0, -- Calculada
    es_promocion            NUMBER(1)       DEFAULT 0 CHECK (es_promocion IN (0,1)),
    id_promocion            NUMBER(10),
    id_combo                NUMBER(10),
    
    -- Constraints
    CONSTRAINT PK_DETALLE_VENTAS PRIMARY KEY (id_detalle),
    CONSTRAINT FK_DETALLE_VENTA FOREIGN KEY (id_venta) REFERENCES VENTAS(id_venta) ON DELETE CASCADE,
    CONSTRAINT FK_DETALLE_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT CHK_DETALLE_CANTIDAD CHECK (cantidad > 0),
    CONSTRAINT CHK_DETALLE_PRECIO CHECK (precio_unitario >= 0),
    CONSTRAINT CHK_DETALLE_COSTO CHECK (costo_unitario >= 0),
    CONSTRAINT CHK_DETALLE_SUBTOTAL CHECK (subtotal >= 0),
    CONSTRAINT CHK_DETALLE_DESCUENTO CHECK (descuento_linea >= 0)
);

-- Índices para optimización
CREATE INDEX IDX_DETALLE_VENTA ON DETALLE_VENTAS(id_venta);
CREATE INDEX IDX_DETALLE_PRODUCTO ON DETALLE_VENTAS(id_producto);
CREATE INDEX IDX_DETALLE_PROMOCION ON DETALLE_VENTAS(id_promocion);
CREATE INDEX IDX_DETALLE_COMBO ON DETALLE_VENTAS(id_combo);

-- Comentarios
COMMENT ON TABLE DETALLE_VENTAS IS 'Detalle de productos vendidos con análisis de rentabilidad por línea';
COMMENT ON COLUMN DETALLE_VENTAS.costo_unitario IS 'Costo del producto al momento de la venta';
COMMENT ON COLUMN DETALLE_VENTAS.ganancia_linea IS 'Calculada: (precio_unitario - costo_unitario) * cantidad';
COMMENT ON COLUMN DETALLE_VENTAS.es_promocion IS '0=Precio normal, 1=Precio promocional';

PROMPT 'Tabla DETALLE_VENTAS creada exitosamente.'
