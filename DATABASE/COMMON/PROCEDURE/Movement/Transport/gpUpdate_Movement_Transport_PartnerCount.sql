-- Function: gpUpdate_Movement_Transport_PartnerCount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Transport_PartnerCount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Transport_PartnerCount(
    IN inMovementId   Integer   , -- Ключ объекта <Документ>
    IN inSession      TVarChar    -- сессия пользователя

)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());
     vbUserId:= lpGetUserBySession (inSession);

     -- пересохраняем
     PERFORM lpUpdate_Movement_Transport_PartnerCount (inMovementId_trasport:= inMovementId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.04.21         *
*/

-- тест
--
