-- Function: gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer,  Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TrasportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
 INOUT ioMIId                     Integer   , -- Ключ объекта <строчная часть Документа>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    
    IN inDistance                 TFloat    , -- Пробег факт, км
    IN inPrice                    TFloat    , -- Цена (топлива)
    IN inCountPoint               TFloat    , -- Кол-во точек
    IN inTrevelTime               TFloat    , -- Время в пути, часов

    IN inComment                  TVarChar  , -- Примечание
    
    IN inJuridicalId              Integer   , -- Юридические лица
    IN inContractId               Integer   , -- Договор
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inRouteId                  Integer   , -- Маршрут
    IN inCarId                    Integer   , -- Автомобиль
    IN inContractConditionKindId  Integer   , -- Типы условий договоров

    IN inSession                  TVarChar    -- сессия пользователя

)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportService());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportService());

      -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransportService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Пробег факт, км>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Distance(), ioMIId, inDistance);
     -- сохранили свойство <Цена (топлива)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioMIId, inPrice);
     -- сохранили свойство <Кол-во точек>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPoint(), ioMIId, inCountPoint);
     -- сохранили свойство <Время в пути, часов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TrevelTime(), ioMIId, inTrevelTime);

     -- сохранили свойство <Комментарий>
     PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMIId, inComment);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMIId, inContractId);
     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMIId, inInfoMoneyId);
     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMIId, inPaidKindId);
     -- сохранили связь с <Маршрут>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(), ioMIId, inRouteId);
     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioMIId, inCarId);
     -- сохранили связь с <Типы условий договоров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioMIId, inContractConditionKindId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportService (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
