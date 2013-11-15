-- Function: gpInsertUpdate_Movement_BankStatementItemLoad()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankStatementItemLoad();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankStatementItemLoad(
    IN inDocNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inBankAccountFrom     TVarChar  , -- Расчетный счет
    IN inBankMFOFrom         TVarChar  , -- МФО 
    IN inOKPOFrom            TVarChar  , -- ОКПО
    IN inJuridicalNameFrom   TVarChar  , -- ОКПО
    IN inBankAccountTo       TVarChar  , -- Расчетный счет
    IN inBankMFOTo           TVarChar  , -- МФО 
    IN inOKPOTo              TVarChar  , -- ОКПО
    IN inJuridicalNameTo     TVarChar  , -- ОКПО
    IN inAmount              TFloat    , -- Сумма операции 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBankAccountFromId Integer;
   DECLARE vbBankAccountToId Integer;
   DECLARE vbMainBankAccountId integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItem());
    vbUserId := inSession;

   -- 1. Найти счет от кого и кому в справочнике счетов. 
   SELECT Object_BankAccount.Id INTO vbBankAccountFromId 
     FROM Object AS Object_BankAccount 
    WHERE Object_BankAccount.DescId = zc_Object_BankAccount() AND Object_BankAccount.ValueData = inBankAccountFrom;

   SELECT Object_BankAccount.Id INTO vbBankAccountToId 
     FROM Object AS Object_BankAccount 
    WHERE Object_BankAccount.DescId = zc_Object_BankAccount() AND Object_BankAccount.ValueData = inBankAccountTo;

   -- 3. Если такого счета нет, то выдать сообщение об ошибке и прервать выполнение загрузки
   IF (COALESCE(vbBankAccountFromId, 0) = 0) AND (COALESCE(vbBankAccountToId, 0) = 0) THEN
     -- vbMessage := ; 
      RAISE EXCEPTION 'Счет "%" и "%" не указаны в справочнике счетов.% Загрузка не возможна', inBankAccountFrom, inBankAccountTo, chr(13);
   END IF;



/*
4. Если найден и счет кому и от кого, то "главным" считается счет "от кого".
5. Найди документ zc_Movement_BankStatement по дате и расчетному счету. 
6. Если такого документа нет - создать его
7. Найти документ zc_Movement_BankStatementItem номеру. 
8. Если его нет - то создать
9. Если есть - то изменить. */

/*      -- сохранили <Документ>
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
  */
   RETURN 0;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
13.11.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankStatementItemLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
