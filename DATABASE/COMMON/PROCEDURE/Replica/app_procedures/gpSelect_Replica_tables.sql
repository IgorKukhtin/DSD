-- Function: _replica.gpSelect_Replica_tables()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_tables ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_tables (
)
RETURNS TABLE (Master_table Text,
               Slave_table Text
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT RTS.Master_table, RTS.Slave_table 
        FROM   _replica.table_slave
        AS RTS
        ORDER BY RTS.Master_table;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 05.08.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_Replica_tables()
