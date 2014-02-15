-- Function: gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer,  Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TrasportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
 INOUT ioMIId                     Integer   , -- Ключ объекта <строчная часть Документа>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа

 INOUT ioAmount                   TFloat    , -- Сумма
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
    IN inUnitForwardingId         Integer   , -- Подразделение (Место отправки)

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

     -- Расчитываем Сумму
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportOneTrip(), zc_Enum_ContractConditionKind_TransportRoundTrip())
     THEN
                    -- по условиям в договоре "Ставка за маршрут..."
         ioAmount:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                              ), 0)
                    -- добавляем доплату за точку
                  + COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_TransportPoint()
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                              ), 0) * COALESCE (inCountPoint, 0)
         ;
     ELSE
                    -- Расстояние * Цена
         ioAmount:= COALESCE (inDistance * inPrice, 0)
                    -- по условиям в договоре "Ставка за время..."
                  + COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                   AND inContractConditionKindId NOT IN (zc_Enum_ContractConditionKind_TransportDistance())
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                              ), 0) * COALESCE (inTrevelTime, 0)
                    -- по условиям в договоре "Ставка за пробег..."
                  + COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                   AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance())
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                          ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                              ), 0) * COALESCE (inDistance, 0)
         ;
     END IF;


     -- проверка: если есть "Ставка за пробег...", тогда платить по "Цена (топлива)" не будем
     IF inPrice <> 0
                   AND EXISTS (SELECT ObjectFloat_Value.ValueData
                               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                   AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance())
                                    JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                    AND ObjectFloat_Value.ValueData > 0
                               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                              )
     THEN
        RAISE EXCEPTION 'Ошибка.По условиям договора значение <Цена (топлива)> должно быть=0.';
     END IF;

     -- проверка
     IF (COALESCE (ioAmount, 0) = 0) THEN
        RAISE EXCEPTION 'Ошибка.Сумма не рассчитана.Проверьте условия в договоре.';
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_TransportService())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


      -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransportService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Подразделение (Место отправки)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);

     -- сохранили <Элемент документа>
     ioMIId := lpInsertUpdate_MovementItem (ioMIId, zc_MI_Master(), inJuridicalId, ioId, ioAmount, NULL);

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

     -- 5.1. таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- 5.2. таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, BranchId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_TransportService())
     THEN
          PERFORM lpComplete_Movement_TransportService (inMovementId := ioId
                                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.01.14                                        * add inUnitForwardingId
 25.01.14                                        * add lpComplete_Movement_TransportService
 23.12.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportService (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
