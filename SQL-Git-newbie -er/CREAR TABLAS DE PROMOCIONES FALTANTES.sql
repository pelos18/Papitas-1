-- ========================================
-- CREAR TABLAS DE PROMOCIONES FALTANTES
-- ========================================

PROMPT '🚀 === CREANDO TABLAS DE PROMOCIONES ==='
PROMPT ''

-- ========================================
-- TABLA PROMOCIONES
-- ========================================
PROMPT '🔥 1/3 - Creando tabla PROMOCIONES...'

CREATE TABLE PROMOCIONES (
    id_promocion                NUMBER(10)      NOT NULL,
    nombre_promocion            VARCHAR2(100)   NOT NULL,
    descripcion                 VARCHAR2(300),
    id_producto                 NUMBER(10)      NOT NULL,
    tipo_promocion              VARCHAR2(20)    DEFAULT 'DESCUENTO' CHECK (tipo_promocion IN ('DESCUENTO', '2X1', '3X2', 'PRECIO_FIJO')),
    precio_promocion            NUMBER(10,2),
    porcentaje_descuento        NUMBER(5,2),
    cantidad_minima             NUMBER(10)      DEFAULT 1,
    cantidad_regalo             NUMBER(10)      DEFAULT 0,
    fecha_inicio                DATE            NOT NULL,
    fecha_fin                   DATE            NOT NULL,
    hora_inicio                 VARCHAR2(8),    -- 'HH24:MI:SS'
    hora_fin                    VARCHAR2(8),    -- 'HH24:MI:SS'
    dias_semana                 VARCHAR2(50),   -- JSON: [1,2,3,4,5,6,7]
    motivo                      VARCHAR2(50)    CHECK (motivo IN ('CADUCIDAD', 'LIQUIDACION', 'TEMPORADA', 'VOLUMEN')),
    activa                      NUMBER(1)       DEFAULT 1 CHECK (activa IN (0, 1)),
    automatica                  NUMBER(1)       DEFAULT 0 CHECK (automatica IN (0, 1)),
    id_usuario                  NUMBER(10)      NOT NULL,
    fecha_creacion              DATE            DEFAULT SYSDATE,
    productos_vendidos_promocion NUMBER(10)     DEFAULT 0,
    ingresos_promocion          NUMBER(12,2)    DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_PROMOCIONES PRIMARY KEY (id_promocion),
    CONSTRAINT FK_PROMOCION_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_PROMOCION_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_PROMOCION_FECHAS CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_PROMOCION_PRECIOS CHECK (
        (tipo_promocion = 'PRECIO_FIJO' AND precio_promocion > 0) OR
        (tipo_promocion = 'DESCUENTO' AND porcentaje_descuento BETWEEN 0 AND 100) OR
        (tipo_promocion IN ('2X1', '3X2'))
    )
);

-- Índices
CREATE INDEX IDX_PROMOCIONES_PRODUCTO ON PROMOCIONES(id_producto);
CREATE INDEX IDX_PROMOCIONES_FECHAS ON PROMOCIONES(fecha_inicio, fecha_fin);
CREATE INDEX IDX_PROMOCIONES_ACTIVA ON PROMOCIONES(activa);
CREATE INDEX IDX_PROMOCIONES_TIPO ON PROMOCIONES(tipo_promocion);

PROMPT '✅ 1/3 - Tabla PROMOCIONES creada!'

-- ========================================
-- TABLA COMBOS
-- ========================================
PROMPT '🔥 2/3 - Creando tabla COMBOS...'

CREATE TABLE COMBOS (
    id_combo                    NUMBER(10)      NOT NULL,
    nombre_combo                VARCHAR2(100)   NOT NULL,
    descripcion                 VARCHAR2(300),
    precio_combo                NUMBER(10,2)    NOT NULL,
    precio_individual_total     NUMBER(10,2)    DEFAULT 0,
    ahorro_total                NUMBER(10,2)    DEFAULT 0,
    activo                      NUMBER(1)       DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_inicio                DATE            DEFAULT SYSDATE,
    fecha_fin                   DATE,
    id_usuario                  NUMBER(10)      NOT NULL,
    fecha_creacion              DATE            DEFAULT SYSDATE,
    combos_vendidos             NUMBER(10)      DEFAULT 0,
    ingresos_combo              NUMBER(12,2)    DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_COMBOS PRIMARY KEY (id_combo),
    CONSTRAINT FK_COMBO_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_COMBO_PRECIO CHECK (precio_combo > 0),
    CONSTRAINT CHK_COMBO_FECHAS CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- Índices
CREATE INDEX IDX_COMBOS_ACTIVO ON COMBOS(activo);
CREATE INDEX IDX_COMBOS_FECHAS ON COMBOS(fecha_inicio, fecha_fin);

PROMPT '✅ 2/3 - Tabla COMBOS creada!'

-- ========================================
-- TABLA DETALLE_COMBOS
-- ========================================
PROMPT '🔥 3/3 - Creando tabla DETALLE_COMBOS...'

CREATE TABLE DETALLE_COMBOS (
    id_detalle_combo            NUMBER(10)      NOT NULL,
    id_combo                    NUMBER(10)      NOT NULL,
    id_producto                 NUMBER(10)      NOT NULL,
    cantidad_requerida          NUMBER(10)      NOT NULL,
    precio_unitario_combo       NUMBER(10,2)    NOT NULL,
    
    -- Constraints
    CONSTRAINT PK_DETALLE_COMBOS PRIMARY KEY (id_detalle_combo),
    CONSTRAINT FK_DETALLE_COMBO FOREIGN KEY (id_combo) REFERENCES COMBOS(id_combo),
    CONSTRAINT FK_DETALLE_COMBO_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT CHK_DETALLE_COMBO_CANTIDAD CHECK (cantidad_requerida > 0),
    CONSTRAINT CHK_DETALLE_COMBO_PRECIO CHECK (precio_unitario_combo > 0),
    CONSTRAINT UK_COMBO_PRODUCTO UNIQUE (id_combo, id_producto)
);

-- Índices
CREATE INDEX IDX_DETALLE_COMBO ON DETALLE_COMBOS(id_combo);
CREATE INDEX IDX_DETALLE_COMBO_PRODUCTO ON DETALLE_COMBOS(id_producto);

PROMPT '✅ 3/3 - Tabla DETALLE_COMBOS creada!'

PROMPT ''
PROMPT '🎯 === TABLAS DE PROMOCIONES CREADAS EXITOSAMENTE ==='
PROMPT ''
