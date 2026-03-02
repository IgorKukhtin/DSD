-- Function: lpInsertUpdate_MovementItem_OrderFinance()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , --
    IN inContractId            Integer   , --
    IN inCashId                Integer   , --
    IN inAmount                TFloat    , --
    IN inAmount_next           TFloat    , --
    IN inOperDate_Amount_next  TDateTime , --
    IN inAmountPlan_1          TFloat    , --
    IN inAmountPlan_2          TFloat    , --
    IN inAmountPlan_3          TFloat    , --
    IN inAmountPlan_4          TFloat    , --
    IN inAmountPlan_5          TFloat    , --
    IN inComment               TVarChar  , --
    IN inComment_Partner       TVarChar  , -- Примечание Контрагента
    IN inComment_Contract      TVarChar  , -- Примечание Договора
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert       Boolean;
   DECLARE vbOperDate_start TDateTime;
   DECLARE vbOrderFinanceId Integer;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- нашли
     vbOrderFinanceId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_OrderFinance());

     -- Проверка - <Ожидание Согласования-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignWait_1() AND MB.ValueData = TRUE)
        -- НЕ Разрешено изменение плана по дням - в проведенном док. (да/нет)
        AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_Status_off() AND OB.ValueData = TRUE)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Отправлено на Согласование Руководителю>.';
     END IF;
     -- Проверка - <Согласован-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign_1() AND MB.ValueData = TRUE)
        -- НЕ Разрешено изменение плана по дням - в проведенном док. (да/нет)
        AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_Status_off() AND OB.ValueData = TRUE)
        AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Согласовано Руководителем>.';
     END IF;
     -- Проверка - <Виза СБ>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignSB() AND MB.ValueData = TRUE)
        -- НЕ Разрешено изменение плана по дням - в проведенном док. (да/нет)
        AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_Status_off() AND OB.ValueData = TRUE)
        AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Виза СБ>.';
     END IF;


     -- проверка что договор не закрыт
     IF COALESCE (inCashId, 0) = 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inJuridicalId AND Object.DescId = zc_Object_Juridical())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Касса>.';
     END IF;

     -- проверка что договор не закрыт
     IF (SELECT ObjectLink_Contract_ContractStateKind.ChildObjectId
         FROM ObjectLink AS ObjectLink_Contract_ContractStateKind
         WHERE ObjectLink_Contract_ContractStateKind.ObjectId = inContractId
            AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()
        ) = zc_Enum_ContractStateKind_Close()
        --
        -- AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Договор <%> уже Завершен.', (SELECT '(' ||Object.ObjectCode||') '|| Object.ValueData FROM Object WHERE Object.Id = inContractId);
     END IF;

     IF inOperDate_Amount_next > zc_DateStart()
        -- здесь точно должна быть
        OR EXISTS (SELECT 1
                   FROM MovementLinkObject AS MovementLinkObject_OrderFinance
                        -- если Заполнение дата предварительный план = ДА
                        INNER JOIN ObjectBoolean AS ObjectBoolean_OperDate
                                                 ON ObjectBoolean_OperDate.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                                AND ObjectBoolean_OperDate.DescId    = zc_ObjectBoolean_OrderFinance_OperDate()
                                                AND ObjectBoolean_OperDate.ValueData = TRUE
                        -- если Заполнение № заявки 1С (да/нет) = НЕТ
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_InvNumber
                                                ON ObjectBoolean_InvNumber.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                               AND ObjectBoolean_InvNumber.DescId    = zc_ObjectBoolean_OrderFinance_InvNumber()
                                               AND ObjectBoolean_InvNumber.ValueData = TRUE
                        -- если Заполнение № счета (да/нет) = НЕТ
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Invoice
                                                ON ObjectBoolean_Invoice.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                               AND ObjectBoolean_Invoice.DescId    = zc_ObjectBoolean_OrderFinance_InvNumber_Invoice()
                                               AND ObjectBoolean_Invoice.ValueData = TRUE
    
                   WHERE MovementLinkObject_OrderFinance.MovementId = inMovementId
                     AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                     -- если Заполнение № заявки 1С (да/нет) = НЕТ
                     AND ObjectBoolean_InvNumber.ObjectId IS NULL
                     -- если Заполнение № счета (да/нет) = НЕТ
                     AND ObjectBoolean_Invoice.ObjectId IS NULL
                  )
     THEN
         -- нашли дату начала недели
         vbOperDate_start:= (SELECT zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData)
                             FROM Movement
                                  LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                          ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                         AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                             WHERE Movement.Id = inMovementId
                            );

         -- проверка
         IF COALESCE (inOperDate_Amount_next, zc_DateStart()) NOT BETWEEN vbOperDate_start + INTERVAL '0 DAY' AND vbOperDate_start + INTERVAL '4 DAY'
         THEN
 	    RAISE EXCEPTION 'Ошибка.Дата План = <%>%.Должна быть в периоде с <%> по <%>.'
                            , zfConvert_DateToString (inOperDate_Amount_next)
                            , CHR (13)
                            , zfConvert_DateToString (vbOperDate_start)
                            , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                             ;
         END IF;

     END IF;

     -- проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                       ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                                                      AND MILinkObject_Contract.ObjectId       = inContractId               
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
                  AND MovementItem.ObjectId   = inJuridicalId
                  AND MovementItem.isErased   = FALSE
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Дублирование запрещено.%Может быть только одна строчка для%<%> и договор = <%>.'
                       , CHR (13)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (inJuridicalId)
                       , lfGet_Object_ValueData_sh (inContractId)
                        ;
     END IF;

     -- сохранили <Элемент документа> - Первичный план на неделю
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Платежный план на неделю>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_next(), ioId, inAmount_next);
     -- сохранили свойство <Дата Платежный план на неделю>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Amount_next(), ioId, inOperDate_Amount_next);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <касса место выдачи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Cash(), ioId, inCashId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_1(), ioId, inAmountPlan_1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_2(), ioId, inAmountPlan_2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_3(), ioId, inAmountPlan_3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_4(), ioId, inAmountPlan_4);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_5(), ioId, inAmountPlan_5);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_Partner(), ioId, inComment_Partner);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_Contract(), ioId, inComment_Contract);


     -- Проверка - после InsertUpdate
     PERFORM lpCheck_Movement_OrderFinance (inMovementId:= inMovementId, inUserId:= inUserId);


     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

     -- сохранили протокол
     -- !!! времнно откл.!!!
     IF inUserId <> 5 OR vbIsInsert = TRUE THEN PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert); END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.25         *
 18.02.21         * inAmountStart
 29.07.19         *
*/

-- тест
--