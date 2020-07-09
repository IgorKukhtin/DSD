-- Function: gpSELECT_Replica_part11()

DROP FUNCTION IF EXISTS gpSELECT_Replica_part11 (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSELECT_Replica_part11(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Sort Integer, Value Text
             , len_str     Integer
             , part_count  Integer
-- , Operation TEXT, table_name TEXT, upd_cols TEXT, pk_keys TEXT
) AS
$BODY$
   DECLARE vbLen_255 Integer;
   DECLARE vbLen_start Integer;
BEGIN

   vbLen_255:= 240;
   vbLen_start:= 200;

   RETURN QUERY
   WITH tmpRes_all AS (
      SELECT 11 AS Part
        , case when a.operation ILIKE 'update'
                  then ' when ' || zfStr_CHR_39 (a.Operation || '-' || a.table_name || '-' || a.upd_cols || '-' || a.pk_keys) || ' THEN '
                   ||  zfStr_CHR_39 ('update ' || a.table_name || ' SET ' || zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' = ')
                   || '||'
                   || a.table_name || '.' || zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' :: TVarChar  '

                   || CASE WHEN zfCalc_WordText_Split_replica (a.upd_cols, 2) <> ''
                      THEN  zfStr_CHR_39 ( ', ' || zfCalc_WordText_Split_replica (a.upd_cols, 2) || ' = ')
                   || '||'
                   || a.table_name || '.' || zfCalc_WordText_Split_replica (a.upd_cols, 2) || ' :: TVarChar  '
                      ELSE '' END

                   || CASE WHEN zfCalc_WordText_Split_replica (a.upd_cols, 3) <> ''
                      THEN  zfStr_CHR_39 ( ', ' || zfCalc_WordText_Split_replica (a.upd_cols, 3) || ' = ')
                   || '||'
                   || a.table_name || '.' || zfCalc_WordText_Split_replica (a.upd_cols, 3) || ' :: TVarChar  '
                      ELSE '' END

                   || CASE WHEN zfCalc_WordText_Split_replica (a.upd_cols, 4) <> ''
                      THEN  zfStr_CHR_39 ( ', ' || zfCalc_WordText_Split_replica (a.upd_cols, 4) || ' = ')
                   || '||'
                   || a.table_name || '.' || zfCalc_WordText_Split_replica (a.upd_cols, 4) || ' :: TVarChar  '
                      ELSE '' END

                   || zfStr_CHR_39 (' where '
                   || zfCalc_WordText_Split_replica (a.pk_keys, 1)  || ' = ') || '||' || a.table_name || '.' || zfCalc_WordText_Split_replica (a.pk_keys, 1)|| ' :: TVarChar ||'

                   || CASE WHEN zfCalc_WordText_Split_replica (a.pk_keys, 2) <> ''
                      THEN zfStr_CHR_39 (' AND '
                        || zfCalc_WordText_Split_replica (a.pk_keys, 2) || ' = ') || '||' || a.table_name || '.' || zfCalc_WordText_Split_replica (a.pk_keys, 2)|| ' :: TVarChar ||'
                      ELSE '' END
                   || CASE WHEN zfCalc_WordText_Split_replica (a.pk_keys, 3) <> ''
                      THEN zfStr_CHR_39 (' AND '
                        || zfCalc_WordText_Split_replica (a.pk_keys, 3) || ' = ') || '||' || a.table_name || '.' || zfCalc_WordText_Split_replica (a.pk_keys, 3)|| ' :: TVarChar ||'
                      ELSE '' END
                   || CASE WHEN zfCalc_WordText_Split_replica (a.pk_keys, 4) <> ''
                      THEN zfStr_CHR_39 (' AND '
                        || zfCalc_WordText_Split_replica (a.pk_keys, 4) || ' = ') || '||' || a.table_name || '.' || zfCalc_WordText_Split_replica (a.pk_keys, 4)|| ' :: TVarChar ||'
                      ELSE '' END
           end :: Text as res
      FROM
       (SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys--, pk_values
        FROM _replica.table_update_data AS tmp
        WHERE tmp.Id BETWEEN inId_start AND inId_end
         AND tmp.operation ILIKE 'update'
       ) AS a

   -- DELETE
UNION SELECT 12 AS Part
           , case when a.operation ILIKE 'delete'
                  then ' when ' || zfStr_CHR_39  (a.Operation || '-' || a.table_name || '-' || COALESCE (a.upd_cols,a.pk_keys) || '-' || a.pk_keys) || ' THEN '
                   || zfStr_CHR_39 ('DELETE FROM  '|| a.table_name || ' where ' || zfCalc_WordText_Split_replica (a.pk_keys, 1) || ' = ') || '|| zfCalc_WordText_Split_replica (table_update_data.pk_values, 1)'
                   ||' :: TVarChar'

                   || CASE WHEN zfCalc_WordText_Split_replica (a.pk_keys, 2) <> ''
                      THEN zfStr_CHR_39 (' AND '
                        || zfCalc_WordText_Split_replica (a.pk_keys, 2) || ' = ') || '|| zfCalc_WordText_Split_replica (table_update_data.pk_values, 2)'
                   ||' :: TVarChar'
                      ELSE '' END
                   || CASE WHEN zfCalc_WordText_Split_replica (a.pk_keys, 3) <> ''
                      THEN zfStr_CHR_39 (' AND '
                        || zfCalc_WordText_Split_replica (a.pk_keys, 3) || ' = ') || '|| zfCalc_WordText_Split_replica (table_update_data.pk_values, 3)'
                   ||' :: TVarChar'
                      ELSE '' END
                   || CASE WHEN zfCalc_WordText_Split_replica (a.pk_keys, 4) <> ''
                      THEN zfStr_CHR_39 (' AND '
                        || zfCalc_WordText_Split_replica (a.pk_keys, 4) || ' = ') || '|| zfCalc_WordText_Split_replica (table_update_data.pk_values, 4)'
                   ||' :: TVarChar'
                      ELSE '' END
           end :: Text AS res
      FROM
         ( SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys--, pk_values
           FROM _replica.table_update_data AS tmp
           WHERE tmp.Id BETWEEN inId_start AND inId_end
            AND tmp.operation ILIKE 'delete'
          ) AS a

-- INSERT
UNION SELECT 13 AS Part
        , case when a.operation ILIKE 'INSERT'
                  then ' when ' || zfStr_CHR_39 (a.Operation || '-' || a.table_name || '-' || COALESCE (a.upd_cols,a.pk_keys) || '-' || a.pk_keys) || ' THEN '
                   || zfStr_CHR_39 ('INSERT INTO ' || a.table_name || ' (' || tmpColumn.COLUMN_NAME|| ') VALUES ( ' || zfStr_CHR_39 ('||' || tmpColumn.COLUMN_NAME_full ||'||' ) ||')' )
            end :: Text AS res
      FROM
         ( SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys
           FROM _replica.table_update_data AS tmp
           WHERE tmp.Id BETWEEN inId_start AND inId_end
            AND tmp.operation ILIKE 'INSERT'
         ) AS a
         LEFT JOIN gpSelect_Replica_Column(inId_start,inId_end) AS tmpColumn ON tmpColumn.Table_Name = a.Table_Name

      ORDER BY 1,2
                   )
   , tmpRes AS (SELECT ROW_NUMBER() OVER (ORDER BY tmpRes_all.Part ASC) AS Ord
                     , LENGTH (tmpRes_all.res) AS len_str
                     , CEIL (LENGTH (tmpRes_all.res) :: TFloat / vbLen_start :: TFloat) AS part_count
                     , tmpRes_all.*
                FROM tmpRes_all)
    --
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , tmpRes.res AS Value
         , tmpRes.len_str    :: Integer
         , tmpRes.part_count :: Integer
    FROM tmpRes
    WHERE tmpRes.part_count = 1 

   UNION ALL
    --
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , tmpRes.res AS Value
         , tmpRes.len_str    :: Integer
         , tmpRes.part_count :: Integer
    FROM tmpRes
    WHERE tmpRes.part_count = 2 

   UNION ALL
    --
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , tmpRes.res AS Value
         , tmpRes.len_str    :: Integer
         , tmpRes.part_count :: Integer
    FROM tmpRes
    WHERE tmpRes.part_count = 2 
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
-- SELECT * FROM gpSelect_Replica_part11 (1, 594837 * 1000)
