-- Function: _replica.gpSelect_Replica_LastId()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_LastId (
    IN inId_start     BigInt, -- значение table_update_data.Id, начиная с которого будем реплицировать данные
    IN inRec_count    BigInt  -- количество записей из table_update_data, которое предполагается реплицировать
)
RETURNS BigInt
AS
$BODY$
    DECLARE vbId_End    BigInt;
    DECLARE vbLast_modified TDateTime;
BEGIN
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
    
    -- если реальное кол-во записей не соответсвует разнице по Id, значит вклинились транзакции, которые не видно, хотя могут быть и "потерянные" Id
    IF (vbId_End - inId_start + 1) <> (SELECT COUNT(*) FROM _replica.table_update_data WHERE Id BETWEEN inId_start AND vbId_End)
    THEN
       -- нашли время начала этой транзакции - здесь значение без timezone
       vbLast_modified:= (SELECT MAX (last_modified) FROM _replica.table_update_data WHERE Id BETWEEN vbId_End AND vbId_End);

       -- Активные процессы
       CREATE TEMP TABLE _tmp_pg_stat_activity ON COMMIT DROP AS SELECT * FROM pg_stat_activity WHERE state ILIKE 'active'
                                                           AND query NOT ILIKE '%_replica.gpSelect_Replica_LastId(%'
                                                           AND query NOT ILIKE '% _replica.gpSelect_Replica_commands(%';

--    RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmp_pg_stat_activity);

       -- если найдена активная транзакция - для значения без timezone
       IF EXISTS (SELECT 1 FROM _tmp_pg_stat_activity WHERE state ILIKE 'active' AND timezone('utc'::text, query_start) < vbLast_modified + INTERVAL '400 SECOND')
       THEN
           vbId_End:= inId_start - 1;
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

    -- Результат
    RETURN vbId_End;

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
-- SELECT _replica.gpSelect_Replica_LastId (3578398023, 200000)
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
