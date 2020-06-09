-- Function: gpUpdate_wms_receiving_result()

DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar, TFloat);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_wms_receiving_result (
    IN inId            Integer,  -- Наш Id сообщения -> wms_to_host_message.Id   
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS VOID    
AS
$BODY$         
BEGIN

     -- обновили StatusId_Wms - отметили что наш Груз был принят
     PERFORM lpUpdate_wms_receiving_result_MI (inId      := inId
                                             , inSession := inSession
                                              );
     
     -- обновили наши данные - zc_Movement_WeighingProduction
     PERFORM lpUpdate_wms_receiving_result_Movement (inId      := inId
                                                   , inSession := inSession
                                                    );
     
     -- отметили что сообщение обработано
     UPDATE wms_to_host_message SET Done = TRUE WHERE Id = inId;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 09.06.20                                        *               
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM gpUpdate_wms_receiving_result (inId:= 1, inSession:= zfCalc_UserAdmin())