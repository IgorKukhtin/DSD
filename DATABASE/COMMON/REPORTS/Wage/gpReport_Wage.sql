-- Function: gpSelect_Report_Wage ()

--DROP FUNCTION IF EXISTS gpSelect_Report_Wage (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Wage (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение
    IN inModelServiceId Integer,   --модель начисления
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inDetailDay      Boolean,   --детализировать по дням
    IN inDetailMonth    Boolean,   --детализировать по месяцам
    IN inDetailModelService Boolean,   --детализировать по моделям
    IN inDetailModelServiceItemMaster Boolean,   --детализировать по типам документов в модели
    IN inDetailModelServiceItemChild  Boolean,   --детализировать по товарам в типах документов
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffListId                    Integer
    ,StaffListCode                  Integer
    ,StaffListName                  TVarChar
    ,DocumentKindId                 Integer
    ,DocumentKindName               TVarChar
    ,PriceName                      TVarChar
    ,HoursPlan_StaffList            TFloat
    ,HoursDay_StaffList             TFloat
    ,Count_Member_StaffList         Integer    -- Кол-во человек (все - Штатное расписание)
    ,Count_Member                   Integer    -- Кол-во человек (все)
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SUM_MemberHours                TFloat  -- итого часов всех сотрудников (с этой должностью+...)
    ,SheetWorkTime_Amount           TFloat  -- итого часов сотрудника
    ,ServiceModelCode               Integer
    ,ServiceModelName               TVarChar
    ,Price                          TFloat
    ,FromName                       TVarChar
    ,ToName                         TVarChar
    ,MovementDescName               TVarChar
    ,ModelServiceItemChild_FromCode Integer
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToCode   Integer
    ,ModelServiceItemChild_ToName   TVarChar
    ,StorageLineName_From           TVarChar
    ,StorageLineName_To             TVarChar
    ,GoodsKind_FromName             TVarChar
    ,GoodsKindComplete_FromName     TVarChar
    ,GoodsKind_ToName               TVarChar
    ,GoodsKindComplete_ToName       TVarChar
    ,OperDate                       TVarChar -- TVarChar -- TDateTime
    ,Count_Day                      Integer   -- Отраб. дн. 1 чел (инф.)
    ,Count_MemberInDay              Integer   -- Кол-во человек (за 1 д.)
    ,Gross                          TFloat
    ,GrossOnOneMember               TFloat
    ,Amount                         TFloat
    ,AmountOnOneMember              TFloat
    ,PersonalServiceListId          Integer
    ,PersonalServiceListName        TVarChar
    ,Ord                            Integer
    ,ServiceModelName_1             TVarChar
    ,ServiceModelName_2             TVarChar
    ,ServiceModelName_3             TVarChar
    ,ServiceModelName_4             TVarChar

    ,ModelServiceId                 Integer
    ,StaffListSummKindId            Integer

    ,KoeffHoursWork_car             TFloat
    ,Ord_SheetWorkTime              Integer
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId_Constraint_Branch Integer;
    DECLARE vbOperDate_Begin1 TDateTime;
    DECLARE vbScript   TEXT;
    DECLARE vb1        TEXT;
    DECLARE vbValue1   Integer;
    DECLARE vbTime1    INTERVAL;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
    PERFORM lpCheck_UserRole_8813637 (vbUserId);


    -- определяется уровень доступа
    vbObjectId_Constraint_Branch:= COALESCE ((SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0), 0);
    -- определяется уровень доступа
    IF vbObjectId_Constraint_Branch = 0 AND EXISTS (SELECT 1 FROM Object_RoleAccessKey_View AS Object_View WHERE Object_View.UserId = vbUserId AND Object_View.AccessKeyId = zc_Enum_Process_AccessKey_UserBranch())
    THEN vbObjectId_Constraint_Branch:= -1;
    END IF;


    -- Таблица - Данные результат
    /*CREATE TEMP TABLE Res(
          StaffListId                    Integer
        , DocumentKindId                 Integer
        , UnitId                         Integer
        , UnitName                       TVarChar
        , PositionId                     Integer
        , PositionName                   TVarChar
        , PositionLevelId                Integer
        , PositionLevelName              TVarChar
        , Count_Member                  Integer
        , HoursPlan                      TFloat
        , HoursDay                       TFloat
        , PersonalGroupId                Integer
        , PersonalGroupName              TVarChar
        , MemberId                       Integer
        , MemberName                     TVarChar
        , SheetWorkTime_Date             TDateTime
        , SUM_MemberHours                TFloat
        , SheetWorkTime_Amount           TFloat
        , ServiceModelCode               Integer
        , ServiceModelName               TVarChar
        , Price                          TFloat
        , FromId                         Integer
        , FromName                       TVarChar
        , ToId                           Integer
        , ToName                         TVarChar
        , MovementDescId                 Integer
        , MovementDescName               TVarChar
        , SelectKindId                   Integer
        , SelectKindName                 TVarChar
        , Ratio                          TFloat
        , ModelServiceItemChild_FromId       Integer
        , ModelServiceItemChild_FromCode     Integer
        , ModelServiceItemChild_FromDescId   Integer
        , ModelServiceItemChild_FromName     TVarChar
        , ModelServiceItemChild_ToId         Integer
        , ModelServiceItemChild_ToCode       Integer
        , ModelServiceItemChild_ToDescId     Integer
        , ModelServiceItemChild_ToName       TVarChar
        , StorageLineId_From                 Integer
        , StorageLineName_From               TVarChar
        , StorageLineId_To                   Integer
        , StorageLineName_To                 TVarChar
        , GoodsKind_FromId                   Integer
        , GoodsKind_FromName                 TVarChar
        , GoodsKindComplete_FromId           Integer
        , GoodsKindComplete_FromName         TVarChar
        , GoodsKind_ToId                     Integer
        , GoodsKind_ToName                   TVarChar
        , GoodsKindComplete_ToId             Integer
        , GoodsKindComplete_ToName           TVarChar
        , OperDate                       TDateTime
        , Count_Day                      Integer
        , Count_MemberInDay              Integer
        , Gross                          TFloat
        , GrossOnOneMember               TFloat
        , Amount                         TFloat
        , AmountOnOneMember              TFloat
        , PersonalServiceListId          Integer
        , PersonalServiceListName        TVarChar

        , ModelServiceId                 Integer
        , StaffListSummKindId            Integer

         ) ON COMMIT DROP;

    -- Таблица - Список Моделей
    CREATE TEMP TABLE tmpListServiceModel (
          ServiceModelCode Integer
        , ServiceModelName  TVarChar
        , Ord Integer
         ) ON COMMIT DROP;*/


-- Голота К.О.
IF vbUserId = 6604558
   AND inStartDate BETWEEN '01.09.2024' AND '30.09.2024'
   AND inEndDate   BETWEEN '01.09.2024' AND '30.09.2024'
   AND inDetailDay = TRUE
   AND inDetailModelServiceItemChild = TRUE
   AND inUnitId    = 8451
   AND 1=1
THEN
    RETURN QUERY
      SELECT * FROM _gpReport_Wage_golota WHERE _gpReport_Wage_golota.OperDate BETWEEN inStartDate AND inEndDate
     ;

ELSE

    -- Результат
    RETURN QUERY

    -- Report_1 - По штатному расписанию - из Модели + из Табеля - По проводкам кол-во
    WITH Res_1 AS /* (StaffListId, DocumentKindId, UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,Count_Member,HoursPlan,HoursDay, PersonalGroupId, PersonalGroupName, MemberId, MemberName, SheetWorkTime_Date, SUM_MemberHours, SheetWorkTime_Amount
                   , ServiceModelCode,ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName,SelectKindId,SelectKindName,Ratio
                   , ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName
                   , StorageLineId_From, StorageLineName_From, StorageLineId_To, StorageLineName_To
                   , GoodsKind_FromId, GoodsKind_FromName, GoodsKindComplete_FromId, GoodsKindComplete_FromName, GoodsKind_ToId, GoodsKind_ToName, GoodsKindComplete_ToId, GoodsKindComplete_ToName
                   , OperDate, Count_Day, Count_MemberInDay,Gross,GrossOnOneMember,Amount,AmountOnOneMember
                   , ModelServiceId, StaffListSummKindId
                    )*/
   (SELECT Report_1.StaffListId, Report_1.DocumentKindId, Report_1.UnitId, Report_1.UnitName,Report_1.PositionId,Report_1.PositionName,Report_1.PositionLevelId,Report_1.PositionLevelName,Report_1.Count_Member,Report_1.HoursPlan,Report_1.HoursDay
         , Report_1.PersonalGroupId, Report_1.PersonalGroupName, Report_1.MemberId,Report_1.MemberName,Report_1.SheetWorkTime_Date
           -- итого часов всех сотрудников (с этой должностью+...)
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.SUM_MemberHours      ELSE 0 END :: TFloat AS SUM_MemberHours
           -- итого часов сотрудника
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.SheetWorkTime_Amount ELSE 0 END :: TFloat AS SheetWorkTime_Amount
           --
         , Report_1.ServiceModelCode, Report_1.ServiceModelName, Report_1.Price
         , Report_1.FromId,Report_1.FromName,Report_1.ToId,Report_1.ToName,Report_1.MovementDescId,Report_1.MovementDescName,Report_1.SelectKindId,Report_1.SelectKindName,Report_1.Ratio
         , Report_1.ModelServiceItemChild_FromId, Report_1.ModelServiceItemChild_FromCode,Report_1.ModelServiceItemChild_FromDescId,Report_1.ModelServiceItemChild_FromName
         , Report_1.ModelServiceItemChild_ToId,Report_1.ModelServiceItemChild_ToCode, Report_1.ModelServiceItemChild_ToDescId,Report_1.ModelServiceItemChild_ToName
         , Report_1.StorageLineId_From, Report_1.StorageLineName_From, Report_1.StorageLineId_To, Report_1.StorageLineName_To
         , Report_1.GoodsKind_FromId, Report_1.GoodsKind_FromName, Report_1.GoodsKindComplete_FromId, Report_1.GoodsKindComplete_FromName
         , Report_1.GoodsKind_ToId, Report_1.GoodsKind_ToName, Report_1.GoodsKindComplete_ToId, Report_1.GoodsKindComplete_ToName
         , Report_1.OperDate
           -- Отраб. дн. 1 чел (инф.)
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.Count_Day         ELSE 0 END :: Integer AS Count_Day
           -- Кол-во человек (за 1 д.)
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.Count_MemberInDay ELSE 0 END :: Integer AS Count_MemberInDay
           --
         , Report_1.Gross,Report_1.GrossOnOneMember
         , Report_1.Amount,Report_1.AmountOnOneMember
         , Report_1.ServiceModelId AS ModelServiceId
         , 0 AS StaffListSummKindId
         , Report_1.KoeffHoursWork_car
    FROM gpSelect_Report_Wage_Model (inStartDate      := inStartDate,
                                     inEndDate        := inEndDate, --дата окончания периода
                                     inUnitId         := inUnitId,   --подразделение
                                     inModelServiceId := inModelServiceId,   --модель начисления
                                     inMemberId       := inMemberId,   --сотрудник
                                     inPositionId     := inPositionId,   --должность
                                     inSession        := inSession
                                    ) AS Report_1
   )
 , tmpReport_1 AS (SELECT Res.MemberId, MAX (Res.SheetWorkTime_Amount) AS SheetWorkTime_Amount /*, Res.PersonalGroupId, Res.PositionId, Res.PositionLevelId*/
                   FROM Res_1 AS Res
                   WHERE Res.SheetWorkTime_Amount > 0
                   GROUP BY Res.MemberId
                  )
 , Res AS (
    SELECT
         Res_1.StaffListId
       , Res_1.DocumentKindId
       , Res_1.UnitId
       , Res_1.UnitName
       , Res_1.PositionId
       , Res_1.PositionName
       , Res_1.PositionLevelId
       , Res_1.PositionLevelName
       , Res_1.Count_Member
       , Res_1.HoursPlan
       , Res_1.HoursDay
       , Res_1.PersonalGroupId
       , Res_1.PersonalGroupName
       , Res_1.MemberId
       , Res_1.MemberName
       , Res_1.SheetWorkTime_Date
       , Res_1.SUM_MemberHours
       , Res_1.SheetWorkTime_Amount
       , Res_1.ServiceModelCode
       , Res_1.ServiceModelName
       , Res_1.Price

       , Res_1.FromId
       , Res_1.FromName
       , Res_1.ToId
       , Res_1.ToName
       , Res_1.MovementDescId
       , Res_1.MovementDescName
       , Res_1.SelectKindId
       , Res_1.SelectKindName
       , Res_1.Ratio

       , Res_1.ModelServiceItemChild_FromId
       , Res_1.ModelServiceItemChild_FromCode
       , Res_1.ModelServiceItemChild_FromDescId
       , Res_1.ModelServiceItemChild_FromName
       , Res_1.ModelServiceItemChild_ToId
       , Res_1.ModelServiceItemChild_ToCode
       , Res_1.ModelServiceItemChild_ToDescId
       , Res_1.ModelServiceItemChild_ToName

       , Res_1.StorageLineId_From
       , Res_1.StorageLineName_From
       , Res_1.StorageLineId_To
       , Res_1.StorageLineName_To

       , Res_1.GoodsKind_FromId
       , Res_1.GoodsKind_FromName
       , Res_1.GoodsKindComplete_FromId
       , Res_1.GoodsKindComplete_FromName
       , Res_1.GoodsKind_ToId
       , Res_1.GoodsKind_ToName
       , Res_1.GoodsKindComplete_ToId
       , Res_1.GoodsKindComplete_ToName

       , CASE WHEN inDetailDay = TRUE THEN Res_1.OperDate
              WHEN inDetailMonth = TRUE THEN DATE_TRUNC ('MONTH', Res_1.OperDate)
              ELSE DATE_TRUNC ('MONTH', Res_1.OperDate)
         END  ::TDateTime AS OperDate
       , Res_1.Count_Day
       , Res_1.Count_MemberInDay
       , Res_1.Gross
       , Res_1.GrossOnOneMember

       , Res_1.Amount
       , Res_1.AmountOnOneMember
       , Res_1.ModelServiceId
       , Res_1.StaffListSummKindId
       , Res_1.KoeffHoursWork_car

    FROM Res_1

   UNION ALL
    -- Report_2 - По штатному расписанию - Тип суммы ИЛИ по часам - из Табеля
    /*INSERT INTO Res (StaffListId, UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,Count_Member,HoursPlan,HoursDay, PersonalGroupId, PersonalGroupName, MemberId, MemberName
                   , SUM_MemberHours, SheetWorkTime_Amount, ServiceModelCode, ServiceModelName, Price, AmountOnOneMember
                   , Count_Day
                   , ModelServiceId, StaffListSummKindId
                    )*/
    SELECT
         Report_2.StaffListId
       , 0 :: Integer AS DocumentKindId
       , Report_2.UnitId
       , Report_2.UnitName
       , Report_2.PositionId
       , Report_2.PositionName
       , Report_2.PositionLevelId
       , Report_2.PositionLevelName
       , Report_2.Count_Member
       , Report_2.HoursPlan
       , Report_2.HoursDay
       , Report_2.PersonalGroupId
       , Report_2.PersonalGroupName
       , Report_2.MemberId
       , Report_2.MemberName
       , NULL :: TDateTime AS SheetWorkTime_Date
         -- итого часов всех сотрудников (с этой должностью+...)
       , Report_2.SUM_MemberHours
         -- итого часов сотрудника
         --, CASE WHEN tmpReport_1.MemberId > 0 AND Report_2.SheetWorkTime_Amount = tmpReport_1.SheetWorkTime_Amount THEN 0 ELSE Report_2.SheetWorkTime_Amount END AS SheetWorkTime_Amount
         --, CASE WHEN tmpReport_1.MemberId > 0 THEN 0 ELSE Report_2.SheetWorkTime_Amount END AS SheetWorkTime_Amount
       , Report_2.SheetWorkTime_Amount
         --
       , Report_2.StaffListSummKindId   AS ServiceModelCode
       , Report_2.StaffListSummKindName AS ServiceModelName
       , Report_2.StaffListSumm_Value   AS Price

       , 0  :: Integer  AS FromId
       , '' :: TVarChar AS FromName
       , 0  :: Integer  AS ToId
       , '' :: TVarChar AS ToName
       , 0  :: Integer  AS MovementDescId
       , '' :: TVarChar AS MovementDescName
       , 0  :: Integer  AS SelectKindId
       , '' :: TVarChar AS SelectKindName
       , 0  :: TFloat   AS Ratio

       , 0  :: Integer  AS ModelServiceItemChild_FromId
       , 0  :: Integer  AS ModelServiceItemChild_FromCode
       , 0  :: Integer  AS ModelServiceItemChild_FromDescId
       , '' :: TVarChar AS ModelServiceItemChild_FromName
       , 0  :: Integer  AS ModelServiceItemChild_ToId
       , 0  :: Integer  AS ModelServiceItemChild_ToCode
       , 0  :: Integer  AS ModelServiceItemChild_ToDescId
       , '' :: TVarChar AS ModelServiceItemChild_ToName

       , 0  :: Integer  AS StorageLineId_From
       , '' :: TVarChar AS StorageLineName_From
       , 0  :: Integer  AS StorageLineId_To
       , '' :: TVarChar AS StorageLineName_To

       , 0  :: Integer  AS GoodsKind_FromId
       , '' :: TVarChar AS GoodsKind_FromName
       , 0  :: Integer  AS GoodsKindComplete_FromId
       , '' :: TVarChar AS GoodsKindComplete_FromName
       , 0  :: Integer  AS GoodsKind_ToId
       , '' :: TVarChar AS GoodsKind_ToName
       , 0  :: Integer  AS GoodsKindComplete_ToId
       , '' :: TVarChar AS GoodsKindComplete_ToName

       , Report_2.OperDate :: TDateTime AS OperDate
       , Report_2.Count_Day
       , 0 :: Integer AS Count_MemberInDay
       , 0 :: TFloat AS Gross
       , 0 :: TFloat AS GrossOnOneMember

       , 0             AS Amount
       , Report_2.Summ AS AmountOnOneMember
       , 0             AS ModelServiceId
       , Report_2.StaffListSummKindId
       , Report_2.Tax_Trainee :: TFloat   AS KoeffHoursWork_car

    FROM gpSelect_Report_Wage_Sum (inStartDate      := CASE WHEN inModelServiceId > 0 THEN NULL ELSE inStartDate END
                                 , inEndDate        := CASE WHEN inModelServiceId > 0 THEN NULL ELSE inEndDate   END
                                 , inUnitId         := CASE WHEN inModelServiceId > 0 THEN NULL ELSE inUnitId    END
                                 , inMemberId       := inMemberId
                                 , inPositionId     := inPositionId
                                 , inSession        := inSession
                                  ) AS Report_2
         -- LEFT JOIN tmpReport_1 ON tmpReport_1.MemberId = Report_2.MemberId
    WHERE COALESCE (inModelServiceId, 0) = 0
   )

    --
    , tmpListServiceModel  AS  -- (ServiceModelCode, ServiceModelName, Ord)
   (SELECT tmp.ServiceModelCode
         , tmp.ServiceModelName
         , (ROW_NUMBER() OVER (ORDER BY tmp.ServiceModelCode)) :: Integer AS Ord
    FROM (SELECT DISTINCT
                 Res.ServiceModelCode
               , Res.ServiceModelName
          FROM Res
          WHERE Res.ServiceModelCode IS NOT NULL
         ) AS tmp
   )

        , tmpPersonal AS (SELECT *
                               , ROW_NUMBER(*) OVER (PARTITION BY Object_Personal.MemberId
                                                                , COALESCE (Object_Personal.PositionId, 0)
                                                                , COALESCE (Object_Personal.PositionLevelId, 0)
                                                                , COALESCE (Object_Personal.UnitId, 0)
                                                    ) AS Ord
                          FROM Object_Personal_View AS Object_Personal
                         )
          -- доступ филиалов только к этим ведомостям
        , tmpMemberPersonalServiceList
                     AS (SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM ObjectLink AS ObjectLink_User_Member
                              INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                                    ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                              INNER JOIN Object AS Object_MemberPersonalServiceList
                                                ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                                               AND Object_MemberPersonalServiceList.isErased = FALSE
                              LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                     AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
                              LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                                   ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                  AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                              LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                            AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                                              OR ObjectBoolean.ValueData          = TRUE)
                         WHERE ObjectLink_User_Member.ObjectId = vbUserId
                           AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                        UNION
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM ObjectLink AS ObjectLink_User_Member
                              INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                    ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                              LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                            AND Object_PersonalServiceList.Id     = ObjectLink_PersonalServiceList_Member.ObjectId
                         WHERE ObjectLink_User_Member.ObjectId = vbUserId
                           AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                        )
          -- находим ведомость для сотрудника
        , tmpPersonalServiceList AS (SELECT lfSelect.MemberId
                                          , lfSelect.PersonalId
                                          , lfSelect.UnitId
                                          , lfSelect.PositionId
                                          , lfSelect.BranchId
                                          , lfSelect.PersonalServiceListId
                                          , lfSelect.Ord
                                     FROM lfSelect_Object_Member_findPersonal(zfCalc_UserAdmin()) AS lfSelect
                                    )
               -- собраны данные из табеля
             , Movement_SheetWorkTime AS
                (SELECT
                       CASE WHEN inDetailDay = TRUE THEN Movement.OperDate
                            ELSE CASE WHEN inDetailMonth = TRUE THEN DATE_TRUNC ('MONTH', Movement.OperDate)
                                      ELSE NULL
                                 END
                       END :: TDateTime AS OperDate
                     , MI_SheetWorkTime.ObjectId                      AS MemberId
                     , MIObject_Position.ObjectId                     AS PositionId
                     , MIObject_PersonalGroup.ObjectId                AS PersonalGroupId
                   --, COALESCE (MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                       -- итого часов сотрудника
                   --, SUM (CASE WHEN Object_WorkTimeKind.Tax > 0 THEN Object_WorkTimeKind.Tax / 100 ELSE 1 END * MI_SheetWorkTime.Amount) :: TFloat AS SheetWorkTime_Amount
                     , SUM (MI_SheetWorkTime.Amount) :: TFloat AS SheetWorkTime_Amount
                 FROM Movement
                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                   AND MovementLinkObject_Unit.ObjectId = inUnitId
                      INNER JOIN MovementItem AS MI_SheetWorkTime
                                              ON MI_SheetWorkTime.MovementId = Movement.Id
                                             AND MI_SheetWorkTime.Amount > 0
                                             AND MI_SheetWorkTime.isErased = FALSE

                      INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                        ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                       AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                      INNER JOIN Object_WorkTimeKind_Wages_View AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MIObject_WorkTimeKind.ObjectId

                      LEFT JOIN ObjectFloat AS ObjectFloat_WorkTimeKind_Tax
                                            ON ObjectFloat_WorkTimeKind_Tax.ObjectId = MIObject_WorkTimeKind.ObjectId
                                           AND ObjectFloat_WorkTimeKind_Tax.DescId   = zc_ObjectFloat_WorkTimeKind_Tax()

                      LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                             ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                            AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                      LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                             ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                            AND MIObject_Position.DescId = zc_MILinkObject_Position()
                      LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                             ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                            AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                 WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                   AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                 GROUP BY CASE WHEN inDetailDay = TRUE THEN Movement.OperDate
                               ELSE CASE WHEN inDetailMonth = TRUE THEN DATE_TRUNC ('MONTH', Movement.OperDate)
                                         ELSE NULL
                                    END
                          END
                        , MI_SheetWorkTime.ObjectId
                        , MIObject_Position.ObjectId
                        , MIObject_PersonalGroup.ObjectId
                      --, COALESCE (MIObject_PositionLevel.ObjectId, 0)
                )

        -- Результат
      , tmpRes_all AS (
            SELECT
                Res.StaffListId

               ,CASE WHEN inDetailModelService = TRUE OR inDetailModelServiceItemMaster = TRUE
                          THEN Res.DocumentKindId
                     ELSE NULL
                END AS DocumentKindId

               ,Res.UnitId
               ,Res.UnitName
               ,Res.PositionId
               ,Res.PositionName
               ,Res.PositionLevelId
               ,Res.PositionLevelName
               ,Res.Count_Member             -- Кол-во человек (все)
               ,Res.HoursPlan
               ,Res.HoursDay
              , Res.PersonalGroupId
              , Res.PersonalGroupName
               ,Res.MemberId
               ,Res.MemberName
               ,Res.SUM_MemberHours                            AS SUM_MemberHours      -- итого часов всех сотрудников (с этой должностью+...)
              , SUM (Res.SheetWorkTime_Amount) :: TFloat       AS SheetWorkTime_Amount -- итого часов сотрудника
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelCode
                ELSE NULL::Integer END                         AS ServiceModelCode
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelName
                ELSE NULL::TVarChar END                        AS ServiceModelName
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.Price
                ELSE NULL::TFloat END                          AS Price
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.FromName
                ELSE NULL::TVarChar END                         AS FromName
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.ToName
                ELSE NULL::TVarChar END                         AS ToName
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.MovementDescName
                ELSE NULL::TVarChar END                         AS MovementDescName

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_from.ObjectCode, Res.ModelServiceItemChild_FromCode)
                ELSE NULL::Integer END                         AS ModelServiceItemChild_FromCode
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_from.ValueData, Res.ModelServiceItemChild_FromName)
                ELSE NULL::TVarChar END                         AS ModelServiceItemChild_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_to.ObjectCode, Res.ModelServiceItemChild_ToCode)
                ELSE NULL::Integer END                         AS ModelServiceItemChild_ToCode
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_to.ValueData, Res.ModelServiceItemChild_ToName)
                ELSE NULL::TVarChar END                         AS ModelServiceItemChild_ToName

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_From
                ELSE NULL::TVarChar END                         AS StorageLineName_From
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_To
                ELSE NULL::TVarChar END                         AS StorageLineName_To

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_FromName
                ELSE NULL::TVarChar END                         AS GoodsKind_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_FromName
                ELSE NULL::TVarChar END                         AS GoodsKindComplete_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_ToName
                ELSE NULL::TVarChar END                         AS GoodsKind_ToName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_ToName
                ELSE NULL::TVarChar END                         AS GoodsKindComplete_ToName

               ,CASE WHEN inDetailDay = TRUE THEN Res.OperDate
                     WHEN inDetailMonth = TRUE THEN DATE_TRUNC ('MONTH', Res.OperDate) 
                     ELSE Res.OperDate
                END AS OperDate

               , MAX (Res.Count_Day) :: Integer           AS Count_Day         -- Отраб. дн. 1 чел (инф.)

               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Count_MemberInDay
                ELSE NULL::Integer END                    AS Count_MemberInDay -- Кол-во человек (за 1 д.)
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Gross
                     WHEN vbUserId = 5
                     THEN Res.Gross
                ELSE NULL::TFloat END                     AS Gross
               ,SUM(Res.GrossOnOneMember)::TFloat         AS GrossOnOneMember
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Amount
                ELSE NULL::TFloat END                     AS Amount
               ,SUM(Res.AmountOnOneMember)::TFloat        AS AmountOnOneMember

               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ModelServiceId
                END AS ModelServiceId
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.StaffListSummKindId
                END AS StaffListSummKindId

               , Res.KoeffHoursWork_car

            FROM Res
                 LEFT JOIN Object AS Object_Goods_from ON Object_Goods_from.Id = Res.ModelServiceItemChild_FromId
                                                      AND inDetailModelServiceItemChild = TRUE
                 LEFT JOIN Object AS Object_Goods_to   ON Object_Goods_to.Id   = Res.ModelServiceItemChild_ToId
                                                      AND inDetailModelServiceItemChild = TRUE
            WHERE Res.MemberId > 0
            GROUP BY
                Res.StaffListId
               ,CASE WHEN inDetailModelService = TRUE OR inDetailModelServiceItemMaster = TRUE
                          THEN Res.DocumentKindId
                     ELSE NULL
                END
               ,Res.UnitId
               ,Res.UnitName
               ,Res.PositionId
               ,Res.PositionName
               ,Res.PositionLevelId
               ,Res.PositionLevelName
               ,Res.Count_Member
               ,Res.HoursPlan
               ,Res.HoursDay
               , Res.PersonalGroupId
               , Res.PersonalGroupName
               ,Res.MemberId
               ,Res.MemberName
               ,Res.SUM_MemberHours
               /*,CASE WHEN inDetailDay = TRUE
                     THEN Res.SheetWorkTime_Amount
                ELSE NULL::TFloat END*/
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelCode
                ELSE NULL::Integer END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.Price
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.ToName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.MovementDescName
                ELSE NULL::TVarChar END

                -- вот товар
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_from.ValueData, Res.ModelServiceItemChild_FromName)
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_from.ObjectCode, Res.ModelServiceItemChild_FromCode)
                ELSE NULL::Integer END
                -- вот товар
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_to.ValueData, Res.ModelServiceItemChild_ToName)
                ELSE NULL::TVarChar END
                ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN COALESCE (Object_Goods_to.ObjectCode, Res.ModelServiceItemChild_ToCode)
                ELSE NULL::Integer END

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_From
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_To
                ELSE NULL::TVarChar END

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_ToName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_ToName
                ELSE NULL::TVarChar END

               ,CASE WHEN inDetailDay = TRUE THEN Res.OperDate
                     WHEN inDetailMonth = TRUE THEN DATE_TRUNC ('MONTH', Res.OperDate) 
                     ELSE Res.OperDate
                END
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Count_MemberInDay
                ELSE NULL::Integer END
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Gross
                     WHEN vbUserId = 5
                     THEN Res.Gross
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Amount
                ELSE NULL::TFloat END

               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ModelServiceId
                END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.StaffListSummKindId
                END
               ,Res.KoeffHoursWork_car
        )

            -- Результат
          , tmpRes AS (SELECT tmpRes_all.*
                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectLink_Personal_Member_find.ChildObjectId, tmpRes_all.MemberId)
                                                            , tmpRes_all.PositionId
                                                          --, tmpRes_all.PositionLevelId
                                                            , tmpRes_all.PersonalGroupId
                                                            , COALESCE (tmpRes_all.OperDate, zc_DateStart())
                                                 ORDER BY tmpRes_all.AmountOnOneMember DESC, tmpRes_all.Amount DESC, tmpRes_all.Count_Day DESC
                                                ) AS Ord_SheetWorkTime
                            , COALESCE (ObjectLink_Personal_Member_find.ChildObjectId, tmpRes_all.MemberId) AS MemberId_find
                       FROM tmpRes_all
                            -- вдруг здесь PersonalId
                            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_find
                                                 ON ObjectLink_Personal_Member_find.ObjectId = tmpRes_all.MemberId
                                                AND ObjectLink_Personal_Member_find.DescId   = zc_ObjectLink_Personal_Member()
                      )

        -- Результат
        SELECT
            tmpRes.StaffListId
          , Object_StaffList.ObjectCode AS StaffListCode
          , ('(' || Object_StaffList.ObjectCode :: TVarChar || ')'
          ||' (' || COALESCE (Object_Unit_StaffList.ObjectCode, 0) :: TVarChar || ') ' || COALESCE (Object_Unit_StaffList.ValueData, '')
          || CASE WHEN Object_PositionLevel_StaffList.ValueData      <> '' THEN ' - ' || Object_PositionLevel_StaffList.ValueData ELSE '' END
          || CASE WHEN Object_Position_StaffList.ValueData           <> '' THEN ' - ' || Object_Position_StaffList.ValueData      ELSE '' END
          || CASE WHEN ObjectFloat_PersonalCount.ValueData           <> 0  THEN ' - ' || zfConvert_FloatToString (ObjectFloat_PersonalCount.ValueData) ELSE ' - ???' END ||  ' чел.'
            ) :: TVarChar AS StaffListName

          , Object_DocumentKind.Id        AS DocumentKindId
          , Object_DocumentKind.ValueData AS DocumentKindName

          , (CASE
                  WHEN inDetailModelService = FALSE            THEN ''
                  WHEN tmpRes.ModelServiceId <> 0 THEN '1 кг.'
                  WHEN tmpRes.HoursDay       <> 0 THEN zfConvert_FloatToString (tmpRes.HoursDay) || ' час.'
                  WHEN tmpRes.HoursPlan      <> 0 THEN zfConvert_FloatToString (tmpRes.HoursPlan) || ' час.'
                  WHEN ObjectFloat_PersonalCount.ValueData <> 0 THEN zfConvert_FloatToString (ObjectFloat_PersonalCount.ValueData) || ' чел.'
                  ELSE ''
             END) :: TVarChar AS PriceName

          , tmpRes.HoursPlan                AS HoursPlan_StaffList
          , tmpRes.HoursDay                 AS HoursDay_StaffList
          , ObjectFloat_PersonalCount.ValueData :: Integer AS Count_Member_StaffList

           ,tmpRes.Count_Member

           ,tmpRes.UnitId
           ,tmpRes.UnitName
           ,tmpRes.PositionId
           ,tmpRes.PositionName
           ,tmpRes.PositionLevelId
           ,tmpRes.PositionLevelName

          , tmpRes.PersonalGroupId
          , tmpRes.PersonalGroupName
           ,tmpRes.MemberId
           ,tmpRes.MemberName
            -- итого часов всех сотрудников (с этой должностью...)
           ,tmpRes.SUM_MemberHours
            -- итого часов сотрудника
            --,tmpRes.SheetWorkTime_Amount
           ,Movement_SheetWorkTime.SheetWorkTime_Amount
            --
           ,tmpRes.ServiceModelCode
           ,tmpRes.ServiceModelName
           ,tmpRes.Price
           ,tmpRes.FromName
           ,tmpRes.ToName
           ,tmpRes.MovementDescName
           ,tmpRes.ModelServiceItemChild_FromCode
           ,CASE WHEN vbUserId IN (-5) THEN '' ELSE tmpRes.ModelServiceItemChild_FromName END :: TVarChar AS ModelServiceItemChild_FromName
           ,tmpRes.ModelServiceItemChild_ToCode
           ,CASE WHEN vbUserId IN (-5) THEN '' ELSE tmpRes.ModelServiceItemChild_ToName END :: TVarChar AS ModelServiceItemChild_ToName

           ,tmpRes.StorageLineName_From
           ,tmpRes.StorageLineName_To

           ,tmpRes.GoodsKind_FromName
           ,tmpRes.GoodsKindComplete_FromName
           ,tmpRes.GoodsKind_ToName
           ,tmpRes.GoodsKindComplete_ToName

           ,CASE WHEN vbUserId in (/*5, 6561986*/ 0) THEN NULL :: TVarChar ELSE zfConvert_DateToString (tmpRes.OperDate) END  :: TVarChar AS OperDate
