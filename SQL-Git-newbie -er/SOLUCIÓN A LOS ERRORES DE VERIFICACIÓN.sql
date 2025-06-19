-- =====================================================
-- SOLUCIÓN A LOS ERRORES DE VERIFICACIÓN
-- =====================================================

PROMPT '🔧 === SOLUCIONANDO ERRORES ENCONTRADOS ==='
PROMPT ''

-- PASO 1: Verificar qué usuarios existen
PROMPT '👤 PASO 1: Verificando usuarios existentes...'
SELECT id_usuario, usuario, nombre, apellidos, rol 
FROM USUARIOS 
ORDER BY id_usuario;

-- PASO 2: Si no hay usuarios, crear uno básico
PROMPT ''
PROMPT '👤 PASO 2: Creando usuario básico si no existe...'

-- Verificar si existe usuario con ID 1
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM USUARIOS WHERE id_usuario = 1;
    
    IF v_count = 0 THEN
        INSERT INTO USUARIOS (
            id_usuario, usuario, password, nombre, apellidos, 
            rol, activo, fecha_creacion
        ) VALUES (
            1, 'admin', 'admin123', 'Administrador', 'Sistema',
            'ADMIN', 1, SYSDATE
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('✅ Usuario administrador creado con ID 1');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✅ Usuario con ID 1 ya existe');
    END IF;
END;
/

-- PASO 3: Verificar categorías y proveedores
PROMPT ''
PROMPT '📂 PASO 3: Verificando categorías y proveedores...'

-- Crear categoría si no existe
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM CATEGORIAS WHERE id_categoria = 1;
    
    IF v_count = 0 THEN
        INSERT INTO CATEGORIAS (id_categoria, nombre, descripcion, activo)
        VALUES (1, 'GENERAL', 'Categoría general', 1);
        DBMS_OUTPUT.PUT_LINE('✅ Categoría creada con ID 1');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✅ Categoría con ID 1 ya existe');
    END IF;
END;
/

-- Crear proveedor si no existe
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM PROVEEDORES WHERE id_proveedor = 1;
    
    IF v_count = 0 THEN
        INSERT INTO PROVEEDORES (id_proveedor, nombre, empresa, activo)
        VALUES (1, 'Proveedor General', 'Empresa General', 1);
        DBMS_OUTPUT.PUT_LINE('✅ Proveedor creado con ID 1');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✅ Proveedor con ID 1 ya existe');
    END IF;
END;
/

COMMIT;

PROMPT ''
PROMPT '✅ Datos básicos verificados y creados si era necesario'
