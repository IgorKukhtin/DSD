-- Function: _replica.gpSelect_MaxId()

DROP FUNCTION IF EXISTS _replica.gpSelect_MaxId ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_MaxId (
)
RETURNS Integer   
AS
$BODY$      
    DECLARE vbMaxId Integer;     
BEGIN
    vbMaxId:= (SELECT Max(id) AS Max_Id FROM _replica.table_update_data);
                     
    RETURN vbMaxId;        
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 31.07.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_MaxId ()