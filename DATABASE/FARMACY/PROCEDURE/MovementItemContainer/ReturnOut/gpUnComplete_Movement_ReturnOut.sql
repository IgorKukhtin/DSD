-- Function: gpUnComplete_Movement_ReturnOut (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ReturnOut (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ReturnOut(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnit Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbChangeIncmePaymentId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_ReturnOut());

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     --Ищем связанный документ изменения долга по приходам
     SELECT
         MovementLinkMovement.MovementChildId
     INTO
         vbChangeIncmePaymentId
     FROM
         MovementLinkMovement

     WHERE MovementLinkMovement.MovementId = inMovementId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_ChangeIncomePayment();


     --Если такой документ есть - распроводим его
     IF COALESCE(vbChangeIncmePaymentId,0) <> 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := vbChangeIncmePaymentId
                                      , inUserId     := vbUserId);  
     END IF;
                                  
     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_ReturnOut (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
