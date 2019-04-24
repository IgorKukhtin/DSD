-- Function: gpInsertUpdate_Object_ContractCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RetailCostCredit (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RetailCostCredit(
 INOUT ioId                      Integer ,    -- ключ объекта <>
    IN inRetailId                  Integer ,    -- ссылка на подразделение
    IN inMinPrice                   TFloat  ,    --  
    IN inPercent                   TFloat  ,    --  
    IN inSession                 TVarChar     -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RetailCostCredit());
   vbUserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RetailCostCredit(), 0, '');
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RetailCostCredit_Retail(), ioId, inRetailId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RetailCostCredit_MinPrice(), ioId, inMinPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RetailCostCredit_Percent(), ioId, inPercent);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.04.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RetailCostCredit ()                            
