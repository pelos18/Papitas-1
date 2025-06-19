-- =====================================================
-- SCRIPT 03: CREAR TABLA PROVEEDORES
-- Tabla completa de proveedores
-- =====================================================

CREATE TABLE PROVEEDORES (
    id_proveedor NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100),
    empresa VARCHAR2(150),
    telefono VARCHAR2(15),
    telefono_alternativo VARCHAR2(15),
    email VARCHAR2(100),
    direccion VARCHAR2(300),
    rfc VARCHAR2(13),
    contacto_principal VARCHAR2(100),
    dias_credito NUMBER(3) DEFAULT 0,
    descuento_volumen NUMBER(5,2) DEFAULT 0,
    banco VARCHAR2(50),
    cuenta_bancaria VARCHAR2(20),
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_registro DATE DEFAULT SYSDATE,
    ultima_compra DATE
);

-- Trigger para ID automático
CREATE OR REPLACE TRIGGER TRG_PROVEEDORES_ID
    BEFORE INSERT ON PROVEEDORES
    FOR EACH ROW
BEGIN
    IF :NEW.id_proveedor IS NULL THEN
        :NEW.id_proveedor := SEQ_PROVEEDORES.NEXTVAL;
    END IF;
END;
/

-- Índices
CREATE INDEX IDX_PROVEEDORES_NOMBRE ON PROVEEDORES(UPPER(nombre));
CREATE INDEX IDX_PROVEEDORES_RFC ON PROVEEDORES(rfc);
CREATE INDEX IDX_PROVEEDORES_EMAIL ON PROVEEDORES(email);

COMMIT;

PROMPT ✅ Tabla PROVEEDORES creada correctamente
