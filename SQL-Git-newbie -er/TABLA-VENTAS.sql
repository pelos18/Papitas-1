-- =====================================================
-- TABLA: VENTAS
-- Descripción: Registro completo de ventas con análisis de rentabilidad
-- =====================================================

PROMPT 'Creando tabla VENTAS...'

CREATE TABLE VENTAS (
    id_venta                NUMBER(10)      NOT NULL,
    folio                   VARCHAR2(20)    NOT NULL,
    fecha_venta             DATE            DEFAULT SYSDATE NOT NULL,
    hora_venta              VARCHAR2(8)     DEFAULT TO_CHAR(SYSDATE, 'HH24:MI:SS') NOT NULL,
    subtotal                NUMBER(12,2)    NOT NULL,
    descuento               NUMBER(12,2)    DEFAULT 0,
    impuestos               NUMBER(12,2)    DEFAULT 0,
    total                   NUMBER(12,2)    NOT NULL,
    id_cliente              NUMBER(10),
    id_usuario              NUMBER(10)      NOT NULL,
    estado                  VARCHAR2(20)    DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'COMPLETADA', 'CANCELADA', 'DEVUELTA')),
    metodo_pago             VARCHAR2(20)    NOT NULL CHECK (metodo_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'CREDITO')),
    referencia_pago         VARCHAR2(100),  -- Número de autorización
    numero_productos        NUMBER(5)       DEFAULT 0,
    costo_total_venta       NUMBER(12,2)    DEFAULT 0, -- Para calcular ganancia
    ganancia_venta          NUMBER(12,2)    DEFAULT 0, -- Calculada
    observaciones           VARCHAR2(500),
    fecha_creacion          DATE            DEFAULT SYSDATE NOT NULL,
    
    -- Constraints
    CONSTRAINT PK_VENTAS PRIMARY KEY (id_venta),
    CONSTRAINT UK_VENTAS_FOLIO UNIQUE (folio),
    CONSTRAINT FK_VENTAS_CLIENTE FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente),
    CONSTRAINT FK_VENTAS_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_VENTAS_SUBTOTAL CHECK (subtotal >= 0),
    CONSTRAINT CHK_VENTAS_DESCUENTO CHECK (descuento >= 0),
    CONSTRAINT CHK_VENTAS_TOTAL CHECK (total >= 0),
    CONSTRAINT CHK_VENTAS_NUMERO_PROD CHECK (numero_productos >= 0),
    CONSTRAINT CHK_VENTAS_GANANCIA CHECK (ganancia_venta >= 0)
);

-- Índices para optimización
CREATE INDEX IDX_VENTAS_FECHA ON VENTAS(fecha_venta);
CREATE INDEX IDX_VENTAS_CLIENTE ON VENTAS(id_cliente);
CREATE INDEX IDX_VENTAS_USUARIO ON VENTAS(id_usuario);
CREATE INDEX IDX_VENTAS_ESTADO ON VENTAS(estado);
CREATE INDEX IDX_VENTAS_METODO_PAGO ON VENTAS(metodo_pago);

-- Comentarios
COMMENT ON TABLE VENTAS IS 'Registro maestro de ventas con análisis de rentabilidad';
COMMENT ON COLUMN VENTAS.costo_total_venta IS 'Suma de costos de productos vendidos';
COMMENT ON COLUMN VENTAS.ganancia_venta IS 'Calculada: total - costo_total_venta';
COMMENT ON COLUMN VENTAS.numero_productos IS 'Cantidad de líneas de productos diferentes';

PROMPT 'Tabla VENTAS creada exitosamente.'
