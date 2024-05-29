-- Function: gpInsertUpdate_Object_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId	               Integer   ,    -- ключ объекта <Касса> 
    IN inCode              Integer   ,    -- код объекта <Касса> 
    IN inCashName          TVarChar  ,    -- Название объекта <Касса> 
    IN inCurrencyId        Integer   ,    -- Валюта данной кассы 
    IN inBranchId          Integer   ,    -- Какому филиалу принадлежит касса 
    IN inJuridicalBasisId  Integer   ,    -- Главное юр Лицо
    IN inBusinessId        Integer   ,    -- Бизнес
    IN inPaidKindId        Integer   ,    -- Форма оплаты 
    IN inisNotCurrencyDiff Boolean   ,    --  Отключить формирование курсовой разницы 	
    IN inSession           TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Cash());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_Cash());
    
   -- проверка прав уникальности для свойства <Наименование Касса>  
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Cash(), inCashName);
   -- проверка прав уникальности для свойства <Код Кассы>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Cash(), inCode, inCashName
                                , inAccessKeyId:= CASE WHEN COALESCE (inBranchId, 0) = 0 THEN zc_Enum_Process_AccessKey_CashDnepr() ELSE (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId) END);

   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Branch(), ioId, inBranchId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_JuridicalBasis(), ioId, inJuridicalBasisId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Business(), ioId, inBusinessId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_PaidKind(), ioId, inPaidKindId); 
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Cash_notCurrencyDiff(), ioId, inisNotCurrencyDiff);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
  
 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.24         *
 25.11.14         * add PaidKind                 
 28.12.13                                        * rename to zc_ObjectLink_Cash_JuridicalBasis
 26.12.13                                        * add inAccessKeyId
 24.11.13                                        * err lfGet_ObjectCode (zc_Object_Cash(), inCode)
 24.11.13                                        * Cyr1251
 10.06.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Cash()
