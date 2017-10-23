-- Function: gpUpdate_Object_User_ScalePSW()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_ScalePSW (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Member_ScalePSW (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_ScalePSW(
    IN inMemberId      Integer   ,    -- ключ объекта <Пользователь> 
    IN inScalePSW      TVarChar  ,    -- пароль
    IN inSession       TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Member_ScalePSW());
   
   
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.У сотрудника не определено физ.лицо.';
   END IF;

   IF zfConvert_StringToNumber (inScalePSW) = 0 AND inScalePSW <> ''
   THEN
       RAISE EXCEPTION 'Ошибка.Пароль должен быть числом больше 0.';
   END IF;

   IF CHAR_LENGTH (inScalePSW) >= 8
   THEN
       RAISE EXCEPTION 'Ошибка.Пароль должен быть числом до 8 знаков.';
   END IF;

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Member_ScalePSW(), inMemberId, zfConvert_StringToNumber (inScalePSW));
  
   -- Cохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (inMemberId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.17         * rename
 20.01.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Member_ScalePSW ('2')
