-- Function: gpSelect_Object_RoleUser()

DROP FUNCTION IF EXISTS gpSelect_Object_RoleUser (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RoleUser(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, RoleId Integer, UserRoleId Integer
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   WITH tmpPersonal AS (SELECT tmp.MemberId
                             , tmp.UnitId
                             , tmp.PositionId
                        FROM
                            (SELECT ObjectLink_Personal_Member.ChildObjectId         AS MemberId
                                  , ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
                                  , ObjectLink_Personal_Position.ChildObjectId       AS PositionId
                                  , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                       -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                       ORDER BY CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                              , CASE WHEN Object_Personal.isErased = FALSE THEN 0 ELSE 1 END
                                                              , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                              , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                              , ObjectLink_Personal_Member.ObjectId
                                                      ) AS Ord
                             FROM ObjectLink AS ObjectLink_Personal_Member
                                  LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                       ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                                                      
                                  LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                       ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                          ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                         AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                          ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                         AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                                  LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                       ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                             WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                               AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                            ) AS tmp
                        WHERE tmp.Ord = 1
                       )
                         
                         

   SELECT 
         ObjectUser.Id         AS Id 
       , ObjectUser.ObjectCode AS Code
       , ObjectUser.ValueData  AS Name
       , ObjectLink_UserRole_Role.ChildObjectId AS RoleId
       , ObjectLink_UserRole_User.ObjectId      AS UserRoleId

       , Object_Branch.ObjectCode  AS BranchCode
       , Object_Branch.ValueData   AS BranchName
       , Object_Unit.ObjectCode    AS UnitCode
       , Object_Unit.ValueData     AS UnitName
       , Object_Position.ValueData AS PositionName
    
       , ObjectUser.isErased       AS isErased

   FROM ObjectLink AS ObjectLink_UserRole_Role
        JOIN ObjectLink AS ObjectLink_UserRole_User 
                        ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                       AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()

        JOIN Object AS ObjectUser ON ObjectUser.Id = ObjectLink_UserRole_User.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                        ON ObjectLink_User_Member.ObjectId = ObjectLink_UserRole_User.ChildObjectId
                       AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId


   WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role();        
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RoleUser(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

/*SELECT  
  Role.ItemName AS RoleName,
  Process.ItemName AS ProcessName
FROM 
  Object 
  JOIN ObjectEnum RoleRight_Role 
    ON RoleRight_Role.ObjectId = Object.Id AND RoleRight_Role.DescId = zc_Object_RoleRight_Role()
  JOIN Enum Role 
    ON Role.Id = RoleRight_Role.EnumId
  JOIN ObjectEnum RoleRight_Process
    ON RoleRight_Process.ObjectId = Object.Id AND RoleRight_Process.DescId = zc_Object_RoleRight_Process()
  JOIN Enum Process 
    ON Process.Id = RoleRight_Process.EnumId


WHERE Object.DescId = zc_Object_RoleRight()*/

-- тест
-- SELECT * FROM gpSelect_Object_RoleUser (zfCalc_UserAdmin())
