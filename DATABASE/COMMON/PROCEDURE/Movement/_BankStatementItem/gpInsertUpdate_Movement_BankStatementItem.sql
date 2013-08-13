-- Function: gpInsertUpdate_Movement_BankStatementItem()

-- DROP FUNCTION gpInsertUpdate_Movement_BankStatementItem();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankStatementItem(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOKPO                TVarChar  , -- ОКПО
    IN inAmount              TFloat    , -- Сумма операции 
    IN inInfoMoneyId         Integer   , -- Управленческие статьи 
    IN inContractId          Integer   , -- Договор  
    IN inUnitId              Integer   , -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItem());
     vbUserId := inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankStatementItem(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <ОКПО>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO (), ioId, inOKPO);
     -- сохранили свойство <Сумма операции>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);

     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     
     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);     
     
     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
13.08.13          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankStatementItem (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
