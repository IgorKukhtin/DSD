-- Function: gpSetErased_Movement_Loss (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Loss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbUnitiD   Integer;
  DECLARE vbArticleLossId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Loss());

     SELECT
         Movement.OperDate,
         Movement_Unit.ObjectId AS Unit,
         MovementLinkObject_ArticleLoss.ObjectId 
     INTO
         vbOperDate,
         vbUnitiD,
         vbArticleLossId
     FROM Movement
         INNER JOIN MovementLinkObject AS Movement_Unit
                                       ON Movement_Unit.MovementId = Movement.Id
                                      AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                      ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                     AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
     WHERE Movement.Id = inMovementId;

     -- проверка - если <Master> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка - если есть <Child> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     --Пересчет полного списания в зарплате
     IF COALESCE(vbArticleLossId, 0) IN (13892113, 23653195)
     THEN
       PERFORM gpInsertUpdate_MovementItem_WagesFullCharge (vbUnitiD, vbOperDate, inSession); 
     END IF;
     
     --Использование фонда
     IF EXISTS(SELECT 1 FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId
                                             AND MovementFloat.DescId = zc_MovementFloat_SummaFund())
     THEN
       PERFORM gpSelect_Calculation_Retail_FundUsed (inSession);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
21.07.15                                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Loss (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
