-- Function: gpSelect_Object_Branch(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Branch (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Branch(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InvNumber TVarChar
             , PersonalBookkeeperId Integer, PersonalBookkeeperName TVarChar
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- Результат
   RETURN QUERY 
   SELECT Object_Branch.Id           AS Id
        , Object_Branch.ObjectCode   AS Code
        , Object_Branch.ValueData    AS NAME
        
        , ObjectString_InvNumber.ValueData  AS InvNumber
        , Object_Personal_View.PersonalId    AS PersonalBookkeeperId
        , Object_Personal_View.PersonalName  AS PersonalBookkeeperName        
        
        , Object_Branch.isErased     AS isErased
        
   FROM Object AS Object_Branch
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId
                  ) AS tmpRoleAccessKey ON vbAccessKeyAll = FALSE
                   AND tmpRoleAccessKey.AccessKeyId = Object_Branch.AccessKeyId

        LEFT JOIN ObjectString AS ObjectString_InvNumber
                               ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                              AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()                                  

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                             ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                        
        
   WHERE Object_Branch.DescId = zc_Object_Branch()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll = TRUE)
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Branch(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.15         * add InvNumber, PersonalBookkeeper               
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 10.05.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Branch (zfCalc_UserAdmin())