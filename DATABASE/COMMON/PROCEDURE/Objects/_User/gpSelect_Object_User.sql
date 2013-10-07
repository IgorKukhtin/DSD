-- Function: gpSelect_Object_User (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, MemberId Integer, MemberName TVarChar) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_User());


   RETURN QUERY 
   SELECT 
         Object_User.Id
       , Object_User.ObjectCode
       , Object_User.ValueData
       , Object_User.isErased
       , Object_Member.Id AS MemberId
       , Object_Member.ValueData AS MemberName
   FROM Object AS Object_User
        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
   WHERE Object_User.DescId = zc_Object_User();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_User (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.06.13                                        * lpCheckRight
 25.09.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_User ('2')
