-- Function: _replica.gpSelect_Settings()

DROP FUNCTION IF EXISTS _replica.gpSelect_Settings ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_Settings (
)
RETURNS TABLE (Id     Integer,
               Name   Text,
               Value  Text,
               Reserv Text
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT ST.Id, ST.Name, ST.Value, ST.Reserv 
        FROM   _replica.Settings
        AS ST;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 12.08.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_Settings ()
