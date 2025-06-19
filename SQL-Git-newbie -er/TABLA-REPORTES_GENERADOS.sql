-- =====================================================
-- TABLA: REPORTES_GENERADOS
-- Descripción: Control de reportes generados con parámetros
-- =====================================================

PROMPT 'Creando tabla REPORTES_GENERADOS...'

CREATE TABLE REPORTES_GENERADOS (
    id_reporte              NUMBER(10)      NOT NULL,
    tipo_reporte            VARCHAR2(50)    NOT NULL CHECK (tipo_reporte IN ('VENTAS_DIARIAS', 'INVENTARIO', 'PRODUCTOS_CRITICOS')),
    nombre_archivo          VARCHAR2(200)   NOT NULL,
    ruta_archivo            VARCHAR2(500),
    parametros              CLOB,           -- JSON con filtros aplicados
    fecha_inicio_datos      DATE            NOT NULL,
    fecha_fin_datos         DATE            NOT NULL,
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_generacion        DATE            DEFAULT SYSDATE NOT NULL,
    estado                  VARCHAR2(20)    DEFAULT 'GENERANDO' CHECK (estado IN ('GENERANDO', 'COMPLETADO', 'ERROR')),
    registros_procesados    NUMBER(10)      DEFAULT 0,
    
    -- Constraints
    CONSTRAINT PK_REPORTES_GENERADOS PRIMARY KEY (id_reporte),
    CONSTRAINT FK_REPORTES_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_REPORTES_FECHAS CHECK (fecha_fin_datos >= fecha_inicio_datos),
    CONSTRAINT CHK_REPORTES_REGISTROS CHECK (registros_procesados >= 0)
);

-- Índices para optimización
CREATE INDEX IDX_REPORTES_TIPO ON REPORTES_GENERADOS(tipo_reporte);
CREATE INDEX IDX_REPORTES_USUARIO ON REPORTES_GENERADOS(id_usuario);
CREATE INDEX IDX_REPORTES_FECHA_GEN ON REPORTES_GENERADOS(fecha_generacion);
CREATE INDEX IDX_REPORTES_ESTADO ON REPORTES_GENERADOS(estado);

-- Comentarios
COMMENT ON TABLE REPORTES_GENERADOS IS 'Control de reportes generados con parámetros y estado';
COMMENT ON COLUMN REPORTES_GENERADOS.parametros IS 'JSON con filtros: {"categoria":1, "proveedor":2, "formato":"PDF"}';
COMMENT ON COLUMN REPORTES_GENERADOS.tipo_reporte IS 'VENTAS_DIARIAS, INVENTARIO, PRODUCTOS_CRITICOS';

PROMPT 'Tabla REPORTES_GENERADOS creada exitosamente.'
