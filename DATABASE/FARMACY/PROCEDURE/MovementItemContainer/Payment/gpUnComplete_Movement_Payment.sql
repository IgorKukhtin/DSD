-- Function: gpUnComplete_Movement_Payment (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Payment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Payment(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Payment());
    vbUserId := inSession::Integer;
    -- распроводим оплаты
    PERFORM
        lpUnComplete_Movement (inMovementId := MI_Payment.BankAccountId
                              , inUserId     := vbUserId)
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId
        AND
        MI_Payment.NeedPay = TRUE
        AND
        COALESCE(MI_Payment.BankAccountId,0) > 0;
    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А
 13.10.15                                                                       *
*/