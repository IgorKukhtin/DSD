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
        , ', CASE WHEN table_update_data.Operation = ' || CHR (39) || 'UPDATE' || CHR (39) || ' THEN UPDATE ' || table_update_data.table_name ||' SET '|| zfCalc_WordText_Split_replica (upd_cols,1) || ' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,1)
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 2) <> '' THEN ', '||zfCalc_WordText_Split_replica (upd_cols, 2)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,2) ELSE '' END
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 3) <> '' THEN ', '||zfCalc_WordText_Split_replica (upd_cols, 3)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,3) ELSE '' END
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 4) <> '' THEN ', '||zfCalc_WordText_Split_replica (upd_cols, 4)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,4) ELSE '' END
          -- DELETE
          ||' WHEN table_update_data.Operation = ' || CHR (39) || 'DELETE' || CHR (39) || ' THEN DELETE FROM ' || table_update_data.table_name ||' WHERE '|| zfCalc_WordText_Split_replica (upd_cols,1) || ' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,1)
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 2) <> '' THEN ' AND '||zfCalc_WordText_Split_replica (upd_cols, 2)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,2) ELSE '' END
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 3) <> '' THEN ' AND '||zfCalc_WordText_Split_replica (upd_cols, 3)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,3) ELSE '' END
          ||''|| CASE WHEN zfCalc_WordText_Split_replica (upd_cols, 4) <> '' THEN ' AND '||zfCalc_WordText_Split_replica (upd_cols, 4)||' = '|| table_update_data.table_name ||'.'||zfCalc_WordText_Split_replica (upd_cols,4) ELSE '' END
          --
          ||' ELSE ' || CHR (39) || CHR (39) || ' END'
   FROM (SELECT DISTINCT Operation, table_name, upd_cols
         FROM _replica.table_update_data AS tmp
         WHERE tmp.Id BETWEEN inId_start AND inId_end
         ) AS table_update_data;
     
END;
$BODY$


LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 34.07.20          *

*/

-- ����
--SELECT * FROM gpSelect_Replica_part11(307930, 307930)