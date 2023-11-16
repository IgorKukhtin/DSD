-- Function: gpSelect_Object_CarExternal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CarExternal (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CarExternal (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CarExternal(
    IN inIsShowAll        Boolean,   
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar 
             , Length TFloat, Width TFloat, Height TFloat
             , Weight TFloat, Year TFloat
             , VIN TVarChar
             , RegistrationCertificate TVarChar, Comment TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar , CarModelName_full TVarChar
             , CarTypeId Integer, CarTypeCode Integer, CarTypeName TVarChar
             , CarPropertyId Integer, CarPropertyCode Integer, CarPropertyName TVarChar
             , ObjectColorId Integer, ObjectColorCode Integer, ObjectColorName TVarChar
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

           , COALESCE (ObjectFloat_Length.ValueData,0)         :: TFloat  AS Length
           , COALESCE (ObjectFloat_Width.ValueData,0)          :: TFloat  AS Width 
           , COALESCE (ObjectFloat_Height.ValueData,0)         :: TFloat  AS Height
           , COALESCE (ObjectFloat_Weight.ValueData,0)         :: TFloat  AS Weight
           , COALESCE (ObjectFloat_Year.ValueData,0)           :: TFloat  AS Year

           , ObjectString_VIN.ValueData    :: TVarChar AS VIN
           , RegistrationCertificate.ValueData  AS RegistrationCertificate
           , ObjectString_Comment.ValueData     AS Comment
           
           , Object_CarModel.Id           AS CarModelId
           , Object_CarModel.ObjectCode   AS CarModelCode
           , Object_CarModel.ValueData    AS CarModelName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName_full

           , Object_CarType.Id            AS CarTypeId
           , Object_CarType.ObjectCode    AS CarTypeCode
           , Object_CarType.ValueData     AS CarTypeName

           , Object_CarProperty.Id         AS CarPropertyId
           , Object_CarProperty.ObjectCode AS CarPropertyCode
           , Object_CarProperty.ValueData  AS CarPropertyName
           
           , Object_ObjectColor.Id         AS ObjectColorId
           , Object_ObjectColor.ObjectCode AS ObjectColorCode
           , Object_ObjectColor.ValueData  AS ObjectColorName

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
            LEFT JOIN ObjectString AS ObjectString_VIN
                                   ON ObjectString_VIN.ObjectId = Object_CarExternal.Id
                                  AND ObjectString_VIN.DescId = zc_ObjectString_CarExternal_VIN()

            LEFT JOIN ObjectLink AS CarExternal_CarModel
                                 ON CarExternal_CarModel.ObjectId = Object_CarExternal.Id
                                AND CarExternal_CarModel.DescId = zc_ObjectLink_CarExternal_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = CarExternal_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS CarExternal_CarType
                                 ON CarExternal_CarType.ObjectId = Object_CarExternal.Id
                                AND CarExternal_CarType.DescId = zc_ObjectLink_CarExternal_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = CarExternal_CarType.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_Juridical 
                                 ON ObjectLink_CarExternal_Juridical.ObjectId = Object_CarExternal.Id
                                AND ObjectLink_CarExternal_Juridical.DescId = zc_ObjectLink_CarExternal_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CarExternal_Juridical.ChildObjectId            

            LEFT JOIN ObjectLink AS CarExternal_CarProperty
                                 ON CarExternal_CarProperty.ObjectId = Object_CarExternal.Id
                                AND CarExternal_CarProperty.DescId = zc_ObjectLink_CarExternal_CarProperty()
            LEFT JOIN Object AS Object_CarProperty ON Object_CarProperty.Id = CarExternal_CarProperty.ChildObjectId

            LEFT JOIN ObjectLink AS CarExternal_ObjectColor
                                 ON CarExternal_ObjectColor.ObjectId = Object_CarExternal.Id
                                AND CarExternal_ObjectColor.DescId = zc_ObjectLink_CarExternal_ObjectColor()
            LEFT JOIN Object AS Object_ObjectColor ON Object_ObjectColor.Id = CarExternal_ObjectColor.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                  ON ObjectFloat_Length.ObjectId = Object_CarExternal.Id
                                 AND ObjectFloat_Length.DescId = zc_ObjectFloat_CarExternal_Length()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                  ON ObjectFloat_Width.ObjectId = Object_CarExternal.Id
                                 AND ObjectFloat_Width.DescId = zc_ObjectFloat_CarExternal_Width()
            LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                  ON ObjectFloat_Height.ObjectId = Object_CarExternal.Id
                                 AND ObjectFloat_Height.DescId = zc_ObjectFloat_CarExternal_Height()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_CarExternal.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_CarExternal_Weight()
            LEFT JOIN ObjectFloat AS ObjectFloat_Year
                                  ON ObjectFloat_Year.ObjectId = Object_CarExternal.Id
                                 AND ObjectFloat_Year.DescId = zc_ObjectFloat_CarExternal_Year()

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
 16.11.23         *
 17.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_CarExternal (TRUE, zfCalc_UserAdmin())
