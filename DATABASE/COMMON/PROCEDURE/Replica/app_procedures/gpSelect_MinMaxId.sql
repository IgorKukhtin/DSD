-- Function: _replica.gpSelect_MinMaxId()

DROP FUNCTION IF EXISTS _replica.gpSelect_MinMaxId ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_MinMaxId (
)
RETURNS TABLE (MinId    Integer,
               MaxId    Integer,
               RecCount Bigint
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
       SELECT Min(Id) AS Min_Id, Max(id) AS Max_Id, Count(Id) as RecCount 
       FROM   _replica.table_update_data;
       -- SELECT 102243858 :: Integer AS Min_Id, 430715031 :: Integer AS Max_Id, 328381375:: Bigint as RecCount;
       
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 27.07.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_MinMaxId ()
