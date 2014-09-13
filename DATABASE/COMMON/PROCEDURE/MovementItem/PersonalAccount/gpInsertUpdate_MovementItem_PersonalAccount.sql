-- Function: gpInsertUpdate_MovementItem_PersonalAccount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalAccount (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalAccount(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inJuridicalId         Integer   , -- Юр.лицо
    IN inAmount              TFloat    , -- Сумма
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inCarId               Integer   , -- Автомобиль
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalAccount());

     -- проверка
     IF COALESCE (inJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юр.лицо>.';
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Маршрут>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(), ioId, inRouteId);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioId, inCarId);

     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.09.14                                        * add lpInsert_MovementItemProtocol
 14.01.14                                        *
 19.12.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalAccount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
