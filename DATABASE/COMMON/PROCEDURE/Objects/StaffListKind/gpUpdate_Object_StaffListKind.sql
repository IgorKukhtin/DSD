
-- Function: gpUpdate_Object_StaffListKind  (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_StaffListKind (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_StaffListKind(
    IN inId                Integer   ,    -- ключ объекта <> 
    IN inComment           TVarChar  ,    -- 
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_StaffListKind());
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StaffListKind_Comment(), inId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         * 
*/

-- тест
--