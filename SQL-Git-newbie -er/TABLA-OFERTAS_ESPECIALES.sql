-- =====================================================
-- TABLA: OFERTAS_ESPECIALES
-- Descripción: Ofertas por categoría, happy hours, compra mínima
-- =====================================================

PROMPT 'Creando tabla OFERTAS_ESPECIALES...'

CREATE TABLE OFERTAS_ESPECIALES (
    id_oferta               NUMBER(10)      NOT NULL,
    nombre_oferta           VARCHAR2(200)   NOT NULL,
    descripcion             VARCHAR2(500),
    tipo_oferta             VARCHAR2(30)    NOT NULL CHECK (tipo_oferta IN ('DESCUENTO_CATEGORIA', 'HAPPY_HOUR', 'COMPRA_MINIMA')),
    id_categoria            NUMBER(10),     -- Para ofertas por categoría
    descuento_porcentaje    NUMBER(5,2)     NOT NULL,
    monto_minimo_compra     NUMBER(12,2)    DEFAULT 0,
    hora_inicio             VARCHAR2(8),    -- Para happy hours
    hora_fin                VARCHAR2(8),    -- Para happy hours
    dias_semana             VARCHAR2(20)    DEFAULT '[1,2,3,4,5,6,7]', -- JSON: [1,2,3,4,5,6,7]
    fecha_inicio            DATE            NOT NULL,
    fecha_fin               DATE            NOT NULL,
    activa                  NUMBER(1)       DEFAULT 1 CHECK (activa IN (0,1)),
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_creacion          DATE            DEFAULT SYSDATE NOT NULL,
    ventas_aplicadas        NUMBER(10)      DEFAULT 0,
    ingresos_oferta         NUMBER(15,2)    DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_OFERTAS_ESPECIALES PRIMARY KEY (id_oferta),
    CONSTRAINT FK_OFERTAS_CATEGORIA FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria),
    CONSTRAINT FK_OFERTAS_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_OFERTAS_FECHAS CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_OFERTAS_DESCUENTO CHECK (descuento_porcentaje BETWEEN 0 AND 100),
    CONSTRAINT CHK_OFERTAS_MONTO CHECK (monto_minimo_compra >= 0),
    CONSTRAINT CHK_OFERTAS_VALORES CHECK (ventas_aplicadas >= 0 AND ingresos_oferta >= 0),
    CONSTRAINT CHK_OFERTAS_TIPO_VALIDACION CHECK (
        (tipo_oferta = 'DESCUENTO_CATEGORIA' AND id_categoria IS NOT NULL) OR
        (tipo_oferta = 'HAPPY_HOUR' AND hora_inicio IS NOT NULL AND hora_fin IS NOT NULL) OR
        (tipo_oferta = 'COMPRA_MINIMA' AND monto_minimo_compra > 0) OR
        (tipo_oferta NOT IN ('DESCUENTO_CATEGORIA', 'HAPPY_HOUR', 'COMPRA_MINIMA'))
    )
);

-- Índices para optimización
CREATE INDEX IDX_OFERTAS_TIPO ON OFERTAS_ESPECIALES(tipo_oferta);
CREATE INDEX IDX_OFERTAS_CATEGORIA ON OFERTAS_ESPECIALES(id_categoria);
CREATE INDEX IDX_OFERTAS_FECHAS ON OFERTAS_ESPECIALES(fecha_inicio, fecha_fin);
CREATE INDEX IDX_OFERTAS_ACTIVA ON OFERTAS_ESPECIALES(activa);

-- Comentarios
COMMENT ON TABLE OFERTAS_ESPECIALES IS 'Ofertas especiales por categoría, horarios y montos mínimos';
COMMENT ON COLUMN OFERTAS_ESPECIALES.tipo_oferta IS 'DESCUENTO_CATEGORIA, HAPPY_HOUR, COMPRA_MINIMA';
COMMENT ON COLUMN OFERTAS_ESPECIALES.dias_semana IS 'JSON array: [1,2,3,4,5,6,7] donde 1=Lunes, 7=Domingo';

PROMPT 'Tabla OFERTAS_ESPECIALES creada exitosamente.'
