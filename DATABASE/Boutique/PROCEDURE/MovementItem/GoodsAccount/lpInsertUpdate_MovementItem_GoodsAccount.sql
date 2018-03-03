-- Function: lpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer
                                                                , TFloat, TFloat, TFloat
                                                                , Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer
                                                                , TFloat, TFloat
                                                                , Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer
                                                                , TFloat, TFloat
                                                                , TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inPartionId             Integer   , -- Партия
    IN inPartionMI_Id          Integer   , -- Партия элемента продажа/возврат
--    IN inSaleMI_Id             Integer   , -- строка док. продажи
    IN inAmount                TFloat    , -- Количество
 --   IN inSummChangePercent     TFloat    , -- 
 --   IN inTotalPay              TFloat    , -- 
    IN inComment               TVarChar  , -- примечание
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL, inUserId);
   
     -- сохранили свойство <>
     --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, inSummChangePercent);
     -- сохранили свойство <>
     --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, inTotalPay);
    
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionMI(), ioId, inPartionMI_Id);

     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.07.17         *
 18.05.17         *
*/

-- тест
-- 