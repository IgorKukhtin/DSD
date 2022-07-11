-- Function: gpSelect_Object_UserLogin()

DROP FUNCTION IF EXISTS gpSelect_Object_UserLogin (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserLogin(
    IN inSession     TVarChar,  -- сессия пользователя
   OUT outLogin      TBlob      -- Список логинов
  )
RETURNS TBlob
AS
$BODY$
--   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());

    SELECT string_agg(Object_User.ValueData, Chr(13))
    INTO outLogin
    FROM Object AS Object_User
    WHERE Object_User.DescId = zc_Object_User()
      AND Object_User.isErased = FALSE
      AND COALESCE (Object_User.ValueData, '') <> ''
      AND Object_User.ObjectCode >= 0;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 07.07.22                                                      *
*/

-- тест
--

SELECT * FROM gpSelect_Object_UserLogin ('3')