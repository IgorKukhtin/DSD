-- Function: _replica.gpselect_replica_lastid(bigint, bigint)

-- DROP FUNCTION _replica.gpselect_replica_lastid(bigint, bigint);

CREATE OR REPLACE FUNCTION _replica.gpselect_replica_lastid(
    IN inid_start bigint,
    IN inrec_count bigint)
  RETURNS TABLE(nextid bigint, nextdt tdatetime) AS
$BODY$
    DECLARE vbId_End    BigInt;
    DECLARE vbLast_modified TDateTime;
DECLARE vbId_start_save  BigInt;
BEGIN

vbId_start_save  := inId_start;

    -- Нужно передать в gpSelect_Replica_union значения Id из _replica.table_update_data в диапазоне "inId_start..(inId_start + inRec_count)"
    -- и при этом соблюсти условие - "все соответствующие transaction_id находятся в передаваемом диапазоне".
    -- Для этого нужно определить правую границу, которая будет удовлетворять такому условию.
    vbId_End := (SELECT MAX (Id)
                 FROM _replica.table_update_data
                 WHERE transaction_id IN (SELECT DISTINCT transaction_id
                                          FROM _replica.table_update_data
                                          WHERE Id BETWEEN inId_start AND inId_start + inRec_count
                                         )
                );


    -- могли не найти, т.к. следующий Id за границей диапазона
    IF COALESCE (vbId_End, 0) = 0 AND EXISTS (SELECT Id FROM _replica.table_update_data WHERE Id >= inId_start)
    THEN
        -- находим первого
        inId_start:= (SELECT MIN (Id) FROM _replica.table_update_data WHERE Id >= inId_start);
        -- вторая попытка
        vbId_End := (SELECT MAX (Id)
                     FROM _replica.table_update_data
                     WHERE transaction_id IN (SELECT DISTINCT transaction_id
                                              FROM _replica.table_update_data
                                              WHERE Id BETWEEN inId_start AND inId_start + inRec_count
                                             )
                    );

    END IF;

    -- если нет данных для команд, т.е. они уже удалены
    IF 1 < COALESCE ((SELECT SUM (CASE WHEN Object.Id IS NULL THEN 1 ELSE 0 END) - SUM (CASE WHEN Object.Id > 0 THEN 1 ELSE 0 END)
                      FROM _replica.table_update_data
                           LEFT JOIN Object ON Object.Id = CASE WHEN 'Object' ILIKE table_update_data.table_name THEN CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 1) AS BigInt) ELSE NULL END
                      WHERE table_update_data.Id BETWEEN inId_start AND vbId_End
                        AND operation ILIKE 'INSERT'
                        AND table_name ILIKE 'Object'
                     ), 0)
    THEN
        -- если нет команды DELETE
        IF 1=1
         /*100 > (SELECT COUNT(*)
                  FROM _replica.table_update_data
                       LEFT JOIN soldtable ON soldtable.Id = CASE WHEN 'soldtable' = table_update_data.table_name THEN CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 1) AS BigInt) ELSE NULL END
                  WHERE Id BETWEEN inId_start AND vbId_End
                    AND (soldtable.Id > 0
                      OR table_name ILIKE 'soldtable'
                      OR operation ILIKE 'DELETE')
                 )*/
        THEN
            -- !!!Рекурсия!!!
            vbId_End:= (SELECT gpSelect.NextId FROM _replica.gpSelect_Replica_LastId (vbId_End, CASE WHEN inRec_count >= 100000 THEN inRec_count / 100 ELSE inRec_count END :: Integer) AS gpSelect);

        END IF;

    END IF;


    -- если кол-во записей слишком много
    IF inRec_count * 2 < (SELECT COUNT(Id) FROM _replica.table_update_data WHERE Id BETWEEN inId_start AND vbId_End)
       OR EXISTS (SELECT 1
                  FROM _replica.table_update_data
                     --INNER JOIN soldtable ON soldtable.Id = _replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 1) :: BigInt
                  WHERE table_update_data.Id BETWEEN inId_start AND vbId_End
                    AND table_update_data.table_name ILIKE 'soldtable'
                    AND table_update_data.operation  NOT ILIKE 'DELETE')
    THEN
        -- разорвем транзакцию
        vbId_End:= (SELECT MAX (tmp.Id)
                    FROM (SELECT table_update_data.Id
                          FROM _replica.table_update_data
                               LEFT JOIN soldtable ON soldtable.Id = CASE WHEN table_update_data.table_name ILIKE 'soldtable'
                                                                           AND table_update_data.operation  NOT ILIKE 'DELETE'
                                                                               THEN CAST (_replica.zfCalc_WordText_Split_replica (table_update_data.pk_values, 1) AS BigInt)
                                                                          ELSE NULL
                                                                     END
                          WHERE table_update_data.Id BETWEEN inId_start AND vbId_End + inRec_count
                            AND (soldtable.Id > 0 OR table_update_data.table_name NOT ILIKE 'soldtable' OR table_update_data.operation ILIKE 'DELETE')
                          ORDER BY table_update_data.Id
                          LIMIT (inRec_count / 4) :: Integer + 1
                         ) AS tmp
                   );
    END IF;


    -- Результат
  /*IF vbId_End > 5602489721
    THEN
         vbId_End:=5602489721;
    END IF;*/

    vbId_End:= coalesce ((SELECT max(id) FROM _replica.table_update_data WHERE Id between vbId_start_save  and  vbId_End
                                 AND last_modified < timezone('utc'::text, CURRENT_TIMESTAMP) - CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 8 AND 16
                                                                                                     THEN INTERVAL '135 MINUTES'
                                                                                                     ELSE INTERVAL '155 MINUTES'
                                                                                                   --ELSE INTERVAL '55 MINUTES'
                                                                                                END -- :: INTERVAL
                         ), vbId_start_save - 1);

    RETURN QUERY
      SELECT vbId_End AS NextId, (SELECT last_modified FROM _replica.table_update_data WHERE Id = vbId_End) :: TDateTime AS NextDT
;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION _replica.gpselect_replica_lastid(bigint, bigint)
  OWNER TO admin;

-- тест
-- SELECT * FROM ResourseItemProtocol ORDER BY Id DESC LIMIT 100
-- SELECT NextId, NextId -6708805066, * FROM _replica.gpSelect_Replica_LastId (6708805066, 100000)
