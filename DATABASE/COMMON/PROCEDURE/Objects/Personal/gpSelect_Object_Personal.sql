-- Function: gpSelect_Object_Personal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsPeriod    Boolean   , --
    IN inIsShowAll   Boolean,    --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MemberCode Integer, MemberName TVarChar, INN TVarChar
             , Code1C TVarChar
             , DriverCertificate TVarChar, Card TVarChar, CardSecond TVarChar, BankName TVarChar, BankSecondName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, BranchCode Integer, BranchName TVarChar
             , DepartmentId Integer, DepartmentName TVarChar
             , Department_twoId Integer, Department_twoName TVarChar    
             , PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar
             , StorageLineId Integer, StorageLineCode Integer, StorageLineName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , PersonalServiceListOfficialId Integer, PersonalServiceListOfficialName TVarChar
             , ServiceListId_AvanceF2 Integer, ServiceListName_AvanceF2 TVarChar
             , ServiceListCardSecondId Integer, ServiceListCardSecondName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , SheetWorkTimeId Integer, SheetWorkTimeName TVarChar
             , DateIn TDateTime, DateOut TDateTime, DateSend TDateTime
             , isDateOut Boolean, isDateSend Boolean, isMain Boolean, isOfficial Boolean
             , MemberId Integer, UserId Integer
             , ScalePSW TVarChar, ScalePSW_forPrint TFloat
             , isErased Boolean
             , isPastMain Boolean
             , isIrna Boolean
             , Member_ReferId Integer
             , Member_ReferCode Integer
             , Member_ReferName TVarChar
             , Member_MentorId Integer
             , Member_MentorCode Integer
             , Member_MentorName TVarChar
             , ReasonOutId Integer
             , ReasonOutCode Integer
             , ReasonOutName TVarChar
             , Comment TVarChar
             , Birthday_Date TVarChar
             , CardBank TVarChar, CardBankSecond TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbPersonalServiceListId_check Integer;
   DECLARE vbMemberId Integer;

   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId)
                 OR vbUserId = 343013 -- Нагорная Я.Г.
                   ;
   --
   vbMemberId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbUserId AND OL.DescId = zc_ObjectLink_User_Member());

   vbIsAllUnit:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND Object_RoleAccessKeyGuide_View.UserId = vbUserId)
              OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND RoleId IN (447972)) -- Просмотр СБ
              OR vbUserId = 80830   -- Кисличная Т.А.
              OR vbUserId = 343013  -- Нагорная Я.Г.
              OR vbUserId = 2573318 -- Любарский Г.О.
              OR vbUserId = 14599 -- Коротченко Т.Н.
                ;

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);


   -- определяется - Ведомость коммерческий отдел (руководители)
   vbPersonalServiceListId_check:= (WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                                              , lfSelect.PersonalId
                                                              , lfSelect.isDateOut
                                                         FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                                        )
                                       , tmpUser AS (SELECT tmpPersonal.PersonalId
                                                     FROM ObjectLink AS ObjectLink_User_Member
                                                          JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                                                                          AND tmpPersonal.isDateOut = FALSE
                                                     WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                                       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                                    )
                                    -- Ведомость коммерческий отдел (руководители)
                                    SELECT ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                    FROM Object_Personal_View
                                         INNER JOIN tmpUser ON tmpUser.PersonalId = Object_Personal_View.PersonalId
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                               ON ObjectLink_Personal_PersonalServiceList.ObjectId      = Object_Personal_View.PersonalId
                                                              AND ObjectLink_Personal_PersonalServiceList.DescId        = zc_ObjectLink_Personal_PersonalServiceList()
                                                              AND ObjectLink_Personal_PersonalServiceList.ChildObjectId = 305297 -- Ведомость коммерческий отдел (руководители)
                                    WHERE Object_Personal_View.isErased   = FALSE
                                       AND Object_Personal_View.isDateOut = FALSE
                                    LIMIT 1
                                   );


   -- определяется Дефолт
   SELECT View_InfoMoney.InfoMoneyId, View_InfoMoney.InfoMoneyName, View_InfoMoney.InfoMoneyName_all
          INTO vbInfoMoneyId, vbInfoMoneyName, vbInfoMoneyName_all
   FROM Object_InfoMoney_View AS View_InfoMoney
   WHERE View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101(); -- 60101 Заработная плата + Заработная плата


   -- Результат
   RETURN QUERY

     WITH tmpUser_Member AS (SELECT ObjectLink_User_Member.DescId
                                  , ObjectLink_User_Member.ChildObjectId
                                  , MAX (ObjectLink_User_Member.ObjectId) AS ObjectId
                             FROM ObjectLink AS ObjectLink_User_Member
                                  JOIN Object AS Object_User ON Object_User.Id       = ObjectLink_User_Member.ObjectId
                                                            AND Object_User.isErased = FALSE
                             WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                             GROUP BY ObjectLink_User_Member.DescId
                                    , ObjectLink_User_Member.ChildObjectId
                            )

     SELECT
           Object_Personal_View.PersonalId   AS Id
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName  
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_Code1C.ValueData ::TVarChar AS Code1C

         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Card.ValueData              AS Card
         , ObjectString_CardSecond.ValueData        AS CardSecond
         , Object_Bank.ValueData                    AS BankName
         , Object_BankSecond.ValueData              AS BankSecondName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionCode
         , Object_Personal_View.PositionName

         , Object_Personal_View.PositionLevelId
         , Object_Personal_View.PositionLevelCode
         , Object_Personal_View.PositionLevelName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitCode
         , Object_Personal_View.UnitName

         , Object_Branch.ObjectCode AS BranchCode
         , Object_Branch.ValueData  AS BranchName

         , Object_Department.Id              AS DepartmentId
         , Object_Department.ValueData       AS DepartmentName
         , Object_Department_two.Id          AS Department_twoId
         , Object_Department_two.ValueData   AS Department_twoName

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupCode
         , Object_Personal_View.PersonalGroupName

         , Object_Personal_View.StorageLineId
         , Object_Personal_View.StorageLineCode
         , Object_Personal_View.StorageLineName

         , Object_PersonalServiceList.Id           AS PersonalServiceListId
         , Object_PersonalServiceList.ValueData    AS PersonalServiceListName

         , Object_PersonalServiceListOfficial.Id           AS PersonalServiceListOfficialId
         , Object_PersonalServiceListOfficial.ValueData    AS PersonalServiceListOfficialName

         , Object_PersonalServiceListAvance_F2.Id                  AS ServiceListId_AvanceF2
         , Object_PersonalServiceListAvance_F2.ValueData           AS ServiceListName_AvanceF2
         
         , COALESCE (Object_PersonalServiceListCardSecond.Id, CAST (0 as Integer))          AS PersonalServiceListCardSecondId
         , COALESCE (Object_PersonalServiceListCardSecond.ValueData, CAST ('' as TVarChar)) AS PersonalServiceListCardSecondName

         , vbInfoMoneyId       AS InfoMoneyId
         , vbInfoMoneyName     AS InfoMoneyName
         , vbInfoMoneyName_all AS InfoMoneyName_all

         , COALESCE (Object_SheetWorkTime.Id, COALESCE (Object_Position_SheetWorkTime.Id, COALESCE (Object_Unit_SheetWorkTime.Id, 0)) )  AS SheetWorkTimeId
         , COALESCE (Object_SheetWorkTime.ValueData, COALESCE ('* '||Object_Position_SheetWorkTime.ValueData, COALESCE ('** '||Object_Unit_SheetWorkTime.ValueData, '')) ) ::TVarChar     AS SheetWorkTimeName

         , Object_Personal_View.DateIn
         , CASE WHEN Object_Personal_View.isErased = TRUE THEN Object_Personal_View.DateOut ELSE Object_Personal_View.DateOut_user END ::TDateTime AS DateOut
         , Object_Personal_View.DateSend  ::TDateTime
         , Object_Personal_View.isDateOut
         , Object_Personal_View.isDateSend
         , Object_Personal_View.isMain
         , Object_Personal_View.isOfficial
         
         , Object_Personal_View.MemberId                                                    AS MemberId  
         , ObjectLink_User_Member.ObjectId                                                  AS UserId
         , REPEAT ('*', LENGTH (CASE WHEN COALESCE (ObjectFloat_ScalePSW.ValueData, 0) = 0 THEN '' ELSE '12345' /*(ObjectFloat_ScalePSW.ValueData :: Integer) :: TVarChar*/ END)) :: TVarChar AS ScalePSW
         , COALESCE (ObjectFloat_ScalePSW.ValueData, 0) ::TFloat                            AS ScalePSW_forPrint
         , Object_Personal_View.isErased
         , CASE WHEN Object_Personal_View.isErased = TRUE /*OR DATE_PART('YEAR', AGE ( COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) + interval '1 day' , Object_Personal_View.DateIn)) > 0*/
                THEN FALSE
                ELSE CASE WHEN (SELECT 1 FROM lfSelect_Object_Member_Personal_PastMain (inStartDate := Object_Personal_View.DateIn - INTERVAL '1 YEAR'
                                                                                      , inEndDate   := Object_Personal_View.DateIn - INTERVAL '1 DAY'
                                                                                      , inMemberId  := Object_Personal_View.MemberId
                                                                                      , inSession   := inSession)) IS NOT NULL 
                          THEN TRUE 
                          ELSE FALSE
                     END
           END AS isPastMain
           
         , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna

         , Object_Personal_View.Member_ReferId
         , Object_Personal_View.Member_ReferCode
         , Object_Personal_View.Member_ReferName
         , Object_Personal_View.Member_MentorId
         , Object_Personal_View.Member_MentorCode
         , Object_Personal_View.Member_MentorName
         , Object_Personal_View.ReasonOutId
         , Object_Personal_View.ReasonOutCode
         , Object_Personal_View.ReasonOutName
         , Object_Personal_View.Comment
         --, COALESCE (ObjectDate_Birthday.ValueData, Null)   ::TDateTime  AS Birthday_Date
         , COALESCE (zfCalc_MonthName (ObjectDate_Birthday.ValueData),'???')   ::TVarChar  AS Birthday_Date

         , ObjectString_CardBank.ValueData        ::TVarChar  AS CardBank
         , ObjectString_CardBankSecond.ValueData  ::TVarChar  AS CardBankSecond
     FROM Object_Personal_View
          LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Object_Personal_View.AccessKeyId
          LEFT JOIN Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide ON View_RoleAccessKeyGuide.UserId = vbUserId AND View_RoleAccessKeyGuide.UnitId_PersonalService = Object_Personal_View.UnitId AND vbIsAllUnit = FALSE

          LEFT JOIN ObjectString AS ObjectString_Code1C
                                 ON ObjectString_Code1C.ObjectId = Object_Personal_View.PersonalId
                                AND ObjectString_Code1C.DescId = zc_ObjectString_Personal_Code1C()

          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Personal_View.MemberId
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Personal_View.MemberId
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
          LEFT JOIN ObjectString AS ObjectString_CardSecond
                                 ON ObjectString_CardSecond.ObjectId = Object_Personal_View.MemberId
                                AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
          LEFT JOIN ObjectLink AS ObjectLink_Member_Bank
                               ON ObjectLink_Member_Bank.ObjectId = Object_Personal_View.MemberId
                              AND ObjectLink_Member_Bank.DescId = zc_ObjectLink_Member_Bank()
          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Member_Bank.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                               ON ObjectLink_Member_BankSecond.ObjectId = Object_Personal_View.MemberId
                              AND ObjectLink_Member_BankSecond.DescId = zc_ObjectLink_Member_BankSecond()
          LEFT JOIN Object AS Object_BankSecond ON Object_BankSecond.Id = ObjectLink_Member_BankSecond.ChildObjectId

          LEFT JOIN tmpUser_Member AS ObjectLink_User_Member
                                   ON ObjectLink_User_Member.ChildObjectId = Object_Personal_View.MemberId          --ObjectLink_User_Member.ObjectId
                                  AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
        
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = Object_Personal_View.UnitId
                              AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                               ON ObjectLink_Unit_Department.ObjectId = Object_Personal_View.UnitId
                              AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
          LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_Unit_Department.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Department_two
                               ON ObjectLink_Unit_Department_two.ObjectId = Object_Personal_View.UnitId
                              AND ObjectLink_Unit_Department_two.DescId = zc_ObjectLink_Unit_Department_two()
          LEFT JOIN Object AS Object_Department_two ON Object_Department_two.Id = ObjectLink_Unit_Department_two.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                               ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
          LEFT JOIN Object AS Object_PersonalServiceListCardSecond ON Object_PersonalServiceListCardSecond.Id = ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                               ON ObjectLink_Personal_SheetWorkTime.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Position_SheetWorkTime
                               ON ObjectLink_Position_SheetWorkTime.ObjectId = Object_Personal_View.PositionId
                              AND ObjectLink_Position_SheetWorkTime.DescId = zc_ObjectLink_Position_SheetWorkTime()
          LEFT JOIN Object AS Object_Position_SheetWorkTime ON Object_Position_SheetWorkTime.Id = ObjectLink_Position_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                               ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Personal_View.UnitId
                              AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
          LEFT JOIN Object AS Object_Unit_SheetWorkTime ON Object_Unit_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                               ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
          LEFT JOIN Object AS Object_PersonalServiceListAvance_F2 ON Object_PersonalServiceListAvance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_ScalePSW
                                ON ObjectFloat_ScalePSW.ObjectId = Object_Personal_View.MemberId
                               AND ObjectFloat_ScalePSW.DescId   = zc_ObjectFloat_Member_ScalePSW()

          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Personal_View.MemberId
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN() 

          LEFT JOIN ObjectDate AS ObjectDate_Birthday
                               ON ObjectDate_Birthday.ObjectId = Object_Personal_View.MemberId
                              AND ObjectDate_Birthday.DescId = zc_ObjectDate_Member_Birthday()

          LEFT JOIN ObjectString AS ObjectString_CardBank
                                 ON ObjectString_CardBank.ObjectId = Object_Personal_View.MemberId 
                                AND ObjectString_CardBank.DescId = zc_ObjectString_Member_CardBank()
          LEFT JOIN ObjectString AS ObjectString_CardBankSecond
                                 ON ObjectString_CardBankSecond.ObjectId = Object_Personal_View.MemberId
                                AND ObjectString_CardBankSecond.DescId = zc_ObjectString_Member_CardBankSecond()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                  ON ObjectBoolean_Guide_Irna.ObjectId = Object_Personal_View.PersonalId
                                 AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
     WHERE (tmpRoleAccessKey.AccessKeyId IS NOT NULL
         OR vbAccessKeyAll = TRUE
         OR Object_Personal_View.BranchId = vbObjectId_Constraint
         -- если филиал Киев + еще  филиал Львов
         OR (Object_Personal_View.BranchId = 3080683 AND vbObjectId_Constraint = 8379)
         --
         OR Object_Personal_View.UnitId     = 8429  -- Отдел логистики
         OR Object_Personal_View.PositionId = 81178 -- экспедитор
         OR Object_Personal_View.PositionId = 8466  -- водитель
         OR Object_Personal_View.PositionId = 12946 -- заготовитель ж/в
         OR ObjectLink_Personal_PersonalServiceList.ChildObjectId = vbPersonalServiceListId_check -- Ведомость коммерческий отдел (руководители)
         OR Object_Personal_View.MemberId = vbMemberId
           )
       AND (View_RoleAccessKeyGuide.UnitId_PersonalService > 0
            OR vbIsAllUnit = TRUE
            OR Object_Personal_View.BranchId = vbObjectId_Constraint
         -- если филиал Киев + еще  филиал Львов
         OR (Object_Personal_View.BranchId = 3080683 AND vbObjectId_Constraint = 8379)
         --
            OR Object_Personal_View.PositionId = 12436 -- бухгалтер
            OR Object_Personal_View.UnitId     = 8386  -- Бухгалтерия
            OR Object_Personal_View.UnitId     = 8408  -- Отдел коммерции ф.Днепр
            OR ObjectLink_Personal_PersonalServiceList.ChildObjectId = vbPersonalServiceListId_check -- Ведомость коммерческий отдел (руководители)
           )
       AND (Object_Personal_View.isErased = FALSE
            OR (Object_Personal_View.isErased = TRUE AND inIsShowAll = TRUE OR inIsPeriod = TRUE)
           )
       AND (inIsPeriod = FALSE
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
         , 0 AS MemberCode
         , CAST ('УДАЛИТЬ' as TVarChar)  AS MemberName   
         , CAST ('' as TVarChar) AS INN
         , CAST ('' as TVarChar) AS Code1C
         , CAST ('' as TVarChar) AS DriverCertificate
         , CAST ('' as TVarChar) AS Card
         , CAST ('' as TVarChar) AS CardSecond
         , CAST ('' as TVarChar) AS BankName
         , CAST ('' as TVarChar) AS BankSecondName
         , 0                     AS PositionId
         , 0                     AS PositionCode
         , CAST ('' as TVarChar) AS PositionName
         , 0                     AS PositionLevelId
         , 0                     AS PositionLevelCode
         , CAST ('' as TVarChar) AS PositionLevelName
         , 0                     AS UnitId
         , 0                     AS UnitCode
         , CAST ('' as TVarChar) AS UnitName
         , 0                     AS BranchCode
         , CAST ('' as TVarChar) AS BranchName
         , 0                     AS DepartmentId
         , CAST ('' as TVarChar) AS DepartmentName
         , CAST (0 as Integer)    AS Department_twoId
         , CAST ('' as TVarChar)  AS Department_twoName
         , 0                     AS PersonalGroupId
         , 0                     AS PersonalGroupCode
         , CAST ('' as TVarChar) AS PersonalGroupName
         , 0                     AS StorageLineId
         , 0                     AS StorageLineCode
         , CAST ('' as TVarChar) AS StorageLineName
         , 0                     AS PersonalServiceListId
         , CAST ('' as TVarChar) AS PersonalServiceListName
         , 0                     AS PersonalServiceListOfficialId
         , CAST ('' as TVarChar) AS PersonalServiceListOfficialName
         , 0                      AS ServiceListId_AvanceF2
         , CAST ('' as TVarChar)  AS ServiceListName_AvanceF2
         , 0                     AS PersonalServiceListCardSecondId
         , CAST ('' as TVarChar) AS PersonalServiceListCardSecondName
         , 0                     AS InfoMoneyId
         , CAST ('' as TVarChar) AS InfoMoneyName
         , CAST ('' as TVarChar) AS InfoMoneyName_all
         , 0                     AS SheetWorkTimeId
         , CAST ('' as TVarChar)    AS SheetWorkTimeName
         , CAST (NULL as TDateTime) AS DateIn
         , CAST (NULL as TDateTime) AS DateOut
         , CAST (NULL as TDateTime) AS DateSend
         , FALSE                    AS isDateOut
         , FALSE                    AS isDateSend
         , FALSE                    AS isMain
         , FALSE                    AS isOfficial
         , 0                        AS MemberId  
         , 0                        AS UserId
         , CAST ('' as TVarChar)    AS ScalePSW
         , CAST (Null as TFloat)    AS ScalePSW_forPrint
         , FALSE                    AS isErased
         , FALSE                    AS isPastMain 
         , FALSE         :: Boolean AS isIrna

         , 0                        AS Member_ReferId
         , 0                        AS Member_ReferCode
         , CAST ('' as TVarChar)    AS Member_ReferName
         , 0                        AS Member_MentorId
         , 0                        AS Member_MentorCode
         , CAST ('' as TVarChar)    AS Member_MentorName
         , 0                        AS ReasonOutId
         , 0                        AS ReasonOutCode
         , CAST ('' as TVarChar)    AS ReasonOutName
         , CAST ('' as TVarChar)    AS Comment
         , CAST (NULL as TVarChar)  AS Birthday_Date 
         , CAST ('' as TVarChar)    AS CardBank
         , CAST ('' as TVarChar)    AS CardBankSecond
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.23         *
 19.04.23         *
 04.05.22         *
 27.04.22         *
 22.10.17         *
 13.07.17         * add PersonalServiceListCardSecond
 16.11.16         * add SheetWorkTime
 25.03.16         * add Card
 26.08.15         * add ObjectLink_Personal_PersonalServiceListOfficial
 07.05.15         * add ObjectLink_Personal_PersonalServiceList
 24.09.13                                        * add vbIsAllUnit
 12.09.13                                        * add inIsShowAll
 30.08.14                                        * add InfoMoney...
 11.08.14                                        * add 8429 -- Отдел логистики
 21.05.14                         * add Official
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 21.11.13                                        * add PositionLevel...
 28.10.13                         *
 30.09.13                                        * add Object_Personal_View
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business
 19.07.13         *    rename zc_ObjectDate...
 06.07.13                                        * error zc_ObjectLink_Personal_Juridical
 01.07.13         *
*/
/*
-- доступ
UPDATE Object SET AccessKeyId = COALESCE (Object_Branch.AccessKeyId, (SELECT zc_Enum_Process_AccessKey_TrasportDnepr() WHERE EXISTS (SELECT 1 FROM ObjectLink as ObjectLink_ch WHERE ObjectLink_ch.DescId = zc_ObjectLink_Car_Unit() AND ObjectLink_ch.ChildObjectId = ObjectLink.ChildObjectId)))
FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink2 ON ObjectLink2.ObjectId = ObjectLink.ChildObjectId AND ObjectLink2.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink2.ChildObjectId WHERE ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Personal_Unit() AND Object.DescId = zc_Object_Personal();
-- синхронизируем удаленных
update object set  isErased =  TRUE
where id in (select PersonalId
FROM Object_Personal_View
     left join Object on Object.Id = Object_Personal_View.MemberId
WHERE Object_Personal_View.isErased <> COALESCE (Object.isErased, TRUE)
    and COALESCE (Object.isErased, TRUE) = TRUE);
*/
/*

-- !!!!!!!!!!!!!!!!!!!!!!!
-- 1
-- !!!!!!!!!!!!!!!!!!!!!!!

with tmp as (            SELECT max (MovementItem.Id) AS MovementItemId
                              , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
--                              , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
  --                            , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                         FROM Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              INNER JOIN MovementItemFloat AS MIFloat_SummCard
                                                           ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                                                          AND MIFloat_SummCard.ValueData <> 0

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                           ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
where Movement.DescId = zc_Movement_PersonalService()
 AND Movement.StatusId = zc_Enum_Status_Complete()
group by COALESCE (MovementItem.ObjectId, 0)
--       , COALESCE (MILinkObject_Unit.ObjectId, 0)
  --    , COALESCE (MILinkObject_Position.ObjectId, 0)
)

select  -- lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceList(), tmp.ObjectId, MovementLinkObject_PersonalServiceList.ObjectId)
-- *
zc_ObjectLink_Personal_PersonalServiceList(), tmp.ObjectId, MovementLinkObject_PersonalServiceList.ObjectId
from tmp
     INNER JOIN MovementItem ON MovementItem.Id = tmp.MovementItemId
                               INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = MovementItem.MovementId
                                                            AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                            AND MovementLinkObject_PersonalServiceList.ObjectId not IN (293716 -- Ведомость карточки БН Фидо
                                                                                                                      , 413454 -- Ведомость карточки БН Пиреус
                                                                                                                       )

select -- lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), MovementItem.Id, ObjectLink_Personal_PersonalServiceList.ChildObjectId)
-- *
from MovementItem
                               INNER JOIN Movement on Movement.DescId = zc_Movement_PersonalService()
                                                  AND Movement.Id = MovementItem.MovementId
                               INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = MovementItem.MovementId
                                                            AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                            AND MovementLinkObject_PersonalServiceList.ObjectId  IN (293716 -- Ведомость карточки БН Фидо
                                                                                                                   , 413454 -- Ведомость карточки БН Пиреус
                                                                                                                     )
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem .ObjectId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()


-- !!!!!!!!!!!!!!!!!!!!!!!
-- 2
-- !!!!!!!!!!!!!!!!!!!!!!!

with tmp as (            SELECT max (MovementItem.Id) AS MovementItemId
                              , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
--                              , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
  --                            , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                         FROM Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.Amount <> 0
                               INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                            AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                            AND MovementLinkObject_PersonalServiceList.ObjectId not IN (293716 -- Ведомость карточки БН Фидо
                                                                                                                      , 413454 -- Ведомость карточки БН Пиреус
                                                                                                                       )
                               INNER JOIN Object on Object.Id = MovementLinkObject_PersonalServiceList.ObjectId
                                          and Object.ObjectCode not in (105
                                                                        , 135
                                                                        , 136
                                                                        , 138
                                                                        , 156
                                                                        , 162
                                                                        , 164
                                                                        , 165
                                                                        , 166
                                                                        , 167
                                                                        , 168
                                                                         )

where Movement.DescId = zc_Movement_PersonalService()
 AND Movement.StatusId = zc_Enum_Status_Complete()
group by COALESCE (MovementItem.ObjectId, 0)

--       , COALESCE (MILinkObject_Unit.ObjectId, 0)
  --    , COALESCE (MILinkObject_Position.ObjectId, 0)
)

select    -- lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceList(), tmp.ObjectId, MovementLinkObject_PersonalServiceList.ObjectId)
-- *
  zc_ObjectLink_Personal_PersonalServiceList(), tmp.ObjectId, MovementLinkObject_PersonalServiceList.ObjectId
, Object.*, Object_p.*, Object_pp.*
from tmp
     INNER JOIN MovementItem ON MovementItem.Id = tmp.MovementItemId
                               INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = MovementItem.MovementId
                                                            AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()

                               left JOIN MovementItemLinkObject
                                                             ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                            AND MovementItemLinkObject.DescId = zc_MILinkObject_Position()

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem .ObjectId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()

left JOIN Object on Object.Id = MovementLinkObject_PersonalServiceList.ObjectId
left JOIN Object as Object_p on Object_p .Id = tmp.ObjectId
left JOIN Object as Object_pp on Object_pp.Id = MovementItemLinkObject.ObjectId

 where ObjectLink_Personal_PersonalServiceList.ChildObjectId is null
order by Object_p.ValueData


*/
--SELECT DATE_PART('YEAR', AGE ('31.01.2019'::TDateTime+ interval '1 day' , '01.04.2018'::TDateTime))
-- тест
-- SELECT * FROM gpSelect_Object_Personal (inStartDate:= null, inEndDate:= null, inIsPeriod:= FALSE, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())

--SELECT zfCalc_MonthName (CURRENT_DATE)