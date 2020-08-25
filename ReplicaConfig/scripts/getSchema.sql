 SELECT n.nspname AS "Name", 
   pg_catalog.pg_get_userbyid(n.nspowner) AS "Owner", 
   pg_catalog.array_to_string(n.nspacl, E'\n') AS "Access privileges", 
   pg_catalog.obj_description(n.oid, 'pg_namespace') AS "Description" 
 FROM pg_catalog.pg_namespace n 
 WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema' 
 ORDER BY 1;