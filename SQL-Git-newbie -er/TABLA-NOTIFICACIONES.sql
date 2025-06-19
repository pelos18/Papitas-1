-- =====================================================
-- TABLA: NOTIFICACIONES
-- Descripción: Sistema completo de notificaciones con acciones
-- =====================================================

PROMPT 'Creando tabla NOTIFICACIONES...'

CREATE TABLE NOTIFICACIONES (
    id_notificacion         NUMBER(10)      NOT NULL,
    tipo_notificacion       VARCHAR2(30)    NOT NULL CHECK (tipo_notificacion IN ('STOCK_BAJO', 'CADUCIDAD', 'PROMOCION', 'SISTEMA', 'VENTA')),
    titulo                  VARCHAR2(200)   NOT NULL,
    mensaje                 VARCHAR2(1000)  NOT NULL,
    prioridad               VARCHAR2(20)    NOT NULL CHECK (prioridad IN ('CRITICA', 'ALTA', 'MEDIA', 'BAJA')),
    leida                   NUMBER(1)       DEFAULT 0 CHECK (leida IN (0,1)),
    id_producto             NUMBER(10),
    id_usuario_destinatario NUMBER(10)      NOT NULL,
    id_usuario_origen       NUMBER(10),
    fecha_notificacion      DATE            DEFAULT SYSDATE NOT NULL,
    fecha_leida             DATE,
    accion_sugerida         VARCHAR2(500),
    url_accion              VARCHAR2(200),  -- Para redireccionar
    requiere_accion         NUMBER(1)       DEFAULT 0 CHECK (requiere_accion IN (0,1)),
    
    -- Constraints
    CONSTRAINT PK_NOTIFICACIONES PRIMARY KEY (id_notificacion),
    CONSTRAINT FK_NOTIF_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_NOTIF_USUARIO_DEST FOREIGN KEY (id_usuario_destinatario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT FK_NOTIF_USUARIO_ORIG FOREIGN KEY (id_usuario_origen) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_NOTIF_LEIDA_FECHA CHECK (
        (leida = 0 AND fecha_leida IS NULL) OR 
        (leida = 1 AND fecha_leida IS NOT NULL)
    )
);

-- Índices para optimización
CREATE INDEX IDX_NOTIF_USUARIO_DEST ON NOTIFICACIONES(id_usuario_destinatario);
CREATE INDEX IDX_NOTIF_TIPO ON NOTIFICACIONES(tipo_notificacion);
CREATE INDEX IDX_NOTIF_PRIORIDAD ON NOTIFICACIONES(prioridad);
CREATE INDEX IDX_NOTIF_LEIDA ON NOTIFICACIONES(leida);
CREATE INDEX IDX_NOTIF_FECHA ON NOTIFICACIONES(fecha_notificacion);

-- Comentarios
COMMENT ON TABLE NOTIFICACIONES IS 'Sistema completo de notificaciones con acciones y seguimiento';
COMMENT ON COLUMN NOTIFICACIONES.tipo_notificacion IS 'STOCK_BAJO, CADUCIDAD, PROMOCION, SISTEMA, VENTA';
COMMENT ON COLUMN NOTIFICACIONES.url_accion IS 'URL para redireccionar al usuario a la acción correspondiente';
COMMENT ON COLUMN NOTIFICACIONES.requiere_accion IS '0=Solo informativa, 1=Requiere acción del usuario';

PROMPT 'Tabla NOTIFICACIONES creada exitosamente.'