--           ,CASE WHEN vbUserId in (-6561986) THEN NULL :: TDateTime ELSE tmpRes.OperDate :: TDateTime END  :: TDateTime AS OperDate

            -- Отраб. дн. 1 чел (инф.)
           ,tmpRes.Count_Day
            --
           ,tmpRes.Count_MemberInDay
           ,tmpRes.Gross
           ,tmpRes.GrossOnOneMember
           ,ROUND (tmpRes.Amount, 2) :: TFloat            AS Amount
           ,ROUND (tmpRes.AmountOnOneMember, 2) :: TFloat AS AmountOnOneMember
           ,Object_PersonalServiceList.Id                 AS PersonalServiceListId
           ,Object_PersonalServiceList.ValueData          AS PersonalServiceListName
           ,tmpListServiceModel.Ord
           ,tmpListServiceModel_1.ServiceModelName as ServiceModelName_1
           ,tmpListServiceModel_2.ServiceModelName as ServiceModelName_2
           ,tmpListServiceModel_3.ServiceModelName as ServiceModelName_3
           ,tmpListServiceModel_4.ServiceModelName as ServiceModelName_4

           ,tmpRes.ModelServiceId      :: Integer AS ModelServiceId
           ,tmpRes.StaffListSummKindId :: Integer AS StaffListSummKindId

           ,tmpRes.KoeffHoursWork_car  :: TFloat  AS KoeffHoursWork_car
           ,tmpRes.Ord_SheetWorkTime   :: Integer AS Ord_SheetWorkTime

        FROM
            tmpRes
            LEFT JOIN Movement_SheetWorkTime ON Movement_SheetWorkTime.MemberId                      = tmpRes.MemberId_find
                                            AND COALESCE (Movement_SheetWorkTime.PositionId, 0)      = COALESCE (tmpRes.PositionId, 0)
                                            AND COALESCE (Movement_SheetWorkTime.PersonalGroupId, 0) = COALESCE (tmpRes.PersonalGroupId, 0)
                                          --AND COALESCE (Movement_SheetWorkTime.PositionLevelId, 0) = COALESCE (tmpRes.PositionLevelId, 0)
                                            AND (Movement_SheetWorkTime.OperDate                     = tmpRes.OperDate
                                              OR (inDetailDay = FALSE AND inDetailMonth = FALSE)
                                                )
                                            AND tmpRes.Ord_SheetWorkTime                             = 1
            LEFT JOIN tmpPersonal AS Object_Personal
                                  ON Object_Personal.MemberId                      = tmpRes.MemberId
                                 AND COALESCE (Object_Personal.PositionId, 0)      = COALESCE (tmpRes.PositionId, 0)
                                 AND COALESCE (Object_Personal.PositionLevelId, 0) = COALESCE (tmpRes.PositionLevelId, 0)
                                 AND COALESCE (Object_Personal.UnitId, 0)          = COALESCE (tmpRes.UnitId, 0)
                                 AND Object_Personal.ORD                           = 1
            /*LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList_two
                                 ON ObjectLink_Personal_PersonalServiceList_two.ObjectId = tmpRes.MemberId
                                AND ObjectLink_Personal_PersonalServiceList_two.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                       ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.PersonalId
                                      AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()*/

            -- вдруг здесь PersonalId
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_find
                                 ON ObjectLink_Personal_Member_find.ObjectId = tmpRes.MemberId
                                AND ObjectLink_Personal_Member_find.DescId   = zc_ObjectLink_Personal_Member()
            LEFT JOIN tmpPersonalServiceList AS tmpPersonalServiceList_find ON tmpPersonalServiceList_find.MemberId = ObjectLink_Personal_Member_find.ChildObjectId

            LEFT JOIN tmpPersonalServiceList ON tmpPersonalServiceList.MemberId = tmpRes.MemberId
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = COALESCE (tmpPersonalServiceList.PersonalServiceListId, tmpPersonalServiceList_find.PersonalServiceListId) -- COALESCE (ObjectLink_Personal_PersonalServiceList_two.ChildObjectId, COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, tmpPersonalServiceList.PersonalServiceListId))

            -- доступ филиалов только к этим ведомостям
            LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = Object_PersonalServiceList.Id
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = tmpRes.DocumentKindId

            LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = tmpRes.StaffListId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                 ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
            LEFT JOIN Object AS Object_Unit_StaffList ON Object_Unit_StaffList.Id = ObjectLink_StaffList_Unit.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                                 ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
            LEFT JOIN Object AS Object_Position_StaffList ON Object_Position_StaffList.Id = ObjectLink_StaffList_Position.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                 ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel_StaffList ON Object_PositionLevel_StaffList.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount
                                  ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id
                                 AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()

            LEFT JOIN tmpListServiceModel ON tmpListServiceModel.ServiceModelCode = tmpRes.ServiceModelCode
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_1 ON tmpListServiceModel_1.Ord = 1
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_2 ON tmpListServiceModel_2.Ord = 2
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_3 ON tmpListServiceModel_3.Ord = 3
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_4 ON tmpListServiceModel_4.Ord = 4

        -- доступ филиалов только к этим ведомостям
        WHERE (tmpMemberPersonalServiceList.PersonalServiceListId > 0 OR vbObjectId_Constraint_Branch = 0)
          AND (ObjectLink_Personal_Member_find.ChildObjectId = inMemberId OR COALESCE (inMemberId, 0) = 0)

       UNION ALL
        SELECT
            0  :: Integer  AS StaffListId
          , 0  :: Integer  AS StaffListCode
          , '' :: TVarChar AS StaffListName

          , 0  :: Integer  AS DocumentKindId
          , '' :: TVarChar AS DocumentKindName

          , '' :: TVarChar AS PriceName

          , 0  :: TFloat   AS HoursPlan_StaffList
          , 0  :: TFloat   AS HoursDay_StaffList
          , 0  :: Integer  AS Count_Member_StaffList

          , 0  :: Integer  AS Count_Member

          , Object_Unit.Id                  AS UnitId
          , Object_Unit.ValueData           AS UnitName
          , Object_Position.Id              AS PositionId
          , Object_Position.ValueData       AS PositionName
          , Object_PositionLevel.Id         AS PositionLevelId
          , Object_PositionLevel.ValueData  AS PositionLevelName

          , Object_PersonalGroup.Id         AS PersonalGroupId
          , Object_PersonalGroup.ValueData  AS PersonalGroupName
           ,Object_Member.Id                AS MemberId
           ,Object_Member.ValueData         AS MemberName
            -- итого часов всех сотрудников (с этой должностью+...)
           ,0 :: TFloat    AS SUM_MemberHours
            -- итого часов сотрудника
           ,Movement_SheetWorkTime.SheetWorkTime_Amount :: TFloat AS SheetWorkTime_Amount
            --
           ,0  :: Integer  AS ServiceModelCode
           ,'' :: TVarChar AS ServiceModelName
           ,0  :: TFloat   AS Price
           ,'' :: TVarChar AS FromName
           ,'' :: TVarChar AS ToName
           ,'' :: TVarChar AS MovementDescName
           , 0 :: Integer AS ModelServiceItemChild_FromCode
           ,'' :: TVarChar AS ModelServiceItemChild_FromName
           , 0 :: Integer AS ModelServiceItemChild_ToCode
           ,'' :: TVarChar AS ModelServiceItemChild_ToName

           ,'' :: TVarChar AS StorageLineName_From
           ,'' :: TVarChar AS StorageLineName_To

           ,'' :: TVarChar AS GoodsKind_FromName
           ,'' :: TVarChar AS GoodsKindComplete_FromName
           ,'' :: TVarChar AS GoodsKind_ToName
           ,'' :: TVarChar AS GoodsKindComplete_ToName

           ,NULL :: TVarChar AS OperDate
