-- Function: _replica.gpSelect_Replica_LastId()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_LastId (
    IN inId_start     BigInt, -- значение table_update_data.Id, начиная с которого будем реплицировать данные
    IN inRec_count    BigInt  -- количество записей из table_update_data, которое предполагается реплицировать
)
RETURNS TABLE (NextId    Bigint
             , NextDT    TDateTime
              )
AS
$BODY$
    DECLARE vbId_End    BigInt;
    DECLARE vbLast_modified TDateTime;
BEGIN

    -- IF inRec_count >= 200000 OR 1=1
    /*IF inId_start < 6981958236
    THEN
        vbId_End:= (SELECT MAX (Id)
                    FROM _replica.table_update_data
                    WHERE Id BETWEEN inId_start AND inId_start + inRec_count/4
                   );
        IF 8000 > (SELECT COUNT(*)
                   FROM _replica.table_update_data
                   WHERE Id BETWEEN inId_start AND vbId_End
                  )
        THEN
            vbId_End:= (SELECT MAX (Id)
                        FROM _replica.table_update_data
                        WHERE Id BETWEEN inId_start AND inId_start + inRec_count/2
                       );
        END IF;

        --
        RETURN QUERY
          SELECT vbId_End AS NextId, (SELECT last_modified FROM _replica.table_update_data WHERE Id = vbId_End) :: TDateTime AS NextDT;

    ELSE*/

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

    -- если реальное кол-во записей не соответсвует разнице по Id, значит вклинились транзакции, которых не видно, хотя могут быть и "потерянные" Id
    IF (vbId_End - inId_start + 1) <> (SELECT COUNT(*) FROM _replica.table_update_data WHERE Id BETWEEN inId_start AND vbId_End)
       OR EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT BETWEEN 10 AND 16
       OR 1=1
    THEN
        -- делаем задержку на 200 MIN
/*        vbId_End:= COALESCE ((SELECT MAX (Id) FROM _replica.table_update_data
                              WHERE Id BETWEEN inId_start AND vbId_End
                                AND last_modified < timezone('utc'::text, CURRENT_TIMESTAMP) - CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 10 AND 16
                                                                                                    THEN INTERVAL '80 MINUTES'
                                                                                                    WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 17 AND 23
                                                                                                    THEN INTERVAL '120 MINUTES'
                                                                                                    ELSE INTERVAL '200 MINUTES'
                                                                                               END -- :: INTERVAL
                             ), inId_start - 1);
*/

    -- нашли время начала этой транзакции - здесь значение без timezone
    vbLast_modified:= (SELECT MAX (last_modified) FROM _replica.table_update_data WHERE Id BETWEEN vbId_End AND vbId_End);

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmp_pg_stat_activity')
    THEN
        DELETE FROM _tmp_pg_stat_activity;

        INSERT INTO _tmp_pg_stat_activity SELECT * FROM pg_stat_activity
                                          WHERE state ILIKE 'active'
                                            AND query NOT ILIKE '%_replica.gpSelect_Replica_LastId(%'
                                            AND query NOT ILIKE '% _replica.gpSelect_Replica_commands(%'
                                            AND query NOT ILIKE '% VACUUM%'
                                            AND query NOT ILIKE 'SELECT ' || CHR (39) || '(' || CHR (39) ||' || CASE WHEN CAST (movementitemcontainer.id AS Text) IS NULL THEN ' || CHR (39) || 'NULL' || CHR (39) || ' ELSE CAST (movementitemcontainer.id AS Text) END||%'
                                           ;

    ELSE

       -- Активные процессы
       CREATE TEMP TABLE _tmp_pg_stat_activity ON COMMIT DROP AS SELECT * FROM pg_stat_activity
                                                                 WHERE state ILIKE 'active'
                                                                   AND query NOT ILIKE '%_replica.gpSelect_Replica_LastId(%'
                                                                   AND query NOT ILIKE '% _replica.gpSelect_Replica_commands(%'
                                                                   AND query NOT ILIKE '% VACUUM%'
                                                                   AND query NOT ILIKE 'SELECT ' || CHR (39) || '(' || CHR (39) ||' || CASE WHEN CAST (movementitemcontainer.id AS Text) IS NULL THEN ' || CHR (39) || 'NULL' || CHR (39) || ' ELSE CAST (movementitemcontainer.id AS Text) END||%'
                                                                  ;
    END IF;
