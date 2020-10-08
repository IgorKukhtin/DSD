-- Function: gpSelect_Object_MemberExternal_Juridical()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberExternal_Juridical (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberExternal_Juridical(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, INN TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     -- zc_Object_MemberExternal
     SELECT 
           Object_MemberExternal.Id         AS Id
         , Object_MemberExternal.ObjectCode AS Code
         , Object_MemberExternal.ValueData  AS Name
         , ObjectString_INN.ValueData       AS INN

         , ObjectDesc.ItemName

         , Object_MemberExternal.isErased   AS isErased

     FROM Object AS Object_MemberExternal
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MemberExternal.DescId
          
          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_MemberExternal.Id
                                AND ObjectString_INN.DescId = zc_ObjectString_MemberExternal_INN()
     WHERE Object_MemberExternal.DescId = zc_Object_MemberExternal()
       AND (Object_MemberExternal.isErased = FALSE OR inIsShowAll = TRUE)

   UNION ALL
     -- zc_Object_Member
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         , ObjectString_INN.ValueData AS INN

         , ObjectDesc.ItemName

         , Object_Member.isErased   AS isErased

     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId

          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
     WHERE Object_Member.DescId = zc_Object_Member()
       AND (Object_Member.isErased = FALSE OR inIsShowAll = TRUE)                

   UNION ALL
     -- zc_Object_Juridical
     SELECT 
           Object_Juridical.Id         AS Id
         , Object_Juridical.ObjectCode AS Code
         , Object_Juridical.ValueData  AS Name
         , ObjectHistory_JuridicalDetails_View.OKPO AS INN

         , ObjectDesc.ItemName

         , Object_Juridical.isErased   AS isErased

     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       AND (Object_Juridical.isErased = FALSE OR inIsShowAll = TRUE)

   UNION ALL
    SELECT 0                     AS Id
         , NULL :: Integer       AS Code
         , 'УДАЛИТЬ' :: TVarChar AS Name
         , '' :: TVarChar        AS ItemName
         , FALSE                 AS isErased
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberExternal_Juridical (FALSE, zfCalc_UserAdmin())
