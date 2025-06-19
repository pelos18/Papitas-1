-- =====================================================
-- TABLA: CORTES_CAJA
-- Descripción: Reportes consolidados de períodos (diario, semanal, mensual)
-- =====================================================

PROMPT 'Creando tabla CORTES_CAJA...'

CREATE TABLE CORTES_CAJA (
    id_corte                NUMBER(10)      NOT NULL,
    fecha_inicio            DATE            NOT NULL,
    fecha_fin               DATE            NOT NULL,
    tipo_corte              VARCHAR2(20)    NOT NULL CHECK (tipo_corte IN ('DIARIO', 'SEMANAL', 'MENSUAL')),
    total_ventas            NUMBER(15,2)    DEFAULT 0,
    total_costos            NUMBER(15,2)    DEFAULT 0,
    ganancia_bruta          NUMBER(15,2)    DEFAULT 0,
    gastos_operativos       NUMBER(15,2)    DEFAULT 0,
    ganancia_neta           NUMBER(15,2)    DEFAULT 0,
    margen_ganancia         NUMBER(5,2)     DEFAULT 0, -- Porcentaje
    total_transacciones     NUMBER(10)      DEFAULT 0,
    productos_vendidos      NUMBER(10)      DEFAULT 0,
    productos_top_5         CLOB,           -- JSON con top 5
    categorias_top          CLOB,           -- JSON con análisis
    id_usuario              NUMBER(10)      NOT NULL,
    fecha_generacion        DATE            DEFAULT SYSDATE NOT NULL,
    
    -- Constraints
    CONSTRAINT PK_CORTES_CAJA PRIMARY KEY (id_corte),
    CONSTRAINT FK_CORTES_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_CORTES_FECHAS CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_CORTES_VALORES CHECK (
        total_ventas >= 0 AND total_costos >= 0 AND 
        ganancia_bruta >= 0 AND gastos_operativos >= 0 AND
        total_transacciones >= 0 AND productos_vendidos >= 0
    ),
    CONSTRAINT CHK_CORTES_MARGEN CHECK (margen_ganancia BETWEEN -100 AND 100)
);

-- Índices para optimización
CREATE INDEX IDX_CORTES_FECHAS ON CORTES_CAJA(fecha_inicio, fecha_fin);
CREATE INDEX IDX_CORTES_TIPO ON CORTES_CAJA(tipo_corte);
CREATE INDEX IDX_CORTES_USUARIO ON CORTES_CAJA(id_usuario);

-- Comentarios
COMMENT ON TABLE CORTES_CAJA IS 'Reportes consolidados con análisis de rentabilidad por períodos';
COMMENT ON COLUMN CORTES_CAJA.productos_top_5 IS 'JSON: [{"producto":"...", "cantidad":..., "ingresos":...}]';
COMMENT ON COLUMN CORTES_CAJA.categorias_top IS 'JSON: [{"categoria":"...", "ventas":..., "margen":...}]';
COMMENT ON COLUMN CORTES_CAJA.margen_ganancia IS 'Porcentaje: (ganancia_neta / total_ventas) * 100';

PROMPT 'Tabla CORTES_CAJA creada exitosamente.'
