-- Function: lpUpdate_MovementItem_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_IncomeHouseholdInventory (Integer, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_IncomeHouseholdInventory(
    IN inMovementItemId               Integer   , -- Ключ объекта <Документ>
    IN inAmount                       TFloat    , -- Количество
    IN inUserId                       Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAmount TFloat;
BEGIN

     IF COALESCE (inMovementItemId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка. Нет определен элемент прихода.';     
     END IF;
     
     vbAmount := COALESCE((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.ID = inMovementItemId), 0);
     
     IF (COALESCE (vbAmount, 0) + COALESCE (inAmount, 0)) < 0
     THEN
        RAISE EXCEPTION 'Ошибка. Позиция уже списана.';     
     END IF;

     -- сохранили <>
     UPDATE MovementItem SET Amount = (COALESCE (vbAmount, 0) + COALESCE (inAmount, 0)) WHERE MovementItem.ID = inMovementItemId;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.07.20                                                                      * 
 */

-- тест
-- SELECT * FROM lpUpdate_MovementItem_IncomeHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
