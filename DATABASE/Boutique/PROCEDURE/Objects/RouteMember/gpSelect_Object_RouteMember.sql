-- Function: gpSelect_Object_RouteMember()

DROP FUNCTION IF EXISTS gpSelect_Object_RouteMember(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteMember(
    IN inSession     TVarChar        -- сессия пользователя
)

RETURNS TABLE (Id Integer, Code Integer
             , RouteMemberName TBlob
             , isErased boolean 
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_RouteMember());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   RETURN QUERY 

   SELECT Object.Id          AS Id 
        , Object.ObjectCode  AS Code
        , OB_RouteMember_Description.ValueData AS RouteMemberName
     
        , Object.isErased    AS isErased
   FROM Object
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object.AccessKeyId
           
        LEFT JOIN ObjectBlob AS OB_RouteMember_Description
                             ON OB_RouteMember_Description.ObjectId = Object.Id
                            AND OB_RouteMember_Description.DescId = zc_ObjectBlob_RouteMember_Description()
                             
   WHERE Object.DescId = zc_Object_RouteMember()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RouteMember (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.16         *             
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_RouteMember (zfCalc_UserAdmin())


