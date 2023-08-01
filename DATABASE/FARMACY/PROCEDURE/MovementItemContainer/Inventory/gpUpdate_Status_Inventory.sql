-- Function: gpUpdate_Status_Inventory()

DROP FUNCTION IF EXISTS gpUpdate_Status_Inventory (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Inventory(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN

   -- Запрет запуска второй копии
   IF COALESCE((SELECT count(*) as CountProc  
                FROM pg_stat_activity
                WHERE state = 'active'
                  AND (query ilike '%gpComplete_Movement_Inventory%')
                   OR  (query ilike '%gpUpdate_Status_Inventory%')), 0) > 1
   THEN
     RAISE EXCEPTION 'Проведение документа уже идет...%Ориентировочное время окончания процесса для полного переучета 20-30 мин.%Ожидайте!', Chr(13), Chr(13);
   END IF;


     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Inventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_Inventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Inventory (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_Inventory (ioId:= 0, inSession:= zfCalc_UserAdmin())