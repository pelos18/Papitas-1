-- =====================================================
-- CREAR TABLAS FALTANTES PARA TRIGGERS
-- Sistema de Inventarios La Moderna
-- =====================================================

PROMPT '🚀 === CREANDO TABLAS FALTANTES PARA TRIGGERS ==='
PROMPT ''

-- =====================================================
-- 1. TABLA CLIENTES (necesaria para VENTAS)
-- =====================================================
PROMPT '🔥 1/4 - Creando tabla CLIENTES...'

CREATE TABLE CLIENTES (
    id_cliente              NUMBER(10)      NOT NULL,
    nombre                  VARCHAR2(100)   NOT NULL,
    apellidos               VARCHAR2(100),
    telefono                VARCHAR2(20),
    email                   VARCHAR2(100),
    direccion               VARCHAR2(300),
    rfc                     VARCHAR2(13),
    fecha_nacimiento        DATE,
    tipo_cliente            VARCHAR2(20)    DEFAULT 'OCASIONAL' CHECK (tipo_cliente IN ('FRECUENTE', 'OCASIONAL', 'MAYORISTA')),
    limite_credito          NUMBER(10,2)    DEFAULT 0,
    saldo_pendiente         NUMBER(10,2)    DEFAULT 0,
    puntos_acumulados       NUMBER(10)      DEFAULT 0,
    activo                  NUMBER(1)       DEFAULT 1 CHECK (activo IN (0, 1)),
    fecha_registro          DATE            DEFAULT SYSDATE,
    ultima_compra           DATE,
    
    -- Constraints
    CONSTRAINT PK_CLIENTES PRIMARY KEY (id_cliente),
    CONSTRAINT CHK_CLIENTES_CREDITO CHECK (limite_credito >= 0),
    CONSTRAINT CHK_CLIENTES_SALDO CHECK (saldo_pendiente >= 0),
    CONSTRAINT CHK_CLIENTES_PUNTOS CHECK (puntos_acumulados >= 0)
);

-- Índices
CREATE INDEX IDX_CLIENTES_NOMBRE ON CLIENTES(UPPER(nombre));
CREATE INDEX IDX_CLIENTES_TELEFONO ON CLIENTES(telefono);
CREATE INDEX IDX_CLIENTES_EMAIL ON CLIENTES(email);

PROMPT '✅ 1/4 - Tabla CLIENTES creada!'

-- =====================================================
-- 2. TABLA DETALLE_VENTAS (necesaria para stock control)
-- =====================================================
PROMPT '🔥 2/4 - Creando tabla DETALLE_VENTAS...'

CREATE TABLE DETALLE_VENTAS (
    id_detalle              NUMBER(10)      NOT NULL,
    id_venta                NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    cantidad                NUMBER(10)      NOT NULL,
    precio_unitario         NUMBER(10,2)    NOT NULL,
    costo_unitario          NUMBER(10,2)    DEFAULT 0,
    subtotal                NUMBER(10,2)    NOT NULL,
    descuento_linea         NUMBER(10,2)    DEFAULT 0,
    ganancia_linea          NUMBER(10,2)    DEFAULT 0,
    es_promocion            NUMBER(1)       DEFAULT 0 CHECK (es_promocion IN (0, 1)),
    id_promocion            NUMBER(10),
    id_combo                NUMBER(10),
    
    -- Constraints
    CONSTRAINT PK_DETALLE_VENTAS PRIMARY KEY (id_detalle),
    CONSTRAINT FK_DETALLE_VENTA FOREIGN KEY (id_venta) REFERENCES VENTAS(id_venta),
    CONSTRAINT FK_DETALLE_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT CHK_DETALLE_CANTIDAD CHECK (cantidad > 0),
    CONSTRAINT CHK_DETALLE_PRECIOS CHECK (precio_unitario > 0 AND subtotal >= 0)
);

-- Índices
CREATE INDEX IDX_DETALLE_VENTA ON DETALLE_VENTAS(id_venta);
CREATE INDEX IDX_DETALLE_PRODUCTO ON DETALLE_VENTAS(id_producto);

PROMPT '✅ 2/4 - Tabla DETALLE_VENTAS creada!'

-- =====================================================
-- 3. TABLA ALERTAS_SISTEMA (necesaria para alertas)
-- =====================================================
PROMPT '🔥 3/4 - Creando tabla ALERTAS_SISTEMA...'

