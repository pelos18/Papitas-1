-- =====================================================
-- SCRIPT 06: CREAR TABLA PRODUCTOS
-- Tabla más importante del sistema
-- =====================================================

CREATE TABLE PRODUCTOS (
    id_producto NUMBER PRIMARY KEY,
    codigo_barras VARCHAR2(50) UNIQUE,
    codigo_interno VARCHAR2(20) UNIQUE,
    nombre VARCHAR2(200) NOT NULL,
    descripcion VARCHAR2(500),
    marca VARCHAR2(100),
    presentacion VARCHAR2(50), -- "1kg", "500ml", etc
    
    -- Costos y precios
    costo_base NUMBER(10,2) NOT NULL, -- Precio del proveedor
    gastos_adicionales NUMBER(10,2) DEFAULT 0, -- Transporte, impuestos
    costo_total NUMBER(10,2) GENERATED ALWAYS AS (costo_base + gastos_adicionales),
    margen_ganancia NUMBER(5,2) DEFAULT 30, -- Porcentaje deseado
    precio_sugerido NUMBER(10,2) GENERATED ALWAYS AS (costo_total * (1 + margen_ganancia/100)),
    precio_venta NUMBER(10,2) NOT NULL, -- Precio final al público
    ganancia_unitaria NUMBER(10,2) GENERATED ALWAYS AS (precio_venta - costo_total),
    margen_real NUMBER(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN precio_venta > 0 THEN ((precio_venta - costo_total) / precio_venta) * 100
            ELSE 0 
        END
    ),
    
    -- Inventario
    stock_actual NUMBER(10) DEFAULT 0,
    stock_minimo NUMBER(10) DEFAULT 1,
    stock_maximo NUMBER(10) DEFAULT 100,
    
    -- Fechas y vida útil
    fecha_caducidad DATE,
    dias_vida_util NUMBER(4),
    fecha_ultima_venta DATE,
    
    -- Ubicación y características
    ubicacion_fisica VARCHAR2(50), -- "Pasillo A, Estante 3"
    requiere_refrigeracion NUMBER(1) DEFAULT 0 CHECK (requiere_refrigeracion IN (0, 1)),
    es_perecedero NUMBER(1) DEFAULT 0 CHECK (es_perecedero IN (0, 1)),
    
    -- Relaciones
    id_categoria NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    
    -- Control
    activo NUMBER(1) DEFAULT 1 CHECK (activo IN (0, 1)),
    en_promocion NUMBER(1) DEFAULT 0 CHECK (en_promocion IN (0, 1)),
    fecha_registro DATE DEFAULT SYSDATE,
    
    -- Restricciones
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor),
    CONSTRAINT CHK_PRECIOS_POSITIVOS CHECK (costo_base > 0 AND precio_venta > 0),
    CONSTRAINT CHK_STOCK_POSITIVO CHECK (stock_actual >= 0),
    CONSTRAINT CHK_MARGEN_VALIDO CHECK (margen_ganancia >= 0 AND margen_ganancia <= 1000)
);

-- Trigger para ID automático
CREATE OR REPLACE TRIGGER TRG_PRODUCTOS_ID
    BEFORE INSERT ON PRODUCTOS
    FOR EACH ROW
BEGIN
    IF :NEW.id_producto IS NULL THEN
        :NEW.id_producto := SEQ_PRODUCTOS.NEXTVAL;
    END IF;
    
    -- Generar código interno si no existe
    IF :NEW.codigo_interno IS NULL THEN
        :NEW.codigo_interno := 'PROD' || LPAD(:NEW.id_producto, 6, '0');
    END IF;
END;
/

-- Índices para optimizar consultas
CREATE INDEX IDX_PRODUCTOS_CODIGO_BARRAS ON PRODUCTOS(codigo_barras);
CREATE INDEX IDX_PRODUCTOS_CODIGO_INTERNO ON PRODUCTOS(codigo_interno);
CREATE INDEX IDX_PRODUCTOS_NOMBRE ON PRODUCTOS(UPPER(nombre));
CREATE INDEX IDX_PRODUCTOS_CATEGORIA ON PRODUCTOS(id_categoria);
CREATE INDEX IDX_PRODUCTOS_PROVEEDOR ON PRODUCTOS(id_proveedor);
CREATE INDEX IDX_PRODUCTOS_STOCK_BAJO ON PRODUCTOS(stock_actual, stock_minimo);
CREATE INDEX IDX_PRODUCTOS_CADUCIDAD ON PRODUCTOS(fecha_caducidad);

COMMIT;

PROMPT ✅ Tabla PRODUCTOS creada con todas las mejoras
