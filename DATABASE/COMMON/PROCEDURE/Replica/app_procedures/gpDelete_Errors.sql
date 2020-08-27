-- Function: _replica.gpDelete_Errors()

DROP FUNCTION IF EXISTS _replica.gpDelete_Errors ();

CREATE OR REPLACE FUNCTION _replica.gpDelete_Errors (
)
RETURNS VOID 
AS
$BODY$      
BEGIN
    DELETE FROM _replica.Errors;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 27.08.20                                                          *              
*/

-- тест
-- SELECT _replica.gpDelete_Errors ()