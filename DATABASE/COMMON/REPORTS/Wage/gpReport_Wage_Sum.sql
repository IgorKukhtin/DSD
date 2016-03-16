DROP FUNCTION IF EXISTS gpSelect_Report_Wage_2(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    Integer,   --сотрудник
    Integer,   --должность
    TVarChar   --сессия пользователя
);
DROP FUNCTION IF EXISTS gpSelect_Report_Wage_Sum(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    Integer,   --сотрудник
    Integer,   --должность
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage_Sum(
    IN inDateStart      TDateTime, --дата начала периода
    IN inDateFinal      TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение 
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffList                      Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,PersonalCount                  Integer
    ,HoursPlan                      TFloat
    ,HoursDay                       TFloat
    ,StaffListSummId                Integer
    ,StaffListSumm_Value            TFloat
    ,StaffListSummKindId            Integer
    ,StaffListSummKindName          TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SheetWorkTime_Amount           TFloat
    ,Count_Day                      Integer
    ,Count_MemberDay                Integer
    ,SUM_MemberHours                TFloat
    ,Summ                           TFloat
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;

    CREATE TEMP TABLE Setting_Wage_2(
        StaffList             Integer
       ,UnitId                Integer
       ,UnitName              TVarChar
       ,PositionId            Integer 
       ,PositionName          TVarChar
       ,PositionLevelId       Integer
       ,PositionLevelName     TVarChar
       ,PersonalCount         Integer
       ,HoursPlan             TFloat
       ,HoursDay              TFloat
       ,StaffListSummId       Integer
       ,StaffListSumm_Value   TFloat
       ,StaffListSummKindId   Integer
       ,StaffListSummKindName TVarChar) ON COMMIT DROP;

    INSERT INTO Setting_Wage_2(StaffList,UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName
       ,PersonalCount,HoursPlan,HoursDay,StaffListSummId,StaffListSumm_Value,StaffListSummKindId,StaffListSummKindName)
--Настройки
    SELECT
        Object_StaffList.Id                                      AS StaffList
       ,ObjectLink_StaffList_Unit.ChildObjectId                  AS UnitId
       ,Object_Unit.ValueData                                    AS UnitName
       ,ObjectLink_StaffList_Position.ChildObjectId              AS PositionId
       ,Object_Position.ValueData                                AS PositionName
       ,ObjectLink_StaffList_PositionLevel.ChildObjectId         AS PositionLevelId
       ,Object_PositionLevel.ValueData                           AS PositionLevelName
       ,ObjectFloat_PersonalCount.ValueData::Integer             AS PersonalCount
       ,ObjectFloat_HoursPlan.ValueData                          AS HoursPlan
       ,ObjectFloat_HoursDay.ValueData                           AS HoursDay
       ,ObjectLink_StaffListSumm_StaffList.ChildObjectId         AS StaffListSummId
       ,ObjectFloat_StaffListSumm_Value.ValueData                AS StaffListSumm_Value
       ,ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId AS StaffListSummKindId
       ,Object_StaffListSummKind.ValueData                       AS StaffListSummKindName
    FROM
        Object as Object_StaffList
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
                              AND Object_StaffListSummKind.isErased = FALSE
    WHERE
        Object_StaffList.DescId = zc_Object_StaffList()
        AND
        (
            ObjectLink_StaffList_Unit.ChildObjectId = inUnitId
            OR
            inUnitId = 0
        )
        AND
        (
            ObjectLink_StaffList_Position.ChildObjectId = inPositionId
            OR
            inPositionId = 0
        );
    
    RETURN QUERY
--табель
    WITH Movement_SheetWorkTime AS
    (
        SELECT
            SheetWorkTime.MemberId
           ,SheetWorkTime.MemberName
           ,SheetWorkTime.PositionId
           ,SheetWorkTime.PositionLevelId
           ,SUM(SheetWorkTime.SheetWorkTime_Amount) AS SheetWorkTime_Amount
           ,SUM(SheetWorkTime.Count_Day)            AS Count_Day
           ,SheetWorkTime.Count_MemberDay::Integer  AS Count_MemberDay
           ,SheetWorkTime.SUM_MemberHours::TFloat   AS SUM_MemberHours
           ,SUM(SummaAdd)::TFloat                   AS SummaADD
        FROM(
            SELECT
                MI_SheetWorkTime.ObjectId                      AS MemberId
               ,Object_Member.ValueData                        AS MemberName
               ,MIObject_Position.ObjectId                     AS PositionId
               ,MIObject_PositionLevel.ObjectId                AS PositionLevelId
               ,MI_SheetWorkTime.Amount                        AS SheetWorkTime_Amount
               ,1                                              as Count_Day
               ,COUNT(*) OVER(PARTITION BY MIObject_Position.ObjectId,MIObject_PositionLevel.ObjectId) as Count_MemberDay
               ,SUM(MI_SheetWorkTime.Amount) OVER(PARTITION BY MIObject_Position.ObjectId,MIObject_PositionLevel.ObjectId) AS SUM_MemberHours
               ,CASE 
                    WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Day()
                        THEN Setting.StaffListSumm_Value / (SUM(MI_SheetWorkTime.Amount) OVER(PARTITION BY Movement.OperDate,MIObject_Position.ObjectId,MIObject_PositionLevel.ObjectId))*MI_SheetWorkTime.Amount
                    WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Personal()
                        THEN Setting.StaffListSumm_Value
                END::TFloat AS SummaAdd
            FROM
                Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                INNER JOIN MovementItem AS MI_SheetWorkTime 
                                        ON MI_SheetWorkTime.MovementId = Movement.Id
                INNER JOIN Object AS Object_Member
                                  ON Object_Member.Id = MI_SheetWorkTime.ObjectId
                LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                       ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                       ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                  ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                 AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                INNER JOIN Object_WorkTimeKind_Wages_View AS Object_WorkTimeKind
                                                          ON Object_WorkTimeKind.Id = MIObject_WorkTimeKind.ObjectId
                LEFT OUTER JOIN Setting_Wage_2 AS Setting ON COALESCE(MIObject_Position.ObjectId,0) = COALESCE(Setting.PositionId,0)
                                                         AND COALESCE(MIObject_PositionLevel.ObjectId,0) = COALESCE(Setting.PositionLevelId,0)                                          
                
            WHERE 
                Movement.DescId = zc_Movement_SheetWorkTime()
                AND
                Movement.OperDate between inDateStart AND inDateFinal
                AND
                (
                    MovementLinkObject_Unit.ObjectId = inUnitId
                    OR
                    inUnitId = 0
                )
                AND
                (
                    MIObject_Position.ObjectId = inPositionId
                    OR
                    inPositionId = 0
                )
                AND
                (
                    MI_SheetWorkTime.ObjectId = inMemberId
                    OR
                    inMemberId = 0
                )
                AND
                COALESCE(MI_SheetWorkTime.Amount,0)>0
            ) AS SheetWorkTime
        GROUP BY
            SheetWorkTime.MemberId
           ,SheetWorkTime.MemberName
           ,SheetWorkTime.PositionId
           ,SheetWorkTime.PositionLevelId
           ,SheetWorkTime.Count_MemberDay
           ,SheetWorkTime.SUM_MemberHours
    )
    SELECT 
        Setting.StaffList
       ,Setting.UnitId
       ,Setting.UnitName
       ,Setting.PositionId
       ,Setting.PositionName
       ,Setting.PositionLevelId
       ,Setting.PositionLevelName
       ,Setting.PersonalCount
       ,Setting.HoursPlan
       ,Setting.HoursDay
       ,Setting.StaffListSummId
       ,Setting.StaffListSumm_Value
       ,Setting.StaffListSummKindId
       ,Setting.StaffListSummKindName
       ,Movement_SheetWorkTime.MemberId
       ,Movement_SheetWorkTime.MemberName
       ,Movement_SheetWorkTime.SheetWorkTime_Amount::TFloat
       ,Movement_SheetWorkTime.Count_Day::Integer
       ,Movement_SheetWorkTime.Count_MemberDay::Integer
       ,Movement_SheetWorkTime.SUM_MemberHours::TFloat
       ,CASE 
            -- Фонд за месяц
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Month()
                THEN (Setting.StaffListSumm_Value / NULLIF(Movement_SheetWorkTime.Count_MemberDay,0) * Movement_SheetWorkTime.Count_Day)
            -- Доплата за 1 день на всех
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Day()
                THEN Movement_SheetWorkTime.SummaADD
            -- Доплата за 1 день на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_Personal()
                THEN Movement_SheetWorkTime.SummaADD
            -- Фонд за общий план часов (постоянный) в месяц на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_HoursPlan()
                THEN (Setting.StaffListSumm_Value / NULLIF(Setting.HoursPlan,0) * Movement_SheetWorkTime.SheetWorkTime_Amount)
            -- Фонд за план часов (расчетный) в месяц на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_HoursDay()
                THEN (Setting.StaffListSumm_Value / NULLIF(Setting.HoursDay,0) * Movement_SheetWorkTime.SheetWorkTime_Amount)
            -- Фонд постоянный для факт часов в месяц на человека
            WHEN Setting.StaffListSummKindId = zc_Enum_StaffListSummKind_HoursPlanConst()
                THEN (Setting.StaffListSumm_Value / NULLIF(Movement_SheetWorkTime.SUM_MemberHours,0) * Movement_SheetWorkTime.SheetWorkTime_Amount)
        END::TFloat AS Summ
    FROM Setting_Wage_2 AS Setting
        LEFT OUTER JOIN Movement_SheetWorkTime ON COALESCE(Movement_SheetWorkTime.PositionId,0) = COALESCE(Setting.PositionId,0)
                                              AND COALESCE(Movement_SheetWorkTime.PositionLevelId,0) = COALESCE(Setting.PositionLevelId,0)
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Wage_Sum (TDateTime,TDateTime,Integer,Integer,Integer,TVarChar) OWNER TO postgres;

/*
Select * from gpSelect_Report_Wage_Sum(
    inDateStart      := '20150701'::TDateTime, --дата начала периода
    inDateFinal      := '20150731'::TDateTime, --дата окончания периода
    inUnitId         := 8448::Integer,   --подразделение 
    inMemberId     := 0::Integer,   --сотрудник
    inPositionId     := 0::Integer,   --должность
    inSession        := '5');
*/    