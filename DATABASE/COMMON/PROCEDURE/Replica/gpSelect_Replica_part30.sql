-- Function: _replica.gpSelect_Replica_part30()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_part30 (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_part30 (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_part30(
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
                  SELECT 30 AS Part, 0 AS Sort
                       , ('LEFT JOIN '||tmpData.table_name||' ON '||tmpData.table_name||'.'||_replica.zfCalc_WordText_Split_replica(tmpData.pk_keys,1)||' = CASE WHEN '||_replica.zfStr_CHR_39(tmpData.table_name)||'= table_update_data.table_name THEN CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values,1) AS BigInt) ELSE NULL END'
                         ||CASE WHEN _replica.zfCalc_WordText_Split_replica (tmpData.pk_keys, 2)<> '' THEN ' AND '||tmpData.table_name ||'.'|| _replica.zfCalc_WordText_Split_replica (tmpData.pk_keys, 2)||' = CASE WHEN '||_replica.zfStr_CHR_39(tmpData.table_name)||'= table_update_data.table_name THEN CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 2) AS BigInt) ELSE NULL END' ELSE '' END
                         ||CASE WHEN _replica.zfCalc_WordText_Split_replica (tmpData.pk_keys, 3)<> '' THEN ' AND '||tmpData.table_name ||'.'|| _replica.zfCalc_WordText_Split_replica (tmpData.pk_keys, 3)||' = CASE WHEN '||_replica.zfStr_CHR_39(tmpData.table_name)||'= table_update_data.table_name THEN CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 3) AS BigInt) ELSE NULL END' ELSE '' END) ::Text AS res
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

    --–ÂÁÛÎ¸Ú‡Ú
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , tmpRes.res AS Value
    FROM tmpRes
/*    WHERE tmpRes.part_count = 1 

    -- 2
  UNION ALL
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , SUBSTRING (tmpRes.res, 1, CASE WHEN zfCalc_Position( tmpRes.res, 'AND', vbLen_start) <> 0 THEN vbLen_start + zfCalc_Position( tmpRes.res, 'AND', vbLen_start) - 2 ELSE tmpRes.len_str END) AS Value
    FROM tmpRes
    WHERE tmpRes.part_count = 2 
   UNION ALL
    SELECT tmpRes.Part, (Ord * 10 + 2) :: Integer AS Sort
         , SUBSTRING (tmpRes.res, vbLen_start + zfCalc_Position( tmpRes.res, 'AND', vbLen_start) - 1 , CASE WHEN zfCalc_Position( tmpRes.res, 'AND', vbLen_start) <> 0 THEN (2*vbLen_start + zfCalc_Position( tmpRes.res, 'AND', 2*vbLen_start)) -  (vbLen_start + zfCalc_Position( tmpRes.res, 'AND', vbLen_start)) ELSE 0 END )  AS Value
    FROM tmpRes
    WHERE tmpRes.part_count = 2
   AND SUBSTRING (tmpRes.res, vbLen_start + zfCalc_Position( tmpRes.res, 'AND', vbLen_start) - 1 , CASE WHEN zfCalc_Position( tmpRes.res, 'AND', vbLen_start) <> 0 THEN (2*vbLen_start + zfCalc_Position( tmpRes.res, 'AND', 2*vbLen_start)) -  (vbLen_start + zfCalc_Position( tmpRes.res, 'AND', vbLen_start)) ELSE 0 END ) <> ''
   */
order by 1,2
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
-- SELECT * FROM _replica.gpSelect_Replica_part30 (1, 594837 * 100)
