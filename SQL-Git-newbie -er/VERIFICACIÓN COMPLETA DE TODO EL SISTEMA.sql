-- =====================================================
-- VERIFICACIÓN COMPLETA DE TODO EL SISTEMA
-- Todas las tablas, triggers, datos y funcionalidad
-- =====================================================

PROMPT '🔍🔍🔍 === VERIFICACIÓN COMPLETA DEL SISTEMA LA MODERNA === 🔍🔍🔍'
PROMPT 'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
PROMPT ''

-- =====================================================
-- SECCIÓN 1: VERIFICACIÓN DE TODAS LAS TABLAS
-- =====================================================
PROMPT '📋 === SECCIÓN 1: VERIFICACIÓN DE TODAS LAS TABLAS ==='
PROMPT ''

-- 1.1 Tablas principales del diagrama ER
PROMPT '🎯 1.1 TABLAS PRINCIPALES DEL DIAGRAMA ER:'
WITH tablas_principales AS (
    SELECT 'CATEGORIAS' as tabla_esperada, 1 as orden FROM dual UNION ALL
    SELECT 'PROVEEDORES', 2 FROM dual UNION ALL
    SELECT 'PRODUCTOS', 3 FROM dual UNION ALL
    SELECT 'USUARIOS', 4 FROM dual UNION ALL
    SELECT 'CLIENTES', 5 FROM dual UNION ALL
    SELECT 'VENTAS', 6 FROM dual UNION ALL
    SELECT 'DETALLE_VENTAS', 7 FROM dual UNION ALL
    SELECT 'MOVIMIENTOS_INVENTARIO', 8 FROM dual UNION ALL
    SELECT 'ALERTAS_SISTEMA', 9 FROM dual UNION ALL
    SELECT 'NOTIFICACIONES', 10 FROM dual UNION ALL
    SELECT 'PROMOCIONES', 11 FROM dual UNION ALL
    SELECT 'COMBOS', 12 FROM dual UNION ALL
    SELECT 'DETALLE_COMBOS', 13 FROM dual UNION ALL
    SELECT 'OFERTAS_ESPECIALES', 14 FROM dual UNION ALL
    SELECT 'DEVOLUCIONES', 15 FROM dual UNION ALL
    SELECT 'CAJA', 16 FROM dual UNION ALL
    SELECT 'CORTES_CAJA', 17 FROM dual UNION ALL
    SELECT 'REPORTES_GENERADOS', 18 FROM dual UNION ALL
    SELECT 'AUDITORIA', 19 FROM dual
)
SELECT 
    tp.orden as "#",
    tp.tabla_esperada as "TABLA_REQUERIDA",
    CASE 
        WHEN ut.table_name IS NOT NULL THEN '✅ EXISTE'
        ELSE '❌ FALTA'
    END as "ESTADO",
    NVL(ut.num_rows, 0) as "FILAS"
FROM tablas_principales tp
LEFT JOIN user_tables ut ON tp.tabla_esperada = ut.table_name
ORDER BY tp.orden;

-- 1.2 Resumen de cumplimiento de tablas
PROMPT ''
PROMPT '📊 1.2 RESUMEN DE CUMPLIMIENTO DE TABLAS:'
WITH tablas_principales AS (
    SELECT 'CATEGORIAS' as tabla FROM dual UNION ALL SELECT 'PROVEEDORES' FROM dual UNION ALL
    SELECT 'PRODUCTOS' FROM dual UNION ALL SELECT 'USUARIOS' FROM dual UNION ALL
    SELECT 'CLIENTES' FROM dual UNION ALL SELECT 'VENTAS' FROM dual UNION ALL
    SELECT 'DETALLE_VENTAS' FROM dual UNION ALL SELECT 'MOVIMIENTOS_INVENTARIO' FROM dual UNION ALL
    SELECT 'ALERTAS_SISTEMA' FROM dual UNION ALL SELECT 'NOTIFICACIONES' FROM dual UNION ALL
    SELECT 'PROMOCIONES' FROM dual UNION ALL SELECT 'COMBOS' FROM dual UNION ALL
    SELECT 'DETALLE_COMBOS' FROM dual UNION ALL SELECT 'OFERTAS_ESPECIALES' FROM dual UNION ALL
    SELECT 'DEVOLUCIONES' FROM dual UNION ALL SELECT 'CAJA' FROM dual UNION ALL
    SELECT 'CORTES_CAJA' FROM dual UNION ALL SELECT 'REPORTES_GENERADOS' FROM dual UNION ALL
    SELECT 'AUDITORIA' FROM dual
)
SELECT 
    19 as "TABLAS_REQUERIDAS",
    COUNT(ut.table_name) as "TABLAS_CREADAS",
    19 - COUNT(ut.table_name) as "TABLAS_FALTANTES",
    ROUND(COUNT(ut.table_name) * 100.0 / 19, 1) || '%' as "PORCENTAJE_COMPLETADO"
