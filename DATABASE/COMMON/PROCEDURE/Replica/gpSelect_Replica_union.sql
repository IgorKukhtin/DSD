-- Function: _replica.gpSelect_Replica_union()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_union (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_union (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_union(
    IN inId_start     BigInt,
    IN inId_end       BigInt
)
RETURNS TABLE (Part Integer, Sort integer, Value Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
           SELECT 1, 0, 'SELECT table_update_data.Id'
     UNION SELECT 2, 0, ', CAST (_replica.zfCalc_Text_replace (CASE table_update_data.Operation || ' || _replica.zfStr_CHR_39 ('-') || ' || table_update_data.table_name || ' || _replica.zfStr_CHR_39 ('-') || ' || COALESCE (table_update_data.upd_cols,table_update_data.pk_keys) || ' || _replica.zfStr_CHR_39 ('-') || ' || table_update_data.pk_keys '
     UNION SELECT gpSelect.Part, gpSelect.Sort, gpSelect.Value FROM _replica.gpSelect_Replica_part10 (inId_start, inId_end) AS gpSelect
     UNION SELECT 17,0, ' END, ' || _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || ', CHR(39)) AS TEXT) AS RESULT'
     UNION SELECT 18,0, ', table_update_data.*'
     UNION SELECT 20,0, 'FROM _replica.table_update_data'
     UNION SELECT gpSelect.Part, gpSelect.Sort, gpSelect.Value FROM _replica.gpSelect_Replica_part30 (inId_start, inId_end) AS gpSelect
 --  UNION SELECT  38,0, 'LEFT JOIN gpSelect_Replica_Column(' || inId_start || ','|| inId_end||' ) AS tmpColumn ON tmpColumn.Table_Name = table_update_data.Table_Name'
     UNION SELECT  40,0, 'WHERE table_update_data.Id BETWEEN ' || inId_start :: TVarChar || ' AND ' || inId_end  :: TVarChar
--    UNION SELECT  41,0, '  AND table_update_data.table_name NOT ILIKE ' || _replica.zfStr_CHR_39 ('reportprotocol')
--    UNION SELECT  41,0, '  AND table_update_data.table_name NOT ILIKE ' || _replica.zfStr_CHR_39 ('resourseprotocol')
--    UNION SELECT  41,0, '  AND table_update_data.table_name NOT ILIKE ' || _replica.zfStr_CHR_39 ('userprotocol')
     
     UNION SELECT  47,0, '  AND (table_update_data.Operation ILIKE ' || _replica.zfStr_CHR_39 ('DELETE')
     UNION SELECT  48,0, '    OR CASE '
     UNION SELECT gpSelect.Part, gpSelect.Sort, gpSelect.Value FROM _replica.gpSelect_Replica_part50 (inId_start, inId_end) AS gpSelect
     UNION SELECT  54,0, '      END > 0)'
     UNION SELECT  55,0, 'ORDER BY table_update_data.Id'

     ORDER BY 1, 2;

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
-- SELECT * FROM _replica.gpSelect_Replica_union (1, 594837 * 100)
