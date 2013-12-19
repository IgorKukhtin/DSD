-- Function: gpSelect_DefaultValue(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_DefaultValue (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_DefaultValue(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Key TVarChar, FormClassName TVarChar, DescName TVarChar,
               UserName TVarChar, ObjectCode TVarChar, ObjectName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT DefaultValue.Id,
              DefaultKeys.Key, 
              (DefaultKeys.KeyData::json)->>'FormClassName' AS FormClassName, 
              (DefaultKeys.KeyData::json)->>'DescName' AS DescName,
              Object_User.ValueData AS UserName, 
              Object.ObjectCode AS ObjectCode,
              Object.ValueData AS ObjectName 
         FROM DefaultValue
         JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
         JOIN Object AS Object_User ON Object_User.Id = UserKeyId
         JOIN Object ON Object.Id = zfConvert_StringToNumber(DefaultValue.DefaultValue);

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
-- SELECT * FROM gpSelect_DefaultKey (zfCalc_UserAdmin())