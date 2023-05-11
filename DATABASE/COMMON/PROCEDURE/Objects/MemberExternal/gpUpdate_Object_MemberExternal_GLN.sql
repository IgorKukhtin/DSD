-- Function: gpUpdate_Object_MemberExternal_GLN()

DROP FUNCTION IF EXISTS gpUpdate_Object_MemberExternal_GLN (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_MemberExternal_GLN(
    IN inMemberExternalId      Integer   ,    -- ключ объекта <Пользователь> 
    IN inGLN                   TVarChar  ,    -- 
    IN inSession               TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_MemberExternal_GLN());
   
   
   IF COALESCE (inMemberExternalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено физ.лицо.';
   END IF;

   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_GLN(), inMemberExternalId, inGLN);
  
   -- Cохранили протокол
   PERFORM lpInsert_ObjectProtocol (inMemberExternalId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.23         *
*/

-- тест
--