-- Function: gpSelect_Object_SignInternalItem (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_SignInternalItem (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SignInternalItem(
    IN inShowAll        Boolean,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , SignInternalId Integer, SignInternalCode Integer, SignInternalName TVarChar
             , UserId Integer, UserCode Integer, UserName TVarChar, MemberName TVarChar
             , BranchName TVarChar
             , UnitName TVarChar
             , PositionName TVarChar
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

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
         Object_SignInternalItem.Id         AS Id 
       , Object_SignInternalItem.ObjectCode AS Code
       , Object_SignInternalItem.ValueData  AS Name
              
       , Object_SignInternal.Id         AS SignInternalId 
       , Object_SignInternal.ObjectCode AS SignInternalCode
       , Object_SignInternal.ValueData  AS SignInternalName

       , Object_User.Id            AS UserId
       , Object_User.ObjectCode    AS UserCode
       , Object_User.ValueData     AS UserName
       , Object_Member.ValueData   AS MemberName
       , Object_Branch.ValueData   AS BranchName
       , Object_Unit.ValueData     AS UnitName
       , Object_Position.ValueData AS PositionName

       , Object_SignInternalItem.isErased   AS isErased
       
   FROM Object AS Object_SignInternalItem
        INNER JOIN (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE) AS tmpIsErased ON tmpIsErased.isErased = Object_SignInternalItem.isErased 
       -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_SignInternalItem.AccessKeyId

        LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_SignInternal 
                             ON ObjectLink_SignInternalItem_SignInternal.ObjectId = Object_SignInternalItem.Id
                            AND ObjectLink_SignInternalItem_SignInternal.DescId = zc_ObjectLink_SignInternalItem_SignInternal()
        LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = ObjectLink_SignInternalItem_SignInternal.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_User 
                             ON ObjectLink_SignInternalItem_User.ObjectId = Object_SignInternalItem.Id
                            AND ObjectLink_SignInternalItem_User.DescId = zc_ObjectLink_SignInternalItem_User()
        LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_SignInternalItem_User.ChildObjectId

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
         
   WHERE Object_SignInternalItem.DescId = zc_Object_SignInternalItem()
--     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)

  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.16         *
*/


-- тест
-- SELECT * FROM gpSelect_Object_SignInternalItem (true, zfCalc_UserAdmin())

