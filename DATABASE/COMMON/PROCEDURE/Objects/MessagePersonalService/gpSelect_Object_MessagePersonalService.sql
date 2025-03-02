--
DROP FUNCTION IF EXISTS gpSelect_Object_MessagePersonalService (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MessagePersonalService(
    IN inSessionCode            Integer,
    IN inPersonalServiceListId  Integer,            --
    IN inSession                TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , MemberId Integer, MemberName TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MessagePersonalService());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_MessagePersonalService.Id           AS Id
           , Object_MessagePersonalService.ObjectCode   AS Code   --Session
           , Object_MessagePersonalService.ValueData    AS Name   --Message
           , Object_Unit.Id                             AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_Member.Id                           AS MemberId
           , Object_Member.ValueData                    AS MemberName
           , ObjectString_Comment.ValueData             AS Comment

           , Object_Insert.ValueData                    AS InsertName
           , ObjectDate_Insert.ValueData                AS InsertDate
           , Object_MessagePersonalService.isErased     AS isErased

       FROM Object AS Object_MessagePersonalService
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MessagePersonalService.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_MessagePersonalService_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = Object_MessagePersonalService.Id
                              AND ObjectLink_Unit.DescId   = zc_ObjectLink_MessagePersonalService_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                               ON ObjectLink_PersonalServiceList.ObjectId = Object_MessagePersonalService.Id
                              AND ObjectLink_PersonalServiceList.DescId = zc_ObjectLink_MessagePersonalService_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Member
                               ON ObjectLink_Member.ObjectId = Object_MessagePersonalService.Id
                              AND ObjectLink_Member.DescId = zc_ObjectLink_MessagePersonalService_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Member.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_MessagePersonalService.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_MessagePersonalService.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

       WHERE Object_MessagePersonalService.DescId = zc_Object_MessagePersonalService()
         AND (Object_MessagePersonalService.ObjectCode = inSessionCode OR inSessionCode = 0)
         AND (COALESCE (Object_PersonalServiceList.Id,0) = inPersonalServiceListId OR inPersonalServiceListId = 0)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MessagePersonalService (inSessionCode:= 1, inPersonalServiceListId:= 0, inSession:= zfCalc_UserAdmin())
