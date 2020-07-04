-- Function: gpSelect_Replica_part30()

DROP FUNCTION IF EXISTS gpSelect_Replica_part30 (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_part30(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Value Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
   SELECT 30 AS Part
        , ('LEFT JOIN ' || tmpData.table_name || ' ON ' || tmpData.table_name ||'.' || zfCalc_WordText_Split_replica (tmpData.pk_keys, 1) || ' = zfCalc_WordText_Split_replica (table_update_data.pk_values, 1)'
          || CASE WHEN zfCalc_WordText_Split_replica (tmpData.pk_keys, 2) <> '' THEN ' AND ' || tmpData.table_name ||'.' || zfCalc_WordText_Split_replica (tmpData.pk_keys, 2) || ' = zfCalc_WordText_Split (table_update_data.pk_values, 2)' ELSE '' END
          || CASE WHEN zfCalc_WordText_Split_replica (tmpData.pk_keys, 3) <> '' THEN ' AND ' || tmpData.table_name ||'.' || zfCalc_WordText_Split_replica (tmpData.pk_keys, 3) || ' = zfCalc_WordText_Split (table_update_data.pk_values, 3)' ELSE '' END) :: Text AS Value
   FROM (SELECT DISTINCT table_name, pk_keys
         FROM _replica.table_update_data AS tmp
         WHERE tmp.Id BETWEEN inId_start AND inId_end
         ) AS tmpData;
     
END;
$BODY$


LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 34.07.20          *

*/

-- тест
--SELECT * FROM gpSelect_Replica_part30(307930, 307930)