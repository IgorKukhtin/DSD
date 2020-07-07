-- Function: gpSelect_Replica_part11()

DROP FUNCTION IF EXISTS gpSelect_Replica_part11 (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_part11(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Value Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
   SELECT 11
          -- UPDATE
        , ', CASE WHEN table_update_data.Operation = ' || CHR (39) || 'UPDATE' || CHR (39) || ' THEN ' || CHR (39) || 'UPDATE ' || table_update_data.table_name ||' SET '|| zfCalc_WordText_Split_replica (upd_cols,1) || ' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,1)
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 2) <> '' THEN ', '||zfCalc_WordText_Split_replica (upd_cols, 2)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,2) ELSE '' END
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 3) <> '' THEN ', '||zfCalc_WordText_Split_replica (upd_cols, 3)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,3) ELSE '' END
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 4) <> '' THEN ', '||zfCalc_WordText_Split_replica (upd_cols, 4)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,4) ELSE '' END
          ||''||' WHERE '|| table_update_data.table_name||'.'|| table_update_data.pk_keys || ' = '|| table_update_data.pk_values|| CHR (39)
          -- DELETE
          ||' WHEN table_update_data.Operation = ' || CHR (39) || 'DELETE' || CHR (39) || ' THEN ' || CHR (39) || 'DELETE FROM ' || table_update_data.table_name
              ||' WHERE '|| table_update_data.table_name||'.'|| table_update_data.pk_keys || ' = '|| table_update_data.pk_values|| CHR (39)
          -- INSERT
          ||' WHEN table_update_data.Operation = ' || CHR (39) || 'INSERT' || CHR (39) || ' THEN ' || CHR (39) || 'INSERT INTO ' || table_update_data.table_name ||' ('|| tmpColumn.COLUMN_NAME || ') VALUES ('|| tmpColumn.COLUMN_NAME_full||')'
              ||' WHERE '|| table_update_data.table_name||'.'|| table_update_data.pk_keys || ' = '|| table_update_data.pk_values|| CHR (39)
          --
          ||' ELSE ' || CHR (39) || CHR (39) || ' END'
   FROM (SELECT DISTINCT Operation, table_name, upd_cols, pk_keys, pk_values
         FROM _replica.table_update_data AS tmp
         WHERE tmp.Id BETWEEN inId_start AND inId_end
         ) AS table_update_data
         LEFT JOIN gpSelect_Replica_Column(inId_start,inId_end) AS tmpColumn ON tmpColumn.Table_Name = table_update_data.Table_Name
   ;
     
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 04.07.20          *

*/
-- ÚÂÒÚ
--SELECT * FROM gpSelect_Replica_part11(507180, 507184)