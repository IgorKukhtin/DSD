-- Function: gpSelect_Object_Personal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsPeriod    Boolean   , --
    IN inIsShowAll   Boolean,    --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MemberId Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionCode Integer, PositionName TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar,
               DateIn TDateTime, DateOut TDateTime, isDateOut Boolean, isMain Boolean, isOfficial Boolean, isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbObjectId_Constraint Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   vbIsAllUnit:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);


   IF inIsShowAll = TRUE OR inIsPeriod = TRUE 
   THEN

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Personal_View.PersonalId   AS Id
           , Object_Member.Id                  AS MemberId
           , Object_Member.ObjectCode          AS MemberCode
           , Object_Member.ValueData           AS MemberName

           , Object_Personal_View.PositionId
           , Object_Personal_View.PositionCode
           , Object_Personal_View.PositionName

           , Object_Personal_View.UnitId
           , Object_Personal_View.UnitCode
           , Object_Personal_View.UnitName

           , Object_Personal_View.PersonalGroupId
           , Object_Personal_View.PersonalGroupCode
           , Object_Personal_View.PersonalGroupName

           , Object_Personal_View.DateIn
           , Object_Personal_View.DateOut_user AS DateOut
           , COALESCE (Object_Personal_View.isDateOut, FALSE) AS isDateOut
           , COALESCE (Object_Personal_View.isMain, FALSE) AS isMain
           , COALESCE (Object_Personal_View.isOfficial, FALSE) AS isOfficial
           
           , COALESCE (Object_Personal_View.isErased, Object_Member.isErased) AS isErased
       FROM Object AS Object_Member
            LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = Object_Member.Id
            -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Object_Personal_View.AccessKeyId
            -- LEFT JOIN Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide ON View_RoleAccessKeyGuide.UserId = vbUserId AND View_RoleAccessKeyGuide.UnitId_PersonalService = Object_Personal_View.UnitId AND vbIsAllUnit = FALSE

       WHERE Object_Member.DescId = zc_Object_Member()
        /* AND (Object_Personal_View.isErased = FALSE
              OR (Object_Personal_View.isErased = TRUE AND inIsShowAll = TRUE OR inIsPeriod = TRUE)
             )
         */AND (inIsPeriod = FALSE
              OR (inIsPeriod = TRUE AND ((Object_Personal_View.DateIn BETWEEN inStartDate AND inEndDate)
                                      OR (Object_Personal_View.DateOut BETWEEN inStartDate AND inEndDate)
                                      OR (Object_Personal_View.DateIn < inStartDate
                                      AND Object_Personal_View.DateOut > inEndDate)
                                        )
                 )
             )
      UNION ALL
          SELECT
             0   AS Id
           , 0 AS MemberId
           , 0 AS MemberCode
           , CAST ('УДАЛИТЬ' as TVarChar)  AS MemberName
           , 0 AS PositionId
           , 0 AS PositionCode
           , CAST ('' as TVarChar) AS PositionName
           , 0 AS UnitId
           , 0 AS UnitCode
           , CAST ('' as TVarChar) AS UnitName
           , 0 AS PersonalGroupId
           , 0 AS PersonalGroupCode
           , CAST ('' as TVarChar) AS PersonalGroupName
           , CAST (NULL as TDateTime) AS DateIn
           , CAST (NULL as TDateTime) AS DateOut
           , FALSE AS isDateOut
           , FALSE AS isMain
           , FALSE AS isOfficial
           , FALSE AS isErased
      ;
   ELSE

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Personal_View.PersonalId   AS Id
           , Object_Member.Id                  AS MemberId
           , Object_Member.ObjectCode          AS MemberCode
           , Object_Member.ValueData           AS MemberName

           , Object_Personal_View.PositionId
           , Object_Personal_View.PositionCode
           , Object_Personal_View.PositionName

           , Object_Personal_View.UnitId
           , Object_Personal_View.UnitCode
           , Object_Personal_View.UnitName

           , Object_Personal_View.PersonalGroupId
           , Object_Personal_View.PersonalGroupCode
           , Object_Personal_View.PersonalGroupName

           , Object_Personal_View.DateIn
           , Object_Personal_View.DateOut_user AS DateOut
           , COALESCE (Object_Personal_View.isDateOut, FALSE) AS isDateOut
           , COALESCE (Object_Personal_View.isMain, FALSE) AS isMain
           , COALESCE (Object_Personal_View.isOfficial, FALSE) AS isOfficial
           
           , COALESCE (Object_Personal_View.isErased, Object_Member.isErased) AS isErased
       FROM Object AS Object_Member
            INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = Object_Member.Id
                                          AND Object_Personal_View.isErased = FALSE

       WHERE Object_Member.DescId = zc_Object_Member() 
         AND Object_Member.isErased = FALSE
      UNION ALL
          SELECT
             0   AS Id
           , 0 AS MemberId
           , 0 AS MemberCode
           , CAST ('УДАЛИТЬ' as TVarChar)  AS MemberName
           , 0 AS PositionId
           , 0 AS PositionCode
           , CAST ('' as TVarChar) AS PositionName
           , 0 AS UnitId
           , 0 AS UnitCode
           , CAST ('' as TVarChar) AS UnitName
           , 0 AS PersonalGroupId
           , 0 AS PersonalGroupCode
           , CAST ('' as TVarChar) AS PersonalGroupName
           , CAST (NULL as TDateTime) AS DateIn
           , CAST (NULL as TDateTime) AS DateOut
           , FALSE AS isDateOut
           , FALSE AS isMain
           , FALSE AS isOfficial
           , FALSE AS isErased
      ;
   
   END IF;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.03.19                                                       *              
 21.01.16         *              
*/

-- тест
-- SELECT * FROM gpSelect_Object_Personal (inStartDate:= null, inEndDate:= null, inIsPeriod:= FALSE, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
