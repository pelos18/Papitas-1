-- =====================================================
-- SCRIPT 00: LIMPIAR BASE DE DATOS COMPLETA
-- Elimina todo para empezar desde cero
-- =====================================================

-- Desactivar restricciones temporalmente
BEGIN
    FOR c IN (SELECT table_name, constraint_name FROM user_constraints WHERE constraint_type = 'R') LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE ' || c.table_name || ' DROP CONSTRAINT ' || c.constraint_name;
    END LOOP;
END;
/

-- Eliminar triggers
BEGIN
    FOR t IN (SELECT trigger_name FROM user_triggers) LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || t.trigger_name;
    END LOOP;
END;
/

-- Eliminar procedimientos
BEGIN
    FOR p IN (SELECT object_name FROM user_objects WHERE object_type = 'PROCEDURE') LOOP
        EXECUTE IMMEDIATE 'DROP PROCEDURE ' || p.object_name;
    END LOOP;
END;
/

-- Eliminar funciones
BEGIN
    FOR f IN (SELECT object_name FROM user_objects WHERE object_type = 'FUNCTION') LOOP
        EXECUTE IMMEDIATE 'DROP FUNCTION ' || f.object_name;
    END LOOP;
END;
/

-- Eliminar vistas
BEGIN
    FOR v IN (SELECT view_name FROM user_views) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v.view_name;
    END LOOP;
END;
/

-- Eliminar tablas
BEGIN
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- Eliminar secuencias
BEGIN
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

COMMIT;

PROMPT ✅ Base de datos limpiada completamente
