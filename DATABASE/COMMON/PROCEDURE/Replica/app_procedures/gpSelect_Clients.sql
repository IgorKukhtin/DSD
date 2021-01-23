-- Function: _replica.gpSelect_Clients()

DROP FUNCTION IF EXISTS _replica.gpSelect_Clients (Bigint);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Clients (
    IN inClientId  Bigint -- _replica.Clients.Client_Id
)
RETURNS TABLE (Id          Integer,
               Last_Id     BigInt,
               Last_Id_DDL BigInt
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT CL.Id, CL.Last_Id, CL.Last_Id_DDL 
        FROM   _replica.Clients AS CL
        WHERE  CL.Client_Id = inClientId;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 12.08.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_Clients (inClientId:= 1)
