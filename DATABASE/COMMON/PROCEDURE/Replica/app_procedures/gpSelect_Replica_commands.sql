-- Function: _replica.gpSelect_Replica_commands()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_commands (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_commands (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_commands (
    IN inId_start     BigInt, -- значение table_update_data.Id, начиная с которого будем реплицировать данные
    IN inRec_count    BigInt  -- количество записей из table_update_data, которое предполагается реплицировать
)
RETURNS TABLE (Value Text
)    
AS
$BODY$      
    DECLARE vbId_End    BigInt;
BEGIN

-- if inId_start < 2997657991 THEN inId_start:= 2997657991; END IF;

    -- Нужно передать в gpSelect_Replica_union значения Id из _replica.table_update_data в диапазоне "inId_start..(inId_start + inRec_count)"
    -- и при этом соблюсти условие - "все соответствующие transaction_id находятся в передаваемом диапазоне".
    -- Для этого нужно определить правую границу, которая будет удовлетворять такому условию.
    vbId_End := (SELECT NextId FROM _replica.gpSelect_Replica_LastId (inId_start, inRec_count));


  --RAISE EXCEPTION 'Ошибка. inId_start=<%>  vbId_End=<%>', inId_start, vbId_End;

    RETURN QUERY
        SELECT gpSelect.Value 
        FROM   _replica.gpSelect_Replica_union(inId_start := inId_start,
                                               inId_end   := vbId_End
                                              ) AS gpSelect;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 15.07.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_Replica_commands (inId_start:= 1, inRec_count:= 10000)
