-- Function: gpInsertUpdate_Object_RouteMember()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RouteMember (Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RouteMember(
 INOUT ioId	          Integer   ,    -- ключ объекта <> 
    IN inCode             Integer   ,    -- код объекта <> 
    IN inRouteMemberName  TBlob     ,    -- 
    IN inSession          TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RouteMember());
  
   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_RouteMember());
    
   -- проверка прав уникальности для свойства <Наименование >  
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_RouteMember(), inRouteMemberName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RouteMember(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RouteMember(), inCode, '');

   -- сохранили описание
  
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_RouteMember_Description(), ioId, inRouteMemberName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RouteMember (Integer, Integer, TBlob, TVarChar) OWNER TO postgres;
  
 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.16         *
*/

-- тест
--SELECT * FROM gpInsertUpdate_Object_RouteMember(0,1,'лорпаввапро'::TBlob,'5'::TVarChar)
--SELECT * FROM gpSelect_Object_RouteMember (zfCalc_UserAdmin())

