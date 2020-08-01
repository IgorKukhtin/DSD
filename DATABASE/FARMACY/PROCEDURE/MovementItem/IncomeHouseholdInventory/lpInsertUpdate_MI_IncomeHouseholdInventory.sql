-- Function: lpInsertUpdate_MI_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_IncomeHouseholdInventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_IncomeHouseholdInventory(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inHouseholdInventoryId  Integer   , -- Хозяйственный инвентарь
    IN inAmount                TFloat    , -- Количество
    IN inCountForPrice         TFloat    , -- Себестоимость 
    IN inComment               TVarChar  , -- Комментарий
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

          
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inHouseholdInventoryId, inMovementId, inAmount, NULL);
      
     -- Сохранили <Себестоимость>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- Сохранили <Комментарий>
     PERFORM lpInsertUpdate_MovementString (zc_MIString_Comment(), ioId, inComment);
      
     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.07.20                                                                      * 
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MI_IncomeHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
