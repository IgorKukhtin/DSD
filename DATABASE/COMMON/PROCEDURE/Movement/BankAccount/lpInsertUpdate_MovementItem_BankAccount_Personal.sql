-- Function: lpInsertUpdate_MovementItem_BankAccount_Personal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_BankAccount_Personal (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_BankAccount_Personal (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_BankAccount_Personal(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPersonalId            Integer   , -- Сотрудники
    IN inAmount                TFloat    , -- Сумма к выплате
    IN inServiceDate           TDateTime , -- Месяц начислений
    IN inComment               TVarChar  , -- Примечание
    IN inInfoMoneyId           Integer   , -- Статьи назначения
    IN inUnitId                Integer   , -- Подразделение
    IN inPositionId            Integer   , -- Должность
    IN inPersonalServiceListId Integer   , -- Ведомости начисления
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <ФИО (сотрудник)>.';
     END IF;
     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <УП статья>.';
     END IF;
     -- проверка
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Подразделение>.';
     END IF;
     -- проверка
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Должность>.';
     END IF;
     -- проверка
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Ведомость начисления>.';
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPersonalId, inMovementId, inAmount, NULL);

     -- формируются свойство <Месяц начислений>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), ioId, inServiceDate);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- сохранили связь с <Ведомость начисления>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.04.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_BankAccount_Personal (ioId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:=1, inUserId:= zfCalc_UserAdmin() :: Integer)
