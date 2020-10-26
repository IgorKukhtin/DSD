-- Function: _replica.gpSelect_Replica_part50()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_part50 (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_part50 (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_part50(
    IN inId_start     BigInt,
    IN inId_end       BigInt
)
RETURNS TABLE (Part Integer,  Sort Integer, Value Text
) AS
$BODY$
   DECLARE vbLen_255 Integer;
   DECLARE vbLen_start Integer;
BEGIN

   vbLen_255:= 240;
   vbLen_start:= 180;

   RETURN QUERY 
   WITH
   tmpRes_all AS (
                  SELECT 50 AS Part, 0 AS Sort
                       , '  WHEN table_update_data.table_name = ' || _replica.zfStr_CHR_39 (tmpData.table_name)||' THEN ' || tmpData.table_name ||'.'|| _replica.zfCalc_WordText_Split_replica (tmpData.pk_keys, 1) AS res
                  FROM (SELECT DISTINCT table_name, pk_keys
                        FROM _replica.table_update_data AS tmp
                        WHERE tmp.Id BETWEEN inId_start AND inId_end
                        ) AS tmpData
                  )
   , tmpRes AS (SELECT ROW_NUMBER() OVER (ORDER BY tmpRes_all.Part ASC) AS Ord
                     , LENGTH (tmpRes_all.res) AS len_str
                     , CEIL (LENGTH (tmpRes_all.res) :: TFloat / vbLen_start :: TFloat) AS part_count
                     , tmpRes_all.*
                FROM tmpRes_all)

    -- Результат
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , tmpRes.res AS Value
    FROM tmpRes

   UNION
    SELECT 50 :: Integer AS Part, 51 :: Integer AS Sort
         , 'WHEN 1=0 THEN 0'
    WHERE NOT EXISTS (SELECT 1 FROM tmpRes)

    ORDER BY 1, 2
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.20          *

*/

-- тест
-- SELECT * FROM _replica.gpSelect_Replica_part50 (1, 594837 * 100)
