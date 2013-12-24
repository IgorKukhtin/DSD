-- Function: gpInsertUpdate_MovementItem_PersonalAccount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalAccount (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalAccount (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalAccount(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inJuridicalId         Integer   , -- Юр.лицо
    IN inAmount              TFloat    , -- Сумма
    IN inOperDate            TDateTime , -- Дата выдачи
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inCarId               Integer   , -- Автомобиль
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalAccount());
     vbUserId := inSession;

     -- проверка
     IF COALESCE (inJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юр.лицо>.';
     END IF;
     -- проверка
     IF EXISTS (SELECT MovementItem.ObjectId
                FROM MovementItem 
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inJuridicalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.Id <> COALESCE (ioId, 0)
               )
     THEN
         -- RAISE EXCEPTION 'Ошибка при добавлении.Сотрудник <%> <%> <%> уже есть в документе.', inMovementId, inPersonalId, inInfoMoneyId;
         RAISE EXCEPTION 'Ошибка при добавлении.Сотрудник <%> уже есть в документе.', (SELECT ValueData FROM Object where descid = zc_Object_Juridical() and Id = inJuridicalId);
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Дата выдачи>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Маршрут>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(), ioId, inRouteId);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioId, inCarId);

     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserIdd);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalAccount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
