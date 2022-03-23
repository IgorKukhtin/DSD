-- Function: gpSelect_Object_HelsiUserKey (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_HelsiUserKey (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_HelsiUserKey(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , Base64Key TBlob
             , KeyPassword TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Send());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 11041603))
   THEN
     RAISE EXCEPTION 'Доступно только системному администратору';
   END IF;

   -- Результат
   RETURN QUERY 
   SELECT 
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased

       , ObjectBlob_Key.ValueData                   AS Base64Key
       , ObjectString_KeyPassword.ValueData         AS KeyPassword
       
   FROM Object AS Object_User
        
         LEFT JOIN ObjectBlob AS ObjectBlob_Key
                ON ObjectBlob_Key.DescId = zc_ObjectBlob_User_Helsi_Key() 
               AND ObjectBlob_Key.ObjectId = Object_User.Id

         LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
               AND ObjectString_KeyPassword.ObjectId = Object_User.Id

   WHERE Object_User.DescId = zc_Object_User()
     AND COALESCE(ObjectBlob_Key.ValueData, '') <> ''
     AND COALESCE(ObjectString_KeyPassword.ValueData, '') <> '';
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_HelsiUserKey (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 19.03.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_HelsiUserKey ('3')