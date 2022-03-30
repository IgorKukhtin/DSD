-- Function: lpInsertUpdate_MI_OrderInternal_SupplierFailures()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_SupplierFailures(Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_SupplierFailures(
    IN inId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                 Integer   , -- Товары
    IN inSupplierFailuresAmount  TFloat    , -- Количество отказ
    IN inUserId                  Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;


     -- если штшв = 0
     IF vbIsInsert = TRUE 
     THEN
          IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE)
          THEN
              RAISE EXCEPTION 'Ошибка.%Для товара <%> уже сформировано кол-во заказа = <%>.%Обновите у себя данные по <F5>.', CHR (13), lfGet_Object_ValueData (inGoodsId), (SELECT SUM (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE), CHR (13);
          ELSE
              -- сохранили <Элемент документа>
              inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL); 
          END IF;
     END IF;

     -- сохранили свойство кол-во отказ поставщика
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SupplierFailures(), inId, inSupplierFailuresAmount);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.03.22                                                       *
*/

-- тест
--