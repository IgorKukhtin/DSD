-- Function: gpReComplete_Movement_Sale(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Sale (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Sale())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Sale_CreateTemp();

if vbUserId IN (5) AND 1=0 THEN
     -- Проводим Документ
     PERFORM lpComplete_Movement_Sale2222 (inMovementId     := inMovementId
                                     , inUserId         := vbUserId
                                     , inIsLastComplete := inIsLastComplete);
else
     -- Проводим Документ
     PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                     , inUserId         := vbUserId
                                     , inIsLastComplete := inIsLastComplete);
end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.11.14                                        * add lpComplete_Movement_Sale_CreateTemp
 27.11.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_Sale (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
