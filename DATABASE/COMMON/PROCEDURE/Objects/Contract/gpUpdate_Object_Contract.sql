-- Function: gpUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract(
 INOUT ioId                  Integer,       -- Ключ объекта <Договор>
    
    IN inPersonalTradeId     Integer  ,     -- Сотрудники (торговый)
    IN inPersonalCollationId Integer  ,     -- Сотрудники (сверка)
    IN inBankAccountId       Integer  ,     -- Расчетные счета(оплата нам)
    IN inContractTagId       Integer  ,     -- Признак договора
    
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId:= lpGetUserBySession (inSession);

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили связь с <Сотрудники (торговый)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), ioId, inPersonalTradeId);
   -- сохранили связь с <Сотрудники (сверка)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), ioId, inPersonalCollationId);
   -- сохранили связь с <Расчетные счета(оплата нам)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- сохранили связь с <Признак договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTag(), ioId, inContractTagId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.04.14         *
 
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Contract ()
