-- Function: gpSelect_Object_ModelService(TVarChar)

DROP FUNCTION IF EXISTS  gpSelect_Object_ModelService(TVarChar);
DROP FUNCTION IF EXISTS  gpSelect_Object_ModelService(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelService(
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , UnitId Integer, UnitName TVarChar
             , ModelServiceKindId Integer, ModelServiceKindName TVarChar
             , isTrainee Boolean
             , isErased Boolean
             ) AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId_Constraint_Branch Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ModelService);
    vbUserId := lpGetUserBySession (inSession);

     -- определяется уровень доступа
     vbObjectId_Constraint_Branch:= COALESCE ((SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0), 0);
     -- определяется уровень доступа
     IF vbObjectId_Constraint_Branch = 0 AND EXISTS (SELECT 1 FROM Object_RoleAccessKey_View AS Object_View WHERE Object_View.UserId = vbUserId AND Object_View.AccessKeyId = zc_Enum_Process_AccessKey_UserBranch())
     THEN vbObjectId_Constraint_Branch:= -1;
     END IF;


     -- Результат
     RETURN QUERY 
       SELECT 
             Object_ModelService.Id          AS Id
           , Object_ModelService.ObjectCode  AS Code
           , Object_ModelService.ValueData   AS Name
           
           , ObjectString_Comment.ValueData  AS Comment
           
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ValueData   AS UnitName

           , Object_ModelServiceKind.Id          AS ModelServiceKindId
           , Object_ModelServiceKind.ValueData   AS ModelServiceKindName
           
           , COALESCE (ObjectBoolean_Trainee.ValueData, FALSE) :: Boolean AS isTrainee
           , Object_ModelService.isErased        AS isErased
           
       FROM Object AS Object_ModelService
       
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_ModelService.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ModelService_Comment()
     
            LEFT JOIN ObjectLink AS ObjectLink_ModelService_Unit 
                                 ON ObjectLink_ModelService_Unit.ObjectId = Object_ModelService.Id
                                AND ObjectLink_ModelService_Unit.DescId = zc_ObjectLink_ModelService_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ModelService_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ModelService_ModelServiceKind 
                                 ON ObjectLink_ModelService_ModelServiceKind.ObjectId = Object_ModelService.Id
                                AND ObjectLink_ModelService_ModelServiceKind.DescId = zc_ObjectLink_ModelService_ModelServiceKind()
            LEFT JOIN Object AS Object_ModelServiceKind ON Object_ModelServiceKind.Id = ObjectLink_ModelService_ModelServiceKind.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Trainee
                                    ON ObjectBoolean_Trainee.ObjectId = Object_ModelService.Id
                                   AND ObjectBoolean_Trainee.DescId = zc_ObjectBoolean_ModelService_Trainee()
                                   
       WHERE Object_ModelService.DescId = zc_Object_ModelService()
         AND (Object_ModelService.isErased = FALSE OR inIsShowAll = TRUE)
         AND vbObjectId_Constraint_Branch = 0
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , ''        :: TVarChar AS Comment
            , 0         :: Integer  AS UnitId
            , ''        :: TVarChar AS UnitName
            , 0         :: Integer  AS ModelServiceKindId
            , ''        :: TVarChar AS ModelServiceKindName
            , FALSE                 AS isTrainee
            , FALSE                 AS isErased
       ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.19         *
 02.06.17         *
 19.10.13         * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_ModelService (inIsShowAll:=False, inSession:= zfCalc_UserAdmin())
