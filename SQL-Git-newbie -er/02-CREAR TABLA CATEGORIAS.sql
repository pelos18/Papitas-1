-- =====================================================
-- SCRIPT 02: CREAR TABLA CATEGORIAS
-- Tabla con soporte para subcategorías
-- =====================================================

CREATE TABLE CATEGORIAS (
    id_categoria NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(500),
    id_categoria_padre NUMBER,
    nivel NUMBER(1) DEFAULT 1 CHECK (nivel IN (1, 2)),
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_creacion DATE DEFAULT SYSDATE,
    
    CONSTRAINT FK_CATEGORIA_PADRE FOREIGN KEY (id_categoria_padre) REFERENCES CATEGORIAS(id_categoria)
);

-- Trigger para ID automático
CREATE OR REPLACE TRIGGER TRG_CATEGORIAS_ID
    BEFORE INSERT ON CATEGORIAS
    FOR EACH ROW
BEGIN
    IF :NEW.id_categoria IS NULL THEN
        :NEW.id_categoria := SEQ_CATEGORIAS.NEXTVAL;
    END IF;
END;
/

-- Índices
CREATE INDEX IDX_CATEGORIAS_PADRE ON CATEGORIAS(id_categoria_padre);
CREATE INDEX IDX_CATEGORIAS_NOMBRE ON CATEGORIAS(UPPER(nombre));

COMMIT;

PROMPT ✅ Tabla CATEGORIAS creada correctamente
