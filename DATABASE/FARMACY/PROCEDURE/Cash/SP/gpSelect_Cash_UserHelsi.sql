-- Function: gpSelect_Cash_UserHelsi()

--DROP FUNCTION IF EXISTS gpSelect_Cash_UserHelsi (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Cash_UserHelsi (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_UserHelsi (
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer 
             , Name TVarChar
             , UnitId Integer
             , UserName TVarChar
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

        , ObjectLink_User_Unit.ChildObjectId AS UnitId

        ,  CASE WHEN inSession = '0' 
           THEN 'roza.y+gonchar@helsi.me'
           ELSE ObjectString_UserName.ValueData END::TVarChar 
        ,  CASE WHEN inSession = '0'
           THEN encode('Test12341234'::bytea, 'base64')
           ELSE encode(ObjectString_UserPassword.ValueData::bytea, 'base64') END::TVarChar
        , ObjectBlob_Key.ValueData
        , CASE WHEN inSession = '0'
           THEN encode('111'::bytea, 'base64')
           ELSE encode(ObjectString_KeyPassword.ValueData::bytea, 'base64') END::TVarChar
   FROM Object AS Object_User

         INNER JOIN ObjectLink AS ObjectLink_User_Unit
                 ON ObjectLink_User_Unit.ObjectId = Object_User.Id
                AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Helsi_Unit()
                AND ObjectLink_User_Unit.ChildObjectId = vbUnitId
                
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
               
 WHERE Object_User.DescId = zc_Object_User();

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.04.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Cash_UserHelsi('3')