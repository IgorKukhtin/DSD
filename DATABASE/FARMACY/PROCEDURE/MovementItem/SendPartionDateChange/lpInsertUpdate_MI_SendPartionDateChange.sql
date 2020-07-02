-- Function: lpInsertUpdate_MI_SendPartionDateChange()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDateChange (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDateChange(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inNewExpirationDate   TDateTime , -- Новый срок годности
    IN inContainerId         Integer   , -- Контейнер
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

          
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- Сохранили <кол-во ручное>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inNewExpirationDate);
 
    -- Сохранили <кол-во ручное>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
      
     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_SendPartionDateChange_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 02.07.20                                                                      * 
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MI_SendPartionDateChange (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
