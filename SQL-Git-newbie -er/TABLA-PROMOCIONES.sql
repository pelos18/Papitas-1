-- =====================================================
-- TABLA: PROMOCIONES
-- Descripción: Sistema completo de promociones con horarios y días
-- =====================================================

PROMPT 'Creando tabla PROMOCIONES...'

CREATE TABLE PROMOCIONES (
    id_promocion            NUMBER(10)      NOT NULL,
    nombre_promocion        VARCHAR2(200)   NOT NULL,
    descripcion             VARCHAR2(500),
    id_producto             NUMBER(10)      NOT NULL,
    tipo_promocion          VARCHAR2(20)    NOT NULL CHECK (tipo_promocion IN ('DESCUENTO', '2X1', '3X2', 'PRECIO_FIJO')),
    precio_promocion        NUMBER(10,2),
    porcentaje_descuento    NUMBER(5,2),
    cantidad_minima         NUMBER(10)      DEFAULT 1, -- Para promociones por volumen
    cantidad_regalo         NUMBER(10)      DEFAULT 0, -- Para promociones 2x1, 3x2
    fecha_inicio            DATE            NOT NULL,
    fecha_fin               DATE            NOT NULL,
    hora_inicio             VARCHAR2(8)     DEFAULT '00:00:00',
    hora_fin                VARCHAR2(8)     DEFAULT '23:59:59',
    dias_semana             VARCHAR2(20)    DEFAULT '[1,2,3,4,5,6,7]', -- JSON: [1,2,3,4,5,6,7]
    motivo                  VARCHAR2(30)    CHECK (motivo IN ('CADUCIDAD', 'LIQUIDACION', 'TEMPORADA')),
    activa                  NUMBER(1)       DEFAULT 1 CHECK (activa IN (0,1)),
    automatica              NUMBER(1)       DEFAULT 0 CHECK (automatica IN (0,1)), -- Generada por el sistema
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_creacion          DATE            DEFAULT SYSDATE NOT NULL,
    productos_vendidos_promocion NUMBER(10) DEFAULT 0,
    ingresos_promocion      NUMBER(15,2)    DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_PROMOCIONES PRIMARY KEY (id_promocion),
    CONSTRAINT FK_PROMOCIONES_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_PROMOCIONES_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_PROMOCIONES_FECHAS CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_PROMOCIONES_PRECIO CHECK (precio_promocion >= 0),
    CONSTRAINT CHK_PROMOCIONES_DESCUENTO CHECK (porcentaje_descuento BETWEEN 0 AND 100),
    CONSTRAINT CHK_PROMOCIONES_CANTIDAD CHECK (cantidad_minima > 0),
    CONSTRAINT CHK_PROMOCIONES_REGALO CHECK (cantidad_regalo >= 0),
    CONSTRAINT CHK_PROMOCIONES_VALORES CHECK (productos_vendidos_promocion >= 0 AND ingresos_promocion >= 0),
    CONSTRAINT CHK_PROMOCIONES_TIPO_VALOR CHECK (
        (tipo_promocion = 'DESCUENTO' AND porcentaje_descuento IS NOT NULL) OR
        (tipo_promocion = 'PRECIO_FIJO' AND precio_promocion IS NOT NULL) OR
        (tipo_promocion IN ('2X1', '3X2') AND cantidad_regalo > 0)
    )
);

-- Índices para optimización
CREATE INDEX IDX_PROMOCIONES_PRODUCTO ON PROMOCIONES(id_producto);
CREATE INDEX IDX_PROMOCIONES_FECHAS ON PROMOCIONES(fecha_inicio, fecha_fin);
CREATE INDEX IDX_PROMOCIONES_ACTIVA ON PROMOCIONES(activa);
CREATE INDEX IDX_PROMOCIONES_TIPO ON PROMOCIONES(tipo_promocion);

-- Comentarios
COMMENT ON TABLE PROMOCIONES IS 'Sistema completo de promociones con horarios, días y seguimiento';
COMMENT ON COLUMN PROMOCIONES.dias_semana IS 'JSON array: [1,2,3,4,5,6,7] donde 1=Lunes, 7=Domingo';
COMMENT ON COLUMN PROMOCIONES.automatica IS '0=Manual, 1=Generada automáticamente por el sistema';
COMMENT ON COLUMN PROMOCIONES.tipo_promocion IS 'DESCUENTO, 2X1, 3X2, PRECIO_FIJO';

PROMPT 'Tabla PROMOCIONES creada exitosamente.'
