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
             , UpdateName TVarChar, UpdateDate TDateTime 
             , UpdateName_master TVarChar, UpdateDate_master TDateTime 
             , UpdateName_child TVarChar, UpdateDate_child TDateTime 
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
     WITH
     tmpObject AS (SELECT Object.*
                   FROM Object
                   WHERE Object.DescId = zc_Object_ModelService()  
                    AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
                   )
      
   , tmpProtocol AS (SELECT tmp.ObjectId
                          , tmp.UserId
                          , Object_User.ValueData AS UserName
                          , tmp.OperDate
                     FROM (SELECT ObjectProtocol.*
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                           FROM ObjectProtocol
                           WHERE ObjectProtocol.ObjectId IN (SELECT tmpObject.Id FROM tmpObject)
                           ) AS tmp 
                           LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId  
                     WHERE tmp.Ord = 1
                     )
    --мастер
   , tmpObjectMaster AS (SELECT Object.*
                              , ObjectLink_ModelServiceItemMaster_ModelService.ChildObjectId AS ModelServiceId
                         FROM Object
                              LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_ModelService
                                                   ON ObjectLink_ModelServiceItemMaster_ModelService.ObjectId = Object.Id
                                                  AND ObjectLink_ModelServiceItemMaster_ModelService.DescId = zc_ObjectLink_ModelServiceItemMaster_ModelService()
                         WHERE Object.DescId = zc_Object_ModelServiceItemMaster()  
                          AND (Object.isErased = FALSE OR TRUE = TRUE)
                         )
      
   , tmpProtocolMaster AS (SELECT  tmp.ModelServiceId
                                , tmp.UserId
                                , Object_User.ValueData AS UserName
                                , tmp.OperDate
                           FROM (SELECT ObjectProtocol.*
                                      , tmpObjectMaster.ModelServiceId
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY tmpObjectMaster.ModelServiceId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                                 FROM ObjectProtocol
                                      INNER JOIN tmpObjectMaster ON tmpObjectMaster.Id = ObjectProtocol.ObjectId 
                               --  WHERE ObjectProtocol.ObjectId IN (SELECT DISTINCT tmpObjectMaster.Id FROM tmpObjectMaster)
                                 ) AS tmp 
                                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId  
                           WHERE tmp.Ord = 1
                           )

    --чайлд
   , tmpObjectChild AS (SELECT Object.*
                              , ObjectLink_ModelServiceItemMaster_ModelService.ChildObjectId AS ModelServiceId
                         FROM Object
                              LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
                                                   ON ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId = Object.Id
                                                  AND ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.DescId = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()

                              LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_ModelService
                                                   ON ObjectLink_ModelServiceItemMaster_ModelService.ObjectId = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ChildObjectId
                                                  AND ObjectLink_ModelServiceItemMaster_ModelService.DescId = zc_ObjectLink_ModelServiceItemMaster_ModelService()
                         WHERE Object.DescId = zc_Object_ModelServiceItemChild()  
                          AND (Object.isErased = FALSE OR TRUE = TRUE)
                         )
      
   , tmpProtocolChild AS (SELECT  tmp.ModelServiceId
                                , tmp.UserId
                                , Object_User.ValueData AS UserName
                                , tmp.OperDate
                           FROM (SELECT ObjectProtocol.*
                                      , tmpObjectChild.ModelServiceId
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY tmpObjectChild.ModelServiceId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                                 FROM ObjectProtocol
                                      INNER JOIN tmpObjectChild ON tmpObjectChild.Id = ObjectProtocol.ObjectId 
                               --  WHERE ObjectProtocol.ObjectId IN (SELECT DISTINCT tmpObjectChild.Id FROM tmpObjectChild)
                                 ) AS tmp 
                                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId  
                           WHERE tmp.Ord = 1
                           )


       ---
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
           
           , tmpProtocol.UserName          ::TVarChar  AS UpdateName
           , tmpProtocol.OperDate          ::TDateTime AS UpdateDate
           , tmpProtocolMaster.UserName    ::TVarChar  AS UpdateName_master
           , tmpProtocolMaster.OperDate    ::TDateTime AS UpdateDate_master
           , tmpProtocolChild.UserName     ::TVarChar  AS UpdateName_child
           , tmpProtocolChild.OperDate     ::TDateTime AS UpdateDate_child
       FROM tmpObject AS Object_ModelService
       
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

            LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = Object_ModelService.Id
            LEFT JOIN tmpProtocolMaster ON tmpProtocolMaster.ModelServiceId = Object_ModelService.Id
            LEFT JOIN tmpProtocolChild  ON tmpProtocolChild.ModelServiceId = Object_ModelService.Id                       

       WHERE vbObjectId_Constraint_Branch = 0 OR vbUserId = 9457
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
            , NULL      ::TVarChar  AS UpdateName
            , NULL      ::TDateTime AS UpdateDate
            , NULL      ::TVarChar  AS UpdateName_master
            , NULL      ::TDateTime AS UpdateDate_master
            , NULL      ::TVarChar  AS UpdateName_child
            , NULL      ::TDateTime AS UpdateDate_child
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
--  SELECT * FROM gpSelect_Object_ModelService (inIsShowAll:=False, inSession:= zfCalc_UserAdmin())
