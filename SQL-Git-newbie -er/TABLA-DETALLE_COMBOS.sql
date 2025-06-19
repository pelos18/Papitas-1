-- =====================================================
-- TABLA: DETALLE_COMBOS
-- Descripción: Productos que conforman cada combo
-- =====================================================

PROMPT 'Creando tabla DETALLE_COMBOS...'

CREATE TABLE DETALLE_COMBOS (
    id_detalle_combo        NUMBER(10)      NOT NULL,
    id_combo                NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    cantidad_requerida      NUMBER(8,3)     NOT NULL,
    precio_unitario_combo   NUMBER(10,2)    NOT NULL,
    
    -- Constraints
    CONSTRAINT PK_DETALLE_COMBOS PRIMARY KEY (id_detalle_combo),
    CONSTRAINT FK_DETALLE_COMBOS_COMBO FOREIGN KEY (id_combo) REFERENCES COMBOS(id_combo) ON DELETE CASCADE,
    CONSTRAINT FK_DETALLE_COMBOS_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT UK_DETALLE_COMBOS_PRODUCTO UNIQUE (id_combo, id_producto),
    CONSTRAINT CHK_DETALLE_COMBOS_CANTIDAD CHECK (cantidad_requerida > 0),
    CONSTRAINT CHK_DETALLE_COMBOS_PRECIO CHECK (precio_unitario_combo >= 0)
);

-- Índices para optimización
CREATE INDEX IDX_DETALLE_COMBOS_COMBO ON DETALLE_COMBOS(id_combo);
CREATE INDEX IDX_DETALLE_COMBOS_PRODUCTO ON DETALLE_COMBOS(id_producto);

-- Comentarios
COMMENT ON TABLE DETALLE_COMBOS IS 'Productos que conforman cada combo con sus cantidades y precios';
COMMENT ON COLUMN DETALLE_COMBOS.precio_unitario_combo IS 'Precio unitario del producto dentro del combo';

PROMPT 'Tabla DETALLE_COMBOS creada exitosamente.'
