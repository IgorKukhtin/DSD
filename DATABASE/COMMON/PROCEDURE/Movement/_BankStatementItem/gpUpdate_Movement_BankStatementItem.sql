-- Function: gpInsertUpdate_Movement_BankStatementItem()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId         Integer   , -- СПД 
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
      
     IF inJuridicalId = 0 THEN
        inJuridicalId := NULL;
     END IF; 
     IF inInfoMoneyId = 0 THEN
        inInfoMoneyId := NULL;
     END IF; 
     IF inContractId = 0 THEN
        inContractId := NULL;
     END IF; 
     IF inUnitId = 0 THEN
        inUnitId := NULL;
     END IF; 

     -- сохранили связь с <Юр. лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
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
03.12.13                         *
13.08.13          *

*/

-- тест
-- SELECT * FROM gpUpdate_Movement_BankStatementItem (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
