-- Function: gpReport_HolidayPersonal ()

DROP FUNCTION IF EXISTS gpReport_HolidayPersonal (TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HolidayPersonal (TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HolidayPersonal (TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayPersonal(
    IN inStartDate                 TDateTime, -- дата !!!ОКОНЧАНИЯ!!! периода - последний день месяца
    IN inUnitId                    Integer,   -- подразделение
    IN inMemberId                  Integer,   -- сотрудник
    IN inPersonalServiceListId     Integer,   -- ведомость начисления(главная)
    IN inIsDetail                  Boolean,   -- детализировать по дням
    IN inSession                   TVarChar   -- сессия пользователя
)
RETURNS TABLE(MemberId Integer, PersonalId Integer
            , PersonalCode Integer, PersonalName TVarChar
            , PositionId Integer, PositionCode Integer, PositionName TVarChar
            , PositionLevelName TVarChar
            , UnitId Integer, UnitCode Integer, UnitName TVarChar
            , BranchName TVarChar
            , PersonalGroupName TVarChar
            , StorageLineName TVarChar
            , PersonalServiceListName TVarChar
            , DateIn TDateTime, DateOut TDateTime
            , isDateOut Boolean, isMain Boolean, isOfficial Boolean
            , isNotCompensation Boolean
           -- , Age_work      TVarChar
            , Month_work          TFloat
            , Day_calendar        TFloat    -- Рабоч. дней - ЗА ПЕРИОД
            , Day_calendar_year   TFloat    -- Рабоч. дней - ЗА ГОД
            , Day_real            TFloat    -- Календ. дней - ЗА ПЕРИОД
            , Day_real_year       TFloat    -- Календ. дней - ЗА ГОД
            , Day_Holiday_cl      TFloat    -- Holiday дней - ЗА ПЕРИОД
            , Day_Holiday_year_cl TFloat    -- Holiday дней - ЗА ГОД
            , Day_Hol             TFloat    -- Отпуск. дней по табелю - ЗА ПЕРИОД
            , Day_Hol_year        TFloat    -- Отпуск. дней по табелю - ЗА ГОД
            , Day_vacation        TFloat
            , Day_holiday         TFloat
            , Day_diff            TFloat
            , Day_hol_NoZp        TFloat    -- отпуск без сохр. по табелю
            , Day_holiday_NoZp    TFloat    -- отпуск без сохр. по док. отпуск
            , Day_vacation_NoZp   TFloat
            , Day_diff_NoZp       TFloat    --

            , InvNumber          TVarChar
            , OperDate           TDateTime
            , OperDateStart      TDateTime
            , OperDateEnd        TDateTime
            , BeginDateStart     TDateTime
            , BeginDateEnd       TDateTime
            , PositionName_old   TVarChar)
AS
$BODY$
    DECLARE vbUserId         Integer;
    DECLARE vbMonthHoliday   Integer;
    DECLARE vbMonthHoliday_6 Integer;
    DECLARE vbDayHoliday     Integer;
    DECLARE vbStartDate      TDateTime;
    DECLARE vbStartDate_year TDateTime;
    DECLARE vbEndDate        TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

    -- начальная дата - ровно год
    vbStartDate := DATE_TRUNC ('YEAR', inStartDate);
    -- начальная дата - ровно год
    vbStartDate_year := inStartDate - INTERVAL '1 YEAR' + INTERVAL '1 DAY';
    -- дата !!!ОКОНЧАНИЯ!!! периода - как правило последний день месяца
    vbEndDate   := inStartDate;

    -- кол-во месяцев после чего положен отпуск - 1 отпуск - от 1м. до 6м. непрерывного стажа - 1день за 1 месяц
    vbMonthHoliday := 1;
    -- кол-во месяцев после чего положен отпуск - 1 отпуск - после 6м. непрерывного стажа - пропорционально 14 дней за 12 месяцев
    vbMonthHoliday_6 := 6;
    -- кол-во положенных дней отпуска
    vbDayHoliday := 14;


    -- Результат
    RETURN QUERY

    WITH
    -- все сотрудники
    tmpMemberPersonal AS (SELECT ObjectLink_Personal_Member.ChildObjectId         AS MemberId
                               , ObjectLink_Personal_Member.ObjectId              AS PersonalId
                               , Object_Personal.ObjectCode                       AS PersonalCode
                               , Object_Personal.ValueData                        AS PersonalName
                               , ObjectLink_Personal_Position.ChildObjectId       AS PositionId
                               , Object_Position.ObjectCode                       AS PositionCode
                               , Object_Position.ValueData                        AS PositionName
                               , ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
                               , Object_Unit.ObjectCode                           AS UnitCode
                               , Object_Unit.ValueData                            AS UnitName
                               , ObjectLink_Unit_Branch.ChildObjectId             AS BranchId
                               , Object_Branch.ObjectCode                         AS BranchCode
                               , Object_Branch.ValueData                          AS BranchName
                               , ObjectLink_Personal_PersonalGroup.ChildObjectId  AS PersonalGroupId
                               , Object_PersonalGroup.ObjectCode                  AS PersonalGroupCode
                               , Object_PersonalGroup.ValueData                   AS PersonalGroupName
                               , Object_StorageLine.Id                            AS StorageLineId
                               , Object_StorageLine.ObjectCode                    AS StorageLineCode
                               , Object_StorageLine.ValueData                     AS StorageLineName
                               , COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId
                               , Object_PositionLevel.ObjectCode                 AS PositionLevelCode
                               , Object_PositionLevel.ValueData                  AS PositionLevelName
                               , Object_PersonalServiceList.ValueData            AS PersonalServiceListName


                                 -- дата принятия
                               , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd())  AS DateIn
                                 -- дата увольнения
                               , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) AS DateOut
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut_user
                                 -- уволен ли сотрудник
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut
                                 -- основное место работы
                               , COALESCE (ObjectBoolean_Main.ValueData, FALSE)     AS isMain
                               , COALESCE (ObjectBoolean_Official.ValueData, FALSE) AS isOfficial
                               , COALESCE (ObjectBoolean_NotCompensation.ValueData, FALSE) :: Boolean  AS isNotCompensation
                                 -- на всякий случай - если 2 раза осн. место работы, выбираем всегда ТОЛЬКО ОДНО
                               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                    -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                    ORDER BY -- если основное место работы
                                                             CASE WHEN COALESCE (ObjectBoolean_Main.ValueData, FALSE) = TRUE THEN 0 ELSE 1 END
                                                             -- если НЕ удален
                                                           , CASE WHEN Object_Personal.isErased = FALSE THEN 0 ELSE 1 END
                                                             -- если официальное место работы
                                                           , CASE WHEN COALESCE (ObjectBoolean_Official.ValueData, FALSE) = TRUE THEN 0 ELSE 1 END
                                                             -- с максимальной датой увольнения
                                                           , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) DESC
                                                             -- с ранней датой принятия
                                                           , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ASC
                                                           , ObjectLink_Personal_Member.ObjectId
                                                   ) AS Ord
                                 -- сортируем по Дате Увольнения - будем ловить непрерывный период
                               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                    -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                    ORDER BY -- !!!ТОЛЬКО если уволен!!!
                                                             CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) <= vbEndDate THEN 0 ELSE 1 END

                                                           -- если удален + НЕ УВОЛЕН, последним
                                                           -- , CASE WHEN Object_Personal.isErased = TRUE AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 1 ELSE 0 END

                                                             -- сначала если НЕ основное место работы
                                                           , CASE WHEN COALESCE (ObjectBoolean_Main.ValueData, FALSE) = FALSE THEN 0 ELSE 1 END
                                                             -- с максимальной датой увольнения
                                                           , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) DESC
                                                             -- с ранней датой принятия
                                                           , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ASC
                                                           , ObjectLink_Personal_Member.ObjectId
                                                   ) AS Ord_out
                          FROM ObjectLink AS ObjectLink_Personal_Member
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId

                               LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                                    ON ObjectDate_DateIn.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectDate_DateIn.DescId   = zc_ObjectDate_Personal_In()
                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                    ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                    ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                    ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                               LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                    ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                   AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                               LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

                               -- Для Сотрудника
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                               -- Для Физ Лица
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                    ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_PersonalGroup.DescId   = zc_ObjectLink_Personal_PersonalGroup()
                               LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_StorageLine
                                                    ON ObjectLink_Personal_StorageLine.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_StorageLine.DescId   = zc_ObjectLink_Personal_StorageLine()
                               LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = ObjectLink_Personal_StorageLine.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                    ON ObjectLink_Personal_PositionLevel.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_PositionLevel.DescId   = zc_ObjectLink_Personal_PositionLevel()
                               LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_Personal_PositionLevel.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCompensation
                                                       ON ObjectBoolean_NotCompensation.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                      AND ObjectBoolean_NotCompensation.DescId = zc_ObjectBoolean_Member_NotCompensation()

                          WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                            AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                            AND (ObjectLink_Personal_Member.ChildObjectId = inMemberId OR inMemberId = 0)
                            --AND (ObjectLink_Personal_Unit.ChildObjectId = inUnitId OR inUnitId = 0) --выбираем по всем подразделениям, чтоб можно было определить реальную дату приема на работу (вдруг были переводы по подразделениям)
                            AND (ObjectLink_Personal_PersonalServiceList.ChildObjectId = inPersonalServiceListId OR inPersonalServiceListId = 0)
                         )

    -- сотрудники - только основное место работы и только ОДИН
  , tmpList_one AS (SELECT tmpMemberPersonal.*
                    FROM tmpMemberPersonal
                    WHERE tmpMemberPersonal.isMain = TRUE
                      AND tmpMemberPersonal.Ord    = 1
                   )
    -- дата начала работы на предприятии
  , tmpStart AS (SELECT tmpList.MemberId
                      , COALESCE (tmpList5.DateIn, tmpList4.DateIn, tmpList3.DateIn, tmpList2.DateIn, tmpList1.DateIn, tmpList.DateIn) AS DateIn
                        -- прошлые должности (информативно)
                      ,  TRIM (CASE WHEN tmpList5.MemberId > 0
                                         THEN
                                      ' (' || zfConvert_DateToString (tmpList5.DateIn)
                                 ||  ' / ' || zfConvert_DateToString (tmpList5.DateOut)
                                 ||   ') ' || tmpList5.PositionName
                                 ||    ' ' || tmpList5.UnitName
                                         ELSE ''
                               END
                     || ' ' || CASE WHEN tmpList4.MemberId > 0
                                         THEN
                                      ' (' || zfConvert_DateToString (tmpList4.DateIn)
                                 ||  ' / ' || zfConvert_DateToString (tmpList4.DateOut)
                                 ||   ') ' || tmpList4.PositionName
                                 ||    ' ' || tmpList4.UnitName
                                         ELSE ''
                               END
                     || ' ' || CASE WHEN tmpList3.MemberId > 0
                                         THEN
                                      ' (' || zfConvert_DateToString (tmpList3.DateIn)
                                 ||  ' / ' || zfConvert_DateToString (tmpList3.DateOut)
                                 ||   ') ' || tmpList3.PositionName
                                 ||    ' ' || tmpList3.UnitName
                                         ELSE ''
                               END
                     || ' ' || CASE WHEN tmpList2.MemberId > 0
                                         THEN
                                      ' (' || zfConvert_DateToString (tmpList2.DateIn)
                                 ||  ' / ' || zfConvert_DateToString (tmpList2.DateOut)
                                 ||   ') ' || tmpList2.PositionName
                                 ||    ' ' || tmpList2.UnitName
                                         ELSE ''
                               END
                     || ' ' || CASE WHEN tmpList1.MemberId > 0
                                         THEN
                                      ' (' || zfConvert_DateToString (tmpList1.DateIn)
                                 ||  ' / ' || zfConvert_DateToString (tmpList1.DateOut)
                                 ||   ') ' || tmpList1.PositionName
                                 ||    ' ' || tmpList1.UnitName
                                         ELSE ''
                               END
                         ) AS InfoAll_old
                 FROM tmpList_one AS tmpList
                      -- первый уволенный
                      LEFT JOIN tmpMemberPersonal AS tmpList1
                                                  ON tmpList1.MemberId  = tmpList.MemberId
                                                 -- обязательно уволен и принят на работу на следующий день
                                                 AND tmpList1.DateOut   = tmpList.DateIn - '1 DAY' :: INTERVAL
                                                 -- обязательно уволен
                                                 AND tmpList1.isDateOut = TRUE
                                                 -- c максимальной датой увольнения + минимальной датой приема
                                                 AND tmpList1.Ord_Out   = 1
                      -- следующий
                      LEFT JOIN tmpMemberPersonal AS tmpList2
                                                  ON tmpList2.MemberId  = tmpList.MemberId
                                                 -- обязательно уволен и принят на работу на следующий день
                                                 AND tmpList2.DateOut   = tmpList1.DateIn - '1 DAY' :: INTERVAL
                                                 -- обязательно уволен
                                                 AND tmpList2.isDateOut = TRUE
                                                 -- c максимальной датой увольнения + минимальной датой приема
                                                 AND tmpList2.Ord_Out   = 2
                      -- следующий
                      LEFT JOIN tmpMemberPersonal AS tmpList3
                                                  ON tmpList3.MemberId  = tmpList.MemberId
                                                 -- обязательно уволен и принят на работу на следующий день
                                                 AND tmpList3.DateOut   = tmpList2.DateIn - '1 DAY' :: INTERVAL
                                                 -- обязательно уволен
                                                 AND tmpList3.isDateOut = TRUE
                                                 -- c максимальной датой увольнения + минимальной датой приема
                                                 AND tmpList3.Ord_Out   = 3
                      -- следующий
                      LEFT JOIN tmpMemberPersonal AS tmpList4
                                                  ON tmpList4.MemberId  = tmpList.MemberId
                                                 -- обязательно уволен и принят на работу на следующий день
                                                 AND tmpList4.DateOut   = tmpList3.DateIn - '1 DAY' :: INTERVAL
                                                 -- обязательно уволен
                                                 AND tmpList4.isDateOut = TRUE
                                                 -- c максимальной датой увольнения + минимальной датой приема
                                                 AND tmpList4.Ord_Out   = 4
                      -- следующий
                      LEFT JOIN tmpMemberPersonal AS tmpList5
                                                  ON tmpList5.MemberId  = tmpList.MemberId
                                                 -- обязательно уволен и принят на работу на следующий день
                                                 AND tmpList5.DateOut   = tmpList4.DateIn - '1 DAY' :: INTERVAL
                                                 -- обязательно уволен
                                                 AND tmpList5.isDateOut = TRUE
                                                 -- c максимальной датой увольнения + минимальной датой приема
                                                 AND tmpList5.Ord_Out   = 5
                 )
        -- сотрудники - главный список
      , tmpList AS (SELECT tmpList_one.*
                         , tmpStart.InfoAll_old
                         , tmpStart.DateIn AS DateIn_real
                           -- замена - или дата начала отчета - или дата принятия на работу - для расчета реально отработанных дней ТОЛЬКО за период
                         , CASE WHEN tmpStart.DateIn > vbStartDate THEN tmpStart.DateIn ELSE vbStartDate END AS DateIn_Calc
                           -- замена - или дата начала отчета - или дата принятия на работу - для расчета реально отработанных дней ЗА ГОД
                         , CASE WHEN tmpStart.DateIn > vbStartDate_year THEN tmpStart.DateIn ELSE vbStartDate_year END AS DateIn_Calc_year
                           -- замена - или дата окончания отчета - или дата увольнения - для расчета реально отработанных дней ТОЛЬКО за период
                         , CASE WHEN tmpList_one.DateOut < vbEndDate THEN tmpList_one.DateOut ELSE vbEndDate END AS DateOut_Calc
                    FROM tmpList_one
                         LEFT JOIN tmpStart ON tmpStart.MemberId = tmpList_one.MemberId
                   )
    -- табель - кто в какие дни брал отпуск
  , MI_SheetWorkTime AS (SELECT DISTINCT
                                Movement.OperDate
                              , MI_SheetWorkTime.ObjectId AS MemberId
                              --отделяем отпуск без сохранения ЗП
                              , CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_HolidayNoZp() THEN True ELSE False END AS isHolidayNoZp
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                              INNER JOIN MovementItem AS MI_SheetWorkTime
                                                      ON MI_SheetWorkTime.MovementId = Movement.Id
                                                     AND MI_SheetWorkTime.isErased = FALSE
                              INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                               AND MIObject_WorkTimeKind.DescId         = zc_MILinkObject_WorkTimeKind()
                                                               AND MIObject_WorkTimeKind.ObjectId       IN (zc_Enum_WorkTimeKind_Holiday()     -- Отпуск
                                                                                                          , zc_Enum_WorkTimeKind_HolidayNoZp() -- Отпуск без сохр.ЗП
                                                                                                           )
                         WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                           AND Movement.OperDate BETWEEN vbStartDate_year AND vbEndDate
                        )
    -- расчет отработанных месяцев и календарных дней
  , tmpWork AS (SELECT tmp.MemberId
                     , SUM (tmp.Month_work)    AS Month_work
                  -- , SUM (tmp.Day_calendar)  AS Day_calendar  -- Рабоч. дней
                     , SUM (tmp.Day_real)                       AS Day_real         -- Календ. дней - ЗА ПЕРИОД
                     , SUM (tmp.Day_real_year)                  AS Day_real_year    -- Календ. дней - ЗА ГОД
                     , SUM (COALESCE (tmp.Day_Holiday, 0))      AS Day_Holiday      -- Holiday дней - ЗА ПЕРИОД
                     , SUM (COALESCE (tmp.Day_Holiday_year, 0)) AS Day_Holiday_year -- Holiday дней - ЗА ГОД
                  -- , SUM (tmp.Day_Hol)       AS Day_Hol       -- Праздничные дни
                FROM (SELECT tmpList.MemberId
                             -- кол-во календарных дней без праздничных
                        -- , (SELECT COUNT (*) - SUM (CASE WHEN gpSelect.isHoliday = TRUE THEN 1 ELSE 0 END)
                        --    FROM gpSelect_Object_Calendar (inStartDate:= tmpList.DateIn_Calc, inEndDate:= tmpList.DateOut_Calc, inSession:= inSession) AS gpSelect
                        --   ) :: TFloat AS Day_calendar
                             -- кол-во календарных дней - ЗА ПЕРИОД
                           , (SELECT COUNT (*)
                              FROM gpSelect_Object_Calendar (inStartDate:= tmpList.DateIn_Calc, inEndDate:= tmpList.DateOut_Calc, inSession:= inSession) AS gpSelect
                             ) :: TFloat AS Day_real
                             -- кол-во календарных дней - ЗА ГОД
                           , (SELECT COUNT (*)
                              FROM gpSelect_Object_Calendar (inStartDate:= tmpList.DateIn_Calc_year, inEndDate:= tmpList.DateOut_Calc, inSession:= inSession) AS gpSelect
                             ) :: TFloat AS Day_real_year

                             -- кол-во Holiday дней - ЗА ПЕРИОД
                           , (SELECT COUNT (*)
                              FROM gpSelect_Object_Calendar (inStartDate:= tmpList.DateIn_Calc, inEndDate:= tmpList.DateOut_Calc, inSession:= inSession) AS gpSelect
                              WHERE gpSelect.isHoliday = TRUE
                             ) :: TFloat AS Day_Holiday
                             -- кол-во Holiday дней - ЗА ГОД
                           , (SELECT COUNT (*)
                              FROM gpSelect_Object_Calendar (inStartDate:= tmpList.DateIn_Calc_year, inEndDate:= tmpList.DateOut_Calc, inSession:= inSession) AS gpSelect
                              WHERE gpSelect.isHoliday = TRUE
                             ) :: TFloat AS Day_Holiday_year

                             -- кол-во Праздничных дней
                        -- , (SELECT SUM (CASE WHEN gpSelect.isHoliday = TRUE THEN 1 ELSE 0 END)
                        --    FROM gpSelect_Object_Calendar (inStartDate := tmp1.DateIn_Calc, inEndDate := tmp2.DateOut_Calc , inSession := inSession) AS gpSelect
                        --   ) :: TFloat AS Day_Hol

                             -- кол-во отработанных месяцев
                           , DATE_PART ('YEAR', AGE (tmpList.DateOut_Calc  + interval '1 day', tmpList.DateIn_Calc)) * 12
                           + DATE_PART ('MONTH', AGE (tmpList.DateOut_Calc + interval '1 day', tmpList.DateIn_Calc))  AS Month_work
                      FROM tmpList
                      WHERE DATE_PART ('YEAR', AGE (tmpList.DateOut_Calc + interval '1 day', tmpList.DateIn_Calc)) * 12
                          + DATE_PART ('MONTH', AGE (tmpList.DateOut_Calc + interval '1 day', tmpList.DateIn_Calc)) >= vbMonthHoliday
                      ) AS tmp
                GROUP BY tmp.MemberId
                )
   -- кол-во положенных дней отпуска
  , tmpVacation AS (SELECT tmpWork.*
                         , CASE -- кол-во месяцев после чего положен отпуск - 1 отпуск - после 6м. непрерывного стажа - пропорционально 14 дней за 12 месяцев
                                WHEN tmpWork.Month_work >= vbMonthHoliday_6
                                     THEN CAST (vbDayHoliday * tmpWork.Month_work / 12 AS NUMERIC (16,0))
                                -- кол-во месяцев после чего положен отпуск - 1 отпуск - от 1м. до 6м. непрерывного стажа - 1день за 1 месяц
                                WHEN tmpWork.Month_work >= vbMonthHoliday
                                     THEN CAST (tmpWork.Month_work AS NUMERIC (16,0))
                                ELSE 0
                           END  AS Day_vacation
                    FROM tmpWork

                   )

    -- выбираем документы отпусков
  , tmpMov_Holiday AS (SELECT Movement.Id
                            , Movement.InvNumber
                            , Movement.OperDate
                            , MovementLinkObject_Member.ObjectId    AS MemberId
                            , MovementDate_OperDateStart.ValueData  :: TIMESTAMP AS OperDateStart
                            , MovementDate_OperDateEnd.ValueData    :: TIMESTAMP AS OperDateEnd
                            , MovementDate_BeginDateStart.ValueData :: TIMESTAMP AS BeginDateStart
                            , MovementDate_BeginDateEnd.ValueData   :: TIMESTAMP AS BeginDateEnd
                            --отделяем отпуск без сохранения ЗП
                            , CASE WHEN MovementLinkObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_HolidayNoZp() THEN True ELSE False END AS isHolidayNoZp
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                            INNER JOIN (SELECT tmpList.MemberId FROM tmpList) AS tmp ON tmp.MemberId = MovementLinkObject_Member.ObjectId

                            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

                            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                            LEFT JOIN MovementDate AS MovementDate_BeginDateStart
                                                   ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                  AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()

                            LEFT JOIN MovementDate AS MovementDate_BeginDateEnd
                                                   ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                  AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                                         ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_WorkTimeKind.DescId = zc_MovementLinkObject_WorkTimeKind()

                       WHERE Movement.DescId = zc_Movement_MemberHoliday()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                      )

    -- считаем кол-во дней предоставленного отпуска, по документам отпусков
  , tmpHoliday AS (SELECT CASE WHEN inIsDetail = TRUE THEN tmpData.InvNumber      ELSE ''   END :: TVarChar  AS InvNumber
                        , CASE WHEN inIsDetail = TRUE THEN tmpData.OperDate       ELSE NULL END :: TDateTime AS OperDate
                        , CASE WHEN inIsDetail = TRUE THEN tmpData.OperDateStart  ELSE NULL END :: TDateTime AS OperDateStart
                        , CASE WHEN inIsDetail = TRUE THEN tmpData.OperDateEnd    ELSE NULL END :: TDateTime AS OperDateEnd
                        , CASE WHEN inIsDetail = TRUE THEN tmpData.BeginDateStart ELSE NULL END :: TDateTime AS BeginDateStart
                        , CASE WHEN inIsDetail = TRUE THEN tmpData.BeginDateEnd   ELSE NULL END :: TDateTime AS BeginDateEnd
                        , tmpData.MemberId
                        , tmpData.isHolidayNoZp  --отдельно отпуск без оплаты
                        , SUM (DATE_PART ('DAY', tmpData.BeginDateEnd - tmpData.BeginDateStart) +1)  :: TFloat AS Day_holiday
                        , ROW_NUMBER(*) OVER (PARTITION BY tmpData.MemberId ORDER BY tmpData.MemberId, tmpData.isHolidayNoZp) AS Ord
                        , SUM ( SUM(DATE_PART ('DAY', tmpData.BeginDateEnd - tmpData.BeginDateStart) +1 ) )  OVER (PARTITION BY tmpData.MemberId, tmpData.isHolidayNoZp ORDER BY tmpData.MemberId) AS Day_holiday_All
                   FROM tmpMov_Holiday AS tmpData
                   GROUP BY CASE WHEN inIsDetail = TRUE THEN tmpData.InvNumber     ELSE ''   END
                          , CASE WHEN inIsDetail = TRUE THEN tmpData.OperDate      ELSE NULL END
                          , CASE WHEN inIsDetail = TRUE THEN tmpData.OperDateStart ELSE NULL END
                          , CASE WHEN inIsDetail = TRUE THEN tmpData.OperDateEnd   ELSE NULL END
                          , CASE WHEN inIsDetail = TRUE THEN tmpData.BeginDateStart ELSE NULL END
                          , CASE WHEN inIsDetail = TRUE THEN tmpData.BeginDateEnd   ELSE NULL END
                          , tmpData.MemberId
                          , tmpData.isHolidayNoZp
                   HAVING SUM (DATE_PART ('DAY', tmpData.BeginDateEnd - tmpData.BeginDateStart) +1 ) <> 0
                   )

    -- связываем данные положенных(расчетных) дней отпуска и фактически полученные
    -- Результат

    SELECT tmpVacation.MemberId
         , tmpPersonal.PersonalId
         , tmpPersonal.PersonalCode
         , tmpPersonal.PersonalName
         , tmpPersonal.PositionId
         , tmpPersonal.PositionCode
         , tmpPersonal.PositionName
         , tmpPersonal.PositionLevelName
         , tmpPersonal.UnitId
         , tmpPersonal.UnitCode
         , tmpPersonal.UnitName
         , tmpPersonal.BranchName
         , tmpPersonal.PersonalGroupName
         , tmpPersonal.StorageLineName
         , tmpPersonal.PersonalServiceListName
         , tmpPersonal.DateIn_real  :: TDateTime AS DateIn
         , tmpPersonal.DateOut_user :: TDateTime AS DateOut
         , tmpPersonal.isDateOut
         , tmpPersonal.isMain
         , tmpPersonal.isOfficial
         , tmpPersonal.isNotCompensation
         --, tmpPersonal.Age_work      :: TVarChar
         , tmpVacation.Month_work        :: TFloat
           -- так считаются - Рабоч. дней
         , (tmpVacation.Day_real      - tmpVacation.Day_Holiday      /*- COALESCE (MI_SheetWorkTime.Day_Hol, 0)*/)      :: TFloat AS Day_calendar      -- ЗА ПЕРИОД
         , (tmpVacation.Day_real_year - tmpVacation.Day_Holiday_year /*- COALESCE (MI_SheetWorkTime_year.Day_Hol, 0)*/) :: TFloat AS Day_calendar_year -- ЗА ГОД
           -- Календ. дней
         , tmpVacation.Day_real                              :: TFloat AS Day_real      -- ЗА ПЕРИОД
         , tmpVacation.Day_real_year                         :: TFloat AS Day_real_year -- ЗА ГОД
           -- Holiday дней - Календарь
         , tmpVacation.Day_Holiday                           :: TFloat AS Day_Holiday_cl      -- ЗА ПЕРИОД
         , tmpVacation.Day_Holiday_year                      :: TFloat AS Day_Holiday_cl_year -- ЗА ГОД
           -- Дней отпуска
         , COALESCE (MI_SheetWorkTime.Day_Hol, 0)            :: TFloat AS Day_Hol      -- ЗА ПЕРИОД
         , COALESCE (MI_SheetWorkTime_year.Day_Hol, 0)       :: TFloat AS Day_Hol_year -- ЗА ГОД
           -- положено дней отпуска
         , CASE WHEN tmpHoliday.Ord = 1 OR tmpHoliday.Ord IS NULL THEN tmpVacation.Day_vacation ELSE 0 END :: TFloat AS Day_vacation
           -- использовано дней отпуска
         , tmpHoliday.Day_holiday        :: TFloat AS Day_holiday
           -- не использовано дней отпуска
         , CASE WHEN tmpHoliday.Ord = 1 OR tmpHoliday.Ord IS NULL THEN (COALESCE (tmpVacation.Day_vacation, 0) - COALESCE (tmpHoliday.Day_holiday_All, 0)) ELSE 0 END  :: TFloat AS Day_diff

         -- Дней отпуска без оплаты за период
         , COALESCE (MI_SheetWorkTime_NoZp.Day_Hol, 0)                     :: TFloat AS Day_Hol_NoZp     -- SheetWorkTime
         , COALESCE (tmpHoliday_NoZp.Day_holiday,0)                        :: TFloat AS Day_holiday_NoZp -- Holiday
         , CASE WHEN tmpHoliday.Ord = 1 OR tmpHoliday.Ord IS NULL THEN tmpVacation.Day_vacation ELSE 0 END :: TFloat AS Day_vacation_NoZp
           -- положено дней без сохр =  Положен отпуск, дней
         , CASE WHEN tmpHoliday.Ord = 1 OR tmpHoliday.Ord IS NULL THEN (COALESCE (tmpVacation.Day_vacation, 0) - COALESCE (tmpHoliday_NoZp.Day_holiday,0)) ELSE 0 END  :: TFloat AS Day_diff_NoZp

           --
         , tmpHoliday.InvNumber          :: TVarChar
         , tmpHoliday.OperDate           :: TDateTime
         , tmpHoliday.OperDateStart      :: TDateTime
         , tmpHoliday.OperDateEnd        :: TDateTime
         , tmpHoliday.BeginDateStart     :: TDateTime
         , tmpHoliday.BeginDateEnd       :: TDateTime
         , tmpPersonal.InfoAll_old       :: TVarChar AS PositionName_old
    FROM tmpVacation
         LEFT JOIN tmpHoliday ON tmpHoliday.MemberId = tmpVacation.MemberId AND tmpHoliday.isHolidayNoZp = False

         -- отпуск без сохр.ЗП
         LEFT JOIN tmpHoliday AS tmpHoliday_NoZp ON tmpHoliday_NoZp.MemberId = tmpVacation.MemberId AND tmpHoliday_NoZp.isHolidayNoZp = True

         LEFT JOIN tmpList AS tmpPersonal ON tmpPersonal.MemberId   = tmpVacation.MemberId
         -- Дни отпуска - ЗА ПЕРИОД
         LEFT JOIN (SELECT COUNT(*) AS Day_Hol, MI_SheetWorkTime.MemberId
                    FROM MI_SheetWorkTime
                    WHERE MI_SheetWorkTime.OperDate BETWEEN vbStartDate AND vbEndDate
                      AND MI_SheetWorkTime.isHolidayNoZp = False
                    GROUP BY MI_SheetWorkTime.MemberId
                   ) AS MI_SheetWorkTime ON MI_SheetWorkTime.MemberId = tmpVacation.MemberId
         -- Дни отпуска - ЗА ГОД
         LEFT JOIN (SELECT COUNT(*) AS Day_Hol, MI_SheetWorkTime.MemberId FROM MI_SheetWorkTime WHERE MI_SheetWorkTime.isHolidayNoZp = False GROUP BY MI_SheetWorkTime.MemberId
                   ) AS MI_SheetWorkTime_year ON MI_SheetWorkTime_year.MemberId = tmpVacation.MemberId

         -- Дни отпуска без сохр.ЗП- ЗА ПЕРИОД
         LEFT JOIN (SELECT COUNT(*) AS Day_Hol, MI_SheetWorkTime.MemberId
                    FROM MI_SheetWorkTime
                    WHERE MI_SheetWorkTime.OperDate BETWEEN vbStartDate AND vbEndDate
                      AND MI_SheetWorkTime.isHolidayNoZp = True
                    GROUP BY MI_SheetWorkTime.MemberId
                   ) AS MI_SheetWorkTime_NoZp ON MI_SheetWorkTime_NoZp.MemberId = tmpVacation.MemberId

    ORDER BY tmpPersonal.UnitName
           , tmpPersonal.PersonalName
           , tmpPersonal.PositionName
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.23         *
 21.01.20                                        *
 23.12.19         *
 24.12.18         *
*/
-- тест
-- SELECT * FROM gpReport_HolidayPersonal(inStartDate:= '24.12.2024', inUnitId:= 0, inMemberId:= 2671562, inPersonalServiceListId:= 0, inIsDetail:= FALSE, inSession:= '5');
