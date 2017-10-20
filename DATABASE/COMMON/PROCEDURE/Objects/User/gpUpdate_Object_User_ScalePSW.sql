-- Function: gpUpdate_Object_User_ScalePSW()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_ScalePSW (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_ScalePSW(
    IN inUserId      Integer   ,    -- ключ объекта <Пользователь> 
    IN inScalePSW    TFloat    ,    -- пароль
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_User_ScalePSW());
   
   
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.У сотрудника не определен пользователь.';
   END IF;

   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_User_ScalePSW(), inUserId, inScalePSW);
  
   -- Cохранили протокол
   PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_User_ScalePSW ('2')