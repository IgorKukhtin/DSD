-- Function: _replica.gpSELECT_Replica_part10()

DROP FUNCTION IF EXISTS _replica.gpSELECT_Replica_part11 (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSELECT_Replica_part10 (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSELECT_Replica_part10 (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSELECT_Replica_part10(
    IN inId_start     BigInt,
    IN inId_end       BigInt
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
   WITH tmpRes_all AS 
       -- UPDATE
      (WITH tmpTable  AS (SELECT * FROM _replica.gpSelect_Replica_Table (inId_start, inId_end))
          , tmpColumn AS (SELECT * FROM _replica.gpSelect_Replica_Column(inId_start,inId_end))
       SELECT 10 AS Part
            , case when a.operation ILIKE 'update'
                      then ' when ' || _replica.zfStr_CHR_39 ('UPDATE-container-{Amount}-Id' || CASE WHEN a.table_name ILIKE 'container' AND a.upd_cols ILIKE '{Amount}' THEN '' ELSE '==not==' END)
                       || ' THEN '
--                     ||  _replica.zfStr_CHR_39 ('UPDATE ' || a.table_name || ' SET ' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' = ')
                       ||  _replica.zfStr_CHR_39 ('UPDATE Container SET ' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' = ')
--                     ||  _replica.zfStr_CHR_39 ('UPDATE Container SET Amount = ')
                       || '|| COALESCE (table_update_data.Amount, 0.0) ||'

                       || _replica.zfStr_CHR_39 (' where '

                       || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 1)  || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 1)|| ' AS Text)'
    
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2) <> ''
                          THEN '||'  || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2) || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2)|| ' AS Text)'
                          ELSE '' END
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3) <> ''
                          THEN '||'  || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3) || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3)|| ' AS Text)'
                          ELSE '' END
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4) <> ''
                          THEN '||'  || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4) || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4)|| ' AS Text)'
                          ELSE '' END


                       || ' when ' || _replica.zfStr_CHR_39 (a.Operation || '-' || a.table_name || '-' || a.upd_cols || '-' || a.pk_keys) || ' THEN '
                       ||  _replica.zfStr_CHR_39 ('update ' || a.table_name || ' SET ' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' = ')
                       || '|| COALESCE (replace (CAST('
                       ||          CASE WHEN tmpTable1.COLUMN_TYPENAME ILIKE 'TVarChar'
                                          OR tmpTable1.COLUMN_TYPENAME ILIKE 'TDateTime'
                                          OR tmpTable1.COLUMN_TYPENAME ILIKE 'INTERVAL'
                                          OR tmpTable1.COLUMN_TYPENAME ILIKE 'Text'
                                          OR tmpTable1.COLUMN_TYPENAME ILIKE 'TBlob'
                                          OR tmpTable1.COLUMN_TYPENAME ILIKE 'Timestamp'
                                        THEN _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || '||' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' AS Text), CHR (39), ''`'') ||' || _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || ', ''NULL'') ||'
                                        ELSE a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' AS Text), CHR (39), ''`''), ''NULL'') ||'
                                   END

    
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.upd_cols, 2) <> ''
                          THEN  _replica.zfStr_CHR_39 ( ', ' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 2) || ' = ')
                       || '|| COALESCE (replace (CAST('
                       ||          CASE WHEN tmpTable2.COLUMN_TYPENAME ILIKE 'TVarChar'
                                          OR tmpTable2.COLUMN_TYPENAME ILIKE 'TDateTime'
                                          OR tmpTable2.COLUMN_TYPENAME ILIKE 'INTERVAL'
                                          OR tmpTable2.COLUMN_TYPENAME ILIKE 'Text'
                                          OR tmpTable2.COLUMN_TYPENAME ILIKE 'TBlob'
                                          OR tmpTable2.COLUMN_TYPENAME ILIKE 'Timestamp'
                                        THEN _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || '||' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 2) || ' AS Text), CHR (39), ''`'') ||' || _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || ', ''NULL'') ||'
                                        ELSE a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 2) || ' AS Text), CHR (39), ''`''), ''NULL'') ||'
                                   END
                          ELSE '' END
    
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.upd_cols, 3) <> ''
                          THEN  _replica.zfStr_CHR_39 ( ' , ' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 3) || ' = ')
                       || '|| COALESCE (replace (CAST('
                       ||          CASE WHEN tmpTable3.COLUMN_TYPENAME ILIKE 'TVarChar'
                                          OR tmpTable3.COLUMN_TYPENAME ILIKE 'TDateTime'
                                          OR tmpTable3.COLUMN_TYPENAME ILIKE 'INTERVAL'
                                          OR tmpTable3.COLUMN_TYPENAME ILIKE 'Text'
                                          OR tmpTable3.COLUMN_TYPENAME ILIKE 'TBlob'
                                          OR tmpTable3.COLUMN_TYPENAME ILIKE 'Timestamp'
                                        THEN _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || '||' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 3) || ' AS Text), CHR (39), ''`'') ||' || _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || ', ''NULL'') ||'
                                        ELSE a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 3) || ' AS Text), CHR (39), ''`''), ''NULL'') ||'
                                   END
                          ELSE '' END
    
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.upd_cols, 4) <> ''
                          THEN  _replica.zfStr_CHR_39 ( ', ' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 4) || ' = ')
                       || '|| COALESCE (replace (CAST('
                       ||          CASE WHEN tmpTable4.COLUMN_TYPENAME ILIKE 'TVarChar'
                                          OR tmpTable4.COLUMN_TYPENAME ILIKE 'TDateTime'
                                          OR tmpTable4.COLUMN_TYPENAME ILIKE 'INTERVAL'
                                          OR tmpTable4.COLUMN_TYPENAME ILIKE 'Text'
                                          OR tmpTable4.COLUMN_TYPENAME ILIKE 'TBlob'
                                          OR tmpTable4.COLUMN_TYPENAME ILIKE 'Timestamp'
                                        THEN _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || '||' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 4) || ' AS Text), CHR (39), ''`'') ||' || _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || ', ''NULL'') ||'
                                        ELSE a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.upd_cols, 4) || ' AS Text), CHR (39), ''`''), ''NULL'') ||'
                                   END
                          ELSE '' END
    
                       || _replica.zfStr_CHR_39 (' where '
                       || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 1)  || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 1)|| ' AS Text)'
    
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2) <> ''
                          THEN '||'  || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2) || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2)|| ' AS Text)'
                          ELSE '' END
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3) <> ''
                          THEN '||'  || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3) || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3)|| ' AS Text)'
                          ELSE '' END
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4) <> ''
                          THEN '||'  || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4) || ' = ') || ' || CAST(' || a.table_name || '.' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4)|| ' AS Text)'
                          ELSE '' END
               end :: Text as res
          FROM
           (SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys--, pk_values
            FROM _replica.table_update_data AS tmp
            WHERE tmp.Id BETWEEN inId_start AND inId_end
             AND tmp.operation ILIKE 'update'
           ) AS a
           LEFT JOIN tmpTable AS tmpTable1 ON tmpTable1.TABLE_NAME  ILIKE a.table_name
                                          AND tmpTable1.COLUMN_NAME ILIKE _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1)
                                          AND _replica.zfCalc_WordText_Split_replica (a.upd_cols, 1) <> ''
           LEFT JOIN tmpTable AS tmpTable2 ON tmpTable2.TABLE_NAME  ILIKE a.table_name
                                          AND tmpTable2.COLUMN_NAME ILIKE _replica.zfCalc_WordText_Split_replica (a.upd_cols, 2)
                                          AND _replica.zfCalc_WordText_Split_replica (a.upd_cols, 2) <> ''
           LEFT JOIN tmpTable AS tmpTable3 ON tmpTable3.TABLE_NAME  ILIKE a.table_name
                                          AND tmpTable3.COLUMN_NAME ILIKE _replica.zfCalc_WordText_Split_replica (a.upd_cols, 3)
                                          AND _replica.zfCalc_WordText_Split_replica (a.upd_cols, 3) <> ''
           LEFT JOIN tmpTable AS tmpTable4 ON tmpTable4.TABLE_NAME  ILIKE a.table_name
                                          AND tmpTable4.COLUMN_NAME ILIKE _replica.zfCalc_WordText_Split_replica (a.upd_cols, 4)
                                          AND _replica.zfCalc_WordText_Split_replica (a.upd_cols, 4) <> ''
           LEFT JOIN tmpTable AS tmpTable5 ON tmpTable5.TABLE_NAME  ILIKE a.table_name
                                          AND tmpTable5.COLUMN_NAME ILIKE _replica.zfCalc_WordText_Split_replica (a.upd_cols, 5)
                                          AND _replica.zfCalc_WordText_Split_replica (a.upd_cols, 5) <> ''
    
         -- DELETE
         UNION
          SELECT 11 AS Part
               , case when a.operation ILIKE 'delete' AND a.table_name ILIKE 'MovementItemContainer'
                      then ' when ' || _replica.zfStr_CHR_39  (a.Operation || '-' || a.table_name || '-' || COALESCE (a.upd_cols,a.pk_keys) || '-' || a.pk_keys) || ' THEN '
                       || _replica.zfStr_CHR_39 ('DELETE FROM  '|| a.table_name || ' where MovementId = ') || '|| CAST (table_update_data.MovementId'
                       ||' AS Text)'

                      when a.operation ILIKE 'delete'
                      then ' when ' || _replica.zfStr_CHR_39  (a.Operation || '-' || a.table_name || '-' || COALESCE (a.upd_cols,a.pk_keys) || '-' || a.pk_keys) || ' THEN '
                       || _replica.zfStr_CHR_39 ('DELETE FROM  '|| a.table_name || ' where ' || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 1) || ' = ') || '|| CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 1)'
                       ||' AS Text)'
    
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2) <> ''
                          THEN ' ||' || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 2) || ' = ') || '|| CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 2)'
                       ||' AS Text)'
                          ELSE '' END
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3) <> ''
                          THEN ' ||' || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 3) || ' = ') || '|| CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 3)'
                       ||' AS Text)'
                          ELSE '' END
                       || CASE WHEN _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4) <> ''
                          THEN ' ||' || _replica.zfStr_CHR_39 (' AND '
                            || _replica.zfCalc_WordText_Split_replica (a.pk_keys, 4) || ' = ') || '|| CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 4)'
                       ||' AS Text)'
                          ELSE '' END
               end :: Text AS res
          FROM
             ( SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys--, pk_values
               FROM _replica.table_update_data AS tmp
               WHERE tmp.Id BETWEEN inId_start AND inId_end
                AND tmp.operation ILIKE 'delete'
              ) AS a
    
      -- INSERT
      UNION
       SELECT 12 AS Part
            , case when a.operation ILIKE 'INSERT'
                      then ' when ' || _replica.zfStr_CHR_39 (a.Operation || '-' || a.table_name || '-' || COALESCE (a.upd_cols,a.pk_keys) || '-' || a.pk_keys) || ' THEN '

                    -- !!!ON CONFLICT - RAISE EXCEPTION!!!
                    -- || _replica.zfStr_CHR_39 ('INSERT INTO ' || a.table_name || ' (' || tmpColumn.COLUMN_NAME|| ') VALUES ( ' || _replica.zfStr_CHR_39 ('||' || tmpColumn.COLUMN_NAME_full ||'||' ) ||')')

                       --  !!!ON CONFLICT DO NOTHING!!!
                       || _replica.zfStr_CHR_39 ('INSERT INTO ' || a.table_name || ' (' || tmpColumn.COLUMN_NAME|| ') VALUES ( ' || _replica.zfStr_CHR_39 ('||' || tmpColumn.COLUMN_NAME_full ||'||' ) ||') ON CONFLICT DO NOTHING')

                end :: Text AS res
          FROM
             ( SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys
               FROM _replica.table_update_data AS tmp
               WHERE tmp.Id BETWEEN inId_start AND inId_end
                AND tmp.operation ILIKE 'INSERT'
             ) AS a
             LEFT JOIN tmpColumn ON tmpColumn.Table_Name = a.Table_Name
    
          ORDER BY 1,2
                       )
       , tmpRes AS (SELECT ROW_NUMBER() OVER (ORDER BY tmpRes_all.Part ASC) AS Ord
                         , LENGTH (tmpRes_all.res) AS len_str
                         , CEIL (LENGTH (tmpRes_all.res) :: TFloat / vbLen_start :: TFloat) AS part_count
                         , tmpRes_all.*
                    FROM tmpRes_all)

    --–ÂÁÛÎ¸Ú‡Ú
    SELECT tmpRes.Part, (Ord * 10 + 1) :: Integer AS Sort
         , tmpRes.res AS Value
         , tmpRes.len_str    :: Integer
         , tmpRes.part_count :: Integer
    FROM tmpRes
   UNION
    SELECT 10 :: Integer AS Part, 11 :: Integer AS Sort
         , 'WHEN ' || _replica.zfStr_CHR_39 ('') || ' THEN ' || _replica.zfStr_CHR_39 ('') AS Value
         , 0 :: Integer
         , 0 :: Integer
    WHERE NOT EXISTS (SELECT 1 FROM tmpRes)

    ORDER BY 1, 2
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
--  SELECT * FROM _replica.gpSELECT_Replica_part10 (1, 594837 * 100)
