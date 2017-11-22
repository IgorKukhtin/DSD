-- Function: lpInsertUpdate_MI_MarginCategory_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Master (Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_MarginCategory_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountAnalys	     TFloat    , -- 
    IN inAmountMin	     TFloat    , -- 
    IN inAmountMax	     TFloat    , -- 
    IN inNumberMin	     TFloat    , -- 
    IN inNumberMax	     TFloat    , -- 
    IN inRemains             TFloat    , 
    IN inPrice               TFloat    , 
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка
   IF COALESCE (inGoodsId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Не определено значение параметра <Товар>.';
   END IF;

   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Amount(), ioId, inAmountAnalys);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountMin(), ioId, inAmountMin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountMax(), ioId, inAmountMax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_NumberMin(), ioId, inNumberMin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_NumberMax(), ioId, inNumberMax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Remains(), ioId, inRemains);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Price(), ioId, inPrice);  

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.11.17         *
*/

-- тест
-- 