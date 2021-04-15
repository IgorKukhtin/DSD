-- Function: gpSelect_Object_SignInternal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_SignInternal (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SignInternal(
    IN inShowAll        Boolean,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , MovementDescId Tfloat, MovementDescName TVarChar
             , ObjectDescId  Tfloat, ObjectDescName TVarChar
             , Comment TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, DescName TVarChar
             , isMain Boolean
             , isErased Boolean
             , Count_member Integer
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
   WITH tmpSignInternalItem AS (SELECT ObjectLink_SignInternalItem_SignInternal.ChildObjectId AS SignInternalId
                                     , COUNT(*) AS Count_member
                                FROM Object AS Object_SignInternalItem
                                     LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_SignInternal 
                                                          ON ObjectLink_SignInternalItem_SignInternal.ObjectId = Object_SignInternalItem.Id
                                                         AND ObjectLink_SignInternalItem_SignInternal.DescId = zc_ObjectLink_SignInternalItem_SignInternal()
                                     LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = ObjectLink_SignInternalItem_SignInternal.ChildObjectId
                                WHERE Object_SignInternalItem.isErased = FALSE
                                  AND Object_SignInternalItem.DescId = zc_Object_SignInternalItem()
                                GROUP BY ObjectLink_SignInternalItem_SignInternal.ChildObjectId
                                )
   SELECT
         Object_SignInternal.Id         AS Id 
       , Object_SignInternal.ObjectCode AS Code
       , Object_SignInternal.ValueData  AS Name
              
       , ObjectFloat_MovementDesc.ValueData AS MovementDescId
       , Object_MovementDesc.ItemName       AS MovementDescName

       , ObjectFloat_ObjectDesc.ValueData   AS ObjectDescId
       , Object_ObjectDesc.ItemName         AS ObjectDescName

       , ObjectString_Comment.ValueData     AS Comment
      
       , Object_Object.Id           AS ObjectId 
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , Object_Desc.ItemName       AS DescName

       , COALESCE (ObjectBoolean_Main.ValueData, FALSE) :: Boolean AS isMain
       , Object_SignInternal.isErased   AS isErased
       
       , tmpSignInternalItem.Count_member :: Integer AS Count_member
       
   FROM Object AS Object_SignInternal
        INNER JOIN (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE) AS tmpIsErased ON tmpIsErased.isErased = Object_SignInternal.isErased 
       -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_SignInternal.AccessKeyId

        LEFT JOIN ObjectFloat AS ObjectFloat_MovementDesc
                              ON ObjectFloat_MovementDesc.ObjectId = Object_SignInternal.Id
                             AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_SignInternal_MovementDesc()
        LEFT JOIN MovementDesc AS Object_MovementDesc ON Object_MovementDesc.Id = ObjectFloat_MovementDesc.ValueData :: integer
            
        LEFT JOIN ObjectFloat AS ObjectFloat_ObjectDesc
                              ON ObjectFloat_ObjectDesc.ObjectId = Object_SignInternal.Id
                             AND ObjectFloat_ObjectDesc.DescId = zc_ObjectFloat_SignInternal_ObjectDesc()
        LEFT JOIN ObjectDesc AS Object_ObjectDesc ON Object_ObjectDesc.Id = ObjectFloat_ObjectDesc.ValueData :: integer

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_SignInternal.Id 
                              AND ObjectString_Comment.DescId = zc_ObjectString_SignInternal_Comment()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                ON ObjectBoolean_Main.ObjectId = Object_SignInternal.Id 
                               AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_SignInternal_Main()

        LEFT JOIN ObjectLink AS ObjectLink_SignInternal_Object 
                             ON ObjectLink_SignInternal_Object.ObjectId = Object_SignInternal.Id
                            AND ObjectLink_SignInternal_Object.DescId = zc_ObjectLink_SignInternal_Object()
        LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_SignInternal_Object.ChildObjectId
        LEFT JOIN ObjectDesc AS Object_Desc ON Object_Desc.Id = Object_Object.DescId
        
        LEFT JOIN tmpSignInternalItem ON tmpSignInternalItem.SignInternalId = Object_SignInternal.Id
        
   WHERE Object_SignInternal.DescId = zc_Object_SignInternal()
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
-- SELECT * FROM gpSelect_Object_SignInternal (true, zfCalc_UserAdmin())
