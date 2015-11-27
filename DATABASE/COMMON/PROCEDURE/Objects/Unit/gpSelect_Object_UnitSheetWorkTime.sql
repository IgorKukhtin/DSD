-- Function: gpSelect_Object_UnitSheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitSheetWorkTime (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitSheetWorkTime(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentName TVarChar,
               BranchId Integer, BranchName TVarChar,
               isLeaf Boolean, isErased Boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
   -- DECLARE vbAccessKeyAll Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbMemberId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск сотрудник
    IF EXISTS (SELECT UserId 
               FROM ObjectLink_UserRole_View 
               WHERE UserId = vbUserId 
                 AND RoleId IN (zc_Enum_Role_Admin(), 14473)) -- Персонал ввод справочников
    THEN
        vbMemberId:= 0;
    ELSE
        vbMemberId:= (SELECT 
                          ObjectLink_User_Member.ChildObjectId AS MemberId
                      FROM 
                          ObjectLink AS ObjectLink_User_Member
                      WHERE 
                          ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND 
                          ObjectLink_User_Member.ObjectId = vbUserId);
    END IF;

    RETURN QUERY
        WITH tmpList AS (
            SELECT DISTINCT 
                ObjectLink.ObjectId AS UnitId
            FROM 
                ObjectLink
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = ObjectLink.ChildObjectId
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                WHERE 
                    ObjectLink.DescId = zc_ObjectLink_Unit_PersonalSheetWorkTime()
                    AND 
                    (
                        ObjectLink_Personal_Member.ChildObjectId = vbMemberId 
                        OR 
                        vbMemberId = 0)
                    )
        SELECT
            Object_Unit.Id                     AS UnitId
          , Object_Unit.Code                   AS UnitCode
          , Object_Unit.Name                   AS UnitName
          , COALESCE (Object_Unit.ParentId, 0) AS ParentId
          , Object_Unit.ParentName             AS ParentName
          , Object_Unit.BranchId               AS BranchId
          , Object_Unit.BranchName             AS BranchName
          , Object_Unit.isLeaf
          , Object_Unit.isErased
        FROM (
                SELECT DISTINCT 
                    ChildObjectId AS UnitId 
                FROM 
                    ObjectLink 
                WHERE 
                    DescId = zc_ObjectLink_StaffList_Unit() 
                    AND 
                    ChildObjectId > 0 
                    AND 
                    vbMemberId = 0
                UNION
                SELECT 
                    tmpList.UnitId 
                FROM 
                    tmpList
             ) AS ObjectLink_StaffList_Unit
            LEFT JOIN Object_Unit_View AS Object_Unit 
                                       ON Object_Unit.Id = ObjectLink_StaffList_Unit.UnitId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitSheetWorkTime (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 27.11.15                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitSheetWorkTime (zfCalc_UserAdmin())