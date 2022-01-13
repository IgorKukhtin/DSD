-- Function: gpSelect_Object_User (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , User_ TVarChar, isSign Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY 
   SELECT 
         Object_User.Id
       , Object_User.ObjectCode
       , Object_User.ValueData
       , Object_User.isErased
       , Object_Member.Id        AS MemberId
       , Object_Member.ValueData AS MemberName

       , CASE WHEN vbUserId = 5 THEN ObjectString_User_.ValueData ELSE '' END :: TVarChar AS User_
       , COALESCE (ObjectBoolean_Sign.ValueData,FALSE) ::Boolean AS isSign

   FROM Object AS Object_User
        LEFT JOIN ObjectString AS ObjectString_User_
                               ON ObjectString_User_.ObjectId = Object_User.Id
                              AND ObjectString_User_.DescId = zc_ObjectString_User_Password()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Sign
                                ON ObjectBoolean_Sign.DescId = zc_ObjectBoolean_User_Sign() 
                               AND ObjectBoolean_Sign.ObjectId = Object_User.Id

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 13.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_User ('5')
