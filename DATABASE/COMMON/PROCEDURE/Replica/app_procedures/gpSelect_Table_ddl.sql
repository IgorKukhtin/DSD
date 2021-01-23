-- Function: _replica.gpSelect_Table_ddl()

DROP FUNCTION IF EXISTS _replica.gpSelect_Table_ddl (Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Table_ddl (BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Table_ddl (
    IN inStartId BigInt  -- значение _replica.table_ddl.Id, начиная с которого выбираем записи
)
RETURNS TABLE (Id            BigInt, 
               Query         Text,
               Last_modified timestamp
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT TB.Id, TB.Query, TB.Last_modified 
        FROM   _replica.table_ddl AS TB
        WHERE  TB.Id >= inStartId;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 11.08.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_Table_ddl (0)
