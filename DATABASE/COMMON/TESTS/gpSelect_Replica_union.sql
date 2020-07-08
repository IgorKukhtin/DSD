-- Function: gpSelect_Replica_union()

DROP FUNCTION IF EXISTS gpSelect_Replica_union (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_union(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Sort integer, Value Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
      SELECT  9,0, 'SELECT table_update_data.Id'
 UNION SELECT 10,0, ', CASE table_update_data.Operation || ' || zfStr_CHR_39 ('-') || ' || table_update_data.table_name || ' || zfStr_CHR_39 ('-') || ' || COALESCE (table_update_data.upd_cols,table_update_data.pk_keys) || ' || zfStr_CHR_39 ('-') || ' || table_update_data.pk_keys '
 UNION SELECT a.Part , a.Sort , a.Value FROM gpSelect_Replica_part11 (inId_start, inId_end) as a
 UNION SELECT 18,0, ' END :: TVarChar AS RESULT'
UNION SELECT 19,0, ', table_update_data.*'
UNION SELECT 20,0, 'FROM _replica.table_update_data'
UNION SELECT * FROM gpSelect_Replica_part30 (inId_start, inId_end)
UNION SELECT  40,0, 'LEFT JOIN gpSelect_Replica_Column(' || inId_start || ','|| inId_end||' ) AS tmpColumn ON tmpColumn.Table_Name = table_update_data.Table_Name'
UNION SELECT  41,0, 'WHERE table_update_data.Id BETWEEN ' || inId_start :: TVarChar || ' AND ' || inId_end  :: TVarChar
UNION SELECT  42,0, 'ORDER BY table_update_data.Id'
ORDER BY 1,2;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.20          *

*/


-- тест
-- SELECT * FROM gpSelect_Replica_union (594837 - 1000, 594837 + 100)
