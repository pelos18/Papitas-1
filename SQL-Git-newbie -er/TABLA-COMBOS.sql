-- =====================================================
-- TABLA: COMBOS
-- Descripción: Combos de productos con precios especiales
-- =====================================================

PROMPT 'Creando tabla COMBOS...'

CREATE TABLE COMBOS (
    id_combo                NUMBER(10)      NOT NULL,
    nombre_combo            VARCHAR2(200)   NOT NULL,
    descripcion             VARCHAR2(500),
    precio_combo            NUMBER(12,2)    NOT NULL,
    precio_individual_total NUMBER(12,2)    NOT NULL, -- Suma de precios individuales
    ahorro_total            NUMBER(12,2)    DEFAULT 0, -- Calculado automáticamente
    activo                  NUMBER(1)       DEFAULT 1 CHECK (activo IN (0,1)),
    fecha_inicio            DATE            NOT NULL,
    fecha_fin               DATE            NOT NULL,
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_creacion          DATE            DEFAULT SYSDATE NOT NULL,
    combos_vendidos         NUMBER(10)      DEFAULT 0,
    ingresos_combo          NUMBER(15,2)    DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_COMBOS PRIMARY KEY (id_combo),
    CONSTRAINT FK_COMBOS_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_COMBOS_FECHAS CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_COMBOS_PRECIO CHECK (precio_combo > 0),
    CONSTRAINT CHK_COMBOS_PRECIO_INDIVIDUAL CHECK (precio_individual_total > 0),
    CONSTRAINT CHK_COMBOS_AHORRO CHECK (ahorro_total >= 0),
    CONSTRAINT CHK_COMBOS_VALORES CHECK (combos_vendidos >= 0 AND ingresos_combo >= 0)
);

-- Índices para optimización
CREATE INDEX IDX_COMBOS_FECHAS ON COMBOS(fecha_inicio, fecha_fin);
CREATE INDEX IDX_COMBOS_ACTIVO ON COMBOS(activo);
CREATE INDEX IDX_COMBOS_USUARIO ON COMBOS(id_usuario);

-- Comentarios
COMMENT ON TABLE COMBOS IS 'Combos de productos con precios especiales y seguimiento de ventas';
COMMENT ON COLUMN COMBOS.ahorro_total IS 'Calculado: precio_individual_total - precio_combo';

PROMPT 'Tabla COMBOS creada exitosamente.'
