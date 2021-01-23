-- Function: _replica.gpUpdate_Clients_LastId()

DROP FUNCTION IF EXISTS _replica.gpUpdate_Clients_LastId (Bigint, Integer);
DROP FUNCTION IF EXISTS _replica.gpUpdate_Clients_LastId (Bigint, Bigint);

CREATE OR REPLACE FUNCTION _replica.gpUpdate_Clients_LastId (
    IN inClient_Id   Bigint,  -- Master._replica.Clients.Client_Id  
    IN inLast_Id     BigInt   -- Id последней успешной команды репликации
)
RETURNS VOID 
AS
$BODY$      
BEGIN
    -- проверка существования записи с Client_Id = inClient_Id
    IF EXISTS (SELECT 1 FROM _replica.cLIENTS WHERE Client_Id = inClient_Id)
    THEN
        UPDATE _replica.Clients
        SET    Last_Id = inLast_Id
        WHERE  Client_Id = inClient_Id;
    ELSE
        RAISE EXCEPTION 'Value Client_Id = <%>  not find in table  _replica.Clients', inClient_Id;
    END IF;    
        
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 12.08.20                                                          *              
*/

-- тест
-- SELECT _replica.gpUpdate_Clients_LastId (inClient_Id:= 1, inLast_Id:= 1)