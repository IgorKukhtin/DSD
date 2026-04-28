-- Function: gpInsertUpdate_MI_Promo_Param_60()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_Param_60 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_Param_60(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());


     PERFORM lpUpdate_Movement_Promo_Auto_60 (inMovementId:= inMovementId, inUserId:= vbUserId);
     RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 21.07.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Promo_Param_60 (inMovementId:= 5047886 , inSession:= zfCalc_UserAdmin())
