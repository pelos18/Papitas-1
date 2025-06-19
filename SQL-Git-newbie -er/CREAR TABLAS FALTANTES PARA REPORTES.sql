-- ========================================
-- CREAR TABLAS FALTANTES PARA REPORTES
-- ========================================

PROMPT '🚀 === CREANDO TABLAS FALTANTES PARA REPORTES ==='
PROMPT ''

-- ========================================
-- TABLA CORTES_CAJA
-- ========================================
PROMPT '🔥 1/2 - Creando tabla CORTES_CAJA...'

CREATE TABLE CORTES_CAJA (
    id_corte                NUMBER(10)      NOT NULL,
    fecha_inicio            DATE            NOT NULL,
    fecha_fin               DATE            NOT NULL,
    tipo_corte              VARCHAR2(20)    NOT NULL CHECK (tipo_corte IN ('DIARIO', 'SEMANAL', 'MENSUAL')),
    total_ventas            NUMBER(15,2)    DEFAULT 0,
    total_costos            NUMBER(15,2)    DEFAULT 0,
    ganancia_bruta          NUMBER(15,2)    DEFAULT 0,
    gastos_operativos       NUMBER(15,2)    DEFAULT 0,
    ganancia_neta           NUMBER(15,2)    DEFAULT 0,
    margen_ganancia         NUMBER(5,2)     DEFAULT 0,
    total_transacciones     NUMBER(10)      DEFAULT 0,
    productos_vendidos      NUMBER(10)      DEFAULT 0,
    productos_top_5         CLOB,           -- JSON con top 5
    categorias_top          CLOB,           -- JSON con análisis
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_generacion        DATE            DEFAULT SYSDATE,
    
    -- Constraints
    CONSTRAINT PK_CORTES_CAJA PRIMARY KEY (id_corte),
    CONSTRAINT FK_CORTES_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_CORTES_FECHAS CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_CORTES_VALORES CHECK (
        total_ventas >= 0 AND total_costos >= 0 AND 
        ganancia_bruta >= 0 AND gastos_operativos >= 0 AND
        total_transacciones >= 0 AND productos_vendidos >= 0
    )
);

-- Índices
CREATE INDEX IDX_CORTES_FECHAS ON CORTES_CAJA(fecha_inicio, fecha_fin);
CREATE INDEX IDX_CORTES_TIPO ON CORTES_CAJA(tipo_corte);
CREATE INDEX IDX_CORTES_USUARIO ON CORTES_CAJA(id_usuario);

PROMPT '✅ 1/2 - Tabla CORTES_CAJA creada!'

-- ========================================
-- TABLA REPORTES_GENERADOS
-- ========================================
PROMPT '🔥 2/2 - Creando tabla REPORTES_GENERADOS...'

CREATE TABLE REPORTES_GENERADOS (
    id_reporte              NUMBER(10)      NOT NULL,
    tipo_reporte            VARCHAR2(50)    NOT NULL CHECK (tipo_reporte IN ('VENTAS_DIARIAS', 'INVENTARIO', 'PRODUCTOS_CRITICOS', 'CORTE_DIARIO', 'CORTE_SEMANAL', 'CORTE_MENSUAL')),
    nombre_archivo          VARCHAR2(200)   NOT NULL,
    ruta_archivo            VARCHAR2(500),
    parametros              CLOB,           -- JSON con filtros aplicados
    fecha_inicio_datos      DATE            NOT NULL,
    fecha_fin_datos         DATE            NOT NULL,
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_generacion        DATE            DEFAULT SYSDATE,
    estado                  VARCHAR2(20)    DEFAULT 'GENERANDO' CHECK (estado IN ('GENERANDO', 'COMPLETADO', 'ERROR')),
    registros_procesados    NUMBER(10)      DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_REPORTES_GENERADOS PRIMARY KEY (id_reporte),
    CONSTRAINT FK_REPORTES_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_REPORTES_FECHAS CHECK (fecha_fin_datos >= fecha_inicio_datos),
    CONSTRAINT CHK_REPORTES_REGISTROS CHECK (registros_procesados >= 0)
);

-- Índices
CREATE INDEX IDX_REPORTES_TIPO ON REPORTES_GENERADOS(tipo_reporte);
CREATE INDEX IDX_REPORTES_USUARIO ON REPORTES_GENERADOS(id_usuario);
CREATE INDEX IDX_REPORTES_FECHA_GEN ON REPORTES_GENERADOS(fecha_generacion);
CREATE INDEX IDX_REPORTES_ESTADO ON REPORTES_GENERADOS(estado);

PROMPT '✅ 2/2 - Tabla REPORTES_GENERADOS creada!'

PROMPT ''
PROMPT '🎯 === TABLAS DE REPORTES CREADAS EXITOSAMENTE ==='