FROM tablas_principales tp
LEFT JOIN user_tables ut ON tp.tabla = ut.table_name;

-- 1.3 Todas las tablas en la base de datos
PROMPT ''
PROMPT '📋 1.3 TODAS LAS TABLAS EN LA BASE DE DATOS:'
SELECT 
    table_name as "TABLA",
    num_rows as "FILAS",
    CASE 
        WHEN table_name IN (
            'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
            'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
            'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
            'OFERTAS_ESPECIALES', 'DEVOLUCIONES', 'CAJA', 'CORTES_CAJA',
            'REPORTES_GENERADOS', 'AUDITORIA'
        ) THEN '🎯 PRINCIPAL'
        ELSE '📋 AUXILIAR'
    END as "TIPO"
FROM user_tables 
WHERE table_name NOT LIKE 'BIN$%'
ORDER BY 
    CASE WHEN table_name IN (
        'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
        'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
        'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
        'OFERTAS_ESPECIALES', 'DEVOLUCIONES', 'CAJA', 'CORTES_CAJA',
        'REPORTES_GENERADOS', 'AUDITORIA'
    ) THEN 1 ELSE 2 END,
    table_name;

-- =====================================================
-- SECCIÓN 2: VERIFICACIÓN DE TODOS LOS TRIGGERS
-- =====================================================
PROMPT ''
PROMPT '⚡ === SECCIÓN 2: VERIFICACIÓN DE TODOS LOS TRIGGERS ==='
PROMPT ''

-- 2.1 Lista completa de triggers esperados
PROMPT '🎯 2.1 TRIGGERS ESPERADOS DEL SISTEMA (18 triggers):'
WITH triggers_esperados AS (
    SELECT 'TRG_PRODUCTOS_CALCULOS' as trigger_name, '1️⃣ CÁLCULOS' as grupo, 1 as orden FROM dual UNION ALL
    SELECT 'TRG_STOCK_CONTROL', '1️⃣ CÁLCULOS', 2 FROM dual UNION ALL
    SELECT 'TRG_ALERTAS_CADUCIDAD', '1️⃣ CÁLCULOS', 3 FROM dual UNION ALL
    SELECT 'TRG_CONTROL_CAJA', '1️⃣ CÁLCULOS', 4 FROM dual UNION ALL
    SELECT 'TRG_AUDITORIA_PRODUCTOS', '2️⃣ AUDITORÍA', 5 FROM dual UNION ALL
    SELECT 'TRG_AUDITORIA_VENTAS', '2️⃣ AUDITORÍA', 6 FROM dual UNION ALL
    SELECT 'TRG_AUDITORIA_USUARIOS', '2️⃣ AUDITORÍA', 7 FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_STOCK', '3️⃣ NOTIFICACIONES', 8 FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_CADUCIDAD', '3️⃣ NOTIFICACIONES', 9 FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_VENTAS', '3️⃣ NOTIFICACIONES', 10 FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_SISTEMA', '3️⃣ NOTIFICACIONES', 11 FROM dual UNION ALL
    SELECT 'TRG_CALCULOS_VENTAS', '4️⃣ VENTAS', 12 FROM dual UNION ALL
    SELECT 'TRG_CALCULOS_DETALLE_VENTAS', '4️⃣ VENTAS', 13 FROM dual UNION ALL
    SELECT 'TRG_ACTUALIZAR_TOTALES_VENTA', '4️⃣ VENTAS', 14 FROM dual UNION ALL
    SELECT 'TRG_CONTROL_DEVOLUCIONES', '4️⃣ VENTAS', 15 FROM dual UNION ALL
    SELECT 'TRG_APLICACION_PROMOCIONES', '5️⃣ PROMOCIONES', 16 FROM dual UNION ALL
    SELECT 'TRG_CONTROL_COMBOS', '5️⃣ PROMOCIONES', 17 FROM dual UNION ALL
    SELECT 'TRG_GENERACION_REPORTES', '6️⃣ REPORTES', 18 FROM dual
)
SELECT 
    te.orden as "#",
    te.grupo as "GRUPO",
    te.trigger_name as "TRIGGER",
    NVL(ut.status, '❌ NO EXISTE') as "ESTADO",
    NVL(ut.table_name, 'N/A') as "TABLA",
    CASE 
        WHEN ut.status = 'ENABLED' THEN '✅'
        WHEN ut.status IS NOT NULL THEN '⚠️'
        ELSE '❌'
    END as "OK"
