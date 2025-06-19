SELECT trigger_name, status
FROM user_triggers;


SELECT column_name as COLUMNA, data_type as TIPO, data_length as TAMAÑO
FROM user_tab_columns 
WHERE table_name = 'PRODUCTOS'
ORDER BY column_id;