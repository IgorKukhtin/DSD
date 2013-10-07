-- Function: lpInsertUpdate_MovementItem_PersonalSendCash ()

-- DROP FUNCTION lpInsertUpdate_MovementItem_PersonalSendCash ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalSendCash(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inPersonalId          Integer   , -- Сотрудник
    IN inAmount              TFloat    , -- Сумма
    IN inRouteId             Integer   , -- Маршрут
    IN inCarId               Integer   , -- Автомобиль
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
BEGIN

     -- проверка
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <Сотрудник>.';
     END IF;
     -- проверка
     IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT MovementItem.ObjectId
                                           FROM MovementItem 
                                                JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                                           AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                                           WHERE MovementItem.MovementId = inMovementId
                                             AND MovementItem.ObjectId = inPersonalId
                                             AND MovementItem.DescId = zc_MI_Master())
     THEN
         RAISE EXCEPTION 'Ошибка при добавлении.Сотрудник <%> уже есть в документе.', (SELECT ValueData FROM Object WHERE Id = inPersonalId);
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- сохранили связь с <Маршрут>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(), ioId, inRouteId);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioId, inCarId);

     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, inUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        * add check
 30.09.13                                        * 
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_PersonalSendCash (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
