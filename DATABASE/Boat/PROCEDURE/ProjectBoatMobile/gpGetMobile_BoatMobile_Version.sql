-- Function: gpGetMobile_BoatMobile_Version (TVarChar)

DROP FUNCTION IF EXISTS gpGetMobile_BoatMobile_Version (TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_BoatMobile_Version(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (APKFileName     TVarChar
             , MajorVersion    Integer
             , MinorVersion    Integer
)
AS
$BODY$
  DECLARE vbUserId     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       -- Результат
       SELECT OBJECT.ValueData
            , COALESCE(MajorVersion.ValueData, 0)::INTEGER
            , COALESCE(MinorVersion.ValueData, 0)::INTEGER 
       FROM OBJECT 
       LEFT JOIN ObjectFloat AS MajorVersion 
         ON MajorVersion.objectid = OBJECT.id AND MajorVersion.DescId = zc_ObjectFloat_Program_MajorVersion()
       LEFT JOIN ObjectFloat AS MinorVersion 
         ON MinorVersion.objectid = OBJECT.id AND MinorVersion.DescId = zc_ObjectFloat_Program_MinorVersion()
       WHERE Object.ValueData = 'BoatMobile.apk' AND Object.DescId = zc_Object_Program();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.   Шаблий Щ.В.
 21.03.19                                                                    * APIKey
*/
-- тест
-- SELECT * FROM gpGetMobile_BoatMobile_Version (inSession:= zfCalc_UserAdmin())
