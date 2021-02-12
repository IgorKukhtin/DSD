-- Function: lpInsertUpdate_MI_FinalSUA()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_FinalSUA (Integer, Integer, Integer, Integer, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_FinalSUA(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inUnitId              Integer   , -- Подразделение
    IN inAmount              TFloat    , -- Количество
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     
     IF COALESCE (ioId, 0) = 0 
        AND EXISTS(SELECT 1
                   FROM MovementItem

                       INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.ObjectId= inGoodsId
                     AND MILinkObject_Unit.ObjectId = inUnitId)
     THEN
        RAISE EXCEPTION 'Ошибка. По товару и подразделению должна быть одна запись.';     
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
          
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- Сохранили <Подразделение>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
       
     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_FinalSUA_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 11.02.21                                                                      * 
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MI_FinalSUA (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')