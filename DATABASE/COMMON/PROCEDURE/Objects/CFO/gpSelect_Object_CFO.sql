-- Function: gpSelect_Object_CFO()

DROP FUNCTION IF EXISTS gpSelect_Object_CFO(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CFO(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_CFO());

     RETURN QUERY 
     SELECT 
           Object_CFO.Id              AS Id
         , Object_CFO.ObjectCode      AS Code
         , Object_CFO.ValueData       AS Name
         , Object_Member.Id         ::Integer  AS MemberId
         , Object_Member.ObjectCode ::Integer  AS MemberCode
         , Object_Member.ValueData  ::TVarChar AS MemberName
         
         , ObjectString_Comment.ValueData AS Comment
         , Object_CFO.isErased        AS isErased
     FROM Object AS Object_CFO
          LEFT JOIN ObjectLink AS ObjectLink_CFO_Member
                               ON ObjectLink_CFO_Member.ObjectId = Object_CFO.Id
                              AND ObjectLink_CFO_Member.DescId = zc_ObjectLink_CFO_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_CFO_Member.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_CFO.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_CFO_Comment()  
     WHERE Object_CFO.DescId = zc_Object_CFO()

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
         , '<ПУСТО>' :: TVarChar AS Name
         , NULL      ::Integer  AS MemberId
         , NULL      ::Integer  AS MemberCode
         , ''        ::TVarChar AS MemberName
         , ''        :: TVarChar AS Comment
         , FALSE                 AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_CFO (zfCalc_UserAdmin())