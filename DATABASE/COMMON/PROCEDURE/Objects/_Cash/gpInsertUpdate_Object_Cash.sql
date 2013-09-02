-- Function: gpInsertUpdate_Object_Cash()

-- DROP FUNCTION gpInsertUpdate_Object_Cash();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId	         Integer   ,   	-- ключ объекта <Касса> 
    IN inCode            Integer   ,    -- код объекта <Касса> 
    IN inCashName        TVarChar  ,    -- Название объекта <Касса> 
    IN inCurrencyId      Integer   ,    -- Валюта данной кассы 
    IN inBranchId        Integer   ,    -- Какому филиалу принадлежит касса 
    IN inMainJuridicalId Integer   ,    -- Главное юр Лицо
    IN inBusinessId      Integer   ,    -- Бизнес
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
 BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode(zc_Object_Cash(), inCode);
    
   -- проверка прав уникальности для свойства <Наименование Касса>  
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Cash(), inCashName);
   -- проверка прав уникальности для свойства <Код Кассы>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Cash(), inCode, inCashName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Cash_Branch(), ioId, inBranchId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Cash_MainJuridical(), ioId, inMainJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Cash_Business(), ioId, inBusinessId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Cash(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, tvarchar)
  OWNER TO postgres;
  
  
 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 03.06.13
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Cash()
  

  
                            