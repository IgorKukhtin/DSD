-- По штатному расписанию - Тип суммы ИЛИ по часам - из Табеля
-- Function: gpSelect_Report_Wage_Sum_Server ()

DROP FUNCTION IF EXISTS gpSelect_Report_Wage_Sum_Server (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage_Sum_Server(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение 
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffListId                    Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,Count_Member                   Integer   -- Кол-во человек (все)
    ,HoursPlan                      TFloat
    ,HoursDay                       TFloat
    ,StaffListSummId                Integer
    ,StaffListSumm_Value            TFloat
    ,StaffListSummKindId            Integer
    ,StaffListSummKindName          TVarChar
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SUM_MemberHours                TFloat    -- итого часов всех сотрудников (с этой должностью+...)
    ,SheetWorkTime_Amount           TFloat    -- итого часов сотрудника
    ,Count_Day                      Integer   -- Отраб. дн. 1 чел (инф.)
    ,Summ                           TFloat
    ,Tax_Trainee                    TFloat
    ,OperDate                       TDateTime
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Таблица - Данные для расчета
    CREATE TEMP TABLE Setting_Wage_2(
        StaffListId             Integer
       ,UnitId                Integer
       ,UnitName              TVarChar
       ,PositionId            Integer 
       ,PositionName          TVarChar
       ,isPositionLevel_all   Boolean
       ,PositionLevelId       Integer
       ,PositionLevelName     TVarChar
       ,Count_Member         Integer
       ,HoursPlan             TFloat
       ,HoursDay              TFloat
       ,StaffListSummId       Integer
       ,StaffListSumm_Value   TFloat
       ,StaffListSummKindId   Integer
       ,StaffListSummKindName TVarChar
       ) ON COMMIT DROP;

    -- Настройки
    INSERT INTO Setting_Wage_2 (StaffListId, UnitId,UnitName,PositionId,PositionName, isPositionLevel_all, PositionLevelId, PositionLevelName
                              , Count_Member,HoursPlan,HoursDay,StaffListSummId,StaffListSumm_Value,StaffListSummKindId,StaffListSummKindName
                               )
    SELECT
        Object_StaffList.Id                                      AS StaffListId
       ,ObjectLink_StaffList_Unit.ChildObjectId                  AS UnitId
       ,Object_Unit.ValueData                                    AS UnitName
       ,ObjectLink_StaffList_Position.ChildObjectId              AS PositionId
       ,Object_Position.ValueData                                AS PositionName
       ,COALESCE (ObjectBoolean_PositionLevel.ValueData, FALSE)  AS isPositionLevel_all
       ,CASE WHEN ObjectBoolean_PositionLevel.ValueData = TRUE THEN 0 ELSE ObjectLink_StaffList_PositionLevel.ChildObjectId END AS PositionLevelId
       ,Object_PositionLevel.ValueData                           AS PositionLevelName
       ,ObjectFloat_PersonalCount.ValueData::Integer             AS Count_Member
       ,ObjectFloat_HoursPlan.ValueData                          AS HoursPlan
       ,ObjectFloat_HoursDay.ValueData                           AS HoursDay
       ,ObjectLink_StaffListSumm_StaffList.ChildObjectId         AS StaffListSummId
       ,ObjectFloat_StaffListSumm_Value.ValueData                AS StaffListSumm_Value
       ,ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId AS StaffListSummKindId
       ,Object_StaffListSummKind.ValueData                       AS StaffListSummKindName
    FROM Object as Object_StaffList
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionLevel
                                ON ObjectBoolean_PositionLevel.ObjectId = Object_StaffList.Id 
                               AND ObjectBoolean_PositionLevel.DescId = zc_ObjectBoolean_StaffList_PositionLevel()
        --Unit подразделение
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                   ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                  AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
        LEFT OUTER JOIN Object AS Object_Unit
                               ON Object_Unit.Id = ObjectLink_StaffList_Unit.ChildObjectId
        --Position  должность
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
        LEFT JOIN Object AS Object_Position 
                         ON Object_Position.Id = ObjectLink_StaffList_Position.ChildObjectId
        --PositionLevel разряд должности
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                             ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
        LEFT JOIN Object AS Object_PositionLevel 
                         ON Object_PositionLevel.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
        --PersonalCount  кол-во сотрудников в подразделении/должности/разряде
        LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount 
                              ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
        --HoursPlan  1.Общ.пл.ч.в мес. на человека
        LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                              ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
        --HoursDay  2.Дневной пл.ч. на человека
        LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay 
                              ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
        --StaffListCost
        INNER JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffList
                              ON ObjectLink_StaffListSumm_StaffList.ChildObjectId = Object_StaffList.ID
                             AND ObjectLink_StaffListSumm_StaffList.DescId = zc_ObjectLink_StaffListSumm_StaffList()
        INNER JOIN Object AS Object_StaffListSumm
                          ON Object_StaffListSumm.Id = ObjectLink_StaffListSumm_StaffList.ObjectId
                         AND Object_StaffListSumm.isErased = FALSE
        --Сумма
        LEFT JOIN ObjectFloat AS ObjectFloat_StaffListSumm_Value
                              ON ObjectFloat_StaffListSumm_Value.ObjectId = Object_StaffListSumm.Id 
                             AND ObjectFloat_StaffListSumm_Value.DescId = zc_ObjectFloat_StaffListSumm_Value()
        --Тип суммы
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffListSummKind
                                   ON ObjectLink_StaffListSumm_StaffListSummKind.ObjectId = Object_StaffListSumm.Id
                                  AND ObjectLink_StaffListSumm_StaffListSummKind.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind()
        LEFT OUTER JOIN Object AS Object_StaffListSummKind
                               ON Object_StaffListSummKind.Id = ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId
                              -- AND Object_StaffListSummKind.isErased = FALSE
    WHERE Object_StaffList.DescId = zc_Object_StaffList()
      AND Object_StaffList.isErased = FALSE
      AND (ObjectLink_StaffList_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
      AND (ObjectLink_StaffList_Position.ChildObjectId = inPositionId OR inPositionId = 0)
   ;
    
    -- результат
    RETURN QUERY
    WITH -- табель - кто в какие дни работал
         MI_SheetWorkTime AS
          (SELECT
                 MI_SheetWorkTime.ObjectId                      AS MemberId
               , Object_Member.ValueData                        AS MemberName
               , MIObject_PersonalGroup.ObjectId                AS PersonalGroupId
               , MIObject_Position.ObjectId                     AS PositionId
               , COALESCE (MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                 -- итого часов сотрудника !!!может измениться!!!
               , (CASE WHEN Object_WorkTimeKind.Tax > 0 THEN Object_WorkTimeKind.Tax / 100 ELSE 1 END * MI_SheetWorkTime.Amount) :: TFloat AS SheetWorkTime_Amount
                 -- Отраб. дн. 1 чел (инф.)
               , 1                                              AS Count_Day
               -- , COUNT(*) OVER (PARTITION BY MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS Count_Member
               -- , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS SUM_MemberHours
               , CASE WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Day() -- Доплата за 1 день на всех
                           THEN Setting.StaffListSumm_Value / NULLIF ((SUM (MI_SheetWorkTime.Amount * CASE WHEN Object_WorkTimeKind.Tax > 0 THEN Object_WorkTimeKind.Tax / 100 ELSE 1 END) OVER (PARTITION BY DATE_TRUNC ('MONTH', Movement.OperDate), MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId)), 0)
                              * MI_SheetWorkTime.Amount * CASE WHEN Object_WorkTimeKind.Tax > 0 THEN Object_WorkTimeKind.Tax / 100 ELSE 1 END
                      WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Personal() -- Доплата за 1 день на человека
                           THEN Setting.StaffListSumm_Value
                 END AS SummaAdd

                 -- !!!стажеры!!!
               , COALESCE (ObjectFloat_WorkTimeKind_Tax.ValueData, 0) AS Tax_Trainee
               
               , DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate

           FROM Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND (MovementLinkObject_Unit.ObjectId = inUnitId /*OR inUnitId = 0*/)
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

                LEFT JOIN Object AS Object_Member ON Object_Member.Id = MI_SheetWorkTime.ObjectId

                LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                       ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                       ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                       ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                LEFT OUTER JOIN Setting_Wage_2 AS Setting ON COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (Setting.PositionId, 0)
                                                         AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (Setting.PositionLevelId, 0)
           WHERE Movement.DescId = zc_Movement_SheetWorkTime()
             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
             AND Movement.StatusId <> zc_Enum_Status_Erased()
             /*AND (MIObject_Position.ObjectId       = inPositionId OR inPositionId = 0)
             AND (MI_SheetWorkTime.ObjectId        = inMemberId   OR inMemberId = 0)*/
          )
         -- собраны данные из табеля
       , Movement_SheetWorkTime AS
       (SELECT
             SheetWorkTime.MemberId
           , SheetWorkTime.MemberName
           , SheetWorkTime.PersonalGroupId
           , SheetWorkTime.PositionId
           , SheetWorkTime.PositionLevelId
             -- итого часов всех сотрудников (с этой должностью+...)
           , SheetWorkTime.SUM_MemberHours              AS SUM_MemberHours
             -- итого часов сотрудника
           , SUM (SheetWorkTime.SheetWorkTime_Amount)   AS SheetWorkTime_Amount
             -- Отраб. дн. 1 чел (инф.)
           , SUM (SheetWorkTime.Count_Day)              AS Count_Day
             --
           , SheetWorkTime.Count_MemberInDay            AS Count_MemberInDay
             --
           , COUNT (*) OVER (PARTITION BY SheetWorkTime.PositionId, SheetWorkTime.PositionLevelId) AS Count_Member
           , SUM (SummaAdd)                             AS SummaADD

           , SheetWorkTime.Tax_Trainee
           , SheetWorkTime.OperDate
        FROM (SELECT MI_SheetWorkTime.MemberId
                   , MI_SheetWorkTime.MemberName
                   , MI_SheetWorkTime.PersonalGroupId
                   , MI_SheetWorkTime.PositionId
                   , MI_SheetWorkTime.PositionLevelId
                   , MI_SheetWorkTime.SheetWorkTime_Amount
                   , MI_SheetWorkTime.Count_Day
                   , COUNT(*) OVER (PARTITION BY MI_SheetWorkTime.OperDate, MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId) AS Count_MemberInDay
                   , SUM (MI_SheetWorkTime.SheetWorkTime_Amount) OVER (PARTITION BY MI_SheetWorkTime.OperDate, MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId) AS SUM_MemberHours
                   , MI_SheetWorkTime.SummaAdd
                   , MI_SheetWorkTime.Tax_Trainee
                   , MI_SheetWorkTime.OperDate

              FROM
             (SELECT MI_SheetWorkTime.MemberId
                   , MI_SheetWorkTime.MemberName
                   , MI_SheetWorkTime.PersonalGroupId
                   , MI_SheetWorkTime.PositionId
                   , MI_SheetWorkTime.PositionLevelId
                   , MI_SheetWorkTime.SheetWorkTime_Amount
                   , MI_SheetWorkTime.Count_Day
                   , MI_SheetWorkTime.SummaAdd
                   , MI_SheetWorkTime.Tax_Trainee 
                   , MI_SheetWorkTime.OperDate
              FROM MI_SheetWorkTime
             UNION ALL
              SELECT MI_SheetWorkTime.MemberId
                   , MI_SheetWorkTime.MemberName
                   , MI_SheetWorkTime.PersonalGroupId
                   , MI_SheetWorkTime.PositionId
                   , 0 AS PositionLevelId
                   , MI_SheetWorkTime.SheetWorkTime_Amount
                   , MI_SheetWorkTime.Count_Day
                   , 0 AS SummaAdd
                   , MI_SheetWorkTime.Tax_Trainee
                   , MI_SheetWorkTime.OperDate
              FROM (SELECT DISTINCT Setting_Wage_2.PositionId FROM Setting_Wage_2 WHERE Setting_Wage_2.isPositionLevel_all = TRUE) AS Setting
                   INNER JOIN MI_SheetWorkTime ON MI_SheetWorkTime.PositionId = Setting.PositionId AND MI_SheetWorkTime.PositionLevelId <> 0
             )AS MI_SheetWorkTime
             )AS SheetWorkTime
        GROUP BY
             SheetWorkTime.MemberId
           , SheetWorkTime.MemberName
           , SheetWorkTime.PersonalGroupId
           , SheetWorkTime.PositionId
           , SheetWorkTime.PositionLevelId
           , SheetWorkTime.Count_MemberInDay
           , SheetWorkTime.SUM_MemberHours
           , SheetWorkTime.Tax_Trainee
           , SheetWorkTime.OperDate
       )

   -- Результат
   SELECT 
        Setting.StaffListId
       ,Setting.UnitId
       ,Setting.UnitName
       ,Setting.PositionId
       ,Setting.PositionName
       ,Setting.PositionLevelId
       ,Setting.PositionLevelName
       -- ,Setting.Count_Member
       ,Movement_SheetWorkTime.Count_Member :: Integer AS Count_Member
       ,Setting.HoursPlan
       ,Setting.HoursDay
       ,Setting.StaffListSummId
       ,Setting.StaffListSumm_Value
       ,Setting.StaffListSummKindId
       ,Setting.StaffListSummKindName
       , Object_PersonalGroup.Id        AS PersonalGroupId
       , Object_PersonalGroup.ValueData AS PersonalGroupName
       ,Movement_SheetWorkTime.MemberId
       ,Movement_SheetWorkTime.MemberName
       ,Movement_SheetWorkTime.SUM_MemberHours      :: TFloat AS SUM_MemberHours
       ,Movement_SheetWorkTime.SheetWorkTime_Amount :: TFloat AS SheetWorkTime_Amount
       ,Movement_SheetWorkTime.Count_Day::Integer
       ,CASE 
            -- Фонд за месяц
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Month()
                THEN (Setting.StaffListSumm_Value / NULLIF (Movement_SheetWorkTime.Count_Member, 0) * CASE WHEN Movement_SheetWorkTime.Tax_Trainee > 0 AND 1=1 THEN Movement_SheetWorkTime.Tax_Trainee / 100 ELSE 1 END)
            -- Фонд за месяц (по дням)
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_MonthDay()
                THEN (Setting.StaffListSumm_Value / NULLIF (Movement_SheetWorkTime.Count_MemberInDay,0) * Movement_SheetWorkTime.Count_Day * CASE WHEN Movement_SheetWorkTime.Tax_Trainee > 0 AND 1=1 THEN Movement_SheetWorkTime.Tax_Trainee / 100 ELSE 1 END)
            -- Доплата за 1 день на всех
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Day()
                THEN Movement_SheetWorkTime.SummaADD
            -- Доплата за 1 день на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Personal()
                THEN Movement_SheetWorkTime.SummaADD
            -- Фонд за общий план часов (постоянный) в месяц на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_HoursPlan()
                THEN (Setting.StaffListSumm_Value / NULLIF (Setting.HoursPlan,0) * Movement_SheetWorkTime.SheetWorkTime_Amount * CASE WHEN Movement_SheetWorkTime.Tax_Trainee > 0 AND 1=0 THEN Movement_SheetWorkTime.Tax_Trainee / 100 ELSE 1 END)
            -- Фонд за план часов (расчетный) в месяц на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_HoursDay()
                THEN (Setting.StaffListSumm_Value / NULLIF (Setting.HoursDay,0) * Movement_SheetWorkTime.SheetWorkTime_Amount * CASE WHEN Movement_SheetWorkTime.Tax_Trainee > 0 AND 1=0 THEN Movement_SheetWorkTime.Tax_Trainee / 100 ELSE 1 END)
            -- Фонд постоянный для факт часов в месяц на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_HoursPlanConst()
                THEN Setting.StaffListSumm_Value
                   / NULLIF (Setting.Count_Member, 0) * Movement_SheetWorkTime.Count_Member
                   / NULLIF (Movement_SheetWorkTime.SUM_MemberHours, 0) * Movement_SheetWorkTime.SheetWorkTime_Amount
                   * CASE WHEN Movement_SheetWorkTime.Tax_Trainee > 0 AND 1=0 THEN Movement_SheetWorkTime.Tax_Trainee / 100 ELSE 1 END
        END :: TFloat AS Summ

       ,(Movement_SheetWorkTime.Tax_Trainee / 100) :: TFloat AS Summ 

       , Movement_SheetWorkTime.OperDate ::TDateTime

    FROM Setting_Wage_2 AS Setting
        LEFT OUTER JOIN Movement_SheetWorkTime ON COALESCE (Movement_SheetWorkTime.PositionId, 0)      = COALESCE (Setting.PositionId, 0)
                                              AND COALESCE (Movement_SheetWorkTime.PositionLevelId, 0) = COALESCE (Setting.PositionLevelId, 0)
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = Movement_SheetWorkTime.PersonalGroupId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- тест
-- SELECT * FROM gpSelect_Report_Wage_Sum_Server (inStartDate:= '01.04.2023', inEndDate:= '01.04.2023', inUnitId:= 8439, inMemberId:= 0, inPositionId:= 0, inSession:= '5');
