-- Function: gpInsertUpdate_Movement_PersonalService()

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TDateTime, Integer, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalService (integer, tvarchar, tdatetime, tdatetime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalService (integer, tvarchar, tdatetime, Integer, tfloat, TVarChar, integer, integer, integer, integer, TDateTime, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalService(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPersonalId          Integer   , -- Сотрудник
    IN inAmount              TFloat    , -- Сумма операции 
    IN inComment             TVarChar  , -- Комментерий
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inUnitId              Integer   , -- Подразделение 	
    IN inPositionId          Integer   , -- Должность
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
           vbMovementItemId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
     vbUserId := inSession;
     IF inInvNumber = '' THEN
        inInvNumber := (NEXTVAL ('Movement_PersonalService_seq'))::TVarChar;
     END IF;

     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- сохранили <Документ>
     ioMovementId := lpInsertUpdate_Movement (ioMovementId, zc_Movement_PersonalService(), inInvNumber, inOperDate, NULL);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Master();

          -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inPersonalId, ioMovementId, inAmount, NULL);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- сохранили связь с <Должность>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), vbMovementItemId, inPositionId);
     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);
     -- сохранили связь с <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.14                         *
 17.02.14                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PersonalService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