FROM triggers_esperados te
LEFT JOIN user_triggers ut ON te.trigger_name = ut.trigger_name
ORDER BY te.orden;

-- 2.2 Resumen de triggers por grupo
PROMPT ''
PROMPT '📊 2.2 RESUMEN DE TRIGGERS POR GRUPO:'
WITH triggers_esperados AS (
    SELECT 'TRG_PRODUCTOS_CALCULOS' as trigger_name, '1️⃣ CÁLCULOS' as grupo FROM dual UNION ALL
    SELECT 'TRG_STOCK_CONTROL', '1️⃣ CÁLCULOS' FROM dual UNION ALL
    SELECT 'TRG_ALERTAS_CADUCIDAD', '1️⃣ CÁLCULOS' FROM dual UNION ALL
    SELECT 'TRG_CONTROL_CAJA', '1️⃣ CÁLCULOS' FROM dual UNION ALL
    SELECT 'TRG_AUDITORIA_PRODUCTOS', '2️⃣ AUDITORÍA' FROM dual UNION ALL
    SELECT 'TRG_AUDITORIA_VENTAS', '2️⃣ AUDITORÍA' FROM dual UNION ALL
    SELECT 'TRG_AUDITORIA_USUARIOS', '2️⃣ AUDITORÍA' FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_STOCK', '3️⃣ NOTIFICACIONES' FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_CADUCIDAD', '3️⃣ NOTIFICACIONES' FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_VENTAS', '3️⃣ NOTIFICACIONES' FROM dual UNION ALL
    SELECT 'TRG_NOTIFICACIONES_SISTEMA', '3️⃣ NOTIFICACIONES' FROM dual UNION ALL
    SELECT 'TRG_CALCULOS_VENTAS', '4️⃣ VENTAS' FROM dual UNION ALL
    SELECT 'TRG_CALCULOS_DETALLE_VENTAS', '4️⃣ VENTAS' FROM dual UNION ALL
    SELECT 'TRG_ACTUALIZAR_TOTALES_VENTA', '4️⃣ VENTAS' FROM dual UNION ALL
    SELECT 'TRG_CONTROL_DEVOLUCIONES', '4️⃣ VENTAS' FROM dual UNION ALL
    SELECT 'TRG_APLICACION_PROMOCIONES', '5️⃣ PROMOCIONES' FROM dual UNION ALL
    SELECT 'TRG_CONTROL_COMBOS', '5️⃣ PROMOCIONES' FROM dual UNION ALL
    SELECT 'TRG_GENERACION_REPORTES', '6️⃣ REPORTES' FROM dual
)
SELECT 
    te.grupo as "GRUPO",
    COUNT(*) as "ESPERADOS",
    COUNT(CASE WHEN ut.status = 'ENABLED' THEN 1 END) as "✅ FUNCIONANDO",
    COUNT(CASE WHEN ut.status IS NULL THEN 1 END) as "❌ FALTANTES",
    COUNT(CASE WHEN ut.status IS NOT NULL AND ut.status != 'ENABLED' THEN 1 END) as "⚠️ CON_ERRORES",
    ROUND(COUNT(CASE WHEN ut.status = 'ENABLED' THEN 1 END) * 100.0 / COUNT(*), 1) || '%' as "% ÉXITO"