--           ,NULL :: TDateTime AS OperDate

            -- Отраб. дн. 1 чел (инф.)
           ,0  :: Integer  AS Count_Day
            --
           ,0  :: Integer  AS Count_MemberInDay
           ,0  :: TFloat   AS Gross
           ,0  :: TFloat   AS GrossOnOneMember
           ,0  :: TFloat   AS Amount
           ,0  :: TFloat   AS AmountOnOneMember
           ,Object_PersonalServiceList.Id                 AS PersonalServiceListId
           ,(Object_PersonalServiceList.ValueData/* || ' ' || COALESCE (Movement_SheetWorkTime.MemberId, 0) :: TVarChar*/) :: TVarChar AS PersonalServiceListName
           ,0  :: Integer  AS Ord
           ,'' :: TVarChar AS ServiceModelName_1
           ,'' :: TVarChar AS ServiceModelName_2
           ,'' :: TVarChar AS ServiceModelName_3
           ,'' :: TVarChar AS ServiceModelName_4

           ,0  :: Integer  AS ModelServiceId
           ,0  :: Integer  AS StaffListSummKindId

           ,0  :: TFloat   AS KoeffHoursWork_car
           ,0  :: Integer  AS Ord_SheetWorkTime

        FROM
            Movement_SheetWorkTime

            -- вдруг здесь PersonalId
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_find
                                 ON ObjectLink_Personal_Member_find.ObjectId = Movement_SheetWorkTime.MemberId
                                AND ObjectLink_Personal_Member_find.DescId   = zc_ObjectLink_Personal_Member()
            LEFT JOIN tmpPersonalServiceList AS tmpPersonalServiceList_find ON tmpPersonalServiceList_find.MemberId = ObjectLink_Personal_Member_find.ChildObjectId

            LEFT JOIN tmpPersonalServiceList ON tmpPersonalServiceList.MemberId = Movement_SheetWorkTime.MemberId
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = COALESCE (tmpPersonalServiceList.PersonalServiceListId, tmpPersonalServiceList_find.PersonalServiceListId) -- COALESCE (ObjectLink_Personal_PersonalServiceList_two.ChildObjectId, COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, tmpPersonalServiceList.PersonalServiceListId))

            LEFT JOIN tmpRes ON Movement_SheetWorkTime.MemberId                      = tmpRes.MemberId_find
                            AND COALESCE (Movement_SheetWorkTime.PositionId, 0)      = COALESCE (tmpRes.PositionId, 0)
                            AND COALESCE (Movement_SheetWorkTime.PersonalGroupId, 0) = COALESCE (tmpRes.PersonalGroupId, 0)
                          --AND COALESCE (Movement_SheetWorkTime.PositionLevelId, 0) = COALESCE (tmpRes.PositionLevelId, 0)
                            AND (Movement_SheetWorkTime.OperDate                     = tmpRes.OperDate
                              OR (inDetailDay = FALSE AND inDetailMonth = FALSE)
                                )
            LEFT JOIN Object AS Object_Member        ON Object_Member.Id        = Movement_SheetWorkTime.MemberId
            LEFT JOIN Object AS Object_Position      ON Object_Position.Id      = Movement_SheetWorkTime.PositionId
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = Movement_SheetWorkTime.PersonalGroupId
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = NULL -- Movement_SheetWorkTime.PositionLevelId
            LEFT JOIN Object AS Object_Unit          ON Object_Unit.Id          = inUnitId

        WHERE tmpRes.MemberId_find IS NULL AND 1=0
       ;



      vbValue1:= (SELECT COUNT (*) FROM pg_stat_activity WHERE state = 'active');
      -- сколько всего выполнялась проц;
      vbTime1:= CLOCK_TIMESTAMP() - vbOperDate_Begin1;



      vbScript:= 'INSERT INTO ResourseProtocol (UserId
                                                , OperDate
                                                , Value1
                                                , Time1
                                                , Time5
                                                , ProcName
                                                , ProtocolData
                                                 )

                       SELECT ' || vbUserId :: TVarChar ||'
                            , ' || CHR (39) || zfConvert_DateTimeToString (CURRENT_TIMESTAMP) || CHR (39) || ' AS OperDate'
                         ||', ' || vbValue1 :: TVarChar  || ' AS Value1'
                         ||', ' || CHR (39) || vbTime1 :: TvarChar || CHR (39) || ' :: INTERVAL AS Time1'
                         ||', ' || CHR (39) || zfConvert_DateTimeToString (CLOCK_TIMESTAMP()) || CHR (39) || ' AS Time5'
                         ||', ' || CHR (39) || 'gpSelect_Report_Wage (' || CASE WHEN inUnitId > 0 THEN lfGet_Object_ValueData_sh (inUnitId) ELSE 'inUnitId = 0' END  || ')'|| CHR (39)


                              -- ProtocolData
                         ||', ' || CHR (39)
                                || zfConvert_DateToString (inStartDate)
                         ||', ' || zfConvert_DateToString (inEndDate)
                         ||', ' || inUnitId              :: TVarChar
                         ||', ' || inModelServiceId      :: TVarChar
                         ||', ' || inMemberId            :: TVarChar
                         ||', ' || inPositionId          :: TVarChar

                         ||', ' || inDetailDay           :: TVarChar
                         ||', ' || inDetailMonth         :: TVarChar
                         ||', ' || inDetailModelService            :: TVarChar
                         ||', ' || inDetailModelServiceItemMaster  :: TVarChar
                         ||', ' || inDetailModelServiceItemChild   :: TVarChar
                         ||', ' || inSession
                         || CHR (39)
                           ;


         -- Результат
         vb1:= (SELECT *
                FROM dblink_exec ('host=192.168.0.219 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'
                                   -- Результат
                                , vbScript));

    -- информативно
    --RAISE INFO  '%',vbScript;

    --RAISE EXCEPTION 'ok = %', vb1;

    --RAISE EXCEPTION 'ok';


    END IF; -- else _gpReport_Wage_golota


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- тест
-- SELECT * FROM gpSelect_Report_Wage (inStartDate:= '03.11.2023', inEndDate:= '03.11.2023', inUnitId:= 8439, inModelServiceId:= 633116, inMemberId:= 0, inPositionId:= 0, inDetailDay:= TRUE, inDetailModelService:= TRUE, inDetailModelServiceItemMaster:= TRUE, inDetailModelServiceItemChild:= TRUE, inSession:= '5');
-- SELECT * FROM gpSelect_Report_Wage(inStartDate := ('01.01.2023')::TDateTime , inEndDate := ('31.01.2023')::TDateTime , inUnitId := 8395 , inModelServiceId := 0 , inMemberId := 0 , inPositionId := 0 , inDetailDay := 'False' , inDetailModelService := 'True' , inDetailModelServiceItemMaster := 'False' , inDetailModelServiceItemChild := 'False' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
-- SELECT * FROM gpSelect_Report_Wage(inStartDate := ('01.01.2023')::TDateTime , inEndDate := ('31.01.2023')::TDateTime , inUnitId := 8395 , inModelServiceId := 0 , inMemberId := 0 , inPositionId := 0 , inDetailDay := 'False' , inDetailMonth := False, inDetailModelService := 'True' , inDetailModelServiceItemMaster := 'False' , inDetailModelServiceItemChild := 'False' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
