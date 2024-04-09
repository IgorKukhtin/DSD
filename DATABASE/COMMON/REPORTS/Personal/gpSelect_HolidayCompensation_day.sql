-- Function: gpSelect_HolidayCompensation_day ()

DROP FUNCTION IF EXISTS gpSelect_HolidayCompensation_day (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_HolidayCompensation_day(
    IN inStartDate                 TDateTime, --дата начала периода
    IN inUnitId                    Integer,   --подразделение
    IN inMemberId                  Integer,   --сотрудник
    IN inPersonalServiceListId     Integer,   -- ведомость начисления(главная)
    IN inSession                   TVarChar   --сессия пользователя
)
RETURNS TABLE(OperDate_year TDateTime, OperDate TDateTime
            , YEAR Integer
            , IsWork      Boolean 
            , isHoliday   Boolean
            , isHoliday_year Boolean
            , isHoliday_NoZp Boolean
            , OperDate_year_amount TFloat 
            , OperDate_amount TFloat
            , Holiday TFloat
            , Holiday_year TFloat
            , Holiday_NoZp TFloat
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbStartDate    TDateTime;
    DECLARE vbStartDate_year TDateTime;
    DECLARE vbEndDate      TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

    -- начальная дата  год
    vbStartDate := DATE_TRUNC ('YEAR', inStartDate);
    -- начальная дата - ровно год
    vbStartDate_year := inStartDate - INTERVAL '1 YEAR' + INTERVAL '1 DAY';
    -- дата !!!ОКОНЧАНИЯ!!! периода - как правило последний день месяца
    vbEndDate   := inStartDate;


    RETURN QUERY
    --tmpListDate AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)

    WITH
    -- все сотрудники
    tmpMemberPersonal AS (SELECT ObjectLink_Personal_Member.ChildObjectId         AS MemberId
                                 -- дата принятия
                               , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd())  AS DateIn
                                 -- дата увольнения
                               , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) AS DateOut
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut_user
                                 -- уволен ли сотрудник
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut
                                 -- основное место работы
                               , COALESCE (ObjectBoolean_Main.ValueData, FALSE)     AS isMain
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
                                                             -- если НЕ основное место работы
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

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                                      
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                          WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                            AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                            AND (ObjectLink_Personal_Member.ChildObjectId = inMemberId )    --OR inMemberId = 0
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
                           AND MI_SheetWorkTime.ObjectId = inMemberId
                        )
   --все даті
   , tmpListDate AS (SELECT GENERATE_SERIES ((SELECT tmpList.DateIn_Calc_year FROM tmpList)
                                           , (SELECT tmpList.DateOut_Calc FROM tmpList), '1 DAY' :: INTERVAL) AS OperDate)

    -- Результат
    SELECT tmpListDate.OperDate::TDateTime AS OperDate_year
         
         , CASE WHEN tmpListDate.OperDate BETWEEN (SELECT tmpList.DateIn_Calc FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                 AND MI_SheetWorkTime.OperDate IS NULL THEN tmpListDate.OperDate
               ELSE NULL
           END ::TDateTime AS OperDate
          
         , DATE_PART ('YEAR', tmpListDate.OperDate) ::Integer AS YEAR
         , CASE WHEN tmpCalendar.Working = True THEN True
                ELSE FALSE
           END ::Boolean AS IsWork

        , CASE WHEN MI_SheetWorkTime.OperDate IS NULL THEN FALSE
                ELSE TRUE
           END ::Boolean AS isHoliday
        , CASE WHEN MI_SheetWorkTime_year.OperDate IS NULL THEN FALSE
                ELSE TRUE
           END ::Boolean AS isHoliday_year
        , CASE WHEN MI_SheetWorkTime_NoZp.OperDate IS NULL THEN FALSE
               ELSE TRUE
          END ::Boolean AS isHoliday_NoZp
          
          --для итогов 
        , CASE WHEN MI_SheetWorkTime.OperDate IS NULL THEN 1
               ELSE 0
           END ::TFloat AS OperDate_year_amount  --   рабочие дни все
           
        , CASE WHEN tmpListDate.OperDate BETWEEN (SELECT tmpList.DateIn_Calc FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                 AND MI_SheetWorkTime.OperDate IS NULL THEN 1
               ELSE 0
           END ::TFloat AS OperDate_amount          -- раб. днеи  за год

        , CASE WHEN MI_SheetWorkTime.OperDate IS NULL THEN 0
                ELSE 1
           END ::TFloat AS Holiday
        , CASE WHEN MI_SheetWorkTime_year.OperDate IS NULL THEN 0
                ELSE 1
           END ::TFloat AS Holiday_year
        , CASE WHEN MI_SheetWorkTime_NoZp.OperDate IS NULL THEN 0
               ELSE 1
          END ::TFloat AS Holiday_NoZp

    FROM tmpListDate

        -- Дни отпуска - ЗА ПЕРИОД   с начала года
         LEFT JOIN (SELECT MI_SheetWorkTime.OperDate, MI_SheetWorkTime.MemberId 
                    FROM MI_SheetWorkTime 
                    WHERE MI_SheetWorkTime.OperDate BETWEEN (SELECT tmpList.DateIn_Calc_year FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                      AND MI_SheetWorkTime.isHolidayNoZp = False
                    ) AS MI_SheetWorkTime ON MI_SheetWorkTime.OperDate = tmpListDate.OperDate
                                   --AND MI_SheetWorkTime.MemberId = tmpVacation.MemberId
         -- Дни отпуска - ЗА ГОД
         LEFT JOIN (SELECT MI_SheetWorkTime.OperDate, MI_SheetWorkTime.MemberId FROM MI_SheetWorkTime WHERE MI_SheetWorkTime.isHolidayNoZp = False 
                   ) AS MI_SheetWorkTime_year ON MI_SheetWorkTime_year.OperDate = tmpListDate.OperDate
                                   --AND MI_SheetWorkTime_year.MemberId = tmpVacation.MemberId

         -- Дни отпуска без сохр.ЗП- ЗА ПЕРИОД с начала года
         LEFT JOIN (SELECT MI_SheetWorkTime.OperDate, MI_SheetWorkTime.MemberId 
                    FROM MI_SheetWorkTime 
                    WHERE MI_SheetWorkTime.OperDate BETWEEN (SELECT tmpList.DateIn_Calc_year FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                      AND MI_SheetWorkTime.isHolidayNoZp = True
                   -- GROUP BY MI_SheetWorkTime.MemberId
                   ) AS MI_SheetWorkTime_NoZp ON MI_SheetWorkTime_NoZp.OperDate = tmpListDate.OperDate
                                   --AND MI_SheetWorkTime_NoZp.MemberId = tmpVacation.MemberId
         --календарные віходніе
         LEFT JOIN gpSelect_Object_Calendar (vbStartDate_year, vbEndDate, inSession) AS tmpCalendar ON tmpCalendar.Value = tmpListDate.OperDate
    WHERE inMemberId <> 0
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
*/
-- тест
--     SELECT * FROM gpSelect_HolidayCompensation_day(inStartDate := ('01.01.2023')::TDateTime , inUnitId := 8384 , inMemberId :=  8918847  , inPersonalServiceListId:=0,  inSession := '5');
