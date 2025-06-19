-- =====================================================
-- SCRIPT 04: CREAR TABLA USUARIOS
-- Tabla de usuarios del sistema
-- =====================================================

CREATE TABLE USUARIOS (
    id_usuario NUMBER PRIMARY KEY,
    usuario VARCHAR2(50) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    rol VARCHAR2(20) DEFAULT 'EMPLEADO' CHECK (rol IN ('ADMIN', 'GERENTE', 'CAJERO', 'EMPLEADO')),
    permisos CLOB, -- JSON con permisos específicos
    limite_descuento NUMBER(5,2) DEFAULT 0,
    turno VARCHAR2(15) CHECK (turno IN ('MATUTINO', 'VESPERTINO', 'NOCTURNO')),
    telefono VARCHAR2(15),
    email VARCHAR2(100),
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_creacion DATE DEFAULT SYSDATE,
    ultimo_acceso DATE
);

-- Trigger para ID automático
CREATE OR REPLACE TRIGGER TRG_USUARIOS_ID
    BEFORE INSERT ON USUARIOS
    FOR EACH ROW
BEGIN
    IF :NEW.id_usuario IS NULL THEN
        :NEW.id_usuario := SEQ_USUARIOS.NEXTVAL;
    END IF;
END;
/

-- Índices
CREATE INDEX IDX_USUARIOS_USUARIO ON USUARIOS(usuario);
CREATE INDEX IDX_USUARIOS_ROL ON USUARIOS(rol);
CREATE INDEX IDX_USUARIOS_EMAIL ON USUARIOS(email);

COMMIT;

PROMPT ✅ Tabla USUARIOS creada correctamente
