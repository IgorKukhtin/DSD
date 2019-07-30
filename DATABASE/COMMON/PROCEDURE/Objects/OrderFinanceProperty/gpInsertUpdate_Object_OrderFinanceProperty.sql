-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinanceProperty (Integer, Integer, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderFinanceProperty(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inOrderFinanceId          Integer   ,    -- 
    IN inObjectId                Integer   ,    -- 
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderFinanceProperty());
   vbUserId := lpGetUserBySession (inSession); 
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderFinanceProperty(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinanceProperty_OrderFinance(), ioId, inOrderFinanceId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinanceProperty_Object(), ioId, inObjectId);   


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         * 

*/

-- тест
--