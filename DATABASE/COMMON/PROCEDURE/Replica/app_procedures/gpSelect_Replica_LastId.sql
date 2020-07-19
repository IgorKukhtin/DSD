-- Function: gpSelect_Replica_LastId()

DROP FUNCTION IF EXISTS gpSelect_Replica_LastId (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_LastId (
    IN inId_start     Integer, -- значение table_update_data.Id, начиная с которого будем реплицировать данные
    IN inRec_count    Integer  -- количество записей из table_update_data, которое предполагается реплицировать
)
RETURNS Integer     
AS
$BODY$      
    DECLARE vbId_End    Integer;
BEGIN
    -- Нужно передать в gpSelect_Replica_union значения Id из _replica.table_update_data в диапазоне "inId_start..(inId_start + inRec_count)"
    -- и при этом соблюсти условие - "все соответствующие transaction_id находятся в передаваемом диапазоне".
    -- Для этого нужно определить правую границу, которая будет удовлетворять такому условию.
    vbId_End := (SELECT Max(Id) 
                 FROM   _replica.table_update_data 
                 WHERE  transaction_id IN (SELECT DISTINCT transaction_id 
                                           FROM _replica.table_update_data 
                                           WHERE Id 
                                                BETWEEN inId_start 
                                                    AND inId_start + inRec_count
                                          )
                );

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
-- SELECT * FROM gpSelect_Replica_LastId (inId_start:= 1, inRec_count:= 10000)