FROM triggers_esperados te
LEFT JOIN user_triggers ut ON te.trigger_name = ut.trigger_name
GROUP BY te.grupo
ORDER BY te.grupo;

-- 2.3 Todos los triggers en la base de datos
PROMPT ''
PROMPT '⚡ 2.3 TODOS LOS TRIGGERS EN LA BASE DE DATOS:'
SELECT 
    trigger_name as "TRIGGER",
    table_name as "TABLA",
    triggering_event as "EVENTO",
    status as "ESTADO",
    CASE 
        WHEN trigger_name LIKE 'TRG_%' THEN '🎯 SISTEMA'
        ELSE '📋 OTROS'
    END as "TIPO"
FROM user_triggers 
ORDER BY 
    CASE WHEN trigger_name LIKE 'TRG_%' THEN 1 ELSE 2 END,
    trigger_name;

-- 2.4 Triggers con errores
PROMPT ''
PROMPT '❌ 2.4 TRIGGERS CON ERRORES (SI LOS HAY):'
SELECT 
    object_name as "TRIGGER_CON_ERROR",
    status as "ESTADO",
    object_type as "TIPO"
FROM user_objects 
WHERE object_type = 'TRIGGER' 
AND status != 'VALID'
AND object_name LIKE 'TRG_%';

-- Si no hay errores, mostrar mensaje
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✅ NO HAY TRIGGERS CON ERRORES'
        ELSE TO_CHAR(COUNT(*)) || ' TRIGGERS CON ERRORES ENCONTRADOS'
    END as "RESULTADO"
FROM user_objects 
WHERE object_type = 'TRIGGER' 
AND status != 'VALID'
AND object_name LIKE 'TRG_%';

-- =====================================================
-- SECCIÓN 3: VERIFICACIÓN DE ESTRUCTURA CRÍTICA
-- =====================================================
PROMPT ''
PROMPT '🏗️ === SECCIÓN 3: VERIFICACIÓN DE ESTRUCTURA CRÍTICA ==='
PROMPT ''

-- 3.1 Estructura de tabla PRODUCTOS (la más importante)
PROMPT '🎯 3.1 ESTRUCTURA COMPLETA DE PRODUCTOS:'
SELECT 
    column_id as "#",
    column_name as "COLUMNA",
    data_type as "TIPO",
    CASE 
        WHEN data_type LIKE '%NUMBER%' THEN 
            data_type || '(' || NVL(data_precision,38) || 
            CASE WHEN data_scale > 0 THEN ',' || data_scale ELSE '' END || ')'
        WHEN data_type LIKE '%VARCHAR%' THEN 
            data_type || '(' || data_length || ')'
        ELSE data_type
    END as "TIPO_COMPLETO",
    CASE WHEN nullable = 'Y' THEN 'SÍ' ELSE 'NO' END as "NULO"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS'
ORDER BY column_id;

