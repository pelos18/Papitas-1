-- =====================================================
-- TABLA: ALERTAS_SISTEMA
-- Descripción: Sistema de alertas automáticas y manuales
-- =====================================================

PROMPT 'Creando tabla ALERTAS_SISTEMA...'

CREATE TABLE ALERTAS_SISTEMA (
    id_alerta               NUMBER(10)      NOT NULL,
    tipo_alerta             VARCHAR2(30)    NOT NULL CHECK (tipo_alerta IN ('STOCK_BAJO', 'CADUCIDAD', 'PROMOCION_SUGERIDA')),
    nivel_prioridad         VARCHAR2(20)    NOT NULL CHECK (nivel_prioridad IN ('CRITICA', 'ALTA', 'MEDIA', 'BAJA')),
    id_producto             NUMBER(10),
    mensaje                 VARCHAR2(500)   NOT NULL,
    accion_sugerida         VARCHAR2(500),
    procesada               NUMBER(1)       DEFAULT 0 CHECK (procesada IN (0,1)),
    fecha_generacion        DATE            DEFAULT SYSDATE NOT NULL,
    fecha_procesada         DATE,
    id_usuario_procesado    NUMBER(10),
    resultado_accion        VARCHAR2(500),
    
    -- Constraints
    CONSTRAINT PK_ALERTAS_SISTEMA PRIMARY KEY (id_alerta),
    CONSTRAINT FK_ALERTAS_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_ALERTAS_USUARIO_PROC FOREIGN KEY (id_usuario_procesado) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_ALERTAS_PROCESADA_FECHA CHECK (
        (procesada = 0 AND fecha_procesada IS NULL) OR 
        (procesada = 1 AND fecha_procesada IS NOT NULL)
    )
);

-- Índices para optimización
CREATE INDEX IDX_ALERTAS_TIPO ON ALERTAS_SISTEMA(tipo_alerta);
CREATE INDEX IDX_ALERTAS_PRIORIDAD ON ALERTAS_SISTEMA(nivel_prioridad);
CREATE INDEX IDX_ALERTAS_PROCESADA ON ALERTAS_SISTEMA(procesada);
CREATE INDEX IDX_ALERTAS_FECHA ON ALERTAS_SISTEMA(fecha_generacion);

-- Comentarios
COMMENT ON TABLE ALERTAS_SISTEMA IS 'Sistema de alertas automáticas para gestión proactiva';
COMMENT ON COLUMN ALERTAS_SISTEMA.tipo_alerta IS 'STOCK_BAJO, CADUCIDAD, PROMOCION_SUGERIDA';
COMMENT ON COLUMN ALERTAS_SISTEMA.nivel_prioridad IS 'CRITICA, ALTA, MEDIA, BAJA';
COMMENT ON COLUMN ALERTAS_SISTEMA.procesada IS '0=Pendiente, 1=Procesada';

PROMPT 'Tabla ALERTAS_SISTEMA creada exitosamente.'
