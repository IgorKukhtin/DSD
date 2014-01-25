-- Function: gpInsertUpdate_Movement_BankStatement()

-- DROP FUNCTION gpInsertUpdate_Movement_BankStatement();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankStatement(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFileName            TVarChar  , -- Имя файла
    IN inBankAccountId       Integer   , -- Расчетный счет
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatement());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankStatement(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Имя файла>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_FileName(), ioId, inFileName);

     -- сохранили связь с <Расчетный счет>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankAccount(), ioId, inBankAccountId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankStatement (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
