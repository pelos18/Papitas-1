-- =====================================================
-- TABLA: CAJA
-- Descripción: Control diario de caja con múltiples métodos de pago
-- =====================================================

PROMPT 'Creando tabla CAJA...'

CREATE TABLE CAJA (
    id_caja                 NUMBER(10)      NOT NULL,
    fecha                   DATE            DEFAULT TRUNC(SYSDATE) NOT NULL,
    hora_apertura           VARCHAR2(8),
    hora_cierre             VARCHAR2(8),
    saldo_inicial           NUMBER(12,2)    DEFAULT 0,
    ingresos_efectivo       NUMBER(12,2)    DEFAULT 0,
    ingresos_tarjeta        NUMBER(12,2)    DEFAULT 0,
    ingresos_transferencia  NUMBER(12,2)    DEFAULT 0,
    egresos                 NUMBER(12,2)    DEFAULT 0,
    saldo_teorico           NUMBER(12,2)    DEFAULT 0, -- Calculado
    saldo_fisico            NUMBER(12,2)    DEFAULT 0, -- Contado físicamente
    diferencia              NUMBER(12,2)    DEFAULT 0, -- Faltante o sobrante
    id_usuario_apertura     NUMBER(10),
    id_usuario_cierre       NUMBER(10),
    estado                  VARCHAR2(20)    DEFAULT 'ABIERTA' CHECK (estado IN ('ABIERTA', 'CERRADA', 'CUADRADA')),
    fecha_creacion          DATE            DEFAULT SYSDATE NOT NULL,
    fecha_cierre            DATE,
    observaciones           VARCHAR2(500),
    numero_ventas           NUMBER(10)      DEFAULT 0, -- Total de transacciones
    ganancia_dia            NUMBER(12,2)    DEFAULT 0, -- Calculada
    
    -- Constraints
    CONSTRAINT PK_CAJA PRIMARY KEY (id_caja),
    CONSTRAINT FK_CAJA_USUARIO_APERTURA FOREIGN KEY (id_usuario_apertura) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT FK_CAJA_USUARIO_CIERRE FOREIGN KEY (id_usuario_cierre) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_CAJA_SALDOS CHECK (saldo_inicial >= 0),
    CONSTRAINT CHK_CAJA_INGRESOS CHECK (ingresos_efectivo >= 0 AND ingresos_tarjeta >= 0 AND ingresos_transferencia >= 0),
    CONSTRAINT CHK_CAJA_EGRESOS CHECK (egresos >= 0),
    CONSTRAINT CHK_CAJA_NUMERO_VENTAS CHECK (numero_ventas >= 0),
    CONSTRAINT CHK_CAJA_CIERRE CHECK (
        (estado = 'ABIERTA' AND fecha_cierre IS NULL AND hora_cierre IS NULL) OR
        (estado IN ('CERRADA', 'CUADRADA') AND fecha_cierre IS NOT NULL AND hora_cierre IS NOT NULL)
    )
);

-- Índices para optimización
CREATE UNIQUE INDEX UK_CAJA_FECHA ON CAJA(fecha);
CREATE INDEX IDX_CAJA_ESTADO ON CAJA(estado);
CREATE INDEX IDX_CAJA_USUARIO_APERTURA ON CAJA(id_usuario_apertura);

-- Comentarios
COMMENT ON TABLE CAJA IS 'Control diario de caja con análisis de ingresos por método de pago';
COMMENT ON COLUMN CAJA.saldo_teorico IS 'Calculado: saldo_inicial + ingresos - egresos';
COMMENT ON COLUMN CAJA.diferencia IS 'saldo_fisico - saldo_teorico (+ sobrante, - faltante)';
COMMENT ON COLUMN CAJA.ganancia_dia IS 'Suma de ganancias de todas las ventas del día';

PROMPT 'Tabla CAJA creada exitosamente.'
