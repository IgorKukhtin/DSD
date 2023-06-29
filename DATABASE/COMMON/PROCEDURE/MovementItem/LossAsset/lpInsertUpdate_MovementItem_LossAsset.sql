-- Function: lpInsertUpdate_MovementItem_LossAsset()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LossAsset(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inSumm                TFloat    , -- Сумма ОС-услуги
    IN inContainerId         Integer   , -- Партия ОС 
    IN inStorageId           Integer   , -- Место хранения
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- Проверка
     IF 1=0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         RAISE EXCEPTION 'Ошибка.Значение ОС не может быть пустым <%> <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From()));
     END IF;
     -- Проверка
     IF COALESCE (inContainerId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлена партия.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;

     -- проверка сумма вводится для ObjectId = уп статья
     IF COALESCE (inSumm,0) <> 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Infomoney())
     THEN
         RAISE EXCEPTION 'Ошибка.Сумма указывается для УП статьи.';
     END IF;
     
      -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, null);

     -- сохранили свойство <Сумма ОС-услуги>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- сохранили свойство <Партия ОС>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);

     -- сохранили связь с <Место хранения> - для партии прихода на МО 
     IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     END IF;

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
 28.06.23         *
 18.06.20         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_LossAsset(ioId := 0 , inMovementId := 16151863 , inGoodsId := 4071624 , inAmount := 0 , inContainerId := 2682725 ,  inSession := '5');
