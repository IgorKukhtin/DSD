-- Function: gpInsertUpdate_Object_BankAccountContract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountContract(Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountContract(Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountContract(
 INOUT ioId              Integer   , -- ключ объекта <Расчетные счета(оплата нам по любому договору)р>
    IN inBankAccountId   Integer   , -- ссылка на Расчетные счета
    IN inInfoMoneyId     Integer   , -- ссылка на Статьи назначения 	
    IN inUnitId          Integer   , -- ссылка на Подразделение 	
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BankAccountContract()());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BankAccountContract(), 0, '');
   
   -- сохранили связь с <Расчетные счета>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountContract_BankAccount(), ioId, inBankAccountId);
   -- сохранили связь с <Статьи назначения 	>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountContract_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountContract_Unit(), ioId, inUnitId);
     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.15         * add Unit
 19.07.13         * rename zc_ObjectDate_              
 09.07.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccountContract ()
