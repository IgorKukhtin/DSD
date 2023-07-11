-- Function: gpUpdate_Object_Member_GLN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_GLN (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_GLN(
    IN inMemberId      Integer   ,    -- ключ объекта <Пользователь> 
    IN inGLN           TVarChar  ,    -- 
    IN inSession       TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Member_GLN());
   
   
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено физ.лицо.';
   END IF;

   --  
   
   PERFORM lpInsertUpdate_ObjectString (CASE WHEN (SELECT a.DescId FROM Object AS a WHERE a.Id = inMemberId) = zc_Object_Member()
                                             THEN zc_ObjectString_Member_GLN()
                                             ELSE zc_ObjectString_MemberExternal_GLN() END
                                      , inMemberId
                                      , inGLN);
  
   -- Cохранили протокол
   PERFORM lpInsert_ObjectProtocol (inMemberId, vbUserId);
 
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