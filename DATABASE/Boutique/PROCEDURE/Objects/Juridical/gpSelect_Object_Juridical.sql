-- Function: gpSelect_Object_Juridical (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isCorporate Boolean, FullName TVarChar, Address TVarChar, OKPO TVarChar, INN TVarChar, JuridicalGroupName TVarChar, isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Juridical());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Juridical.Id                  AS Id
           , Object_Juridical.ObjectCode          AS Code
           , Object_Juridical.ValueData           AS Name
           , ObjectBoolean_isCorporate.ValueData  AS isCorporate
           , ObjectString_FullName.ValueData      AS FullName
           , ObjectString_Address.ValueData       AS Address
           , ObjectString_OKPO.ValueData          AS OKPO
           , ObjectString_INN.ValueData           AS INN
           , Object_JuridicalGroup.ValueData      AS JuridicalGroupName
           , Object_Juridical.isErased            AS isErased           
       FROM Object AS Object_Juridical
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                    ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                                   AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

            LEFT JOIN ObjectString AS ObjectString_FullName 
                                   ON ObjectString_FullName.ObjectId = Object_Juridical.Id 
                                  AND ObjectString_FullName.DescId = zc_ObjectString_Juridical_FullName()

            LEFT JOIN ObjectString AS ObjectString_Address 
                                   ON ObjectString_Address.ObjectId = Object_Juridical.Id 
                                  AND ObjectString_Address.DescId = zc_ObjectString_Juridical_Address()

            LEFT JOIN ObjectString AS ObjectString_OKPO 
                                   ON ObjectString_OKPO.ObjectId = Object_Juridical.Id 
                                  AND ObjectString_OKPO.DescId = zc_ObjectString_Juridical_OKPO()

            LEFT JOIN ObjectString AS ObjectString_INN 
                                   ON ObjectString_INN.ObjectId = Object_Juridical.Id 
                                  AND ObjectString_INN.DescId = zc_ObjectString_Juridical_INN()

     WHERE Object_Juridical.DescId = zc_Object_Juridical()
              AND (Object_Juridical.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
28.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical (TRUE, zfCalc_UserAdmin())