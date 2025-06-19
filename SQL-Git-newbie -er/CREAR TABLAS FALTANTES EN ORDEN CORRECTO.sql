-- =====================================================
-- CREAR TABLAS FALTANTES EN ORDEN CORRECTO
-- =====================================================

-- Primero verificar si USUARIOS existe
SELECT COUNT(*) as usuarios_existe FROM user_tables WHERE table_name = 'USUARIOS';

-- Si no existe, crearla primero
CREATE TABLE USUARIOS (
    id_usuario NUMBER PRIMARY KEY,
    usuario VARCHAR2(50) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    rol VARCHAR2(20) DEFAULT 'EMPLEADO' CHECK (rol IN ('ADMIN', 'GERENTE', 'CAJERO', 'EMPLEADO')),
    permisos CLOB,
    limite_descuento NUMBER(5,2) DEFAULT 0,
    turno VARCHAR2(15) CHECK (turno IN ('MATUTINO', 'VESPERTINO', 'NOCTURNO')),
    telefono VARCHAR2(15),
    email VARCHAR2(100),
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_creacion DATE DEFAULT SYSDATE,
    ultimo_acceso DATE
);

-- Trigger para USUARIOS
CREATE OR REPLACE TRIGGER TRG_USUARIOS_ID
    BEFORE INSERT ON USUARIOS
    FOR EACH ROW
BEGIN
    IF :NEW.id_usuario IS NULL THEN
        :NEW.id_usuario := SEQ_USUARIOS.NEXTVAL;
    END IF;
END;
/

-- Verificar si PRODUCTOS existe
SELECT COUNT(*) as productos_existe FROM user_tables WHERE table_name = 'PRODUCTOS';

-- Si no existe, crearla
CREATE TABLE PRODUCTOS (
    id_producto NUMBER PRIMARY KEY,
    codigo_barras VARCHAR2(50) UNIQUE,
    codigo_interno VARCHAR2(20) UNIQUE,
    nombre VARCHAR2(200) NOT NULL,
    descripcion VARCHAR2(500),
    marca VARCHAR2(100),
    presentacion VARCHAR2(50),
    costo_base NUMBER(10,2) NOT NULL,
    gastos_adicionales NUMBER(10,2) DEFAULT 0,
    costo_total NUMBER(10,2) GENERATED ALWAYS AS (costo_base + gastos_adicionales),
    margen_ganancia NUMBER(5,2) DEFAULT 30,
    precio_sugerido NUMBER(10,2) GENERATED ALWAYS AS (costo_total * (1 + margen_ganancia/100)),
    precio_venta NUMBER(10,2) NOT NULL,
    ganancia_unitaria NUMBER(10,2) GENERATED ALWAYS AS (precio_venta - costo_total),
    margen_real NUMBER(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN precio_venta > 0 THEN ((precio_venta - costo_total) / precio_venta) * 100
            ELSE 0 
        END
    ),
    stock_actual NUMBER(10) DEFAULT 0,
    stock_minimo NUMBER(10) DEFAULT 1,
    stock_maximo NUMBER(10) DEFAULT 100,
    fecha_caducidad DATE,
    dias_vida_util NUMBER(4),
    fecha_ultima_venta DATE,
    ubicacion_fisica VARCHAR2(50),
    requiere_refrigeracion NUMBER(1) DEFAULT 0 CHECK (requiere_refrigeracion IN (0, 1)),
    es_perecedero NUMBER(1) DEFAULT 0 CHECK (es_perecedero IN (0, 1)),
    id_categoria NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    en_promocion NUMBER(1) DEFAULT 0 CHECK (en_promocion IN (0, 1)),
    fecha_registro DATE DEFAULT SYSDATE,
    
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor)
);

-- Trigger para PRODUCTOS
CREATE OR REPLACE TRIGGER TRG_PRODUCTOS_ID
    BEFORE INSERT ON PRODUCTOS
    FOR EACH ROW
BEGIN
    IF :NEW.id_producto IS NULL THEN
        :NEW.id_producto := SEQ_PRODUCTOS.NEXTVAL;
    END IF;
    
    IF :NEW.codigo_interno IS NULL THEN
        :NEW.codigo_interno := 'PROD' || LPAD(:NEW.id_producto, 6, '0');
    END IF;
END;
/

COMMIT;
PROMPT '✅ Tablas base creadas correctamente';
