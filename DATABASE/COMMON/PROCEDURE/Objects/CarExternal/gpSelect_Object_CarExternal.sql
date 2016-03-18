-- Function: gpSelect_Object_CarExternal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CarExternal (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CarExternal (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CarExternal(
    IN inIsShowAll        Boolean,   
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar 
             , RegistrationCertificate TVarChar, Comment TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_CarExternal());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);
     
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_CarExternal.Id          AS Id
           , Object_CarExternal.ObjectCode  AS Code
           , Object_CarExternal.ValueData   AS Name
           , (COALESCE (Object_CarModel.ValueData, '') || ' ' || COALESCE (Object_CarExternal.ValueData, '')) :: TVarChar AS NameAll
           
           , RegistrationCertificate.ValueData  AS RegistrationCertificate
           , ObjectString_Comment.ValueData     AS Comment
           
           , Object_CarModel.Id           AS CarModelId
           , Object_CarModel.ObjectCode   AS CarModelCode
           , Object_CarModel.ValueData    AS CarModelName
         
           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName           
           
           , Object_CarExternal.isErased  AS isErased
           
       FROM Object AS Object_CarExternal
            
            LEFT JOIN ObjectString AS RegistrationCertificate 
                                   ON RegistrationCertificate.ObjectId = Object_CarExternal.Id 
                                  AND RegistrationCertificate.DescId = zc_ObjectString_CarExternal_RegistrationCertificate()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_CarExternal.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_CarExternal_Comment()
                                                             
            LEFT JOIN ObjectLink AS CarExternal_CarModel
                                 ON CarExternal_CarModel.ObjectId = Object_CarExternal.Id
                                AND CarExternal_CarModel.DescId = zc_ObjectLink_CarExternal_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = CarExternal_CarModel.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_Juridical 
                                 ON ObjectLink_CarExternal_Juridical.ObjectId = Object_CarExternal.Id
                                AND ObjectLink_CarExternal_Juridical.DescId = zc_ObjectLink_CarExternal_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CarExternal_Juridical.ChildObjectId            

     WHERE Object_CarExternal.DescId = zc_Object_CarExternal()
       AND (Object_CarExternal.isErased = FALSE
        OR (Object_CarExternal.isErased = TRUE AND inIsShowAll = TRUE))
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_CarExternal (TRUE, zfCalc_UserAdmin())
