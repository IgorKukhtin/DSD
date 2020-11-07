-- Function: gpInsertUpdate_Object_ContractGoods  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, TDateTime, TDateTime, Tfloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_ContractGoods(
 INOUT ioId                Integer   ,    -- ключ объекта <> 
    IN inCode              Integer   ,    -- Код объекта <>
    IN inContractId        Integer   ,    --   
    IN inGoodsId           Integer   ,    -- 
    IN inGoodsKindId       Integer   ,    --   
    IN inStartDate         TDateTime ,    --
    IN inEndDate           TDateTime ,    --
    IN inPrice             Tfloat    ,
    IN inUserId            Integer       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbCode_calc Integer;   
BEGIN
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractGoods()); 
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractGoods(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractGoods(), vbCode_calc, '');

   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_Goods(), ioId, inGoodsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractGoods_Price(), ioId, inPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractGoods_Start(), ioId, inStartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractGoods_End(), ioId, inEndDate);
 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.11.20         *

*/

-- тест
--