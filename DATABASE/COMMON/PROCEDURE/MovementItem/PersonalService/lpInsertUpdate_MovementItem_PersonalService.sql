-- Function: lpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/

/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/
/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);*/

/*DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);  */
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inPersonalId             Integer   , -- Сотрудники
    IN inisMain                 Boolean   , -- Основное место работы
   OUT outAmount                TFloat    , -- ***Сумма (затраты)
   OUT outAmountToPay           TFloat    , -- ***Сумма к выплате (итог)
   OUT outAmountCash            TFloat    , -- ***Сумма к выплате из кассы
   OUT outSummTransport         TFloat    , -- ***Сумма ГСМ (удержание за заправку, хотя может быть и доплатой...)
   OUT outSummTransportAdd      TFloat    , -- ***Сумма командировочные (доплата)
   OUT outSummTransportAddLong  TFloat    , -- ***Сумма дальнобойные (доплата, тоже командировочные)
   OUT outSummTransportTaxi     TFloat    , -- ***Сумма на такси (доплата)
   OUT outSummPhone             TFloat    , -- ***Сумма Моб.связь (удержание)

    IN inSummService            TFloat    , -- Сумма начислено
    IN inSummCardRecalc         TFloat    , -- Карта БН (ввод) - 1ф.
    IN inSummCardSecondRecalc   TFloat    , -- Карта БН (ввод) - 2ф.
    IN inSummCardSecondCash     TFloat    , -- Карта БН (касса) - 2ф.
    IN inSummAvCardSecondRecalc TFloat    , -- Карта БН (ввод) - 2ф. аванс
    IN inSummNalogRecalc        TFloat    , -- Налоги - удержания с ЗП (ввод)
    IN inSummNalogRetRecalc     TFloat    , -- Налоги - возмещение к ЗП (ввод)
    IN inSummMinus              TFloat    , -- Сумма удержания
    IN inSummAdd                TFloat    , -- Сумма премия
    IN inSummAddOthRecalc       TFloat    , -- Сумма премия (ввод для распределения)
    
    IN inSummHoliday            TFloat    , -- Сумма отпускные    
    IN inSummSocialIn           TFloat    , -- Сумма соц выплаты (из зарплаты)
    IN inSummSocialAdd          TFloat    , -- Сумма соц выплаты (доп. зарплате)
    IN inSummChildRecalc        TFloat    , -- Алименты - удержание (ввод)
    IN inSummMinusExtRecalc     TFloat    , -- Удержания сторон. юр.л. (ввод)
    IN inSummFine               TFloat    , -- штраф
    IN inSummFineOthRecalc      TFloat    , -- штраф (ввод для распределения)
    IN inSummHosp               TFloat    , -- больничный
    IN inSummHospOthRecalc      TFloat    , -- больничный (ввод для распределения)
    IN inSummCompensationRecalc TFloat    , -- Компенсация ввод (ввод)
    IN inSummAuditAdd           TFloat    , -- Сумма доплата за аудит
    IN inSummHouseAdd           TFloat    , -- Сумма Компенсация жилья 
    IN inSummAvanceRecalc       TFloat    , -- сумма аванса
    
    IN inNumber                 TVarChar  , -- № исполнительного листа
    IN inComment                TVarChar  , --
    IN inInfoMoneyId            Integer   , -- Статьи назначения
    IN inUnitId                 Integer   , -- Подразделение
    IN inPositionId             Integer   , -- Должность
    IN inMemberId               Integer   , -- Физ лицо (кому начисляют алименты)
    IN inPersonalServiceListId  Integer   , -- Ведомость начисления
    IN inFineSubjectId          Integer   , -- вид нарушения
    IN inUnitFineSubjectId      Integer   , -- Кем налагается взыскание
    IN inUserId                 Integer     -- пользователь
)                               
RETURNS RECORD AS               
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAccessKeyId Integer;

   DECLARE vbServiceDateId Integer;
   DECLARE vbisDetail Boolean;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <ФИО (сотрудник)> для Сумма начислено = <%>.', zfConvert_FloatToString (inSummService);
     END IF;
     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0 -- AND inSummService <> 0
     THEN
         IF inSummService = 0 THEN RETURN; END IF;
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <УП статья> для Сумма начислено = <%>.', zfConvert_FloatToString (inSummService);
     END IF;
     -- проверка
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Подразделение> для Сумма начислено = <%>.', zfConvert_FloatToString (inSummService);
     END IF;
     -- проверка
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Должность> для Сумма начислено = <%>.', zfConvert_FloatToString (inSummService);
     END IF;

     -- проверка - распределение !!!если это БН!!!
     IF NOT EXISTS (SELECT ObjectLink_PersonalServiceList_PaidKind.ChildObjectId
                FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                     INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
                                          AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                  AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
               )
     THEN
         IF inSummCardRecalc <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Поле <Карта БН (ввод) - 1ф.> заполняется только для Ведомости БН.';
         END IF;
         IF inSummCardSecondRecalc <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Поле <Карта БН (ввод) - 2ф.> заполняется только для Ведомости БН.';
         END IF;
         IF inSummAvCardSecondRecalc <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Поле <Карта БН (ввод) - 2ф. Аванс> заполняется только для Ведомости БН.';
         END IF;
         IF inSummNalogRecalc <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Поле <Налоги - удержания (ввод)> заполняется только для Ведомости БН.';
         END IF;
         IF inSummChildRecalc <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Поле <Алименты - удержание (ввод)> заполняется только для Ведомости БН.';
         END IF;
         IF inSummMinusExtRecalc <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Поле <Удержания сторон. юр.л. (ввод)> заполняется только для Ведомости БН.';
         END IF;
     END IF;



     -- проверка записываем zc_MILinkObject_FineSubject - но только для ведомости с признаком zc_ObjectBoolean_PersonalServiceList_Detail  = TRUE 
     -- получаем свойство PersonalServiceList
     vbPersonalServiceListId:= (SELECT MovementLinkObject.ObjectId
                                FROM MovementLinkObject
                                WHERE MovementLinkObject.MovementId = inMovementId
                                  AND MovementLinkObject.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                );
     vbisDetail := COALESCE ((SELECT ObjectBoolean.ValueData
                              FROM ObjectBoolean
                              WHERE ObjectBoolean.ObjectId = vbPersonalServiceListId 
                                AND ObjectBoolean.DescId = zc_ObjectBoolean_PersonalServiceList_Detail())
                             , FALSE) ::Boolean;
     IF (COALESCE (inFineSubjectId,0) <> 0 OR COALESCE (inUnitFineSubjectId,0) <> 0) AND vbisDetail = FALSE
     THEN
         RAISE EXCEPTION 'Ошибка.Для текущей ведомости Нет детализации данных.';
     END IF;


     -- !!!ВАЖНО!!!
     -- определяем ключ доступа
     vbAccessKeyId:= CASE WHEN EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
                               AND NOT EXISTS (SELECT 1
                                               FROM ObjectLink
                                                    INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                               WHERE ObjectLink.DescId   = zc_ObjectLink_PersonalServiceList_Member()
                                                 AND ObjectLink.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList())
                                              )
                        -- THEN zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                        THEN lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalService(), vbPersonalServiceListId)
                        ELSE
                     lpGetAccessKey (COALESCE ((SELECT ObjectLink_User_Member.ObjectId
                                                FROM ObjectLink
                                                     INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                                    AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                                 WHERE ObjectLink.DescId = zc_ObjectLink_PersonalServiceList_Member()
                                                   AND ObjectLink.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList())
                                                 LIMIT 1
                                               ), inUserId)
                                   , zc_Enum_Process_InsertUpdate_Movement_PersonalService()
                                   , vbPersonalServiceListId
                                    )
                     END;
     -- !!!ВАЖНО!!!
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = inMovementId;

     -- Поиск
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     -- Поиск
     SELECT -- Сумма ГСМ (удержание за заправку, хотя может быть и доплатой...)
            SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.Amount ELSE 0 END) AS SummTransport
            -- Сумма командировочные (доплата)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add()        THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAdd
            -- Сумма дальнобойные (доплата, тоже командировочные)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_AddLong()    THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAddLong
            -- Сумма на такси (доплата)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Taxi()       THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportTaxi
            -- Сумма Моб.связь (удержание)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_MobileBills_Personal() THEN  1 * MIContainer.Amount ELSE 0 END) AS SummPhone
            INTO outSummTransport, outSummTransportAdd, outSummTransportAddLong, outSummTransportTaxi, outSummPhone
     FROM ContainerLinkObject AS CLO_ServiceDate
          INNER JOIN ContainerLinkObject AS CLO_Personal
                                         ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                        AND CLO_Personal.ObjectId = inPersonalId
          INNER JOIN ContainerLinkObject AS CLO_Position
                                         ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                        AND CLO_Position.ObjectId = inPositionId
          INNER JOIN ContainerLinkObject AS CLO_Unit
                                         ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                        AND CLO_Unit.ObjectId = inUnitId
          INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                         ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                        AND CLO_InfoMoney.ObjectId = inInfoMoneyId
          INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                         ON CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
          INNER JOIN MovementLinkObject AS MLO
                                        ON MLO.MovementId = inMovementId
                                       AND MLO.ObjectId = CLO_PersonalServiceList.ObjectId
                                       AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()
          INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = CLO_Personal.ContainerId
                                                         -- AND MIContainer.MovementDescId = zc_Movement_Income()
     WHERE CLO_ServiceDate.ObjectId = vbServiceDateId
       AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate();


     -- рассчитываем сумму (затраты)
     outAmount:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) - COALESCE (inSummFine, 0)
               + COALESCE (inSummAdd, 0) + COALESCE (inSummHoliday, 0) + COALESCE (inSummHosp, 0) + COALESCE (inSummAuditAdd, 0)-- - COALESCE (inSummSocialIn, 0);
               + COALESCE (inSummHouseAdd, 0)  -- "плюс" компенсация жилья
                 -- "плюс" <Премия (распределено)>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                 -- "минус" <штраф (распределено)>
               - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummFineOth()), 0)
                 -- "плюс" <больничн (распределено)>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummHospOth()), 0)
                 -- "плюс" <компенсация(распределено)>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCompensation()), 0)
                 -- "плюс" <за санобработка>
               + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummMedicdayAdd()), 0)
                 -- "минус" <за прогул>
               - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummSkip()), 0)
                ;
     -- рассчитываем сумму к выплате
     outAmountToPay:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) - COALESCE (inSummFine, 0)
                    + COALESCE (inSummAdd, 0) + COALESCE (inSummHoliday, 0)  + COALESCE (inSummHosp, 0) + COALESCE (inSummSocialAdd, 0) + COALESCE (inSummAuditAdd, 0)
                    + COALESCE (inSummHouseAdd, 0)  -- "плюс" компенсация жилья
                    - COALESCE (outSummTransport, 0) + COALESCE (outSummTransportAdd, 0) + COALESCE (outSummTransportAddLong, 0) + COALESCE (outSummTransportTaxi, 0)
                    - COALESCE (outSummPhone, 0)
                      -- "плюс" <Премия (распределено)>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                      -- "минус" <Налоги - удержания с ЗП>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummNalog()), 0)
                      -- "плюс" <Налоги - возмещение к ЗП>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummNalogRet()), 0)    --
                      -- "минус" <Алименты - удержание>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChild()), 0)
                      -- "минус" <Удержания сторон. юр.л.>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummMinusExt()), 0)
                      -- "минус" <штраф (распределено)>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummFineOth()), 0)
                      -- "плюс" <больничн (распределено)>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummHospOth()), 0)
                      -- "плюс"" <компенсация(распределено)>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCompensation()), 0)
                      -- "плюс" <за санобработка>
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummMedicdayAdd()), 0)
                      -- "минус" <за прогул>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummSkip()), 0)
                     ;
     -- рассчитываем сумму к выплате из кассы
     outAmountCash:= outAmountToPay
                     -- "минус" <Карта БН - 1ф.>
                   - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCard()), 0)
                     -- "минус" <Карта БН - 2ф.>
                   - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummCardSecond()), 0)
                     -- "минус" <Карта БН (касса) - 2ф.>
                   - inSummCardSecondCash
                    ;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, outAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), ioId, outAmountToPay);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummService(), ioId, inSummService);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardRecalc(), ioId, inSummCardRecalc);

     -- сохранили свойство <Карта БН (ввод) - 2ф.>
   --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondRecalc(), ioId, inSummCardSecondRecalc);
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondRecalc(), ioId, ROUND (inSummCardSecondRecalc, 1));
     IF COALESCE (inSummCardSecondRecalc, 0) = 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecond_num(), ioId, 0);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondTwo_num(), ioId, 0);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondDiff_num(), ioId, 0);
     END IF;

     -- сохранили свойство <Карта БН (округление) - 2ф>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondDiff(), ioId, inSummCardSecondRecalc - ROUND (inSummCardSecondRecalc, 1));
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondCash(), ioId, inSummCardSecondCash);
     -- сохранили свойство <Карта БН (ввод) - 2ф.> аванс
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvCardSecondRecalc(), ioId, inSummAvCardSecondRecalc);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRecalc(), ioId, inSummNalogRecalc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRetRecalc(), ioId, inSummNalogRetRecalc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinus(), ioId, inSummMinus);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd(), ioId, inSummAdd );
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAuditAdd(), ioId, inSummAuditAdd );
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAddOthRecalc(), ioId, inSummAddOthRecalc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHoliday(), ioId, inSummHoliday );
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialIn(), ioId, inSummSocialIn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialAdd(), ioId, inSummSocialAdd);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHouseAdd(), ioId, inSummHouseAdd);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Main(), ioId, inisMain);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChildRecalc(), ioId, inSummChildRecalc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinusExtRecalc(), ioId, inSummMinusExtRecalc);
     -- сохранили свойство <компенсация (ввод для распределения)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensationRecalc(), ioId, inSummCompensationRecalc);

     -- сохранили свойство <Сумма ГСМ (удержание за заправку, хотя может быть и доплатой...)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport(), ioId, COALESCE (outSummTransport, 0));
     -- сохранили свойство <Сумма командировочные (доплата)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAdd(), ioId, COALESCE (outSummTransportAdd, 0));
     -- сохранили свойство <Сумма дальнобойные (доплата, тоже командировочные)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAddLong(), ioId, COALESCE (outSummTransportAddLong, 0));
     -- сохранили свойство <Сумма на такси (доплата)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportTaxi(), ioId, COALESCE (outSummTransportTaxi, 0));
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPhone(), ioId, COALESCE (outSummPhone, 0));

     -- сохранили свойство <штраф>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFine(), ioId, inSummFine);
     -- сохранили свойство <штраф (ввод для распределения)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFineOthRecalc(), ioId, inSummFineOthRecalc);
     -- сохранили свойство <больничный>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHosp(), ioId, inSummHosp);
     -- сохранили свойство <больничный (ввод для распределения)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHospOthRecalc(), ioId, inSummHospOthRecalc);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvanceRecalc(), ioId, COALESCE (inSummAvanceRecalc, 0));

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Number(), ioId, inNumber);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Member(), ioId, inMemberId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_FineSubject(), ioId, inFineSubjectId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_UnitFineSubject(), ioId, inUnitFineSubjectId);
     
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.12.21         * inNumber
 06.05.21         * inUnitFineSubjectId
 28.04.21         * inFineSubjectId
 25.03.20         * inSummAuditAdd
 27.01.20         * add inSummCompensationRecalc
 15.10.19         * замена inSummFine, inSummHosp на inSummFineRecalc, inSummHospRecalc
 29.07.19         * inSummFine, inSummHosp
 25.06.18         * inSummAddOthRecalc
 05.01.18         * add inSummNalogRetRecalc
 20.06.17         * add inSummCardSecondCash
 24.02.17         * add SummMinusExtRecalc, CHANGE inSummChild on inSummChildRecalc
 20.02.17         * inSummCardSecondRecalc
 20.04.16         * inSummHoliday
 07.05.15         * add PersonalServiceList
 02.10.14                                        * del inSummCard
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- тест
-- 