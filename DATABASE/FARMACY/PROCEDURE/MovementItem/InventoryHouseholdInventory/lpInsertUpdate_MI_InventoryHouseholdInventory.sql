-- Function: lpInsertUpdate_MI_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_InventoryHouseholdInventory (Integer, Integer, Integer, TFloat, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_InventoryHouseholdInventory(
 INOUT ioId                           Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                   Integer   , -- Ключ объекта <Документ>
    IN inPartionHouseholdInventoryId  Integer   , -- Партия хозяйственного инвентаря
    IN inAmount                       TFloat    , -- Количество
    IN inComment                      TVarChar  , -- Комментарий
    IN inUserId                       Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
               
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPartionHouseholdInventoryId, inMovementId, inAmount, NULL);
     
     -- Сохранили <Комментарий>
     PERFORM lpInsertUpdate_MovementString (zc_MIString_Comment(), ioId, inComment);
      
     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.07.20                                                                      * 
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MI_InventoryHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
