-- Function: gpInsertUpdate_MI_OrderIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderIncome (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderIncome(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMeasureId           Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    IN inCountForPrice       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inOrderIncomeId       Integer   , --
    IN inGoodsId             Integer   , -- Товары
    IN inAssetId             Integer   ,
    IN inUnitId              Integer   ,
    IN inComment             TVarChar ,   -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Товар>.';
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inMeasureId, inMovementId, inAmount, NULL);



     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_OrderIncome(), ioId, inOrderIncomeId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);



     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.15         *
*/

-- тест
-- 