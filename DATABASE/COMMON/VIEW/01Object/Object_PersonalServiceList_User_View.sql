-- View: Object_PersonalServiceList_User_View

CREATE OR REPLACE VIEW Object_PersonalServiceList_User_View
AS
      SELECT ObjectLink_User_Member.ObjectId AS UserId
           , Object_PersonalServiceList.Id   AS PersonalServiceListId
           , ObjectBoolean.ValueData         AS isAll
      FROM ObjectLink AS ObjectLink_User_Member
           -- Назанчен в правах
           INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                 ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
           INNER JOIN Object AS Object_MemberPersonalServiceList
                             ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                            -- Права НЕ удалены
                            AND Object_MemberPersonalServiceList.isErased = FALSE
           -- признак - ВСЕ Ведомости
           LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                  AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
           -- нашли Ведомость
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
           LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                         AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                           -- !!! или ВСЕ !!!
                                                           OR ObjectBoolean.ValueData          = TRUE
                                                             )
      WHERE ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()

     UNION
      SELECT ObjectLink_User_Member.ObjectId AS UserId
           , Object_PersonalServiceList.Id   AS PersonalServiceListId
           , FALSE                           AS isAll
      FROM ObjectLink AS ObjectLink_User_Member
           -- Назанчен в Ведомости
           INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                 ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
           LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                         AND Object_PersonalServiceList.Id     = ObjectLink_PersonalServiceList_Member.ObjectId
      WHERE ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
     ;

ALTER TABLE Object_PersonalServiceList_User_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.24                                        *
*/

-- тест
-- SELECT * FROM Object_PersonalServiceList_User_View
