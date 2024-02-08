-- View: Object_PersonalServiceList_User_View

CREATE OR REPLACE VIEW Object_PersonalServiceList_User_View AS
      SELECT ObjectLink_User_Member.ObjectId AS UserId
           , Object_PersonalServiceList.Id   AS PersonalServiceListId
      FROM ObjectLink AS ObjectLink_User_Member
           INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                 ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
           INNER JOIN Object AS Object_MemberPersonalServiceList
                             ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                            AND Object_MemberPersonalServiceList.isErased = FALSE
           LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                  AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
           LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                         AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                           OR ObjectBoolean.ValueData          = TRUE)
      WHERE ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()

     UNION
      SELECT ObjectLink_User_Member.ObjectId AS UserId
           , Object_PersonalServiceList.Id   AS PersonalServiceListId
      FROM ObjectLink AS ObjectLink_User_Member
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
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 07.02.24                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_PersonalServiceList_User_View
