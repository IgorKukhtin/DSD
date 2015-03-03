-- Function: lpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Ключ объекта
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inAmountIn            TFloat    , -- Сумма прихода
    IN inAmountOut           TFloat    , -- Сумма расхода
    IN inComment             TVarChar  , -- Комментарий
    IN inCashId              Integer   , -- Касса
    IN inMoneyPlaceId        Integer   , -- Объекты работы с деньгами
    IN inPositionId          Integer   , -- Должность
    IN inContractId          Integer   , -- Договора
    IN inInfoMoneyId         Integer   , -- Управленческие статьи
    IN inMemberId            Integer   , -- Физ лицо (через кого)
    IN inUnitId              Integer   , -- Подразделения
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- проверка
     IF (COALESCE (inAmountIn, 0) = 0) AND (COALESCE (inAmountOut, 0) = 0) AND COALESCE (inParentId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Введите сумму.';
     END IF;
     -- проверка
     IF (COALESCE (inAmountIn, 0) <> 0) AND (COALESCE (inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма: <Приход> или <Расход>.';
     END IF;
     -- проверка + !!!временно для Админа откл!!!
     IF COALESCE (inInfoMoneyId, 0) = 0 AND (inUserId <> 5) THEN
        RAISE EXCEPTION 'Ошибка.Должно быть выбрано значение <УП статья назначения>.';
     END IF;
     -- проверка
     IF EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80300()) -- Расчеты с участниками
     THEN
         IF COALESCE (inMoneyPlaceId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значении <От Кого, Кому> должно быть заполнено.';
         END IF;
         IF EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Founder())
           AND NOT EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inMoneyPlaceId AND DescId = zc_ObjectLink_Founder_InfoMoney() AND ChildObjectId = inInfoMoneyId)
         THEN
             RAISE EXCEPTION 'Ошибка.Значении <УП статья назначения> должно соответсвовать значению <От Кого, Кому>.';
         END IF;
     END IF;
     -- проверка
     /*IF EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_60000()) -- Заработная плата
     THEN
         IF inOperDate < '01.09.2014' AND inServiceDate < '01.08.2014' AND 1 = 0
         THEN
             IF inMoneyPlaceId <> 0 THEN
               RAISE EXCEPTION 'Ошибка.Для данного периода значение <От Кого, Кому> должно быть пустым.';
             END IF;
         ELSE
             IF NOT EXISTS (SELECT PersonalId FROM Object_Personal_View WHERE PersonalId = inMoneyPlaceId)
             THEN
                 RAISE EXCEPTION 'Ошибка.Значении <От Кого, Кому> должно содержать ФИО сотрудника.';
             END IF;
             IF COALESCE (inPositionId, 0) = 0
             THEN
               RAISE EXCEPTION 'Ошибка.Не установлено значение <Должность>.';
             END IF;
         END IF;
     END IF;*/

     -- расчет
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;


     -- определяем ключ доступа
-- 280297;9;"Касса Крым";f;"грн";"филиал Крым";"ТОВ АЛАН";"";"Нал"
-- 280298;10;"Касса Никополь";f;"грн";"филиал Никополь";"ТОВ АЛАН";"";"Нал"

     vbAccessKeyId:= CASE WHEN inCashId = 296540 -- Касса Днепр БН
                               THEN zc_Enum_Process_AccessKey_CashOfficialDnepr()
                          WHEN inCashId = 14686 -- Касса Киев
                               THEN zc_Enum_Process_AccessKey_CashKiev()
                          WHEN inCashId = 279788 -- Касса Кривой Рог
                               THEN zc_Enum_Process_AccessKey_CashKrRog()
                          WHEN inCashId = 279789 -- Касса Николаев
                               THEN zc_Enum_Process_AccessKey_CashNikolaev()
                          WHEN inCashId = 279790 -- касса Харьков
                               THEN zc_Enum_Process_AccessKey_CashKharkov()
                          WHEN inCashId = 279791 -- Касса Черкассы
                               THEN zc_Enum_Process_AccessKey_CashCherkassi()
                          WHEN inCashId = 280185 -- Касса Донецк
                               THEN zc_Enum_Process_AccessKey_CashDoneck()
                          WHEN inCashId = 280296 -- Касса Одесса
                               THEN zc_Enum_Process_AccessKey_CashOdessa()
                          WHEN inCashId = 301799 -- Касса Запорожье
                               THEN zc_Enum_Process_AccessKey_CashZaporozhye()
                          ELSE zc_Enum_Process_AccessKey_CashDnepr() -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Cash())
                     END;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Cash(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);


     -- поиск <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCashId, ioId, vbAmount, NULL);


     -- сохранили связь с <Объект>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
    
     -- сохранили связь с <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);
     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Физ лицо (через кого)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Member(), vbMovementItemId, inMemberId);
     -- сохранили связь с <Должность>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), vbMovementItemId, inPositionId);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.08.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
