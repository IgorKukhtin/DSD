-- Function: _replica.gpInsertUpdate_Settings()

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_Settings ();

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_Settings (
 INOUT inClientId  Bigint, -- _replica.Clients.Client_Id
    IN inName      Text,   -- значение поля Name
    IN inValue     Text    -- значение поля Value
)
RETURNS Bigint 
AS
$BODY$      
BEGIN
    -- проверка существования записи с Name = inName
    IF EXISTS (SELECT 1 FROM _replica.Settings WHERE Name ILIKE(inName))
    THEN
        -- выполняем обновление
        UPDATE _replica.Settings SET Value = inValue WHERE Name ILIKE(inName);
    ELSE    
        -- выполняем вставку новой записи
        INSERT INTO _replica.Settings(Name, Value) VALUES(inName, inValue);
    END IF;

    -- проверка существования записи с Name = 'Client_Id'
    IF EXISTS (SELECT 1 FROM _replica.Settings WHERE Name ILIKE('Client_Id'))
    THEN 
        inClientId := (SELECT Value
                       FROM   _replica.Settings
                       WHERE  Name ILIKE('Client_Id')
                       );
    ELSE 
        RAISE EXCEPTION 'Значение Client_Id не найдено в таблице _replica.Settings';
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
-- SELECT * FROM _replica.gpInsertUpdate_Settings (inClientId:= 0, inName:= 'test', inValue:= 'test3')
--
-- !!!project_colocall!!!
-- SELECT * FROM _replica.gpInsertUpdate_Settings (inClientId:= 0, inName:= 'client_id', inValue:= '2968573160406278080"')
-- -- INSERT INTO _replica.clients (client_id, client_name, application_name) SELECT 2968573160406278080, 'project_colocall', 'Replicator'
--
-- !!!project_cloud AZURE!!!
-- SELECT * FROM _replica.gpInsertUpdate_Settings (inClientId:= 0, inName:= 'client_id', inValue:= '2006407796010160000')
-- -- INSERT INTO _replica.clients (client_id, client_name, application_name) SELECT 2006407796010160000, 'project_cloud AZURE', 'Replicator'

