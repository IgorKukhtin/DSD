-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_bonus (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash_bonus(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmountIn             TFloat    , -- Сумма прихода
    IN inAmountOut            TFloat    , -- Сумма расхода
    IN inAmountSumm           TFloat    , -- Cумма грн, обмен
    IN inComment              TVarChar  , -- Комментарий
    IN inCarId                Integer   , -- автомобиль
    IN inCashId               Integer   , -- Касса
    IN inMoneyPlaceId         Integer   , -- Объекты работы с деньгами
    IN inPositionId           Integer   , -- Должность
    IN inMemberId             Integer   , -- Физ лицо (через кого)
    IN inContractId           Integer   , -- Договора
    IN inInfoMoneyId          Integer   , -- Управленческие статьи
    IN inUnitId               Integer   , -- Подразделения
    IN inMovementId_Invoice   Integer   , -- документ счет

    IN inCurrencyId           Integer   , -- Валюта
   OUT outCurrencyValue       TFloat    , -- Курс для перевода в валюту баланса
   OUT outParValue            TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerId    Integer   , -- Валюта
    IN inCurrencyPartnerValue TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat    , -- Номинал для расчета суммы операции
    IN inMovementId_Partion   Integer   , -- Id документа продажи
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmount TFloat;
   DECLARE vbAmountIn TFloat;
   DECLARE vbAmountOut TFloat;
   DECLARE vbAmountCurrency TFloat;
   DECLARE vbSummPay_invoice TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- проверка - 
     IF inInfoMoneyId NOT IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502()) -- статьи бонусы
     THEN
        RAISE EXCEPTION 'Ошибка.Выбранная статья <%> не является начислением бонусов.', lfGet_Object_ValueData_sh (inInfoMoneyId);
     END IF;

     -- Заработная плата
     IF EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Personal())
     AND vbUserId IN (5, zfCalc_UserMain())
     THEN
         -- !!!замена!!!
         inMoneyPlaceId:= (WITH tmpServiceDate AS (SELECT lpInsertFind_Object_ServiceDate (inOperDate:= DATE_TRUNC ('MONTH', inServiceDate)) AS ServiceDateId)
                              , tmpContainer AS (SELECT DISTINCT CLO_Personal.ObjectId AS PersonalId
                                                 FROM Container
                                                      INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                                     ON CLO_Personal.ContainerId = Container.Id
                                                                                    AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                                      INNER JOIN ObjectLink AS ObjectLink_Member
                                                                            ON ObjectLink_Member.ObjectId      = CLO_Personal.ObjectId
                                                                           AND ObjectLink_Member.DescId        = zc_ObjectLink_Personal_Member()
                                                                           AND ObjectLink_Member.ChildObjectId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inMoneyPlaceId AND OL.DescId = zc_ObjectLink_Personal_Member())
                                                      INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                                     ON CLO_InfoMoney.ContainerId = Container.Id
                                                                                    AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                                                    AND CLO_InfoMoney.ObjectId    = inInfoMoneyId
                                                      INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                                     ON CLO_Unit.ContainerId = Container.Id
                                                                                    AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                                    AND CLO_Unit.ObjectId    = inUnitId
                                                      INNER JOIN ContainerLinkObject AS CLO_Position
                                                                                     ON CLO_Position.ContainerId = Container.Id
                                                                                    AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                                                                    AND CLO_Position.ObjectId    = inPositionId
                                                      INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                                     ON CLO_ServiceDate.ContainerId = Container.Id
                                                                                    AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                      INNER JOIN tmpServiceDate ON tmpServiceDate.ServiceDateId = CLO_ServiceDate.ObjectId
                                                      -- LEFT JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                      --                               ON CLO_PersonalServiceList.ContainerId = Container.Id
                                                      --                              AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                                      --                              AND CLO_PersonalServiceList.ObjectId    = 
                                                 WHERE Container.DescId = zc_Container_Summ()
                                                   AND Container.Amount <> 0
                                                   AND inServiceDate < '01.01.2018'
                                                 LIMIT 1
                                                )
                           SELECT tmpContainer.PersonalId FROM tmpContainer
                          UNION
                           SELECT inMoneyPlaceId WHERE NOT EXISTS (SELECT 1 FROM tmpContainer)
                          );

     END IF;


     -- Блокируем ему просмотр за ДРУГОЙ период
     IF EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_CashReplace() AND UserId = vbUserId)
        AND (NOT (inOperDate BETWEEN zc_DateStart_Role_CashReplace() AND zc_DateEnd_Role_CashReplace())
          OR inCashId    <> 14462 -- Касса Днепр
          OR inAmountOut <> 0
            )
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав на изменение данных для <%>.', lfGet_Object_ValueData (vbUserId);
     END IF;


     -- проверка
     IF COALESCE (inMovementId_Invoice, 0) = 0 AND EXISTS (SELECT 1 FROM Object_InfoMoney_View AS View_InfoMoney WHERE View_InfoMoney.InfoMoneyId = inInfoMoneyId AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()) -- Инвестиции
        AND inSession <> zfCalc_UserMain() :: TVarChar
     THEN
        RAISE EXCEPTION 'Ошибка.Для УП статьи <%> необходимо заполнить значение <№ док. Счет>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;
     -- проверка что счет НЕ оплачен
     IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId_Invoice AND MB.DescId = zc_MovementBoolean_Closed() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка.Счет № <%> от <%> уже полностью оплачен.Выберите другой.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Invoice), DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Invoice));
     END IF;
     
     -- итого сумма всех оплат по счету
     IF inMovementId_Invoice > 0
     THEN
         vbSummPay_invoice:= inAmountOut
                           + COALESCE ((SELECT -1 * SUM (MovementItem.Amount)
                                        FROM MovementLinkMovement AS MLM_Invoice
                                             INNER JOIN Movement ON Movement.Id = MLM_Invoice.MovementId
                                                                AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                AND Movement.Id <> ioId
                                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId = zc_MI_Master()
          
                                        WHERE MLM_Invoice.MovementChildId = inMovementId_Invoice
                                          AND MLM_Invoice.DescId          = zc_MovementLinkMovement_Invoice()   
                                       ), 0);
     END IF;

     -- проверка что сумма по счету должна быть >= чем итого сумма всех оплат
     IF COALESCE (inMovementId_Invoice, 0) <> 0 AND vbSummPay_invoice > COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_TotalSumm()), 0)
     THEN
        RAISE EXCEPTION 'Ошибка.В счете № <%> от <%> сумма = <%>, меньше чем Итого сумма оплат = <%>.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Invoice)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Invoice))
                       , zfConvert_FloatToString ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_TotalSumm()))
                       , zfConvert_FloatToString (vbSummPay_invoice)
                        ;
     END IF;
     

     -- 1. если  update
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Cash())
     THEN
         -- проверка
         IF EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND ParentId <> 0)
         THEN
             RAISE EXCEPTION 'Ошибка.Документ № <%> может корректироваться только через <Касса выплата зп>.', inInvNumber;
         END IF;

         -- 1. Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- проверка
     IF COALESCE (inCurrencyId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Валюта> не определено.';
     END IF;
     -- проверка
     IF inCurrencyId = zc_Enum_Currency_Basis() AND inAmountSumm <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Валюта> для суммы обмена не определено.';
     END IF;
     -- проверка
     IF inAmountSumm < 0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Cумма грн, обмен> не определено.';
     END IF;

     -- курса для баланса и Клиента - почти НЕТ расчета
     IF inCurrencyId <> zc_Enum_Currency_Basis()
     THEN
         -- проверка
         IF COALESCE (inCurrencyPartnerValue, 0) <= 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Курс> не определено.';
         END IF;

         -- !!!Замена!!!
         inParPartnerValue:= CASE WHEN inParPartnerValue > 0 THEN inParPartnerValue ELSE 1 END;

         -- !!!Замена!!!
         IF inAmountSumm = 0 AND inInfoMoneyId = zc_Enum_InfoMoney_41001() -- Покупка/продажа валюты
         THEN
             inAmountSumm:= (inAmountIn + inAmountOut) * inCurrencyPartnerValue / inParPartnerValue;
         END IF;

         -- если обмен
         IF inAmountSumm <> 0 OR (EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
                             AND inCurrencyId <> COALESCE (inCurrencyPartnerId, 0)
                                )
         THEN
            -- Замена - курс - расчет
            inCurrencyPartnerValue:= CASE WHEN inAmountSumm > 0 THEN inAmountSumm / (inAmountIn + inAmountOut) ELSE inCurrencyPartnerValue END;
            --
            IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
            THEN
                -- Замена
                inMoneyPlaceId:= inCashId;
            END IF;

            -- Замена
            inContractId  := 0;
            inInfoMoneyId := zc_Enum_InfoMoney_41001(); -- Покупка/продажа валюты

         /*ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inMoneyPlaceId AND Object.DescId = zc_Object_Cash())
         THEN
            -- Замена - расчет по курсу
            inAmountSumm  := inCurrencyPartnerValue * (inAmountIn + inAmountOut) / inParPartnerValue;*/

         END IF;

          -- !!!определяется ТАК значение!!!
          outCurrencyValue      := inCurrencyPartnerValue;
          outParValue           := inParPartnerValue;
     ELSE
         -- !!!обнуляется!!!
         outCurrencyValue      := 0;
         outParValue           := 0;
         inCurrencyPartnerValue:= 0;
         inParPartnerValue     := 0;
     END IF;


     -- проверка - Обмен только в ту же кассу
     IF inInfoMoneyId = zc_Enum_InfoMoney_41001() -- Покупка/продажа валюты
        AND inMoneyPlaceId <> inCashId
     THEN
        RAISE EXCEPTION 'Ошибка.Нет прав проводить обмен в кассу <%>.', lfGet_Object_ValueData_sh (inMoneyPlaceId);
     END IF;



     -- !!!очень важный расчет!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- запишем оригинал - сумму в валюте
             vbAmountCurrency := inAmountIn;
             -- сумму в ГРН - посчитаем - кроме обмена
             vbAmount         := CASE WHEN inAmountSumm > 0 THEN inAmountSumm ELSE CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- это значение в ГРН - сохраним
             vbAmountIn       := vbAmount;

        ELSE -- ВСЕ в ГРН
             vbAmount         := inAmountIn;
             vbAmountIn       := inAmountIn;
        END IF;

     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- запишем оригинал - сумму в валюте
             vbAmountCurrency := -1 * inAmountOut;
             -- сумму в ГРН - посчитаем - кроме обмена
             vbAmount         := -1 * CASE WHEN inAmountSumm > 0 THEN inAmountSumm ELSE CAST (inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- это значение в ГРН - сохраним
             vbAmountOut      := ABS (vbAmount);

        ELSE -- ВСЕ в ГРН
             vbAmount         := -1 * inAmountOut;
             vbAmountOut      := inAmountOut;
        END IF;
     END IF;

     -- проверка
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма пересчета из валюты <%> в валюту <%> не должна быть = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;

     -- сохранили
     ioId := lpInsertUpdate_Movement_Cash (ioId          := ioId
                                         , inParentId    := NULL
                                         , inInvNumber   := inInvNumber
                                         , inOperDate    := inOperDate
                                         , inServiceDate := inServiceDate
                                         , inAmountIn    := vbAmountIn
                                         , inAmountOut   := vbAmountOut
                                         , inAmountSumm  := inAmountSumm
                                         , inAmountCurrency := vbAmountCurrency
                                         , inComment     := inComment
                                         , inCarId       := inCarId
                                         , inCashId      := inCashId
                                         , inMoneyPlaceId:= inMoneyPlaceId
                                         , inPositionId  := inPositionId
                                         , inContractId  := inContractId
                                         , inInfoMoneyId := inInfoMoneyId
                                         , inMemberId    := inMemberId
                                         , inUnitId      := inUnitId
                                         , inCurrencyId           := inCurrencyId
                                         , inCurrencyValue        := outCurrencyValue
                                         , inParValue             := outParValue
                                         , inCurrencyPartnerId    := inCurrencyPartnerId
                                         , inCurrencyPartnerValue := inCurrencyPartnerValue
                                         , inParPartnerValue      := inParPartnerValue
                                         , inMovementId_Partion   := inMovementId_Partion
                                         , inUserId      := vbUserId
                                          );

     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- это временно
     /*IF (inInfoMoneyId <> 0 AND inMoneyPlaceId <> 0 AND (inContractId <> 0 OR EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId IN (zc_Object_Founder(), zc_Object_Member(), zc_Object_Personal())))) OR vbUserId <> 5 -- Админ -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN*/
         -- 5.3. проводим Документ
         IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Cash())
         THEN
              PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                              , inUserId     := vbUserId);
         END IF;
     -- END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.09.18         * add Car
 21.05.17         * inCurrencyPartnerId
 26.07.16         *
 27.05.15         * add MovementId_Partion
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 09.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 30.08.14                                        * это временно
 29.08.14                                        * all
 17.08.14                                        * add MovementDescId
 10.05.14                                        * add lpInsert_MovementItemProtocol
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 22.01.14                                        * add IsMaster
 14.01.14                                        *
 26.12.13                                        * add lpComplete_Movement_Cash
 26.12.13                                        * add lpGetAccessKey
 23.12.13                        *
 19.11.13                        *
 06.08.13                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cash_bonus (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
