-- Function: gpUnComplete_Movement_PromoCode (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PromoCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PromoCode(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Promo());
    vbUserId:= lpGetUserBySession (inSession);

/*
    -- 1. поставим ObjectIntId_analyzer = NULL, для zc_MIContainer_Count() + zc_MIContainer_Summ()
    UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      -- AND MovementItem.IsErased = FALSE - на всякий случай, вдруг - удаляли
      AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
      AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check())
     ;
*/

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А
 14.12.17         *
*/