-- =====================================================
-- CREAR TABLA PRODUCTOS (VERSIÓN SIMPLE)
-- =====================================================

PROMPT '🚀 Creando tabla PRODUCTOS (versión simple)...'

-- Eliminar si existe
DROP TABLE PRODUCTOS CASCADE CONSTRAINTS;

-- Crear tabla simple SIN cálculos automáticos
CREATE TABLE PRODUCTOS (
    id_producto                 NUMBER(10)      NOT NULL,
    codigo_barras               VARCHAR2(50),
    codigo_interno              VARCHAR2(20),
    nombre                      VARCHAR2(200)   NOT NULL,
    descripcion                 VARCHAR2(500),
    marca                       VARCHAR2(100),
    presentacion                VARCHAR2(50),
    
    -- Costos y precios (SIMPLES)
    costo_base                  NUMBER(10,2)    NOT NULL,
    gastos_adicionales          NUMBER(10,2)    DEFAULT 0,
    costo_total                 NUMBER(10,2)    NOT NULL,
    margen_ganancia             NUMBER(5,2)     DEFAULT 30,
    precio_sugerido             NUMBER(10,2),
    precio_venta                NUMBER(10,2)    NOT NULL,
    ganancia_unitaria           NUMBER(10,2),
    margen_real                 NUMBER(5,2),
    
    -- Inventario
    stock_actual                NUMBER(10)      DEFAULT 0,
    stock_minimo                NUMBER(10)      DEFAULT 1,
    stock_maximo                NUMBER(10)      DEFAULT 100,
    
    -- Fechas
    fecha_caducidad             DATE,
    dias_vida_util              NUMBER(4),
    fecha_ultima_venta          DATE,
    
    -- Ubicación
    ubicacion_fisica            VARCHAR2(50),
    requiere_refrigeracion      NUMBER(1)       DEFAULT 0 CHECK (requiere_refrigeracion IN (0, 1)),
    es_perecedero               NUMBER(1)       DEFAULT 0 CHECK (es_perecedero IN (0, 1)),
    
    -- Relaciones
    id_categoria                NUMBER(10)      NOT NULL,
    id_proveedor                NUMBER(10)      NOT NULL,
    
    -- Control
    activo                      NUMBER(1)       DEFAULT 1 CHECK (activo IN (0, 1)),
    en_promocion                NUMBER(1)       DEFAULT 0 CHECK (en_promocion IN (0, 1)),
    fecha_registro              DATE            DEFAULT SYSDATE,
    
    -- Constraints básicos
    CONSTRAINT PK_PRODUCTOS PRIMARY KEY (id_producto),
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor),
    CONSTRAINT CHK_PRECIOS_POSITIVOS CHECK (costo_base > 0 AND precio_venta > 0),
    CONSTRAINT CHK_STOCK_POSITIVO CHECK (stock_actual >= 0)
);

-- Índices básicos
CREATE INDEX IDX_PRODUCTOS_NOMBRE ON PRODUCTOS(nombre);
CREATE INDEX IDX_PRODUCTOS_CATEGORIA ON PRODUCTOS(id_categoria);

COMMIT;

PROMPT '✅ Tabla PRODUCTOS creada exitosamente!'












-- Verificar que PRODUCTOS se creó correctamente
PROMPT '🔍 Verificando tabla PRODUCTOS:'

SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS'
ORDER BY column_id;

PROMPT ''
PROMPT '📊 Total de columnas en PRODUCTOS:'
SELECT COUNT(*) as total_columnas FROM user_tab_columns WHERE table_name = 'PRODUCTOS';
