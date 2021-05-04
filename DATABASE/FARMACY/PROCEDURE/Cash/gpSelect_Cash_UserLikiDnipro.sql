-- Function: gpSelect_Cash_UserLikiDnipro()

DROP FUNCTION IF EXISTS gpSelect_Cash_UserLikiDnipro (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_UserLikiDnipro (
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer 
             , Name TVarChar
             , UnitId Integer
             , UserEmail TVarChar
             , UserPassword TVarChar
             , Key TBlob
             , KeyPassword TVarChar
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbCashRegisterId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   RETURN QUERY
   SELECT 
          Object_User.Id
        , Object_User.ValueData

        , ObjectLink_User_LikiDnepr_Unit.ChildObjectId AS UnitId

        , ObjectString_UserEmail.ValueData
        , encode(ObjectString_UserPassword.ValueData::bytea, 'base64')::TVarChar
        , ObjectBlob_Key.ValueData
        , encode(ObjectString_KeyPassword.ValueData::bytea, 'base64')::TVarChar
   FROM Object AS Object_User

         INNER JOIN ObjectLink AS ObjectLink_User_LikiDnepr_Unit
                 ON ObjectLink_User_LikiDnepr_Unit.ObjectId = Object_User.Id
                AND ObjectLink_User_LikiDnepr_Unit.DescId = zc_ObjectLink_User_LikiDnepr_Unit()
                AND ObjectLink_User_LikiDnepr_Unit.ChildObjectId = vbUnitId
                
         LEFT JOIN ObjectString AS ObjectString_UserEmail
                ON ObjectString_UserEmail.DescId = zc_ObjectString_User_LikiDnepr_UserEmail() 
               AND ObjectString_UserEmail.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_UserPassword
                ON ObjectString_UserPassword.DescId = zc_ObjectString_User_LikiDnepr_PasswordEHels() 
               AND ObjectString_UserPassword.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectBlob AS ObjectBlob_Key
                ON ObjectBlob_Key.DescId = zc_ObjectBlob_User_Helsi_Key() 
               AND ObjectBlob_Key.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
               AND ObjectString_KeyPassword.ObjectId = Object_User.Id
               
 WHERE Object_User.DescId = zc_Object_User();

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.05.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Cash_UserLikiDnipro('3')