-- Function: gpSelect_Object_MemberChoice (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberChoice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberChoice(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)

RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isOfficial Boolean
             , isNotCompensation Boolean
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , DateIn TDateTime, DateOut TDateTime
             , isDateOut Boolean, PersonalId Integer
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   vbIsAllUnit:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId)
                 --  Справочник физ лица - показать все ФИО
                 OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11481474)
                 -- Трейд-маркетинг (согласование)
                 OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11317677)
                 OR vbUserId = 80373 -- "Прохорова С.А."
               ;

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0
                --  Справочник физ лица - показать все ФИО
                AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11481474)
                -- Трейд-маркетинг (согласование)
                AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11317677)
                   ;

   -- Результат
   RETURN QUERY
      WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                                , lfSelect.isDateOut
                                , lfSelect.Ord
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
      , tmpCar AS (SELECT MAX (ObjectLink_Car_PersonalDriver.ObjectId) AS CarId
                        , View_PersonalDriver.PersonalId
                        , View_PersonalDriver.MemberId
                   FROM ObjectLink AS ObjectLink_Car_PersonalDriver
                       Inner JOIN Object_Personal_View AS View_PersonalDriver
                                                       ON View_PersonalDriver.PersonalId = ObjectLink_Car_PersonalDriver.ChildObjectId
                   WHERE  ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                   GROUP BY View_PersonalDriver.PersonalId
                          , View_PersonalDriver.MemberId
                   )

     SELECT
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name

         , ObjectBoolean_Official.ValueData        ::Boolean AS isOfficial
         , COALESCE (ObjectBoolean_NotCompensation.ValueData, FALSE) :: Boolean  AS isNotCompensation

         , Object_Branch.ObjectCode   AS BranchCode
         , Object_Branch.ValueData    AS BranchName
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , ObjectDate_DateIn.ValueData AS DateIn
         , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut
         , tmpPersonal.isDateOut   :: Boolean
         , tmpPersonal.PersonalId

         , Object_Member.isErased      AS isErased

     FROM Object AS Object_Member
          LEFT JOIN (SELECT View_Personal.MemberId
                     FROM Object_Personal_View AS View_Personal
                          INNER JOIN Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide
                                                                    ON View_RoleAccessKeyGuide.UserId = vbUserId
                                                                   AND View_RoleAccessKeyGuide.UnitId_PersonalService = View_Personal.UnitId
                                                                   AND vbIsAllUnit = FALSE
                     GROUP BY View_Personal.MemberId
                    ) AS View_Personal ON View_Personal.MemberId = Object_Member.Id
          LEFT JOIN (SELECT View_Personal.MemberId
                     FROM ObjectLink AS ObjectLink_Unit_Branch
                          INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = ObjectLink_Unit_Branch.ObjectId
                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint
                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                     GROUP BY View_Personal.MemberId
                    UNION
                     SELECT View_Personal.MemberId
                     FROM Object_Personal_View AS View_Personal
                     WHERE View_Personal.PositionId = 81178 -- экспедитор
                        OR View_Personal.PositionId = 8466  -- водитель
                        OR View_Personal.UnitId = 8409 -- Отдел экспедиторов
                     GROUP BY View_Personal.MemberId
                    ) AS View_Personal_Branch ON View_Personal_Branch.MemberId = Object_Member.Id

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                 ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCompensation
                                 ON ObjectBoolean_NotCompensation.ObjectId = Object_Member.Id
                                AND ObjectBoolean_NotCompensation.DescId = zc_ObjectBoolean_Member_NotCompensation()

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id AND tmpPersonal.Ord = 1
         LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
         LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId

         LEFT JOIN ObjectDate AS ObjectDate_DateIn
                              ON ObjectDate_DateIn.ObjectId = tmpPersonal.PersonalId
                             AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
         LEFT JOIN ObjectDate AS ObjectDate_DateOut
                              ON ObjectDate_DateOut.ObjectId = tmpPersonal.PersonalId
                             AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()

     WHERE Object_Member.DescId = zc_Object_Member()
       AND (Object_Member.isErased = FALSE
            OR (Object_Member.isErased = TRUE AND inIsShowAll = TRUE)
           )
       AND (View_Personal.MemberId > 0
            OR vbIsAllUnit = TRUE
           )
       AND (View_Personal_Branch.MemberId > 0
            OR vbIsConstraint = FALSE
           )
  UNION ALL
          SELECT
             CAST (0 as Integer)    AS Id
           , 0              AS Code
           , CAST ('УДАЛИТЬ' as TVarChar)  AS NAME
           , FALSE          AS isOfficial
           , FALSE          AS isNotCompensation

           , 0              AS BranchCode
           , '' :: TVarChar AS BranchName
           , 0              AS UnitCode
           , '' :: TVarChar AS UnitName
           , 0              AS PositionCode
           , '' :: TVarChar AS PositionName

           , NULL :: TDateTime AS DateIn
           , NULL :: TDateTime AS DateOut

           , FALSE          AS isDateOut
           , 0              AS PersonalId

           , FALSE          AS isErased


    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.02.20         *
 27.12.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberChoice (TRUE, zfCalc_UserAdmin())  order by 3
-- SELECT * FROM gpSelect_Object_MemberChoice (FALSE, zfCalc_UserAdmin()) order by 3
