-- Function: gpSelect_Object_UserByGroupList (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_UserByGroupList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserByGroupList(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UserId Integer, UserCode Integer, UserName TVarChar
             , ParentId Integer
             , UserByGroupId Integer, UserByGroupCode Integer, UserByGroupName TVarChar
             , isErased Boolean   
             , MemberId Integer, MemberName TVarChar
             , BranchCode Integer
             , BranchName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_UserByGroupList());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpPersonal AS (SELECT View_Personal.MemberId
                               , MAX (View_Personal.UnitId) AS UnitId
                               , MAX (View_Personal.PositionId) AS PositionId
                          FROM Object_Personal_View AS View_Personal
                          WHERE View_Personal.isErased = FALSE
                          GROUP BY View_Personal.MemberId
                         )

       SELECT 
             Object_UserByGroupList.Id     AS Id
         
           , Object_User.Id                AS UserId
           , Object_User.ObjectCode        AS UserCode
           , Object_User.ValueData         AS UserName

           , Object_UserByGroup.Id         AS ParentId
           , Object_UserByGroup.Id         AS UserByGroupId
           , Object_UserByGroup.ObjectCode AS UserByGroupCode
           , Object_UserByGroup.ValueData  AS UserByGroupName
       
           , Object_UserByGroupList.isErased  AS isErased

           , Object_Member.Id          AS MemberId
           , Object_Member.ValueData   AS MemberName
           , Object_Branch.ObjectCode  AS BranchCode
           , Object_Branch.ValueData   AS BranchName
           , Object_Unit.ObjectCode    AS UnitCode
           , Object_Unit.ValueData     AS UnitName
           , Object_Position.ValueData AS PositionName
       FROM Object AS Object_UserByGroupList
                                                            
            LEFT JOIN ObjectLink AS ObjectLink_UserByGroupList_User
                                 ON ObjectLink_UserByGroupList_User.ObjectId = Object_UserByGroupList.Id
                                AND ObjectLink_UserByGroupList_User.DescId = zc_ObjectLink_UserByGroupList_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_UserByGroupList_User.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_UserByGroupList_UserByGroup
                                 ON ObjectLink_UserByGroupList_UserByGroup.ObjectId = Object_UserByGroupList.Id
                                AND ObjectLink_UserByGroupList_UserByGroup.DescId = zc_ObjectLink_UserByGroupList_UserByGroup()
            LEFT JOIN Object AS Object_UserByGroup ON Object_UserByGroup.Id = ObjectLink_UserByGroupList_UserByGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
    
            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

     WHERE Object_UserByGroupList.DescId = zc_Object_UserByGroupList()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UserByGroupList (zfCalc_UserAdmin())
