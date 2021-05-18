-- Function: gpInsertUpdate_Movement_PersonalReport()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalReport (integer, tvarchar, TDateTime, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PersonalReport(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmount                   TFloat    , -- Сумма операции
    IN inComment                  TVarChar  , -- Примечание
    IN inMemberId                 Integer   ,
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inContractId               Integer   , -- Договора
    IN inUnitId                   Integer   ,
    IN inMoneyPlaceId             Integer   ,
    IN inCarId                    Integer   ,
    IN inUserId                   Integer    -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalReport(), inInvNumber, inOperDate, NULL);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inMemberId, ioId, inAmount, NULL);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Договором>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), vbMovementItemId, inCarId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.21         *
*/

-- тест
--