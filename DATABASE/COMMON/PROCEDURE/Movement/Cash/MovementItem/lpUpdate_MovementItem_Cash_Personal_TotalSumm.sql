-- Function: lpUpdate_MovementItem_Cash_Personal_TotalSumm()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_Cash_Personal_TotalSumm (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_Cash_Personal_TotalSumm(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- в мастере всегда Итоговая сумма
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId
                                        , -1 * COALESCE ((SELECT SUM (COALESCE (MovementItem.Amount, 0)) AS Amount
                                                          FROM MovementItem
                                                          WHERE MovementItem.MovementId = inMovementId
                                                            AND MovementItem.DescId = zc_MI_Child()
                                                            AND MovementItem.isErased = FALSE
                                                         ), 0)
                                        , MovementItem.ParentId
                                         )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.04.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_MovementItem_Cash_Personal_TotalSumm (inMovementId:= 10, inUserId:= zfCalc_UserAdmin() :: Integer)