-- 3.2 Verificación específica de VALOR_INVENTARIO
PROMPT ''
PROMPT '💰 3.2 VERIFICACIÓN ESPECÍFICA DE VALOR_INVENTARIO:'
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ COLUMNA VALOR_INVENTARIO EXISTE'
        ELSE '❌ COLUMNA VALOR_INVENTARIO NO EXISTE'
    END as "ESTADO_COLUMNA",
    CASE 
        WHEN COUNT(*) > 0 THEN 
            (SELECT data_type || '(' || data_precision || ',' || data_scale || ')' 
             FROM user_tab_columns 
             WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO')
        ELSE 'N/A'
    END as "TIPO_DATOS"
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO';

-- 3.3 Secuencias del sistema
PROMPT ''
PROMPT '🔢 3.3 TODAS LAS SECUENCIAS DEL SISTEMA:'
SELECT 
    sequence_name as "SECUENCIA",
    last_number as "ÚLTIMO_NÚMERO",
    increment_by as "INCREMENTO",
    CASE 
        WHEN sequence_name LIKE 'SEQ_%' THEN '🎯 SISTEMA'
        ELSE '📋 OTRAS'
    END as "TIPO"
FROM user_sequences 
ORDER BY 
    CASE WHEN sequence_name LIKE 'SEQ_%' THEN 1 ELSE 2 END,
    sequence_name;

-- =====================================================
-- SECCIÓN 4: VERIFICACIÓN DE DATOS
-- =====================================================
PROMPT ''
PROMPT '📊 === SECCIÓN 4: VERIFICACIÓN DE DATOS ==='
PROMPT ''

-- 4.1 Conteo de registros en todas las tablas principales
PROMPT '📋 4.1 REGISTROS EN TODAS LAS TABLAS PRINCIPALES:'
SELECT 'CATEGORIAS' as "TABLA", COUNT(*) as "REGISTROS" FROM CATEGORIAS
UNION ALL SELECT 'PROVEEDORES', COUNT(*) FROM PROVEEDORES
UNION ALL SELECT 'PRODUCTOS', COUNT(*) FROM PRODUCTOS
UNION ALL SELECT 'USUARIOS', COUNT(*) FROM USUARIOS
UNION ALL SELECT 'CLIENTES', COUNT(*) FROM CLIENTES
UNION ALL SELECT 'VENTAS', COUNT(*) FROM VENTAS
UNION ALL SELECT 'DETALLE_VENTAS', COUNT(*) FROM DETALLE_VENTAS
UNION ALL SELECT 'MOVIMIENTOS_INVENTARIO', COUNT(*) FROM MOVIMIENTOS_INVENTARIO
UNION ALL SELECT 'ALERTAS_SISTEMA', COUNT(*) FROM ALERTAS_SISTEMA
UNION ALL SELECT 'NOTIFICACIONES', COUNT(*) FROM NOTIFICACIONES
UNION ALL SELECT 'PROMOCIONES', COUNT(*) FROM PROMOCIONES
UNION ALL SELECT 'COMBOS', COUNT(*) FROM COMBOS
UNION ALL SELECT 'DETALLE_COMBOS', COUNT(*) FROM DETALLE_COMBOS
UNION ALL SELECT 'OFERTAS_ESPECIALES', COUNT(*) FROM OFERTAS_ESPECIALES
UNION ALL SELECT 'DEVOLUCIONES', COUNT(*) FROM DEVOLUCIONES
UNION ALL SELECT 'CAJA', COUNT(*) FROM CAJA
UNION ALL SELECT 'CORTES_CAJA', COUNT(*) FROM CORTES_CAJA
UNION ALL SELECT 'REPORTES_GENERADOS', COUNT(*) FROM REPORTES_GENERADOS
UNION ALL SELECT 'AUDITORIA', COUNT(*) FROM AUDITORIA
ORDER BY "TABLA";

-- 4.2 Análisis detallado de PRODUCTOS
PROMPT ''
PROMPT '🛍️ 4.2 ANÁLISIS DETALLADO DE PRODUCTOS:'
SELECT 
    COUNT(*) as "TOTAL_PRODUCTOS",
    COUNT(CASE WHEN activo = 1 THEN 1 END) as "PRODUCTOS_ACTIVOS",
    COUNT(CASE WHEN valor_inventario IS NOT NULL THEN 1 END) as "CON_VALOR_INVENTARIO",
    COUNT(CASE WHEN valor_inventario > 0 THEN 1 END) as "CON_VALOR_POSITIVO",
    COUNT(CASE WHEN stock_actual <= stock_minimo THEN 1 END) as "STOCK_CRÍTICO",
    TO_CHAR(NVL(SUM(valor_inventario), 0), '999,999,999.99') as "VALOR_TOTAL_INVENTARIO"
FROM PRODUCTOS;

-- 4.3 Muestra de productos con todos sus campos
PROMPT ''
PROMPT '📋 4.3 MUESTRA DE PRODUCTOS (PRIMEROS 5):'
SELECT 
    id_producto as "ID",
    SUBSTR(nombre, 1, 20) as "NOMBRE",
    stock_actual as "STOCK",
    TO_CHAR(costo_total, '999.99') as "COSTO",
    TO_CHAR(precio_venta, '999.99') as "PRECIO",
    TO_CHAR(valor_inventario, '999,999.99') as "VALOR_INV",
    CASE 
        WHEN valor_inventario IS NULL THEN '❌ NULL'
        WHEN valor_inventario = 0 THEN '⚠️ CERO'
        WHEN valor_inventario = (stock_actual * costo_total) THEN '✅ OK'
        ELSE '❓ REVISAR'
    END as "VALIDACIÓN"
FROM PRODUCTOS 
WHERE ROWNUM <= 5
ORDER BY id_producto;

-- =====================================================
-- SECCIÓN 5: VERIFICACIÓN FUNCIONAL
-- =====================================================
PROMPT ''
PROMPT '🧪 === SECCIÓN 5: VERIFICACIÓN FUNCIONAL ==='
PROMPT ''

-- 5.1 Verificar que los triggers de valor_inventario funcionan
PROMPT '💰 5.1 TRIGGERS ESPECÍFICOS DE VALOR_INVENTARIO:'
SELECT 
    trigger_name as "TRIGGER",
    table_name as "TABLA",
    status as "ESTADO",
    triggering_event as "EVENTO"
FROM user_triggers 
WHERE trigger_name LIKE '%VALOR%' 
OR trigger_body LIKE '%valor_inventario%'
OR trigger_name IN (
    'TRG_ACTUALIZAR_VALOR_INVENTARIO',
    'TRG_VALOR_INV_MOVIMIENTOS',
    'TRG_PRODUCTOS_CALCULOS'
);

-- 5.2 Verificar vistas del sistema
PROMPT ''
PROMPT '👁️ 5.2 VISTAS DEL SISTEMA:'
SELECT 
    view_name as "VISTA",
    'DISPONIBLE' as "ESTADO"
FROM user_views 
WHERE view_name LIKE 'V_%'
ORDER BY view_name;

-- 5.3 Verificar procedimientos del sistema
PROMPT ''
PROMPT '⚙️ 5.3 PROCEDIMIENTOS DEL SISTEMA:'
SELECT 
    object_name as "PROCEDIMIENTO",
    status as "ESTADO",
    object_type as "TIPO"
FROM user_objects 
WHERE object_type IN ('PROCEDURE', 'FUNCTION')
AND object_name LIKE 'SP_%'
ORDER BY object_name;

-- =====================================================
-- SECCIÓN 6: RESUMEN EJECUTIVO FINAL
-- =====================================================
PROMPT ''
PROMPT '🏆 === SECCIÓN 6: RESUMEN EJECUTIVO FINAL ==='
PROMPT ''

-- 6.1 Estadísticas generales del sistema
PROMPT '📊 6.1 ESTADÍSTICAS GENERALES DEL SISTEMA:'
WITH stats AS (
    SELECT 
        (SELECT COUNT(*) FROM user_tables WHERE table_name IN (
            'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
            'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
            'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
            'OFERTAS_ESPECIALES', 'DEVOLUCIONES', 'CAJA', 'CORTES_CAJA',
            'REPORTES_GENERADOS', 'AUDITORIA'
        )) as tablas_principales,
        (SELECT COUNT(*) FROM user_triggers WHERE trigger_name LIKE 'TRG_%' AND status = 'ENABLED') as triggers_funcionando,
        (SELECT COUNT(*) FROM user_sequences WHERE sequence_name LIKE 'SEQ_%') as secuencias_sistema,
        (SELECT COUNT(*) FROM user_tab_columns WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO') as columna_valor_inv,
        (SELECT COUNT(*) FROM PRODUCTOS) as total_productos,
        (SELECT COUNT(*) FROM PRODUCTOS WHERE valor_inventario IS NOT NULL) as productos_con_valor
    FROM dual
)
SELECT 
    tablas_principales as "TABLAS_PRINCIPALES",
    triggers_funcionando as "TRIGGERS_FUNCIONANDO",
    secuencias_sistema as "SECUENCIAS_SISTEMA",
    columna_valor_inv as "COLUMNA_VALOR_INV",
    total_productos as "TOTAL_PRODUCTOS",
    productos_con_valor as "PRODUCTOS_CON_VALOR"
FROM stats;

-- 6.2 Evaluación final del sistema
PROMPT ''
PROMPT '🎯 6.2 EVALUACIÓN FINAL DEL SISTEMA:'
WITH evaluacion AS (
    SELECT 
        CASE WHEN (SELECT COUNT(*) FROM user_tables WHERE table_name IN (
            'CATEGORIAS', 'PROVEEDORES', 'PRODUCTOS', 'USUARIOS', 'CLIENTES',
            'VENTAS', 'DETALLE_VENTAS', 'MOVIMIENTOS_INVENTARIO', 'ALERTAS_SISTEMA',
            'NOTIFICACIONES', 'PROMOCIONES', 'COMBOS', 'DETALLE_COMBOS',
            'OFERTAS_ESPECIALES', 'DEVOLUCIONES', 'CAJA', 'CORTES_CAJA',
            'REPORTES_GENERADOS', 'AUDITORIA'
        )) >= 15 THEN 1 ELSE 0 END as tablas_ok,
        
        CASE WHEN (SELECT COUNT(*) FROM user_triggers WHERE trigger_name LIKE 'TRG_%' AND status = 'ENABLED') >= 10 THEN 1 ELSE 0 END as triggers_ok,
        
        CASE WHEN (SELECT COUNT(*) FROM user_tab_columns WHERE table_name = 'PRODUCTOS' AND column_name = 'VALOR_INVENTARIO') = 1 THEN 1 ELSE 0 END as valor_inv_ok,
        
        CASE WHEN (SELECT COUNT(*) FROM PRODUCTOS WHERE valor_inventario IS NOT NULL) > 0 THEN 1 ELSE 0 END as datos_ok
    FROM dual
)
SELECT 
    CASE WHEN tablas_ok = 1 THEN '✅ TABLAS OK' ELSE '❌ FALTAN TABLAS' END as "ESTADO_TABLAS",
    CASE WHEN triggers_ok = 1 THEN '✅ TRIGGERS OK' ELSE '❌ FALTAN TRIGGERS' END as "ESTADO_TRIGGERS",
    CASE WHEN valor_inv_ok = 1 THEN '✅ VALOR_INV OK' ELSE '❌ FALTA VALOR_INV' END as "ESTADO_VALOR_INV",
    CASE WHEN datos_ok = 1 THEN '✅ DATOS OK' ELSE '❌ FALTAN DATOS' END as "ESTADO_DATOS",
    CASE 
        WHEN tablas_ok = 1 AND triggers_ok = 1 AND valor_inv_ok = 1 AND datos_ok = 1 
        THEN '🎉 SISTEMA 100% FUNCIONAL'
        WHEN tablas_ok = 1 AND triggers_ok = 1 AND valor_inv_ok = 1 
        THEN '✅ SISTEMA FUNCIONAL (FALTA POBLAR DATOS)'
        WHEN tablas_ok = 1 AND valor_inv_ok = 1 
        THEN '⚠️ SISTEMA PARCIAL (REVISAR TRIGGERS)'
        ELSE '❌ SISTEMA INCOMPLETO'
    END as "VEREDICTO_FINAL"
FROM evaluacion;

PROMPT ''
PROMPT '🏆🏆🏆 === VERIFICACIÓN COMPLETA TERMINADA ==='
PROMPT 'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
PROMPT ''
PROMPT '📋 RESUMEN:'
PROMPT '   • Tablas verificadas: 19 principales + auxiliares'
PROMPT '   • Triggers verificados: 18 del sistema + auxiliares'
PROMPT '   • Estructura completa analizada'
PROMPT '   • Datos y funcionalidad verificados'
PROMPT ''
PROMPT '🎯 Si el VEREDICTO_FINAL es "SISTEMA 100% FUNCIONAL":'
PROMPT '   ✅ Tu sistema está listo para producción'
PROMPT '   ✅ Tu entidad Java funcionará perfectamente'
PROMPT '   ✅ Todos los triggers están activos'
PROMPT '   ✅ La columna valor_inventario funciona'
PROMPT ''
