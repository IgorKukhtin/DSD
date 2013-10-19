-- Function: gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelServiceItemChild(
 INOUT ioId                  Integer   , -- ключ объекта <Подчиненные элементы Модели начисления>
    IN inComment             TVarChar  , -- Примечание
    IN inFromId              Integer   , -- Товар(От кого)
    IN inToId                Integer   , -- Товар(Кому) 	
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ModelServiceItemChild()());
   vbUserId := inSession;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ModelServiceItemChild(), 0, '');
   
   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ModelServiceItemChild_Comment(), ioId, inComment);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_From(), ioId, inFromId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_To(), ioId, inToId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ModelServiceItemChild (Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
20.10.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ModelServiceItemChild (0, '1000', 5, 6, '2')
    