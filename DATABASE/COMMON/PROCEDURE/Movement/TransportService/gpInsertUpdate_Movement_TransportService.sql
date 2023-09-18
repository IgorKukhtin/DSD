-- Function: gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer,  Integer, Integer, TVarChar)


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportService (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
 INOUT ioMIId                     Integer   , -- Ключ объекта <строчная часть Документа>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа

    IN inStartRunPlan             TDateTime , -- Дата/Время выезда план
    IN inStartRun                 TDateTime , -- Дата/Время выезда факт

 INOUT ioAmount                   TFloat    , -- Сумма
    IN inSummTransport            TFloat    , -- Вывоз факт, грн
    IN inWeightTransport          TFloat    , -- Вывоз факт, кг
    IN inDistance                 TFloat    , -- Пробег факт, км
    IN inPrice                    TFloat    , -- Цена (топлива)
    IN inCountPoint               TFloat    , -- Кол-во точек
    IN inTrevelTime               TFloat    , -- Время в пути, часов
    IN inSummAdd                  TFloat    , -- Сумма доплаты, грн

    IN inComment                  TVarChar  , -- Примечание

    IN inMemberExternalName       TVarChar  , -- Физические лица(сторонние)
    IN inDriverCertificate        TVarChar  , -- Водительское удостоверение

    IN inJuridicalId              Integer   , -- Юридические лица
    IN inContractId               Integer   , -- Договор
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inRouteId                  Integer   , -- Маршрут
    IN inCarId                    Integer   , -- Автомобиль
    IN inCarTrailerId             Integer   , -- Прицеп
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inUnitForwardingId         Integer   , -- Подразделение (Место отправки)

    IN inSession                  TVarChar    -- сессия пользователя

)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbValue TFloat;
   DECLARE vbValueAdd TFloat;
   DECLARE vbMemberExternalId Integer;
   DECLARE vbDriverCertificate TVarChar;
   DECLARE vbSummReestr TFloat;
   DECLARE vbisSummReestr Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportService());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportService());


     -- Проверка
     IF 1 < (SELECT COUNT (*)
             FROM Object_ContractCondition_View
                  LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                        ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
             WHERE Object_ContractCondition_View.ContractId              = inContractId
               AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
               AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate)
     THEN
         RAISE EXCEPTION 'Ошибка в договоре № <%>. Условие <%> указано более 1 раза.', lfGet_Object_ValueData (inContractId), lfGet_Object_ValueData_sh (inContractConditionKindId);
     END IF;

     -- Расчитываем Сумму
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportWeight()) -- Ставка за вывоз, грн/кг
     THEN
         -- по условиям в договоре "Ставка за вывоз, грн/кг"
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                              FROM Object_ContractCondition_View
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                              WHERE Object_ContractCondition_View.ContractId              = inContractId
                                AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                             ), 0);

         ioAmount:= COALESCE (inWeightTransport, 0) * vbValue;

     ELSEIF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportSumm()) -- Ставка за вывоз, грн/кг (% от суммы)
     THEN
         -- по условиям в договоре "Ставка за вывоз, грн/кг"
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                              FROM Object_ContractCondition_View
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                              WHERE Object_ContractCondition_View.ContractId              = inContractId
                                AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                             ), 0);

         ioAmount:= COALESCE (inSummTransport, 0) * vbValue / 100;
     ELSE
     IF inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportOneTrip()   -- Ставка за маршрут в одну сторону, грн
                                    , zc_Enum_ContractConditionKind_TransportOneTrip05() -- Ставка за маршрут 5т. в одну сторону, грн
                                    , zc_Enum_ContractConditionKind_TransportOneTrip10() -- Ставка за маршрут 10т. в одну сторону, грн
                                    , zc_Enum_ContractConditionKind_TransportOneTrip20() -- Ставка за маршрут 20т. в одну сторону, грн
                                    , zc_Enum_ContractConditionKind_TransportRoundTrip() -- Ставка за маршрут в обе стороны, грн
                                    --, zc_Enum_ContractConditionKind_TransportPoint()   -- Ставка за точку, грн
                                    , zc_Enum_ContractConditionKind_TransportForward()   -- доплата за экспедитора, грн/месяц
                                    , zc_Enum_ContractConditionKind_TransportOneDay()    -- Ставка за маршрут в день
                                    , zc_Enum_ContractConditionKind_TransportOneDayCon() -- Ставка за маршрут в день + кондиционер
                                     )
     THEN
         -- по условиям в договоре "Ставка за маршрут..."
         vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                              FROM Object_ContractCondition_View
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                              WHERE Object_ContractCondition_View.ContractId              = inContractId
                                AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                             ), 0);
         -- по условиям в договоре "доплату за точку"
         vbValueAdd:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                                 FROM Object_ContractCondition_View
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                            ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                 WHERE Object_ContractCondition_View.ContractId              = inContractId
                                   AND Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_TransportPoint()
                                   AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                ), 0);

         -- по условиям в договоре "Ставка за маршрут..."
         ioAmount:= vbValue
                    -- добавляем доплату за точку
                  + vbValueAdd * COALESCE (inCountPoint, 0);
     ELSE
          -- проверка
          IF COALESCE (inDistance, 0) = 0 THEN
             RAISE EXCEPTION 'Ошибка.Не введено значение <Пробег факт, км.>';
          END IF;
          -- по условиям в договоре "Ставка за время..."
          vbValue:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                               FROM Object_ContractCondition_View
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                               WHERE Object_ContractCondition_View.ContractId              = inContractId
                                 AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                 AND inContractConditionKindId NOT IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                     , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                     , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                      )
                                 AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                              ), 0);
         -- по условиям в договоре "Ставка за пробег..."
         vbValueAdd:= COALESCE ((SELECT ObjectFloat_Value.ValueData
                                 FROM Object_ContractCondition_View
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                            ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                 WHERE Object_ContractCondition_View.ContractId              = inContractId
                                   AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                   AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                   , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                   , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                    )
                                   AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                ), 0);

         -- Расстояние * Цена
         ioAmount:= COALESCE (inDistance * inPrice, 0)
                    -- по условиям в договоре "Ставка за время..."
                  + vbValue * COALESCE (inTrevelTime, 0)
                    -- по условиям в договоре "Ставка за пробег..."
                  + vbValueAdd * COALESCE (inDistance, 0)
         ;
     END IF;
     END IF;


     -- проверка: если есть "Ставка за пробег...", тогда платить по "Цена (топлива)" не будем
     IF inPrice <> 0
                   AND EXISTS (SELECT ObjectFloat_Value.ValueData
                               FROM Object_ContractCondition_View
                                    JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ContractCondition_View.ContractConditionId
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                    AND ObjectFloat_Value.ValueData > 0
                               WHERE Object_ContractCondition_View.ContractId              = inContractId
                                 AND Object_ContractCondition_View.ContractConditionKindId = inContractConditionKindId
                                 AND inContractConditionKindId IN (zc_Enum_ContractConditionKind_TransportDistance()
                                                                 , zc_Enum_ContractConditionKind_TransportDistanceInt()
                                                                 , zc_Enum_ContractConditionKind_TransportDistanceExt()
                                                                  )
                                 AND inOperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                              )
     THEN
        RAISE EXCEPTION 'Ошибка.По условиям договора значение <Цена (топлива)> должно быть=0.';
     END IF;

     -- проверка
     IF inSummAdd > 50 THEN
        RAISE EXCEPTION 'Ошибка.Сумма <Доплата, грн> не может быть больше 50 грн.';
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

     IF COALESCE (inMemberExternalName, '') <> ''
     THEN
         -- ищем существует ли такой сотрудник
         vbMemberExternalId := (SELECT Object.Id
                                FROM Object
                                WHERE Object.DescId = zc_Object_MemberExternal()
                                  AND LOWER (Object.ValueData) LIKE '%'|| LOWER (inMemberExternalName) ||'%'
                                LIMIT 1);   -- на всякий случай

         vbDriverCertificate := (SELECT ObjectString.ValueData
                                 FROM ObjectString
                                 WHERE ObjectString.ObjectId = vbMemberExternalId
                                   AND ObjectString.DescId = zc_ObjectString_MemberExternal_DriverCertificate());

         IF COALESCE (vbMemberExternalId, 0) = 0
         THEN
             -- Создание
             vbMemberExternalId := lpInsertUpdate_Object_MemberExternal (ioId	 := 0
                                                                       , inCode  := lfGet_ObjectCode(0, zc_Object_MemberExternal())
                                                                       , inName  := inMemberExternalName  :: TVarChar
                                                                       , inDriverCertificate := COALESCE (inDriverCertificate,'') :: TVarChar
                                                                       , inINN   := '' ::TVarChar
                                                                       , inUserId:= vbUserId
                                                                        );
         ELSE
             -- если отличается вод.удостоверение перезаписываем
             IF COALESCE (inDriverCertificate,'') <> '' AND  COALESCE (vbDriverCertificate,'') <> COALESCE (inDriverCertificate,'')
                THEN
                    -- сохранили
                    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_DriverCertificate(), vbMemberExternalId, inDriverCertificate);
             END IF;

         END IF;
     END IF;

      -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransportService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Дата/Время выезда план>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
     -- сохранили связь с <Дата/Время выезда факт>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);


     -- сохранили связь с <Подразделение (Место отправки)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);

     -- сохранили <Элемент документа>
     ioMIId := lpInsertUpdate_MovementItem (ioMIId, zc_MI_Master(), inJuridicalId, ioId, ioAmount, NULL);

     -- сохранили свойство <Вывоз факт, грн>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport(), ioMIId, inSummTransport);
     -- сохранили свойство <Вывоз факт, кг>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTransport(), ioMIId, inWeightTransport);
     -- сохранили свойство <Пробег факт, км>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Distance(), ioMIId, inDistance);
     -- сохранили свойство <Цена (топлива)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioMIId, inPrice);
     -- сохранили свойство <Кол-во точек>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPoint(), ioMIId, inCountPoint);
     -- сохранили свойство <Время в пути, часов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TrevelTime(), ioMIId, inTrevelTime);
     -- сохранили свойство <Доплата)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd(), ioMIId, inSummAdd);
     -- сохранили свойство <Доплата)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractValue(), ioMIId, vbValue);
     -- сохранили свойство <Дополнительное значение из условия договора>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractValueAdd(), ioMIId, COALESCE (vbValueAdd, 0));

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
     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CarTrailer(), ioMIId, inCarTrailerId);
     -- сохранили связь с <Типы условий договоров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioMIId, inContractConditionKindId);
     -- сохранили связь с <Физические лица(сторонние)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MemberExternal(), ioMIId, vbMemberExternalId);

     -- если сумма внесена руками zc_MIBoolean_SummReestr = FALSE расчет не выполняем, сумма внесена руками
     vbisSummReestr := COALESCE ( (SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = ioMIId AND MIB.DescId = zc_MIBoolean_SummReestr()), TRUE) :: Boolean;
     IF COALESCE (vbisSummReestr, TRUE) = TRUE
     THEN
         -- рассчитываем и сохраняем св-во Сумма отгрузки по реестру накладных
         vbSummReestr := COALESCE ((SELECT SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) AS vbSummReestr
                                    FROM MovementLinkMovement
                                         INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement.MovementId
                                                                AND MovementItem.DescId     = zc_MI_Master()
                                                                AND MovementItem.isErased   = FALSE
                                         JOIN MovementFloat AS MovementFloat_MovementItemId
                                                            ON MovementFloat_MovementItemId.ValueData ::Integer = MovementItem.Id
                                                           AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                         JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId = MovementFloat_MovementItemId.MovementId
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                    WHERE MovementLinkMovement.MovementChildId = ioId
                                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                                   ), 0) :: TFloat;

         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), ioMIId, vbSummReestr );
     END IF;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_TransportService())
     THEN
          PERFORM lpComplete_Movement_TransportService (inMovementId := ioId
                                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'OK';
    -- 'Повторите действие через 3 мин.'
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.10.21         * add inCarTrailerId
 10.12.20         * add inSummTransport
 27.01.20         * add inMemberExternalName
                        inDriverCertificate
 03.07.16         * Add inSummAdd, vbValue, vbValueAdd
 16.12.15         * add WeightTransport
 26.08.15         * add inStartRunPlan
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 26.01.14                                        * add inUnitForwardingId
 25.01.14                                        * add lpComplete_Movement_TransportService
 23.12.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportService (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
