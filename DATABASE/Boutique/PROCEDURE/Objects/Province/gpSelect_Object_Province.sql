-- Function: gpSelect_Object_Province (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Province (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Province(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , RegionId Integer, RegionCode Integer, RegionName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Province());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Province.Id          AS Id
           , Object_Province.ObjectCode  AS Code
           , Object_Province.ValueData   AS Name
           
           , Object_Region.Id          AS RegionId
           , Object_Region.ObjectCode  AS RegionCode
           , Object_Region.ValueData   AS RegionName
           
           , Object_Province.isErased    AS isErased
           
       FROM Object AS Object_Province
            -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId
            --           ) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_Province.AccessKeyId
       
            LEFT JOIN ObjectLink AS ObjectLink_Province_Region
                                ON ObjectLink_Province_Region.ObjectId = Object_Province.Id
                               AND ObjectLink_Province_Region.DescId = zc_ObjectLink_Province_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_Province_Region.ChildObjectId

     WHERE Object_Province.DescId = zc_Object_Province()
       -- AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Province(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14         * 
        
*/
/*
UPDATE Object SET AccessKeyId = COALESCE (Object_Branch.AccessKeyId, zc_Enum_Process_AccessKey_TrasportDnepr()) FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink2 ON ObjectLink2.ObjectId = ObjectLink.ChildObjectId AND ObjectLink2.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink2.ChildObjectId WHERE ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Province_Unit() AND Object.DescId = zc_Object_Province();
*/
-- тест
-- SELECT * FROM gpSelect_Object_Province (zfCalc_UserAdmin())