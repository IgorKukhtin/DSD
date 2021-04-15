-- Function: gpGet_Object_User()

DROP FUNCTION IF EXISTS gpGet_Object_HelsiUser (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_HelsiUser(
    IN inId          Integer,       -- пользователь 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , UserName TVarChar
             , UserPassword TVarChar
             , Key TBlob
             , KeyPassword TVarChar
             , LikiDnepr_UnitId Integer, LikiDnepr_UnitName TVarChar
             , LikiDnepr_UserEmail TVarChar
             , LikiDnepr_PasswordEHels TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Object_User());

   IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
     8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
   THEN
     RAISE EXCEPTION 'У вас нет прав выполнение операции.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Запись не сохранена.';
   END IF;

   RETURN QUERY 
   SELECT 
          Object_User.Id
        , Object_User.ObjectCode
        , Object_User.ValueData

        , Object_Unit.Id AS UnitId
        , Object_Unit.ValueData AS UnitName

        , ObjectString_UserName.ValueData
        , ObjectString_UserPassword.ValueData
        , ObjectBlob_Key.ValueData
        , ObjectString_KeyPassword.ValueData
        
        , Object_LikiDnepr_Unit.Id AS LikiDnepr_UnitId
        , Object_LikiDnepr_Unit.ValueData AS LikiDnepr_UnitName
        , ObjectString_LikiDnepr_UserEmail.ValueData
        , ObjectString_LikiDnepr_PasswordEHels.ValueData

   FROM Object AS Object_User

         LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                ON ObjectLink_User_Unit.ObjectId = Object_User.Id
               AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Helsi_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_UserName 
                ON ObjectString_UserName.DescId = zc_ObjectString_User_Helsi_UserName() 
               AND ObjectString_UserName.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_UserPassword
                ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Helsi_UserPassword() 
               AND ObjectString_UserPassword.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectBlob AS ObjectBlob_Key
                ON ObjectBlob_Key.DescId = zc_ObjectBlob_User_Helsi_Key() 
               AND ObjectBlob_Key.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
               AND ObjectString_KeyPassword.ObjectId = Object_User.Id
                         
         LEFT JOIN ObjectLink AS ObjectLink_User_LikiDnepr_Unit
                ON ObjectLink_User_LikiDnepr_Unit.ObjectId = Object_User.Id
               AND ObjectLink_User_LikiDnepr_Unit.DescId = zc_ObjectLink_User_LikiDnepr_Unit()
         LEFT JOIN Object AS Object_LikiDnepr_Unit ON Object_LikiDnepr_Unit.Id = ObjectLink_User_LikiDnepr_Unit.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_LikiDnepr_UserEmail
                ON ObjectString_LikiDnepr_UserEmail.DescId = zc_ObjectString_User_LikiDnepr_UserEmail() 
               AND ObjectString_LikiDnepr_UserEmail.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_LikiDnepr_PasswordEHels
                ON ObjectString_LikiDnepr_PasswordEHels.DescId = zc_ObjectString_User_LikiDnepr_PasswordEHels() 
               AND ObjectString_LikiDnepr_PasswordEHels.ObjectId = Object_User.Id

   WHERE Object_User.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_HelsiUser (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.04.19                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_HelsiUser (3, '3')
