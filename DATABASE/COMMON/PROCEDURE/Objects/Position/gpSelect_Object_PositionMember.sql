-- Function: gpSelect_Object_PositionMember (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PositionMember (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PositionMember(
    IN inMemberId         Integer , --
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PersonalId Integer, PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , isOfficial Boolean
             , BranchId Integer, BranchName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAll    Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- User by RoleId
   vbAll:= NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View
                       WHERE UserId = vbUserId
                         AND RoleId IN (SELECT Object.Id FROM Object
                                        WHERE Object.DescId = zc_Object_Role()
                                          -- Так криво - через zc_Object_Role
                                          AND Object.ObjectCode IN (3004, 4004, 5004, 6004, 7004, 8004, 8014, 9004
                                                                  , 1201, 2001, 2002, 2003, 2004, 2005, 2006
                                                                   )
                                       ));

   -- Результат
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT Object_Personal.PersonalId
                             , Object_Personal.MemberId
                             , Object_Personal.PositionId
                             , Object_Personal.PositionName
                               --  № п/п
                             , ROW_NUMBER() OVER (PARTITION BY Object_Personal.MemberId ORDER BY Object_Personal.PersonalId DESC) AS Ord
                        FROM Object_Personal_View AS Object_Personal
                        WHERE (Object_Personal.MemberId = inMemberId OR inMemberId = 0)
                          AND Object_Personal.isErased = FALSE
                       )
                   
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         , tmpPersonal.PersonalId
         , tmpPersonal.PositionId
         , tmpPersonal.PositionName
         , Object_PositionLevel.Id           AS PositionLevelId
         , Object_PositionLevel.ValueData    AS PositionLevelname
         , ObjectBoolean_Official.ValueData  AS isOfficial
 
         , Object_Branch.Id                         AS BranchId
         , Object_Branch.ValueData                  AS BranchName

         , COALESCE (ObjectLink_Personal_Unit.ChildObjectId, 0) AS UnitId
         , Object_Unit.ObjectCode                   AS UnitCode
         , Object_Unit.ValueData                    AS UnitName

         , Object_Member.isErased                   AS isErased

     FROM tmpPersonal
          INNER JOIN Object AS Object_Member
                            ON Object_Member.Id = tmpPersonal.MemberId
                           AND Object_Member.DescId = zc_Object_Member()
          LEFT JOIN Object AS Object_Position
                           ON Object_Position.Id = tmpPersonal.PositionId
         
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                  ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()

         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                              ON ObjectLink_Personal_Unit.ObjectId = tmpPersonal.PersonalId
                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
 
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                              ON ObjectLink_Personal_PositionLevel.ObjectId = tmpPersonal.PersonalId
                             AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_Personal_PositionLevel.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId


     WHERE Object_Position.isErased = FALSE OR inIsShowAll = TRUE
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PositionMember (1425395, FALSE, zfCalc_UserAdmin()) order by 3