-- Function: gpGet_Object_User()

DROP FUNCTION IF EXISTS gpGet_Object_User (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User(
    IN inId          Integer,       -- пользователь 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name TVarChar
             , Password TVarChar
             , MemberId Integer
             , MemberName TVarChar
             , LanguageId Integer
             , LanguageName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Object_User());


   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
              0 :: Integer    AS Id
           ,  NEXTVAL ('Object_User_seq') :: Integer AS Code
           , '' :: TVarChar  AS NAME
           , '' :: TVarChar  AS Password
           ,  0 :: Integer   AS MemberId 
           , '' :: TVarChar  AS MemberName
           ,  0 :: Integer   AS LanguageId
           , '' :: TVarChar  AS LanguageName;
   ELSE
      RETURN QUERY 
      SELECT 
            Object_User.Id                       AS Id
          , Object_User.ObjectCode               AS Code
          , Object_User.ValueData                AS NAME
          , ObjectString_UserPassword.ValueData  AS Password
          , Object_Member.Id                     AS MemberId
          , Object_Member.ValueData              AS MemberName
          , Object_Language.Id                   AS LanguageId
          , Object_Language.ValueData            AS LanguageName
      FROM Object AS Object_User
           LEFT JOIN ObjectString AS ObjectString_UserPassword 
                                  ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password() 
                                 AND ObjectString_UserPassword.ObjectId = Object_User.Id

           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_User_Language
                                ON ObjectLink_User_Language.ObjectId = Object_User.Id
                               AND ObjectLink_User_Language.DescId = zc_ObjectLink_User_Language()
           LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_User_Language.ChildObjectId

      WHERE Object_User.Id = inId;
   END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
 21.10.20         * Language
 15.02.18         *
 05.05.17                                                          *
 12.09.16         *
 07.06.13                                        * lpCheckRight
 03.06.13         *
*/

-- тест
-- SELECT * FROM gpGet_Object_User (1, zfCalc_UserAdmin())
