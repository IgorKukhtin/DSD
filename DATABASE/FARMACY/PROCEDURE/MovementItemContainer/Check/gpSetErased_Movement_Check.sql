DROP FUNCTION IF EXISTS gpSetErased_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Check(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    --Если документ уже проведен то проверим права
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT 1
              FROM Movement
              WHERE
                  ID = inMovementId
                  AND
                  StatusId = zc_Enum_Status_Complete())
    THEN
        vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Income());
    END IF;

    -- Если есть распределение по партиям удаляем
    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False)
    THEN
      PERFORM lpSetErased_MovementItem(MovementItem.Id, vbUserId)
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False;
    END IF;

    -- Программа лояльности накопительная возвращаем списанную сумму
    IF COALESCE((SELECT MovementFloat.ValueData
                 FROM MovementFloat
                 WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMDiscount()
                   AND MovementFloat.MovementId = inMovementId), 0) <> 0
    THEN
      PERFORM gpUpdate_LoyaltySaveMoney_SummaDiscount (MovementFloat_LoyaltySMID.ValueData::INTEGER, -1.0 * MovementFloat.ValueData, inSession)
      FROM MovementFloat
           INNER JOIN MovementFloat AS MovementFloat_LoyaltySMID
                                    ON MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
                                   AND MovementFloat_LoyaltySMID. MovementId = inMovementId
      WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMDiscount()
        AND MovementFloat.MovementId = inMovementId;
    END IF;

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 13.05.19                                                                                     *
 05.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())