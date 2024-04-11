-- Function: gpSelect_Object_UserRoleUnion (TVarChar)
DROP FUNCTION IF EXISTS gpSelect_Object_UserRoleUnion (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserRoleUnion(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UserId Integer, UserCode Integer, UserName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , RoleId Integer, RoleCode Integer, RoleName TVarChar   
             , isErased Boolean
             )
AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY
   WITH
       tmp_RoleUnion AS (SELECT DISTINCT tmp.Id, tmp.RoleId , tmp.DescName
                         FROM gpSelect_Object_RoleUnion(inValue := 1 
                                                     ,  inSession := inSession) AS tmp
                        -- WHERE tmp.process_enumname <>'' 
                        )
     
     , tmpRoleUser AS (SELECT DISTINCT tmp.RoleId, tmp.Id, tmp.Code, tmp.Name, tmp.BranchCode, tmp.BranchName, tmp.UnitCode, tmp.UnitName, tmp.PositionName , tmp.isErased 
                       FROM gpSelect_Object_RoleUser (inSession := inSession) AS tmp
                       )


   SELECT 
         tmp_RoleUnion.Id
       , tmpRoleUser.Id   AS UserId
       , tmpRoleUser.Code AS UserCode
       , tmpRoleUser.Name AS UserName
        
       , tmpRoleUser.BranchCode
       , tmpRoleUser.BranchName
       , tmpRoleUser.UnitCode
       , tmpRoleUser.UnitName
       , tmpRoleUser.PositionName
    
       , Object_Role.Id         AS RoleId 
       , Object_Role.ObjectCode AS RoleCode
       , Object_Role.ValueData  AS RoleName  
       
       , tmpRoleUser.isErased

   FROM tmp_RoleUnion
        
        LEFT JOIN tmpRoleUser ON ((tmpRoleUser.RoleId = tmp_RoleUnion.RoleId AND tmp_RoleUnion.DescName <> 'Связь пользователей и ролей')
                               OR (tmpRoleUser.RoleId = tmp_RoleUnion.RoleId AND tmpRoleUser.Id = tmp_RoleUnion.Id AND tmp_RoleUnion.DescName = 'Связь пользователей и ролей')
                                 ) 
        JOIN Object AS Object_Role ON Object_Role.Id = tmpRoleUser.RoleId
   ;      
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.24                         *
*/
-- SELECT * FROM gpSelect_Object_UserRoleUnion ('2')

--SELECT * FROM Objectdesc where id =  zc_Object_User()