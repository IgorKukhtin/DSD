-- Function: gpInsertUpdate_Object_Cash()

-- DROP FUNCTION gpInsertUpdate_Object_Cash();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId	         Integer   ,   	-- ключ объекта <Касса> 
    IN inCode        Integer   ,    -- код объекта <Касса> 
    IN inCashName    TVarChar  ,    -- Название объекта <Касса> 
    IN inCurrencyId  Integer   ,    -- Валюта данной кассы 
    IN inBranchId    Integer   ,    -- Какому филиалу принадлежит касса 
    IN inPaidKindhId Integer   ,    -- Вид формы оплаты кассы 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
 
 BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Cash();
   ELSE
       Code_max := inCode;
   END IF; 
    
   -- проверка прав уникальности для свойства <Наименование Касса>  
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Cash(), inCashName);
   -- проверка прав уникальности для свойства <Код Кассы>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Cash(), Code_max, inCashName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Cash_Branch(), ioId, inBranchId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Cash(Integer, Integer, TVarChar, Integer, Integer, Integer, tvarchar)
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
  

  
                            