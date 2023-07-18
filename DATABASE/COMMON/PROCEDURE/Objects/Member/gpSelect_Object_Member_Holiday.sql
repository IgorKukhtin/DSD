-- Function: gpSelect_Object_Member_Holiday (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member_Holiday (TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_Holiday(
    IN inOperDate         TDateTime,       --
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)

RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar
             , Card TVarChar, CardSecond TVarChar, CardChild TVarChar
             , CardIBAN TVarChar, CardIBANSecond TVarChar
             , Comment TVarChar
             , isOfficial Boolean
             , isNotCompensation Boolean
             , BankId Integer, BankName TVarChar
             , BankSecondId Integer, BankSecondName TVarChar
             , BankChildId Integer, BankChildName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , StartSummerDate TDateTime, EndSummerDate TDateTime
             , SummerFuel TFloat, WinterFuel TFloat, Reparation TFloat, LimitMoney TFloat, LimitDistance TFloat
             , CarNameAll TVarChar, CarName TVarChar, CarModelName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , ObjectToId Integer, ObjectToName TVarChar, DescName TVarChar
             , isDateOut Boolean, PersonalId Integer
             , DateIn_Holiday TDateTime, DateOut_Holiday TDateTime, DateOut_Holiday_user TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
IF inOperDate IS NULL THEN inOperDate:= CURRENT_DATE; END IF;

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   vbIsAllUnit:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId)
                 OR vbUserId = 80373   -- Прохорова С.А.
                 OR vbUserId = 80830   -- Кисличная Т.А.
                 OR vbUserId = 2573318 -- Любарский Г.О.
               ;

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;
/*
if vbUserId = 80971
then
    RAISE EXCEPTION '<%>  %   %', vbIsAllUnit, vbObjectId_Constraint, vbIsConstraint; -- Полякова
end if;
*/

   -- Результат
   RETURN QUERY
      WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                                , lfSelect.isDateOut
                                , lfSelect.DateIn
                                , lfSelect.DateOut
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

         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Card.ValueData              AS Card
         , ObjectString_CardSecond.ValueData        AS CardSecond
         , ObjectString_CardChild.ValueData         AS CardChild
         , ObjectString_CardIBAN.ValueData          AS CardIBAN
         , ObjectString_CardIBANSecond.ValueData    AS CardIBANSecond
         , ObjectString_Comment.ValueData           AS Comment

         , ObjectBoolean_Official.ValueData         AS isOfficial
         , COALESCE (ObjectBoolean_NotCompensation.ValueData, FALSE) :: Boolean  AS isNotCompensation

         , Object_Bank.Id               AS BankId
         , Object_Bank.ValueData        AS BankName
         , Object_BankSecond.Id         AS BankSecondId
         , Object_BankSecond.ValueData  AS BankSecondName
         , Object_BankChild.Id          AS BankChildId
         , Object_BankChild.ValueData   AS BankChildName

         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all

         , COALESCE(ObjectDate_StartSummer.ValueData, Null)  ::TDateTime  AS StartSummerDate
         , COALESCE(ObjectDate_EndSummer.ValueData, Null)  ::TDateTime    AS EndSummerDate

         , COALESCE(ObjectFloat_SummerFuel.ValueData, 0) ::TFloat  AS SummerFuel
         , COALESCE(ObjectFloat_WinterFuel.ValueData, 0) ::TFloat  AS WinterFuel
         , COALESCE(ObjectFloat_Reparation.ValueData, 0) ::TFloat  AS Reparation
         , COALESCE(ObjectFloat_Limit.ValueData, 0) ::TFloat       AS LimitMoney
         , COALESCE(ObjectFloat_LimitDistance.ValueData, 0) ::TFloat   AS LimitDistance

         , (COALESCE (Object_CarModel.ValueData, '') || COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarNameAll
         , Object_Car.ValueData       AS CarName
         , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

         , Object_Branch.ObjectCode   AS BranchCode
         , Object_Branch.ValueData    AS BranchName
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , ObjectTo.Id                AS ObjectToId
         , ObjectTo.ValueData         AS ObjectToName
         , ObjectDesc.ItemName        AS DescName

         , tmpPersonal.isDateOut :: Boolean AS isDateOut
         , tmpPersonal.PersonalId

         , CASE WHEN tmpPersonal.DateIn < DATE_TRUNC ('YEAR', inOperDate) THEN DATE_TRUNC ('YEAR', inOperDate) ELSE tmpPersonal.DateIn END :: TDateTime AS DateIn_Holiday
         , CASE WHEN tmpPersonal.DateOut > DATE_TRUNC ('YEAR', inOperDate) + INTERVAL '1 YEAR' - INTERVAL '1 DAY' THEN DATE_TRUNC ('YEAR', inOperDate) + INTERVAL '1 YEAR' - INTERVAL '1 DAY' ELSE tmpPersonal.DateOut - INTERVAL '1 DAY' END :: TDateTime AS DateOut_Holiday
         , CASE WHEN tmpPersonal.DateOut = zc_DateEnd() THEN NULL WHEN tmpPersonal.DateOut > DATE_TRUNC ('YEAR', inOperDate) + INTERVAL '1 YEAR' - INTERVAL '1 DAY' THEN DATE_TRUNC ('YEAR', inOperDate) + INTERVAL '1 YEAR' - INTERVAL '1 DAY' ELSE tmpPersonal.DateOut - INTERVAL '1 DAY' END :: TDateTime AS DateOut_Holiday_user

         , Object_Member.isErased                   AS isErased

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

          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Member.Id
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
          LEFT JOIN ObjectString AS ObjectString_CardSecond
                                 ON ObjectString_CardSecond.ObjectId = Object_Member.Id
                                AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
          LEFT JOIN ObjectString AS ObjectString_CardChild
                                 ON ObjectString_CardChild.ObjectId = Object_Member.Id
                                AND ObjectString_CardChild.DescId = zc_ObjectString_Member_CardChild()
          LEFT JOIN ObjectString AS ObjectString_CardIBAN
                                 ON ObjectString_CardIBAN.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecond
                                 ON ObjectString_CardIBANSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()
          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Member.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()
         LEFT JOIN ObjectLink AS ObjectLink_Member_InfoMoney
                              ON ObjectLink_Member_InfoMoney.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_InfoMoney.DescId = zc_ObjectLink_Member_InfoMoney()
         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Member_InfoMoney.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo
                              ON ObjectLink_Member_ObjectTo.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
         LEFT JOIN Object AS ObjectTo ON ObjectTo.Id = ObjectLink_Member_ObjectTo.ChildObjectId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = ObjectTo.DescId

         LEFT JOIN ObjectDate AS ObjectDate_StartSummer
                              ON ObjectDate_StartSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_StartSummer.DescId = zc_ObjectDate_Member_StartSummer()

         LEFT JOIN ObjectDate AS ObjectDate_EndSummer
                              ON ObjectDate_EndSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_EndSummer.DescId = zc_ObjectDate_Member_EndSummer()

         LEFT JOIN ObjectFloat AS ObjectFloat_SummerFuel
                               ON ObjectFloat_SummerFuel.ObjectId = Object_Member.Id
                              AND ObjectFloat_SummerFuel.DescId = zc_ObjectFloat_Member_Summer()

         LEFT JOIN ObjectFloat AS ObjectFloat_WinterFuel
                               ON ObjectFloat_WinterFuel.ObjectId = Object_Member.Id
                              AND ObjectFloat_WinterFuel.DescId = zc_ObjectFloat_Member_Winter()

         LEFT JOIN ObjectFloat AS ObjectFloat_Reparation
                               ON ObjectFloat_Reparation.ObjectId = Object_Member.Id
                              AND ObjectFloat_Reparation.DescId = zc_ObjectFloat_Member_Reparation()

         LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                               ON ObjectFloat_Limit.ObjectId = Object_Member.Id
                              AND ObjectFloat_Limit.DescId = zc_ObjectFloat_Member_Limit()

         LEFT JOIN ObjectFloat AS ObjectFloat_LimitDistance
                               ON ObjectFloat_LimitDistance.ObjectId = Object_Member.Id
                              AND ObjectFloat_LimitDistance.DescId = zc_ObjectFloat_Member_LimitDistance()

         LEFT JOIN tmpCar ON tmpCar.MemberId = Object_Member.Id

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id AND tmpPersonal.Ord = 1
         LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
         LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId

         LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpCar.CarId
         LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
         LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                              ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                             AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
         LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Bank
                              ON ObjectLink_Member_Bank.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Bank.DescId = zc_ObjectLink_Member_Bank()
         LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Member_Bank.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                              ON ObjectLink_Member_BankSecond.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecond.DescId = zc_ObjectLink_Member_BankSecond()
         LEFT JOIN Object AS Object_BankSecond ON Object_BankSecond.Id = ObjectLink_Member_BankSecond.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_BankChild
                              ON ObjectLink_Member_BankChild.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankChild.DescId = zc_ObjectLink_Member_BankChild()
         LEFT JOIN Object AS Object_BankChild ON Object_BankChild.Id = ObjectLink_Member_BankChild.ChildObjectId

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
           , 0    AS Code
           , CAST ('УДАЛИТЬ' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Card
           , CAST ('' as TVarChar)  AS CardSecond
           , CAST ('' as TVarChar)  AS CardChild
           , CAST ('' AS TVarChar)  AS CardIBAN
           , CAST ('' AS TVarChar)  AS CardIBANSecond
           , CAST ('' as TVarChar)  AS Comment
           , FALSE                  AS isOfficial
           , FALSE                  AS isNotCompensation

           , CAST (0 as Integer)    AS BankId
           , CAST ('' as TVarChar)  AS BankName
           , CAST (0 as Integer)    AS BankSecondId
           , CAST ('' as TVarChar)  AS BankSecondName
           , CAST (0 as Integer)    AS BankChildId
           , CAST ('' as TVarChar)  AS BankChildName

           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST (0 as Integer)    AS InfoMoneyCode
           , CAST ('' as TVarChar)  AS InfoMoneyName
           , CAST ('' as TVarChar)  AS InfoMoneyName_all

           , CAST (Null as TDateTime) AS StartSummerDate
           , CAST (Null as TDateTime) AS EndSummerDate

           , CAST (0 as TFloat) AS SummerFuel
           , CAST (0 as TFloat) AS WinterFuel
           , CAST (0 as TFloat) AS Reparation
           , CAST (0 as TFloat) AS LimitMoney
           , CAST (0 as TFloat) AS LimitDistance
           , CAST ('' as TVarChar)  AS CarNameAll
           , CAST ('' as TVarChar)  AS CarName
           , CAST ('' as TVarChar)  AS CarModelName

           , 0              AS BranchCode
           , '' :: TVarChar AS BranchName
           , 0              AS UnitCode
           , '' :: TVarChar AS UnitName
           , 0              AS PositionCode
           , '' :: TVarChar AS PositionName

           , CAST (0 as Integer)   AS ObjectToId
           , CAST ('' as TVarChar) AS ObjectToName
           , CAST ('' as TVarChar) AS DescName

           , FALSE          AS isDateOut
           , 0              AS PersonalId

           , CURRENT_DATE :: TDateTime AS DateIn_Holiday
           , CURRENT_DATE :: TDateTime AS DateOut_Holiday
           , NULL         :: TDateTime AS DateOut_Holiday_user

           , FALSE AS isErased


    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.02.20         * add isNotCompensation
 09.09.19         *
 03.03.17         * add Bank, BankSecond, BankChild
 20.02.17         * add CardSecond
 02.02.17         * add ObjectTo
 25.03.16         * add Card
 14.01.16         * add Car, StartSummerDate, EndSummerDate
                           , SummerFuel, WinterFuel, Reparation, LimitMoney, LimitDistance
 19.02.15         * add InfoMoney
 24.09.13                                        * add vbIsAllUnit
 12.09.14                                        * add isOfficial
 12.09.13                                        * add inIsShowAll
 13.12.13                                        * del Object_RoleAccessKey_View
 08.12.13                                        * add Object_RoleAccessKey_View
 01.10.13         *  add DriverCertificate, Comment
 01.07.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member_Holiday (CURRENT_DATE, TRUE, zfCalc_UserAdmin())  order by 3
-- SELECT * FROM gpSelect_Object_Member_Holiday (CURRENT_DATE, FALSE, zfCalc_UserAdmin()) order by 3
