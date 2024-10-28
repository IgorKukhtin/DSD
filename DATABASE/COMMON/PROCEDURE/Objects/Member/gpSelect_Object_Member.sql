-- Function: gpSelect_Object_Member (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)

RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Code1C TVarChar
             , INN TVarChar, DriverCertificate TVarChar
             , Card TVarChar, CardSecond TVarChar, CardChild TVarChar
             , CardIBAN TVarChar, CardIBANSecond TVarChar
             , CardBank TVarChar, CardBankSecond TVarChar  
             , CardBankSecondTwo TVarChar, CardIBANSecondTwo TVarChar, CardSecondTwo TVarChar
             , CardBankSecondDiff TVarChar, CardIBANSecondDiff TVarChar, CardSecondDiff TVarChar 
             , CardBank_search TVarChar, CardIBAN_search TVarChar, Card_search TVarChar
             , Comment TVarChar
             , isOfficial Boolean
             , isNotCompensation Boolean
             , BankId Integer, BankName TVarChar
             , BankSecondId Integer, BankSecondName TVarChar
             , BankChildId Integer, BankChildName TVarChar
             , BankSecondTwoId Integer, BankSecondTwoName TVarChar
             , BankSecondDiffId Integer, BankSecondDiffName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , StartSummerDate TDateTime, EndSummerDate TDateTime
             , SummerFuel TFloat, WinterFuel TFloat, Reparation TFloat, LimitMoney TFloat, LimitDistance TFloat
             , CarNameAll TVarChar, CarName TVarChar, CarModelName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , UnitMobileId Integer, UnitMobileName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , ObjectToId Integer, ObjectToName TVarChar, DescName TVarChar
             , isDateOut Boolean, PersonalId Integer
             , isErased Boolean
             
             , GenderId Integer
             , GenderName TVarChar
             , MemberSkillId Integer
             , MemberSkillName TVarChar
             , JobSourceId Integer
             , JobSourceName TVarChar
             , RegionId Integer
             , RegionName TVarChar
             , RegionId_Real Integer
             , RegionName_Real TVarChar
             , CityId Integer
             , CityName TVarChar
             , CityId_Real Integer
             , CityName_Real TVarChar 
             , RouteNumId Integer, RouteNumName TVarChar
             , Birthday_Date TDateTime
             , Children1_Date TDateTime
             , Children2_Date TDateTime
             , Children3_Date TDateTime
             , Children4_Date TDateTime
             , Children5_Date TDateTime
             , PSP_StartDate TDateTime
             , PSP_EndDate TDateTime
             , Dekret_StartDate TDateTime
             , Dekret_EndDate TDateTime
  
             , Street TVarChar
             , Street_Real TVarChar
             , Children1 TVarChar
             , Children2 TVarChar
             , Children3 TVarChar
             , Children4 TVarChar
             , Children5 TVarChar
             , Law TVarChar
             , DriverCertificateAdd TVarChar
             , PSP_S TVarChar
             , PSP_N TVarChar
             , PSP_W TVarChar
             , PSP_D TVarChar
             , GLN TVarChar    
             , Phone TVarChar
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
                 OR vbUserId = 80373   -- Прохорова С.А.
                 OR vbUserId = 80830   -- Кисличная Т.А.
                 OR vbUserId = 2573318 -- Любарский Г.О.
                 OR vbUserId = 9457    -- Климентьев К.И.
               ;

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0; 
   
   IF vbUserId = 9457 THEN  vbIsConstraint= false; END IF;
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

         , ObjectString_Code1C.ValueData ::TVarChar AS Code1C
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Card.ValueData              AS Card
         , ObjectString_CardSecond.ValueData        AS CardSecond
         , ObjectString_CardChild.ValueData         AS CardChild
         , ObjectString_CardIBAN.ValueData          AS CardIBAN
         , ObjectString_CardIBANSecond.ValueData    AS CardIBANSecond
         , ObjectString_CardBank.ValueData          AS CardBank
         , ObjectString_CardBankSecond.ValueData    AS CardBankSecond 
             
         , ObjectString_CardBankSecondTwo.ValueData    AS CardBankSecondTwo
         , ObjectString_CardIBANSecondTwo.ValueData    AS CardIBANSecondTwo
         , ObjectString_CardSecondTwo.ValueData        AS CardSecondTwo
         , ObjectString_CardBankSecondDiff.ValueData   AS CardBankSecondDiff
         , ObjectString_CardIBANSecondDiff.ValueData   AS CardIBANSecondDiff
         , ObjectString_CardSecondDiff.ValueData       AS CardSecondDiff
         
         , (COALESCE (ObjectString_CardBank.ValueData,'') ||'&'||COALESCE (ObjectString_CardBankSecond.ValueData,'') ||'&'|| COALESCE (ObjectString_CardBankSecondTwo.ValueData,'')||'&'|| COALESCE (ObjectString_CardBankSecondDiff.ValueData,''))::TVarChar AS CardBank_search
         , (COALESCE (ObjectString_CardIBAN.ValueData,'') ||'&'||COALESCE (ObjectString_CardIBANSecond.ValueData,'') ||'&'|| COALESCE (ObjectString_CardIBANSecondTwo.ValueData,'')||'&'|| COALESCE (ObjectString_CardIBANSecondDiff.ValueData,''))::TVarChar AS CardIBAN_search
         , (COALESCE (ObjectString_Card.ValueData,'')     ||'&'||COALESCE (ObjectString_CardSecond.ValueData,'')     ||'&'|| COALESCE (ObjectString_CardSecondTwo.ValueData,'')    ||'&'|| COALESCE (ObjectString_CardSecondDiff.ValueData,'')    )::TVarChar AS Card_search         
             
         , ObjectString_Comment.ValueData           AS Comment

         , ObjectBoolean_Official.ValueData         AS isOfficial
         , COALESCE (ObjectBoolean_NotCompensation.ValueData, FALSE) :: Boolean  AS isNotCompensation

         , Object_Bank.Id               AS BankId
         , Object_Bank.ValueData        AS BankName
         , Object_BankSecond.Id         AS BankSecondId
         , Object_BankSecond.ValueData  AS BankSecondName
         , Object_BankChild.Id          AS BankChildId
         , Object_BankChild.ValueData   AS BankChildName

         , Object_BankSecondTwo.Id          AS BankSecondTwoId
         , Object_BankSecondTwo.ValueData   AS BankSecondTwoName
         , Object_BankSecondDiff.Id         AS BankSecondDiffId
         , Object_BankSecondDiff.ValueData  AS BankSecondDiffName

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

         , (COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarNameAll
         , Object_Car.ValueData       AS CarName
         , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

         , Object_Branch.ObjectCode   AS BranchCode
         , Object_Branch.ValueData    AS BranchName
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName
         , Object_UnitMobile.Id        AS UnitMobileId
         , Object_UnitMobile.ValueData AS UnitMobileName
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , ObjectTo.Id                AS ObjectToId
         , ObjectTo.ValueData         AS ObjectToName
         , ObjectDesc.ItemName        AS DescName

         , tmpPersonal.isDateOut :: Boolean AS isDateOut
         , tmpPersonal.PersonalId

         , Object_Member.isErased                   AS isErased

--
         , Object_Gender.Id       AS GenderId
         , Object_Gender.ValueData       AS GenderName
         , Object_MemberSkill.Id         AS MemberSkillId
         , Object_MemberSkill.ValueData  AS MemberSkillName
         , Object_JobSource.Id           AS JobSourceId
         , Object_JobSource.ValueData    AS JobSourceName
         , Object_Region.Id              AS RegionId
         , Object_Region.ValueData       AS RegionName
         , Object_Region_Real.Id         AS RegionId_Real
         , Object_Region_Real.ValueData  AS RegionName_Real
         , Object_City.Id                AS CityId
         , Object_City.ValueData         AS CityName
         , Object_City_Real.Id           AS CityId_Real
         , Object_City_Real.ValueData    AS CityName_Real
         
         , Object_RouteNum.Id            AS RouteNumId
         , Object_RouteNum.ValueData     AS RouteNumName
         
         , COALESCE(ObjectDate_Birthday.ValueData, Null)   ::TDateTime  AS Birthday_Date
         , COALESCE(ObjectDate_Children1.ValueData, Null)  ::TDateTime  AS Children1_Date
         , COALESCE(ObjectDate_Children2.ValueData, Null)  ::TDateTime  AS Children2_Date
         , COALESCE(ObjectDate_Children3.ValueData, Null)  ::TDateTime  AS Children3_Date
         , COALESCE(ObjectDate_Children4.ValueData, Null)  ::TDateTime  AS Children4_Date
         , COALESCE(ObjectDate_Children5.ValueData, Null)  ::TDateTime  AS Children5_Date
         , COALESCE(ObjectDate_PSP_Start.ValueData, Null)  ::TDateTime  AS PSP_StartDate
         , COALESCE(ObjectDate_PSP_End.ValueData, Null)    ::TDateTime  AS PSP_EndDate
         , COALESCE(ObjectDate_Dekret_Start.ValueData, Null)  ::TDateTime  AS Dekret_StartDate
         , COALESCE(ObjectDate_Dekret_End.ValueData, Null)    ::TDateTime  AS Dekret_EndDate
         
         , ObjectString_Street.ValueData               AS Street
         , ObjectString_Street_Real.ValueData          AS Street_Real
         , ObjectString_Children1.ValueData            AS Children1
         , ObjectString_Children2.ValueData            AS Children2
         , ObjectString_Children3.ValueData            AS Children3
         , ObjectString_Children4.ValueData            AS Children4
         , ObjectString_Children5.ValueData            AS Children5
         , ObjectString_Law.ValueData                  AS Law
         , ObjectString_DriverCertificateAdd.ValueData AS DriverCertificateAdd
         , ObjectString_PSP_S.ValueData                AS PSP_S
         , ObjectString_PSP_N.ValueData                AS PSP_N
         , ObjectString_PSP_W.ValueData                AS PSP_W
         , ObjectString_PSP_D.ValueData                AS PSP_D

         , ObjectString_GLN.ValueData      :: TVarChar AS GLN  
         
         , ObjectString_Phone.ValueData    :: TVarChar AS Phone
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

          LEFT JOIN ObjectString AS ObjectString_CardBank
                                 ON ObjectString_CardBank.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBank.DescId = zc_ObjectString_Member_CardBank()
          LEFT JOIN ObjectString AS ObjectString_CardBankSecond
                                 ON ObjectString_CardBankSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecond.DescId = zc_ObjectString_Member_CardBankSecond()

          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

          LEFT JOIN ObjectString AS ObjectString_CardBankSecondTwo
                                 ON ObjectString_CardBankSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecondTwo.DescId = zc_ObjectString_Member_CardBankSecondTwo()
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecondTwo
                                 ON ObjectString_CardIBANSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecondTwo.DescId = zc_ObjectString_Member_CardIBANSecondTwo()
          LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                 ON ObjectString_CardSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecondTwo.DescId = zc_ObjectString_Member_CardSecondTwo()
          LEFT JOIN ObjectString AS ObjectString_CardBankSecondDiff
                                 ON ObjectString_CardBankSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecondDiff.DescId = zc_ObjectString_Member_CardBankSecondDiff()
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecondDiff
                                 ON ObjectString_CardIBANSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecondDiff.DescId = zc_ObjectString_Member_CardIBANSecondDiff()
          LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                 ON ObjectString_CardSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecondDiff.DescId = zc_ObjectString_Member_CardSecondDiff()

          LEFT JOIN ObjectString AS ObjectString_Code1C
                                 ON ObjectString_Code1C.ObjectId = Object_Member.Id
                                AND ObjectString_Code1C.DescId = zc_ObjectString_Member_Code1C()

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

         LEFT JOIN ObjectLink AS ObjectLink_Member_Gender
                              ON ObjectLink_Member_Gender.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Gender.DescId = zc_ObjectLink_Member_Gender()
         LEFT JOIN Object AS Object_Gender ON Object_Gender.Id = ObjectLink_Member_Gender.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_MemberSkill
                              ON ObjectLink_Member_MemberSkill.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_MemberSkill.DescId = zc_ObjectLink_Member_MemberSkill()
         LEFT JOIN Object AS Object_MemberSkill ON Object_MemberSkill.Id = ObjectLink_Member_MemberSkill.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_JobSource
                              ON ObjectLink_Member_JobSource.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_JobSource.DescId = zc_ObjectLink_Member_JobSource()
         LEFT JOIN Object AS Object_JobSource ON Object_JobSource.Id = ObjectLink_Member_JobSource.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Region
                              ON ObjectLink_Member_Region.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region.DescId = zc_ObjectLink_Member_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_Member_Region.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_City
                              ON ObjectLink_Member_City.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City.DescId = zc_ObjectLink_Member_City()
         LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Member_City.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Region_Real
                              ON ObjectLink_Member_Region_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region_Real.DescId = zc_ObjectLink_Member_Region_Real()
         LEFT JOIN Object AS Object_Region_Real ON Object_Region_Real.Id = ObjectLink_Member_Region_Real.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_City_Real
                              ON ObjectLink_Member_City_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City_Real.DescId = zc_ObjectLink_Member_City_Real()
         LEFT JOIN Object AS Object_City_Real ON Object_City_Real.Id = ObjectLink_Member_City_Real.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_RouteNum
                              ON ObjectLink_Member_RouteNum.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_RouteNum.DescId = zc_ObjectLink_Member_RouteNum()
         LEFT JOIN Object AS Object_RouteNum ON Object_RouteNum.Id = ObjectLink_Member_RouteNum.ChildObjectId

         LEFT JOIN ObjectDate AS ObjectDate_StartSummer
                              ON ObjectDate_StartSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_StartSummer.DescId = zc_ObjectDate_Member_StartSummer()

         LEFT JOIN ObjectDate AS ObjectDate_EndSummer
                              ON ObjectDate_EndSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_EndSummer.DescId = zc_ObjectDate_Member_EndSummer()

         LEFT JOIN ObjectDate AS ObjectDate_Birthday
                              ON ObjectDate_Birthday.ObjectId = Object_Member.Id
                             AND ObjectDate_Birthday.DescId = zc_ObjectDate_Member_Birthday()
         LEFT JOIN ObjectDate AS ObjectDate_Children1
                              ON ObjectDate_Children1.ObjectId = Object_Member.Id
                             AND ObjectDate_Children1.DescId = zc_ObjectDate_Member_Children1()
         LEFT JOIN ObjectDate AS ObjectDate_Children2
                              ON ObjectDate_Children2.ObjectId = Object_Member.Id
                             AND ObjectDate_Children2.DescId = zc_ObjectDate_Member_Children2()
         LEFT JOIN ObjectDate AS ObjectDate_Children3
                              ON ObjectDate_Children3.ObjectId = Object_Member.Id
                             AND ObjectDate_Children3.DescId = zc_ObjectDate_Member_Children3()
         LEFT JOIN ObjectDate AS ObjectDate_Children4
                              ON ObjectDate_Children4.ObjectId = Object_Member.Id
                             AND ObjectDate_Children4.DescId = zc_ObjectDate_Member_Children4()
         LEFT JOIN ObjectDate AS ObjectDate_Children5
                              ON ObjectDate_Children5.ObjectId = Object_Member.Id
                             AND ObjectDate_Children5.DescId = zc_ObjectDate_Member_Children5()
         LEFT JOIN ObjectDate AS ObjectDate_PSP_Start
                              ON ObjectDate_PSP_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_Start.DescId = zc_ObjectDate_Member_PSP_Start()
         LEFT JOIN ObjectDate AS ObjectDate_PSP_End
                              ON ObjectDate_PSP_End.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_End.DescId = zc_ObjectDate_Member_PSP_End()
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_Start
                              ON ObjectDate_Dekret_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_Start.DescId = zc_ObjectDate_Member_Dekret_Start()
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_End
                              ON ObjectDate_Dekret_End.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_End.DescId = zc_ObjectDate_Member_Dekret_End()

         LEFT JOIN ObjectString AS ObjectString_Street
                                ON ObjectString_Street.ObjectId = Object_Member.Id
                               AND ObjectString_Street.DescId = zc_ObjectString_Member_Street()
         LEFT JOIN ObjectString AS ObjectString_Street_Real
                                ON ObjectString_Street_Real.ObjectId = Object_Member.Id
                               AND ObjectString_Street_Real.DescId = zc_ObjectString_Member_Street_Real()
         LEFT JOIN ObjectString AS ObjectString_Children1
                                ON ObjectString_Children1.ObjectId = Object_Member.Id
                               AND ObjectString_Children1.DescId = zc_ObjectString_Member_Children1()
         LEFT JOIN ObjectString AS ObjectString_Children2
                                ON ObjectString_Children2.ObjectId = Object_Member.Id
                               AND ObjectString_Children2.DescId = zc_ObjectString_Member_Children2()
         LEFT JOIN ObjectString AS ObjectString_Children3
                                ON ObjectString_Children3.ObjectId = Object_Member.Id
                               AND ObjectString_Children3.DescId = zc_ObjectString_Member_Children3()
         LEFT JOIN ObjectString AS ObjectString_Children4
                                ON ObjectString_Children4.ObjectId = Object_Member.Id
                               AND ObjectString_Children4.DescId = zc_ObjectString_Member_Children4()
         LEFT JOIN ObjectString AS ObjectString_Children5
                                ON ObjectString_Children5.ObjectId = Object_Member.Id
                               AND ObjectString_Children5.DescId = zc_ObjectString_Member_Children5()
         LEFT JOIN ObjectString AS ObjectString_Law
                                ON ObjectString_Law.ObjectId = Object_Member.Id
                               AND ObjectString_Law.DescId = zc_ObjectString_Member_Law()
         LEFT JOIN ObjectString AS ObjectString_DriverCertificateAdd
                                ON ObjectString_DriverCertificateAdd.ObjectId = Object_Member.Id
                               AND ObjectString_DriverCertificateAdd.DescId = zc_ObjectString_Member_DriverCertificateAdd()
         LEFT JOIN ObjectString AS ObjectString_PSP_S
                                ON ObjectString_PSP_S.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_S.DescId = zc_ObjectString_Member_PSP_S()
         LEFT JOIN ObjectString AS ObjectString_PSP_N
                                ON ObjectString_PSP_N.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_N.DescId = zc_ObjectString_Member_PSP_N()
         LEFT JOIN ObjectString AS ObjectString_PSP_W
                                ON ObjectString_PSP_W.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_W.DescId = zc_ObjectString_Member_PSP_W()
         LEFT JOIN ObjectString AS ObjectString_PSP_D
                                ON ObjectString_PSP_D.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_D.DescId = zc_ObjectString_Member_PSP_D()

         LEFT JOIN ObjectString AS ObjectString_GLN
                                ON ObjectString_GLN.ObjectId = Object_Member.Id
                               AND ObjectString_GLN.DescId = zc_ObjectString_Member_GLN()

         LEFT JOIN ObjectString AS ObjectString_Phone
                                ON ObjectString_Phone.ObjectId = Object_Member.Id
                               AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()

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

         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                              ON ObjectLink_Member_BankSecondTwo.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecondTwo.DescId = zc_ObjectLink_Member_BankSecondTwo()
         LEFT JOIN Object AS Object_BankSecondTwo ON Object_BankSecondTwo.Id = ObjectLink_Member_BankSecondTwo.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                              ON ObjectLink_Member_BankSecondDiff.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecondDiff.DescId = zc_ObjectLink_Member_BankSecondDiff()
         LEFT JOIN Object AS Object_BankSecondDiff ON Object_BankSecondDiff.Id = ObjectLink_Member_BankSecondDiff.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_UnitMobile
                              ON ObjectLink_Member_UnitMobile.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_UnitMobile.DescId = zc_ObjectLink_Member_UnitMobile()
         LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Member_UnitMobile.ChildObjectId
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
           , CAST ('' as TVarChar)  AS Code1C
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Card
           , CAST ('' as TVarChar)  AS CardSecond
           , CAST ('' as TVarChar)  AS CardChild
           , CAST ('' AS TVarChar)  AS CardIBAN
           , CAST ('' AS TVarChar)  AS CardIBANSecond
           , CAST ('' AS TVarChar)  AS CardBank
           , CAST ('' AS TVarChar)  AS CardBankSecond
           , CAST ('' AS TVarChar)  AS CardBankSecondTwo
           , CAST ('' AS TVarChar)  AS CardIBANSecondTwo
           , CAST ('' AS TVarChar)  AS CardSecondTwo
           , CAST ('' AS TVarChar)  AS CardBankSecondDiff
           , CAST ('' AS TVarChar)  AS CardIBANSecondDiff
           , CAST ('' AS TVarChar)  AS CardSecondDiff
           , CAST ('' AS TVarChar)  AS CardBank_search
           , CAST ('' AS TVarChar)  AS CardIBAN_search
           , CAST ('' AS TVarChar)  AS Card_search 
           , CAST ('' as TVarChar)  AS Comment
           
           , FALSE                  AS isOfficial
           , FALSE                  AS isNotCompensation

           , CAST (0 as Integer)    AS BankId
           , CAST ('' as TVarChar)  AS BankName
           , CAST (0 as Integer)    AS BankSecondId
           , CAST ('' as TVarChar)  AS BankSecondName
           , CAST (0 as Integer)    AS BankChildId
           , CAST ('' as TVarChar)  AS BankChildName
           , CAST (0 as Integer)    AS BankSecondTwoId
           , CAST ('' as TVarChar)  AS BankSecondTwoName
           , CAST (0 as Integer)    AS BankSecondDiffId
           , CAST ('' as TVarChar)  AS BankSecondDiffName

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
           , CAST (0 as Integer)    AS UnitMobileId
           , CAST ('' as TVarChar)  AS UnitMobileName
           , 0              AS PositionCode
           , '' :: TVarChar AS PositionName

           , CAST (0 as Integer)   AS ObjectToId
           , CAST ('' as TVarChar) AS ObjectToName
           , CAST ('' as TVarChar) AS DescName

           , FALSE          AS isDateOut
           , 0              AS PersonalId

           , FALSE AS isErased

           , CAST (0 as Integer)   AS GenderId
           , CAST ('' as TVarChar) AS GenderName
           , CAST (0 as Integer)   AS MemberSkillId
           , CAST ('' as TVarChar) AS MemberSkillName
           , CAST (0 as Integer)   AS JobSourceId
           , CAST ('' as TVarChar) AS JobSourceName
           , CAST (0 as Integer)   AS RegionId
           , CAST ('' as TVarChar) AS RegionName
           , CAST (0 as Integer)   AS RegionId_Real
           , CAST ('' as TVarChar) AS RegionName_Real
           , CAST (0 as Integer)   AS CityId
           , CAST ('' as TVarChar) AS CityName
           , CAST (0 as Integer)   AS CityId_Real
           , CAST ('' as TVarChar) AS CityName_Real  
           , CAST (0 as Integer)   AS RouteNumId
           , CAST ('' as TVarChar) AS RouteNumName 

           , CAST (Null as TDateTime) AS Birthday_Date
           , CAST (Null as TDateTime) AS Children1_Date
           , CAST (Null as TDateTime) AS Children2_Date
           , CAST (Null as TDateTime) AS Children3_Date
           , CAST (Null as TDateTime) AS Children4_Date
           , CAST (Null as TDateTime) AS Children5_Date
           , CAST (Null as TDateTime) AS PSP_StartDate
           , CAST (Null as TDateTime) AS PSP_EndDate
           , CAST (Null as TDateTime) AS Dekret_StartDate
           , CAST (Null as TDateTime) AS Dekret_EndDate

           , CAST ('' as TVarChar) AS Street
           , CAST ('' as TVarChar) AS Street_Real
           , CAST ('' as TVarChar) AS Children1
           , CAST ('' as TVarChar) AS Children2
           , CAST ('' as TVarChar) AS Children3
           , CAST ('' as TVarChar) AS Children4
           , CAST ('' as TVarChar) AS Children5
           , CAST ('' as TVarChar) AS Law
           , CAST ('' as TVarChar) AS DriverCertificateAdd
           , CAST ('' as TVarChar) AS PSP_S
           , CAST ('' as TVarChar) AS PSP_N
           , CAST ('' as TVarChar) AS PSP_W
           , CAST ('' as TVarChar) AS PSP_D
           , CAST ('' as TVarChar) AS GLN
           , CAST ('' as TVarChar) AS Phone
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Member (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.24         *
 26.02.24         *
 10.05.23         * 
 27.09.21         * UnitMobile
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
-- SELECT * FROM gpSelect_Object_Member (TRUE, zfCalc_UserAdmin())  order by 3
-- SELECT * FROM gpSelect_Object_Member (FALSE, zfCalc_UserAdmin()) order by 3
