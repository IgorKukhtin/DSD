-- Function: gpInsertUpdate_Object_MemberBankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberBankAccount(Integer, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberBankAccount(
 INOUT ioId                    Integer   ,     -- ключ объекта <> 
    IN inName                  TVarChar  ,     -- Примечание
    IN inBankAccountId         Integer   ,     -- 
    IN inMemberId              Integer   ,     -- 
    IN inisAll                 Boolean   ,     -- 
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberBankAccount());
   vbUserId:= lpGetUserBySession (inSession);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberBankAccount(), 0, inName);

   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberBankAccount_BankAccount(), ioId, inBankAccountId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberBankAccount_Member(), ioId, inMemberId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MemberBankAccount_All(), ioId, inisAll);
        
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.20         *
*/

-- тест
--