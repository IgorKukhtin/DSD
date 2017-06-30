-- Function: gpUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Contract (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract(
 INOUT ioId                  Integer,       -- Ключ объекта <Договор>
    
    IN inPersonalId          Integer  ,     -- Сотрудник (отвественное лицо)
    IN inPersonalTradeId     Integer  ,     -- Сотрудники (торговый)
    IN inPersonalCollationId Integer  ,     -- Сотрудники (сверка)
    IN inBankAccountId       Integer  ,     -- Расчетные счета(оплата нам)
    IN inContractTagId       Integer  ,     -- Признак договора
    IN inJuridicalDocumentId Integer  ,     -- Юридическое лицо (печать док.)
    IN inJuridicalInvoiceId  Integer  ,     -- Юридическое лицо (печать док. - реквизиты плательщика)
    IN inGoodsPropertyId     Integer  ,     -- Классификаторы свойств товаров

    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract());

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили связь с <Сотрудники (отвественное лицо)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);
   -- сохранили связь с <Сотрудники (торговый)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), ioId, inPersonalTradeId);
   -- сохранили связь с <Сотрудники (сверка)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), ioId, inPersonalCollationId);

   -- сохранили связь с <Расчетные счета(оплата нам)>
   -- PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- сохранили связь с <Признак договора>
   -- PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTag(), ioId, inContractTagId);

   -- сохранили связь с <Юридическое лицо(печать док.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDocument(), ioId, inJuridicalDocumentId);  
   
   -- сохранили связь с <Юридическое лицо(печать док.- реквизиты плательщика)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalInvoice(), ioId, inJuridicalInvoiceId);  
 
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_GoodsProperty(), ioId, inGoodsPropertyId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.17         * inJuridicalInvoiceId
 06.05.15         * add GoodsProperty
 16.01.15         * add inJuridicalDocumentId
 14.08.14                                        * add inPersonalId
 22.04.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Contract ()