CREATE TABLE ALERTAS_SISTEMA (
    id_alerta               NUMBER(10)      NOT NULL,
    tipo_alerta             VARCHAR2(30)    NOT NULL CHECK (tipo_alerta IN ('STOCK_BAJO', 'CADUCIDAD', 'PROMOCION_SUGERIDA')),
    nivel_prioridad         VARCHAR2(10)    DEFAULT 'MEDIA' CHECK (nivel_prioridad IN ('CRITICA', 'ALTA', 'MEDIA', 'BAJA')),
    id_producto             NUMBER(10),
    mensaje                 VARCHAR2(500)   NOT NULL,
    accion_sugerida         VARCHAR2(300),
    procesada               NUMBER(1)       DEFAULT 0 CHECK (procesada IN (0, 1)),
    fecha_generacion        DATE            DEFAULT SYSDATE,
    fecha_procesada         DATE,
    id_usuario_procesado    NUMBER(10),
    resultado_accion        VARCHAR2(500),
    
    -- Constraints
    CONSTRAINT PK_ALERTAS_SISTEMA PRIMARY KEY (id_alerta),
    CONSTRAINT FK_ALERTA_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_ALERTA_USUARIO FOREIGN KEY (id_usuario_procesado) REFERENCES USUARIOS(id_usuario)
);

-- Índices
CREATE INDEX IDX_ALERTAS_TIPO ON ALERTAS_SISTEMA(tipo_alerta);
CREATE INDEX IDX_ALERTAS_PRIORIDAD ON ALERTAS_SISTEMA(nivel_prioridad);
CREATE INDEX IDX_ALERTAS_FECHA ON ALERTAS_SISTEMA(fecha_generacion);
CREATE INDEX IDX_ALERTAS_PROCESADA ON ALERTAS_SISTEMA(procesada);

PROMPT '✅ 3/4 - Tabla ALERTAS_SISTEMA creada!'

-- =====================================================
-- 4. TABLA MOVIMIENTOS_INVENTARIO (necesaria para stock)
-- =====================================================
PROMPT '🔥 4/4 - Creando tabla MOVIMIENTOS_INVENTARIO...'

CREATE TABLE MOVIMIENTOS_INVENTARIO (
    id_movimiento           NUMBER(10)      NOT NULL,
    id_producto             NUMBER(10)      NOT NULL,
    tipo_movimiento         VARCHAR2(20)    NOT NULL CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA', 'AJUSTE', 'MERMA')),
    cantidad                NUMBER(10)      NOT NULL,
    costo_unitario          NUMBER(10,2)    NOT NULL,
    motivo                  VARCHAR2(30)    NOT NULL CHECK (motivo IN ('COMPRA', 'VENTA', 'CADUCIDAD', 'ROBO', 'AJUSTE')),
    referencia              VARCHAR2(100),  -- Folio de venta, factura, etc
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_movimiento        DATE            DEFAULT SYSDATE NOT NULL,
    observaciones           VARCHAR2(500),
    
    -- Constraints
    CONSTRAINT PK_MOVIMIENTOS_INVENTARIO PRIMARY KEY (id_movimiento),
    CONSTRAINT FK_MOVIMIENTOS_PRODUCTO FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    CONSTRAINT FK_MOVIMIENTOS_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_MOVIMIENTOS_CANTIDAD CHECK (cantidad > 0),
    CONSTRAINT CHK_MOVIMIENTOS_COSTO CHECK (costo_unitario >= 0)
);

-- Índices
CREATE INDEX IDX_MOVIMIENTOS_PRODUCTO ON MOVIMIENTOS_INVENTARIO(id_producto);
CREATE INDEX IDX_MOVIMIENTOS_FECHA ON MOVIMIENTOS_INVENTARIO(fecha_movimiento);
CREATE INDEX IDX_MOVIMIENTOS_TIPO ON MOVIMIENTOS_INVENTARIO(tipo_movimiento);

PROMPT '✅ 4/4 - Tabla MOVIMIENTOS_INVENTARIO creada!'

-- =====================================================
-- AGREGAR FOREIGN KEYS FALTANTES
-- =====================================================
PROMPT '🔧 Agregando foreign keys faltantes...'

-- Agregar FK de CLIENTES a VENTAS
ALTER TABLE VENTAS ADD CONSTRAINT FK_VENTA_CLIENTE 
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente);

PROMPT '✅ Foreign keys agregadas!'

-- =====================================================
-- VERIFICACIÓN FINAL
-- =====================================================
PROMPT ''
PROMPT '🔍 Verificando tablas creadas:'

SELECT 'CLIENTES' as tabla, COUNT(*) as existe FROM USER_TABLES WHERE table_name = 'CLIENTES'
UNION ALL
SELECT 'DETALLE_VENTAS' as tabla, COUNT(*) as existe FROM USER_TABLES WHERE table_name = 'DETALLE_VENTAS'
UNION ALL
SELECT 'ALERTAS_SISTEMA' as tabla, COUNT(*) as existe FROM USER_TABLES WHERE table_name = 'ALERTAS_SISTEMA'
UNION ALL
SELECT 'MOVIMIENTOS_INVENTARIO' as tabla, COUNT(*) as existe FROM USER_TABLES WHERE table_name = 'MOVIMIENTOS_INVENTARIO';

PROMPT ''
PROMPT '🎯 === TABLAS FALTANTES CREADAS EXITOSAMENTE ==='
PROMPT '✅ Ahora los triggers del GRUPO 1 deberían funcionar correctamente'
PROMPT ''

COMMIT;
