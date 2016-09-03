-- Function: gpInsertUpdate_MI_EntryAsset_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EntryAsset_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EntryAsset_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inPartionGoodsId      Integer   , -- Партия товара
    IN inAmount              TFloat    , -- Количество
    IN inSumm                TFloat    , -- Сумма
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbNameBeforeId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_EntryAsset());

     -- проверка
     IF COALESCE (inPartionGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Название (Товар/ОС/Услуги)>.';
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPartionGoodsId, inMovementId, inAmount + inSumm, inParentId);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


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
 27.08.16         *
*/

-- тест
-- 