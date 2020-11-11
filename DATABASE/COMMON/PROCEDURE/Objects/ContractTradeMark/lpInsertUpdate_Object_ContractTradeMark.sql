-- Function: gpInsertUpdate_Object_ContractTradeMark  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContractTradeMark (Integer,Integer,Integer,Integer,Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_ContractTradeMark(
 INOUT ioId                Integer   ,    -- ключ объекта <> 
    IN inCode              Integer   ,    -- Код объекта <>
    IN inContractId        Integer   ,    --   
    IN inTradeMarkId       Integer   ,    -- 
    IN inUserId            Integer       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbCode_calc Integer;   
BEGIN
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractTradeMark()); 
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractTradeMark(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractTradeMark(), vbCode_calc, '');

   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractTradeMark_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractTradeMark_TradeMark(), ioId, inTradeMarkId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.20         *
*/

-- тест
--