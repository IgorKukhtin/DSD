-- Function: _replica.gpUpdate_Clients_LastId_Ddl()

DROP FUNCTION IF EXISTS _replica.gpUpdate_Clients_LastId_Ddl (Bigint, Integer);
DROP FUNCTION IF EXISTS _replica.gpUpdate_Clients_LastId_Ddl (Bigint, Bigint);

CREATE OR REPLACE FUNCTION _replica.gpUpdate_Clients_LastId_Ddl (
    IN inClient_Id    Bigint,  -- Master._replica.Clients.Client_Id  
    IN inLast_Id_DDL  BigInt  -- Id последней успешной команды DDL
)
RETURNS VOID 
AS
$BODY$      
BEGIN
    -- проверка существования записи с Client_Id = inClient_Id
    IF EXISTS (SELECT 1 FROM _replica.cLIENTS WHERE Client_Id = inClient_Id)
    THEN
        UPDATE _replica.Clients
        SET    Last_Id_DDL = inLast_Id_DDL
        WHERE  Client_Id = inClient_Id;
    ELSE
        RAISE EXCEPTION 'Значение Client_Id = <%>  не найдено в таблице _replica.Clients', inClient_Id;
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
-- SELECT _replica.gpUpdate_Clients_LastId_Ddl (inClient_Id:= 1, inLast_Id_DDL:= 1)