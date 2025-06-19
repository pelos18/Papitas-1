-- =====================================================
-- TABLA: DEVOLUCIONES
-- Descripción: Control de devoluciones de productos
-- =====================================================

PROMPT 'Creando tabla DEVOLUCIONES...'

CREATE TABLE DEVOLUCIONES (
    id_devolucion           NUMBER(10)      NOT NULL,
    id_venta_original       NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    cantidad_devuelta       NUMBER(8,3)     NOT NULL,
    motivo                  VARCHAR2(30)    NOT NULL CHECK (motivo IN ('CADUCADO', 'DEFECTUOSO', 'CAMBIO_OPINION')),
    monto_devuelto          NUMBER(12,2)    NOT NULL,
    estado                  VARCHAR2(20)    DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'APROBADA', 'RECHAZADA')),
    id_usuario_autoriza     NUMBER(10),
    fecha_devolucion        DATE            DEFAULT SYSDATE NOT NULL,
    observaciones           VARCHAR2(500),
    
    -- Constraints
    CONSTRAINT PK_DEVOLUCIONES PRIMARY KEY (id_devolucion),
    CONSTRAINT FK_DEVOLUCIONES_VENTA FOREIGN KEY (id_venta_original) REFERENCES VENTAS(id_venta),
    CONSTRAINT FK_DEVOLUCIONES_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_DEVOLUCIONES_USUARIO FOREIGN KEY (id_usuario_autoriza) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_DEVOLUCIONES_CANTIDAD CHECK (cantidad_devuelta > 0),
    CONSTRAINT CHK_DEVOLUCIONES_MONTO CHECK (monto_devuelto >= 0),
    CONSTRAINT CHK_DEVOLUCIONES_ESTADO_USER CHECK (
        (estado = 'PENDIENTE') OR 
        (estado IN ('APROBADA', 'RECHAZADA') AND id_usuario_autoriza IS NOT NULL)
    )
);

-- Índices para optimización
CREATE INDEX IDX_DEVOLUCIONES_VENTA ON DEVOLUCIONES(id_venta_original);
CREATE INDEX IDX_DEVOLUCIONES_PRODUCTO ON DEVOLUCIONES(id_producto);
CREATE INDEX IDX_DEVOLUCIONES_FECHA ON DEVOLUCIONES(fecha_devolucion);
CREATE INDEX IDX_DEVOLUCIONES_ESTADO ON DEVOLUCIONES(estado);

-- Comentarios
COMMENT ON TABLE DEVOLUCIONES IS 'Control de devoluciones con proceso de autorización';
COMMENT ON COLUMN DEVOLUCIONES.motivo IS 'CADUCADO, DEFECTUOSO, CAMBIO_OPINION';
COMMENT ON COLUMN DEVOLUCIONES.estado IS 'PENDIENTE, APROBADA, RECHAZADA';

PROMPT 'Tabla DEVOLUCIONES creada exitosamente.'
