-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinanceProperty (Integer, Integer, Integer, Tvarchar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinanceProperty (Integer, Integer, Integer, TFloat, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinanceProperty (Integer, Integer, Integer, TFloat, Boolean, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderFinanceProperty(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inOrderFinanceId          Integer   ,    -- 
    IN inObjectId                Integer   ,    -- 
    IN inNumGroup                TFloat    ,
    IN inisGroup                 Boolean   ,
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

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderFinanceProperty_Group(), ioId, inNumGroup);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderFinanceProperty_Group(), ioId, inisGroup);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.25         *
 29.07.19         * 

*/

-- тест
--