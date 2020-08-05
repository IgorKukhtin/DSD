-- Function: gpUpdate_OrderExternal_Status_wms()

DROP FUNCTION IF EXISTS gpUpdate_OrderExternal_Status_wms (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OrderExternal_Status_wms(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode_wms      Integer   , -- Статус вмс. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_OrderExternal_StatusWMS());
     --
     CASE inStatusCode_wms
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, zc_Enum_Status_UnComplete());
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, zc_Enum_Status_Complete());
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, zc_Enum_Status_Erased()); 
         ELSE
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, NULL);
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.20         *
*/

-- тест
-- SELECT * FROM gpUpdate_OrderExternal_Status_wms (inMovementId:= 17370654, inStatusCode_wms:=1,  inSession:= zfCalc_UserAdmin())
