-- Function: gpUpdate_wms_receiving_result()

DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar, TFloat);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_wms_receiving_result (
    IN inId            Integer,  -- wms_to_host_message.Id   
    IN inIncomingId    Integer,  -- номер задания на упаковку
    IN inName          TVarChar, -- имя груза 
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS VOID    
AS
$BODY$         
BEGIN

  PERFORM lpUpdate_wms_receiving_result_MI (inIncomingId := inIncomingId
                                          , inName       := inName   
                                           );
  
  PERFORM lpUpdate_wms_receiving_result_Movement (inIncomingId := inIncomingId
                                                , inName       := inName 
                                                , inSession    := inSession
                                                 );
  
  UPDATE wms_to_host_message
  SET    Done = TRUE
  WHERE  Id   = inId;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 09.06.20                                                          *               
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM gpUpdate_wms_receiving_result (inId:= 1, inIncomingId:= 1, inName:= 'AHC-00506', inSession:= '5')