-- Function: _replica.gpSelect_Replica_LastId()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_LastId(
    IN inId_start     BigInt, -- значение table_update_data.Id, начиная с которого будем реплицировать данные
    IN inRec_count    BigInt  -- количество записей из table_update_data, которое предполагается реплицировать
)
RETURNS TABLE (NextId    Bigint
             , NextDT    TDateTime
              )
AS
$BODY$
    DECLARE vbId_start_save BigInt;
    DECLARE vbId_End        BigInt;
    --
    DECLARE vb_pId         Bigint;
    DECLARE vb_Waiting     Boolean;
    DECLARE vb_UseName     TVarChar;
    DECLARE vb_Query       TVarChar;
    DECLARE vb_State       TVarChar;
    DECLARE vb_Query_start TDateTime;
    DECLARE vb_Count       Integer;
BEGIN

    -- !!!
    vbId_start_save:= inId_start;


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


    IF 1=0
    THEN
          -- CREATE EXTENSION dblink;
          --
          -- Активные процессы
          SELECT gpSelect.pId
               , gpSelect.Waiting
               , gpSelect.UseName
               , gpSelect.Query
               , gpSelect.State
               , gpSelect.Query_start
               , gpSelect.vb_Count
                 -- нашли время начала этой транзакции - здесь значение с timezone
                 INTO vb_pId
                    , vb_.Waiting
                    , vb_UseName
                    , vb_Query
                    , vb_State
                    , vb_Query_start
                    , vb_Count
          FROM (WITH tmp_activity AS (SELECT gpSelect.pId
                                           , gpSelect.Waiting
                                           , gpSelect.UseName
                                           , gpSelect.Query
                                           , gpSelect.State
                                           , gpSelect.Query_start
                                      FROM dblink('host=192.168.0.219 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL' :: Text
                                                , (' SELECT pId, Waiting, UseName, Query, State, Query_start'
                                                || ' FROM gpSelect_pg_stat_activity()') :: Text
                                                 ) AS gpSelect (pId         Bigint
                                                              , Waiting     Boolean
                                                              , UseName     TVarChar
                                                              , Query       TVarChar
                                                              , State       TVarChar
                                                              , Query_start TDateTime
                                                               )
                                     )
                SELECT gpSelect.pId
                     , gpSelect.Waiting
                     , gpSelect.UseName
                     , gpSelect.Query
                     , gpSelect.State
                     , gpSelect.Query_start
                     , (SELECT COUNT(*) FROM tmp_activity) AS vb_Count
                FROM tmp_activity
                ORDER BY tmp_activity.Query_start
                LIMIT 1
               ) AS gpSelect
         ;

       -- тест
       RAISE EXCEPTION 'Ошибка.<%>', vb_Count;

       -- если найдена активная транзакция - для значения без timezone
       IF vb_Count > 0
       THEN
         -- замена, делаем задержку на 120 SEC
         vbId_End:= COALESCE ((SELECT MAX (Id) FROM _replica.table_update_data
                               WHERE Id BETWEEN inId_start AND vbId_End
                                 AND last_modified < timezone('utc'::text, vb_Query_start - INTERVAL '120 SEC' FROM _tmp_pg_stat_activity))
                              ), inId_start - 1);
       ELSE
         -- замена, делаем задержку на 240 SEC
         vbId_End:= COALESCE ((SELECT MAX (Id) FROM _replica.table_update_data
                               WHERE Id BETWEEN inId_start AND vbId_End
                                 AND last_modified < timezone('utc'::text, CURRENT_TIMESTAMP - INTERVAL '240 SEC')
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
               , timezone('utc'::text, vb_Query_start)
               , vb_query_start
               , vb_datname
               , vb_usename
               , vb_vb_client_addr
               , vb_state
             --, tmp.wait_event_type
             --, tmp.wait_event
               , vb_waiting
               , vb_query
               , CURRENT_TIMESTAMP
               , inId_start
               , vbId_End
                 -- здесь значение с timezone
               , vb_Query_start
          ;

    END IF;


    -- Результат
    /*IF vbId_End > 5602489721
    THEN
         vbId_End:=5602489721;
    END IF;*/
    --
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
