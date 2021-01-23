-- Function: _replica.gpSelect_MinId()

DROP FUNCTION IF EXISTS _replica.gpSelect_MinId ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_MinId (
)
RETURNS BigInt
AS
$BODY$      
    DECLARE vbMinId BigInt;     
BEGIN
    vbMinId:= (SELECT Min(id) AS Min_Id FROM _replica.table_update_data);
                     
    RETURN vbMinId;        
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 31.07.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_MinId ()