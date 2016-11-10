-- Function: gpSelect_DefaultValue(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_DefaultValue (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_DefaultValue(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, KeyId Integer, Key TVarChar, FormClassName TVarChar, DescName TVarChar,
               UserId Integer, UserName TVarChar, ItemName_user TVarChar, ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, ItemName_value TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT DefaultValue.Id,
              DefaultKeys.Id AS KeyId, 
              DefaultKeys.Key, 
              ((DefaultKeys.KeyData::json)->>'FormClassName')::TVarChar AS FormClassName, 
              ((DefaultKeys.KeyData::json)->>'DescName')::TVarChar AS DescName,

              Object_User.Id AS UserId, 
              Object_User.ValueData AS UserName,
              ObjectDesc_User.ItemName AS ItemName_user,

              Object.Id AS ObjectId,
              Object.ObjectCode AS ObjectCode,
              Object.ValueData AS ObjectName,
              ObjectDesc_value.ItemName AS ItemName_value
         FROM DefaultValue
              JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
         LEFT JOIN Object AS Object_User ON Object_User.Id = UserKeyId
         LEFT JOIN ObjectDesc AS ObjectDesc_User ON ObjectDesc_User.Id = Object_User.DescId
         LEFT JOIN Object ON Object.Id = zfConvert_StringToNumber (DefaultValue.DefaultValue)
         LEFT JOIN ObjectDesc AS ObjectDesc_value ON ObjectDesc_value.Id = Object.DescId
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_DefaultValue (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.12.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_DefaultValue (zfCalc_UserAdmin())
