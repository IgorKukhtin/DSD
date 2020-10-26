-- Function: _replica.gpSelect_MinMaxId()

DROP FUNCTION IF EXISTS _replica.gpSelect_MinMaxId ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_MinMaxId (
)
RETURNS TABLE (MinId    Bigint,
               MaxId    Bigint,
               RecCount Bigint
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
       WITH tmpRes AS (SELECT Min(Id) AS Min_Id, Max(Id) AS Max_Id FROM _replica.table_update_data)
       --
       SELECT Min_Id :: Bigint, Max_Id :: Bigint, (Max_Id - Min_Id) :: Bigint AS RecCount 
       FROM tmpRes;
       
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
