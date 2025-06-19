-- =====================================================
-- SCRIPT 02: CREAR TABLAS PRINCIPALES
-- Tablas maestras del sistema
-- =====================================================

-- TABLA: CATEGORIAS (con subcategorías)
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

-- TABLA: PROVEEDORES (mejorada)
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

-- TABLA: USUARIOS (mejorada)
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

-- TABLA: CLIENTES (mejorada)
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

COMMIT;

PROMPT ✅ Tablas principales creadas correctamente
