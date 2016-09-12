-- Function: gpGet_Object_DiscountExternal_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternal_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternal_Unit(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL      TVarChar
             , Service  TVarChar
             , Port     TVarChar
             , UserName TVarChar
             , Password TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternal());
     vbUserId := lpGetUserBySession (inSession);

     vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey :: Integer;

       -- Результат
       RETURN QUERY
       SELECT
             Object_DiscountExternal.Id         AS Id
           , Object_DiscountExternal.ObjectCode AS Code
           , Object_DiscountExternal.ValueData  AS Name

           , ObjectString_URL.ValueData       AS URL
           , ObjectString_Service.ValueData   AS Service
           , ObjectString_Port.ValueData      AS Port

           , ObjectString_User.ValueData             AS UserName
           , ObjectString_Password.ValueData         AS Password

       FROM Object AS Object_DiscountExternal
            LEFT JOIN ObjectString AS ObjectString_URL
                                   ON ObjectString_URL.ObjectId = Object_DiscountExternal.Id 
                                  AND ObjectString_URL.DescId = zc_ObjectString_DiscountExternal_URL()
            LEFT JOIN ObjectString AS ObjectString_Service
                                   ON ObjectString_Service.ObjectId = Object_DiscountExternal.Id 
                                  AND ObjectString_Service.DescId = zc_ObjectString_DiscountExternal_Service()
            LEFT JOIN ObjectString AS ObjectString_Port
                                   ON ObjectString_Port.ObjectId = Object_DiscountExternal.Id 
                                  AND ObjectString_Port.DescId = zc_ObjectString_DiscountExternal_Port()
            INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ChildObjectId = Object_DiscountExternal.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
            INNER JOIN ObjectLink AS ObjectLink_Unit
                                  ON ObjectLink_Unit.ObjectId      = ObjectLink_DiscountExternal.ObjectId
                                 AND ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountExternalTools_Unit()
                                 AND ObjectLink_Unit.ChildObjectId = vbUnitId

            LEFT JOIN ObjectString AS ObjectString_User
                                   ON ObjectString_User.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_User.DescId = zc_ObjectString_DiscountExternalTools_User()
            LEFT JOIN ObjectString AS ObjectString_Password
                                   ON ObjectString_Password.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternalTools_Password()

       WHERE Object_DiscountExternal.Id = inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternal_Unit (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.08.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountExternal_Unit (2488964, zfCalc_UserAdmin())
