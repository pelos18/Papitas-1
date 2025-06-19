-- =====================================================
-- SCRIPT 05: CREAR TABLA CLIENTES
-- Tabla completa de clientes
-- =====================================================

CREATE TABLE CLIENTES (
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100),
    telefono VARCHAR2(15),
    email VARCHAR2(100),
    direccion VARCHAR2(300),
    rfc VARCHAR2(13),
    fecha_nacimiento DATE,
    tipo_cliente VARCHAR2(15) DEFAULT 'OCASIONAL' CHECK (tipo_cliente IN ('FRECUENTE', 'OCASIONAL', 'MAYORISTA')),
    limite_credito NUMBER(10,2) DEFAULT 0,
    saldo_pendiente NUMBER(10,2) DEFAULT 0,
    puntos_acumulados NUMBER(10) DEFAULT 0,
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_registro DATE DEFAULT SYSDATE,
    ultima_compra DATE
);

-- Trigger para ID automático
CREATE OR REPLACE TRIGGER TRG_CLIENTES_ID
    BEFORE INSERT ON CLIENTES
    FOR EACH ROW
BEGIN
    IF :NEW.id_cliente IS NULL THEN
        :NEW.id_cliente := SEQ_CLIENTES.NEXTVAL;
    END IF;
END;
/

-- Índices
CREATE INDEX IDX_CLIENTES_NOMBRE ON CLIENTES(UPPER(nombre));
CREATE INDEX IDX_CLIENTES_TELEFONO ON CLIENTES(telefono);
CREATE INDEX IDX_CLIENTES_EMAIL ON CLIENTES(email);
CREATE INDEX IDX_CLIENTES_TIPO ON CLIENTES(tipo_cliente);

COMMIT;

PROMPT ✅ Tabla CLIENTES creada correctamente
