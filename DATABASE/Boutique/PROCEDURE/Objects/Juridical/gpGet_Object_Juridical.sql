-- Function: gpGet_Object_Juridical()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- Юридические лица
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isCorporate Boolean, FullName TVarChar, Address TVarChar, OKPO TVarChar, INN TVarChar, JuridicalGroupId Integer, JuridicalGroupName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
               0 :: Integer                       AS Id
           , lfGet_ObjectCode(0, zc_Object_Juridical())   AS Code
           , '' :: TVarChar                       AS Name
           , FALSE :: Boolean                     AS isCorporate
           , '' :: TVarChar                       AS FullName
           , '' :: TVarChar                       AS Address
           , '' :: TVarChar                       AS OKPO
           , '' :: TVarChar                       AS INN
           ,  0 :: Integer                        AS JuridicalGroupId
           , '' :: TVarChar                       AS JuridicalGroupName
       ;
   ELSE
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
           , Object_JuridicalGroup.Id             AS JuridicalGroupId
           , Object_JuridicalGroup.ValueData      AS JuridicalGroupName      
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

      WHERE Object_Juridical.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Juridical(1,'2')