--    RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmp_pg_stat_activity);

       -- если найдена активная транзакция - для значения без timezone
       IF EXISTS (SELECT 1 FROM _tmp_pg_stat_activity
                  WHERE state ILIKE 'active'
                    AND timezone('utc'::text, query_start) < vbLast_modified + CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 8 AND 15
                                                                                    THEN INTERVAL'800 SECOND'
                                                                                    ELSE INTERVAL'70 MINUTES'
                                                                               END
                 )
       THEN
         --vbId_End:= inId_start - 1;

         -- делаем задержку на 25/80 MIN
         vbId_End:= COALESCE ((SELECT MAX (Id) FROM _replica.table_update_data
                               WHERE Id BETWEEN inId_start AND vbId_End
                                 AND last_modified < timezone('utc'::text, CURRENT_TIMESTAMP) - CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 8 AND 15
                                                                                                     THEN INTERVAL '25 MINUTES'
                                                                                                     ELSE INTERVAL '75 MINUTES'
                                                                                                   --ELSE INTERVAL '55 MINUTES'
                                                                                                END -- :: INTERVAL
                              ), inId_start - 1);

       END IF;

       -- Item
       INSERT INTO ResourseItemProtocol (pid
                                       , query_start_no_timezone
                                       , query_start
                                       , datname
                                       , usename
                                       , client_addr
                                       , state
                                     --, wait_event_type
                                     --, wait_event
                                       , waiting
                                       , query
                                       , InsertDate
                                       , Id_start
                                       , Id_end
                                       , Last_modified
                                        )
          SELECT tmp.pid
                 -- здесь значение без timezone
               , timezone('utc'::text, tmp.query_start)
               , tmp.query_start
               , tmp.datname
               , tmp.usename
               , tmp.client_addr
               , tmp.state
             --, tmp.wait_event_type
             --, tmp.wait_event
               , tmp.waiting
               , tmp.query
               , CURRENT_TIMESTAMP
               , inId_start
               , vbId_End
                 -- здесь значение без timezone
               , vbLast_modified
          FROM _tmp_pg_stat_activity AS tmp;

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

  /*vbId_End:= COALESCE ((SELECT max(id) FROM _replica.table_update_data WHERE Id between vbId_start_save  and  vbId_End
                                 AND last_modified < timezone('utc'::text, CURRENT_TIMESTAMP) - CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 9 AND 15
                                                                                                     THEN INTERVAL '25 MINUTES'
                                                                                                     ELSE INTERVAL '75 MINUTES'
                                                                                                   --ELSE INTERVAL '55 MINUTES'
                                                                                                END -- :: INTERVAL
                         ), vbId_start_save - 1);*/


    RETURN QUERY
      SELECT vbId_End AS NextId, (SELECT last_modified FROM _replica.table_update_data WHERE Id = vbId_End) :: TDateTime AS NextDT;

  --END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 15.07.20                                                          *
*/

-- тест
-- SELECT * FROM ResourseItemProtocol ORDER BY Id DESC LIMIT 100
-- SELECT NextId, NextId -6708805066, * FROM _replica.gpSelect_Replica_LastId (6708805066, 100000)
/*
 WITH tmpParams2 AS (SELECT 789863512 AS Id_start, 200000 AS Rec_count, 0 AS Rec_count_diff)
-- WITH tmpParams2 AS (SELECT 651426894 AS Id_start, 200000 AS Rec_count, 80000 AS Rec_count_diff)
    , tmpParams AS (SELECT COALESCE ((SELECT MAX (Id) FROM _replica.table_update_data WHERE (SELECT Rec_count_diff FROM tmpParams2) > 0) - (SELECT Rec_count_diff FROM tmpParams2 WHERE Rec_count_diff > 0)
                                   , (SELECT Id_start FROM tmpParams2)) AS Id_start
                         , (SELECT Rec_count FROM tmpParams2) AS Rec_count
                   )
    , tmpRes AS (SELECT _replica.gpSelect_Replica_LastId (inId_start:= (SELECT Id_start FROM tmpParams), inRec_count:= (SELECT Rec_count FROM tmpParams)) AS Id_end)
    , tmpCount AS (SELECT COUNT(*) AS Rec_count_real FROM _replica.table_update_data WHERE Id >= (SELECT Id_start FROM tmpParams) AND Id <= (SELECT Id_end FROM tmpRes))
    SELECT (SELECT Id_start FROM tmpParams)       AS Id_start
         , (SELECT Id_end FROM tmpRes)            AS Id_end
         , (SELECT Rec_count_real FROM tmpCount)  AS Rec_count_real
         , (SELECT Id_end FROM tmpRes) - (SELECT Id_start FROM tmpParams) + 1 AS Rec_count_calc
         , (SELECT Rec_count      FROM tmpParams) AS Rec_count
*/
-- SELECT NextId - 5940705656, * FROM _replica.gpSelect_Replica_LastId (5940705656, 100000) 

-- 1. alter table movementitem DROP CONSTRAINT  fk_movementitem_movementid;
-- 2. alter table movementlinkobject DROP CONSTRAINT  fk_movementlinkobject_object;
-- 3. alter table movementlinkmovement DROP CONSTRAINT  fk_movementlinkmovement_movementchild;
-- 4. alter table objectlink DROP CONSTRAINT  fk_objectlink_childobjectid;

-- Err1 = 6868762052
-- Err1 = 6869046441
-- Err2 = 6969343464
-- Err2 = 6970098890
-- Err2 = 6971651623