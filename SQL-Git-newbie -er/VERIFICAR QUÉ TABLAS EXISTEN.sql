-- =====================================================
-- TABLA: AUDITORIA
-- Descripción: Registro completo de auditoría de cambios
-- =====================================================

PROMPT 'Creando tabla AUDITORIA...'

CREATE TABLE AUDITORIA (
    id_auditoria            NUMBER(10)      NOT NULL,
    tabla_afectada          VARCHAR2(50)    NOT NULL,
    operacion               VARCHAR2(10)    NOT NULL CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE')),
    campo_modificado        VARCHAR2(100),
    valor_anterior          VARCHAR2(1000),
    valor_nuevo             VARCHAR2(1000),
    id_registro_afectado    NUMBER(10)      NOT NULL,
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_operacion         DATE            DEFAULT SYSDATE NOT NULL,
    hora_operacion          VARCHAR2(8)     DEFAULT TO_CHAR(SYSDATE, 'HH24:MI:SS') NOT NULL,
    ip_usuario              VARCHAR2(50),
    observaciones           VARCHAR2(500),
    
    -- Constraints
    CONSTRAINT PK_AUDITORIA PRIMARY KEY (id_auditoria),
    CONSTRAINT FK_AUDITORIA_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_AUDITORIA_ID_REGISTRO CHECK (id_registro_afectado > 0)
);

-- Índices para optimización
CREATE INDEX IDX_AUDITORIA_TABLA ON AUDITORIA(tabla_afectada);
CREATE INDEX IDX_AUDITORIA_OPERACION ON AUDITORIA(operacion);
CREATE INDEX IDX_AUDITORIA_USUARIO ON AUDITORIA(id_usuario);
CREATE INDEX IDX_AUDITORIA_FECHA ON AUDITORIA(fecha_operacion);
CREATE INDEX IDX_AUDITORIA_REGISTRO ON AUDITORIA(tabla_afectada, id_registro_afectado);

-- Comentarios
COMMENT ON TABLE AUDITORIA IS 'Registro completo de auditoría para seguimiento de cambios';
COMMENT ON COLUMN AUDITORIA.operacion IS 'INSERT, UPDATE, DELETE';
COMMENT ON COLUMN AUDITORIA.campo_modificado IS 'Nombre del campo que fue modificado (para UPDATE)';

PROMPT 'Tabla AUDITORIA creada exitosamente.'
