-- =====================================================
-- CLAVES FORÁNEAS ADICIONALES
-- Descripción: FKs que referencian tablas creadas posteriormente
-- =====================================================

PROMPT 'Agregando claves foráneas adicionales...'

-- FK para DETALLE_VENTAS -> PROMOCIONES
ALTER TABLE DETALLE_VENTAS 
ADD CONSTRAINT FK_DETALLE_PROMOCIONES 
FOREIGN KEY (id_promocion) REFERENCES PROMOCIONES(id_promocion);

-- FK para DETALLE_VENTAS -> COMBOS
ALTER TABLE DETALLE_VENTAS 
ADD CONSTRAINT FK_DETALLE_COMBOS_REF 
FOREIGN KEY (id_combo) REFERENCES COMBOS(id_combo);

-- FK auto-referencial para CATEGORIAS (subcategorías)
ALTER TABLE CATEGORIAS 
ADD CONSTRAINT FK_CATEGORIAS_PADRE 
FOREIGN KEY (id_categoria_padre) REFERENCES CATEGORIAS(id_categoria);

PROMPT 'Claves foráneas adicionales agregadas exitosamente.'
