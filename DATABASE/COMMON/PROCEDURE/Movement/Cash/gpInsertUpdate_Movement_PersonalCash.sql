-- Function: gpInsertUpdate_Movement_PersonalCash()


DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalCash (integer, tvarchar, tdatetime, Integer, Integer, tfloat, TVarChar, integer, integer, integer, TDateTime, tvarchar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalCash (integer, tvarchar, tdatetime, Integer, TVarChar, TDateTime, tvarchar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalCash(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inParentId            Integer   , -- документ наче=исления зп
    IN inCashId              Integer   , -- Касса
    IN inComment             TVarChar  , -- Комментерий
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIMasterId Integer;
   
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
     vbUserId := inSession;
     IF inInvNumber = '' THEN
        inInvNumber := (NEXTVAL ('Movement_Cash_seq'))::TVarChar;
     END IF;

     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- сохранили <Документ>
     ioMovementId := lpInsertUpdate_Movement (ioMovementId, zc_Movement_Cash(), inInvNumber, inOperDate, inParentId);

     -- определяем <Главный Элемент документа>
     SELECT MovementItem.Id INTO vbMIMasterId FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Master();
     -- сохранили <Элемент документа>
     vbMIMasterId:= lpInsertUpdate_MovementItem (vbMIMasterId, zc_MI_Master(), inCashId, ioMovementId, 0, NULL);

     -- определяем <Подчиненный Элемент документа>
     --SELECT MovementItem.Id INTO vbMovementItemIdChild FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Child();
     -- сохранили <Элемент документа>
     --vbMovementItemIdChild:= lpInsertUpdate_MovementItem (vbMovementItemIdChild, zc_MI_Child(), inPersonalId, ioMovementId, inAmount, NULL);


     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMIMasterId, inComment);

     -- сохранили связь с <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemIdChild, inServiceDate);

     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (ioMovementId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.14         *


*/

--select * from Object where descid = zc_Object_Position()

-- тест
--SELECT * FROM gpInsertUpdate_Movement_PersonalCash (ioMovementId:= 0, inInvNumber:= '', inOperDate:= '01.09.2014', inCashId := 14462, inPersonalId:= 8469, inAmount:= 99, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8386, inPositionId:= 12428, inPaidKindId:= 4, inServiceDate:= '01.01.2013', inSession:= '2')
