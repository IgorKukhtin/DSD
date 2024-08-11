-- Function: gpReComplete_Movement_ChangePercent(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outMessageText      Text                  ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ChangePercent());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ChangePercent())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ChangePercent_CreateTemp();
     -- Проводим Документ
     outMessageText:= lpComplete_Movement_ChangePercent (inMovementId     := inMovementId
                                                       , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/

-- тест
-- SELECT * FROM gpReComplete_Movement_ChangePercent (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
