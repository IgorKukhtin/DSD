-- Function: gpUpdate_Movement_Promo_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_ChangePercent (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_ChangePercent(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inChangePercent         TFloat    , -- (-)% Ск. (+)% Нац.
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_ChangePercent());
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inMovementId, inChangePercent);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.20         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Promo_ChangePercent (inMovementId:= 2641111, inChangePercent := 5, inSession:= zfCalc_UserAdmin())
