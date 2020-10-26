-- Function: _replica.gpSelect_Replica_LastId()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_LastId (Integer, Integer);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_LastId (
    IN inId_start     Integer, -- значение table_update_data.Id, начиная с которого будем реплицировать данные
    IN inRec_count    Integer  -- количество записей из table_update_data, которое предполагается реплицировать
)
RETURNS Integer
AS
$BODY$
    DECLARE vbId_End    Integer;
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
       -- нашли время начала этой транзакции
       vbLast_modified:= (SELECT last_modified FROM _replica.table_update_data WHERE Id = vbId_End;

       -- если найдена активная транзакция
       IF EXISTS (SELECT 1 FROM pg_stat_activity WHERE state ILIKE 'active' AND query_start < vbLast_modified + INTERVAL '25 SECOND')
       THEN
           vbId_End:= inId_start - 1;
       END IF;

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

-- WITH tmpParams2 AS (SELECT 789863512 AS Id_start, 200000 AS Rec_count, 0 AS Rec_count_diff)
 WITH tmpParams2 AS (SELECT 651426894 AS Id_start, 200000 AS Rec_count, 80000 AS Rec_count_diff)
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
