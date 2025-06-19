SELECT table_name AS name, 'TABLE' AS type FROM user_tables
UNION
SELECT view_name AS name, 'VIEW' AS type FROM user_views
ORDER BY type, name;