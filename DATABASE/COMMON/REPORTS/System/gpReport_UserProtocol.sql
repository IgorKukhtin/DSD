-- Function: gpReport_UserProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_UserProtocol (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_UserProtocol (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_UserProtocol (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_UserProtocol(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inBranchId    Integer , --
    IN inUnitId      Integer , --
    IN inUserId      Integer , -- 
    IN inPositionId  Integer , --
    IN inIsDay       Boolean , --
    IN inIsShowAll   Boolean , -- Показать все
    IN inDiff        TFloat  , -- на сколько минут отклонение
    IN inSession     TVarChar  -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar, UserStatus TVarChar, isErased Boolean
             , MemberName     TVarChar
             , PositionName   TVarChar
             , UnitId Integer, UnitName TVarChar
             , BranchId Integer, BranchName TVarChar
             , DayOfWeekName  TVarChar
             , OperDate       TDateTime
             , OperDate_Last   TDateTime
             , OperDate_Entry TDateTime
             , OperDate_Exit  TDateTime
             , OperDate_Start TDateTime
             , OperDate_End   TDateTime
             , Mov_Count    TFloat             
             , MI_Count     TFloat
             , Count        TFloat       
             , Count_Prog   Tfloat      
             , Count_Work   Tfloat
             , Count_status Tfloat

             , Time_Prog   TVarChar      
             , Time_Work   TVarChar

             , Color_Calc   Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY 
    WITH 
    tmpPersonal AS (SELECT View_Personal.MemberId
                          , MAX (View_Personal.PersonalId) AS PersonalId
                          , MAX (View_Personal.UnitId)     AS UnitId
                          , MAX (View_Personal.PositionId) AS PositionId
                    FROM Object_Personal_View AS View_Personal
                    -- WHERE View_Personal.isErased = FALSE
                    GROUP BY View_Personal.MemberId
                    )

  , tmpUser AS (SELECT Object_User.Id AS UserId
                     , Object_User.ObjectCode AS UserCode
                     , Object_User.ValueData  AS UserName
                     , Object_User.isErased
                     , tmpPersonal.MemberId 
                     , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                     , tmpPersonal.UnitId
                     , tmpPersonal.PositionId

                     , COALESCE (ObjectDate_Start.ValueData, zc_DateStart())        :: Time      AS StartTime
                     , COALESCE (ObjectDate_Work.ValueData, zc_DateStart())         :: Time      AS WorkTime
                     --, CAST ('08:00' AS Time)      AS WorkTime
                     , EXTRACT (HOUR FROM COALESCE (ObjectDate_Work.ValueData, zc_DateStart())) * 60 
                     + EXTRACT (MINUTE FROM COALESCE (ObjectDate_Work.ValueData, zc_DateStart())) :: TFloat AS Minute_Work
                     , Object_SheetWorkTime.Id AS SheetWorkTimeId
                FROM Object AS Object_User
                      LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                      LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = tmpPersonal.UnitId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

                      LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                             ON ObjectLink_Personal_SheetWorkTime.ObjectId = tmpPersonal.PersonalId
                            AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
                      LEFT JOIN ObjectLink AS ObjectLink_Position_SheetWorkTime
                             ON ObjectLink_Position_SheetWorkTime.ObjectId = tmpPersonal.PositionId
                            AND ObjectLink_Position_SheetWorkTime.DescId = zc_ObjectLink_Position_SheetWorkTime()
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                             ON ObjectLink_Unit_SheetWorkTime.ObjectId = tmpPersonal.UnitId
                            AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
                      LEFT JOIN Object AS Object_SheetWorkTime 
                             ON Object_SheetWorkTime.Id = COALESCE (ObjectLink_Personal_SheetWorkTime.ChildObjectId, COALESCE (ObjectLink_Position_SheetWorkTime.ChildObjectId, COALESCE (ObjectLink_Unit_SheetWorkTime.ChildObjectId, 0)) ) 

                      LEFT JOIN ObjectDate AS ObjectDate_Start
                             ON ObjectDate_Start.ObjectId = Object_SheetWorkTime.Id
                            AND ObjectDate_Start.DescId = zc_ObjectDate_SheetWorkTime_Start()

                      LEFT JOIN ObjectDate AS ObjectDate_Work
                             ON ObjectDate_Work.ObjectId = Object_SheetWorkTime.Id
                            AND ObjectDate_Work.DescId = zc_ObjectDate_SheetWorkTime_Work()
                      
                WHERE Object_User.DescId = zc_Object_User()
                  AND (Object_User.Id = inUserId OR inUserId =0)  
                  AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0) 
                  AND (tmpPersonal.UnitId = inUnitId OR inUnitId = 0)
                  AND (tmpPersonal.PositionId = inPositionId OR inPositionId = 0)  
                )
  -- генерируем таблицу дат
  , tmpDay AS (SELECT generate_series (inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate)
        -- определяем время Подключения и выхода из программы
      , tmpLogin_all AS (SELECT LoginProtocol.UserId
                              , DATE_TRUNC ('DAY', LoginProtocol.OperDate) AS OperDate
                              , MIN (CASE CAST (XPATH ('/XML/Field[3]/@FieldValue', LoginProtocol.ProtocolData :: XML) AS TEXT)
                                          WHEN '{Подключение}'                 THEN LoginProtocol.OperDate
                                          WHEN '{"Подключение (виртуальное)"}' THEN LoginProtocol.OperDate
                                          WHEN '{}'                            THEN LoginProtocol.OperDate
                                     END)  AS OperDate_Entry
                              , MAX (CASE CAST (XPATH ('/XML/Field[3]/@FieldValue', LoginProtocol.ProtocolData :: XML) AS TEXT)
                                          WHEN '{Выход}'    THEN LoginProtocol.OperDate
                                          WHEN '{Работает}' THEN LoginProtocol.OperDate
                                          -- WHEN '{}'         THEN LoginProtocol.OperDate + INTERVAL '8 HOUR' -- захардкодили - типа 8ч. отработали
                                     END)  AS OperDate_Exit
                              , MAX (CASE CAST (XPATH ('/XML/Field[3]/@FieldValue', LoginProtocol.ProtocolData :: XML) AS TEXT)
                                          WHEN '{Работает}' THEN 1
                                          ELSE 0
                                     END)  AS isWork
                              , tmpUser.StartTime
                              , tmpUser.Minute_Work
                         FROM LoginProtocol
                              INNER JOIN tmpUser ON tmpUser.UserId = LoginProtocol.UserId
                         WHERE LoginProtocol.OperDate >= inStartDate AND LoginProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                         -- AND POSITION (LOWER ('Подключение (виртуальное)') IN LOWER (LoginProtocol.ProtocolData)) > 0
                         GROUP BY LoginProtocol.UserId
                                , DATE_TRUNC ('DAY', LoginProtocol.OperDate)
                                , tmpUser.StartTime
                                , tmpUser.Minute_Work
                         ) 
       -- променяем фильтры "Показать все" , "отклонение, минут"
       
         -- определяем
       , tmpLoginLast AS (SELECT tmpLogin_all.UserId, MAX (tmpLogin_all.OperDate) AS OperDate
                          FROM tmpLogin_all
                          WHERE inIsDay = FALSE
                          GROUP BY tmpLogin_all.UserId
                         ) 
    -- определяем время Подключения и выхода из программы
  , tmpLoginProtocol AS (SELECT tmp.UserId
                              , tmp.OperDate
                              , tmp.OperDate_Entry
                              , tmp.OperDate_Exit
                              , tmp.OperDate_Last
                              , tmp.isWork
                              , tmp.isWork_current
                              , tmp.Minute_calc
                              , tmp.Time_calc
                              , (tmp.Minute_Work - tmp.Minute_calc) AS Minute_Diff
                         FROM (
                               SELECT tmpLogin_all.UserId
                                    , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate       ELSE inStartDate END AS OperDate
                                    , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Entry ELSE NULL        END AS OperDate_Entry
                                    , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Exit  ELSE NULL        END AS OperDate_Exit
                                    , tmpLoginLast.OperDate                                                          AS OperDate_Last
                                    , MAX (tmpLogin_all.isWork)  AS isWork
                                    , MAX (CASE WHEN tmpLogin_all.OperDate = CURRENT_DATE THEN tmpLogin_all.isWork ELSE 0 END) AS isWork_current
                                    , SUM (EXTRACT (HOUR   FROM (tmpLogin_all.OperDate_Exit - tmpLogin_all.OperDate_Entry)) * 60
                                         + EXTRACT (MINUTE FROM (tmpLogin_all.OperDate_Exit - tmpLogin_all.OperDate_Entry))
                                          )  AS Minute_calc
                                    , SUM (tmpLogin_all.OperDate_Exit - tmpLogin_all.OperDate_Entry)  AS Time_calc
                                    , SUM (tmpLogin_all.Minute_Work) AS Minute_Work
                               FROM tmpLogin_all
                                    LEFT JOIN tmpLoginLast ON tmpLoginLast.UserId = tmpLogin_all.UserId
                               GROUP BY tmpLogin_all.UserId
                                      , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate       ELSE inStartDate END
                                      , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Entry ELSE NULL        END
                                      , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Exit  ELSE NULL        END
                                      , tmpLoginLast.OperDate
                                ) AS tmp
                         ) 

    -- Данные из протокола документа
  , tmpMov_Protocol AS (SELECT MovementProtocol.UserId
                             , DATE_TRUNC ('DAY', MovementProtocol.OperDate) AS OperDate
                             , MovementProtocol.OperDate                     AS OperDate_Protocol
                             , MovementProtocol.MovementId                   AS Id
                        FROM MovementProtocol
                             INNER JOIN tmpUser ON tmpUser.UserId = MovementProtocol.UserId
                        WHERE MovementProtocol.OperDate >= inStartDate AND MovementProtocol.OperDate < inEndDate + INTERVAL '1 DAY'

                       UNION ALL
                        SELECT MovementProtocol.UserId
                             , DATE_TRUNC ('DAY', MovementProtocol.OperDate) AS OperDate
                             , MovementProtocol.OperDate                     AS OperDate_Protocol
                             , MovementProtocol.MovementId                   AS Id
                        FROM MovementProtocol_arc AS MovementProtocol
                             INNER JOIN tmpUser ON tmpUser.UserId = MovementProtocol.UserId
                        WHERE MovementProtocol.OperDate >= inStartDate AND MovementProtocol.OperDate < inEndDate + INTERVAL '1 DAY'

                       UNION ALL
                        SELECT MovementProtocol.UserId
                             , DATE_TRUNC ('DAY', MovementProtocol.OperDate) AS OperDate
                             , MovementProtocol.OperDate                     AS OperDate_Protocol
                             , MovementProtocol.MovementId                   AS Id
                        FROM MovementProtocol_arc_arc AS MovementProtocol
                             INNER JOIN tmpUser ON tmpUser.UserId = MovementProtocol.UserId
                        WHERE MovementProtocol.OperDate >= inStartDate AND MovementProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                       ) 
    -- Данные из протокола строк документа
  , tmpMI_Protocol AS (SELECT MovementItemProtocol.UserId
                            , DATE_TRUNC ('DAY', MovementItemProtocol.OperDate) AS OperDate
                            , MovementItemProtocol.OperDate                     AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId               AS Id
                       FROM MovementItemProtocol
                            INNER JOIN tmpUser ON tmpUser.UserId = MovementItemProtocol.UserId
                       WHERE MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
 
                      UNION ALL
                       SELECT MovementItemProtocol.UserId
                            , DATE_TRUNC ('DAY', MovementItemProtocol.OperDate) AS OperDate
                            , MovementItemProtocol.OperDate                     AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId               AS Id
                       FROM MovementItemProtocol_arc AS MovementItemProtocol
                            INNER JOIN tmpUser ON tmpUser.UserId = MovementItemProtocol.UserId
                       WHERE MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY'

                      UNION ALL
                       SELECT MovementItemProtocol.UserId
                            , DATE_TRUNC ('DAY', MovementItemProtocol.OperDate) AS OperDate
                            , MovementItemProtocol.OperDate                     AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId               AS Id
                       FROM MovementItemProtocol_arc_arc AS MovementItemProtocol
                            INNER JOIN tmpUser ON tmpUser.UserId = MovementItemProtocol.UserId
                       WHERE MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                      )  
  --данные изменения статуса документа
  , tmpMov_Protocol_Status AS (SELECT MovementProtocol.UserId
                                    , DATE_TRUNC ('DAY', MovementProtocol.OperDate) AS OperDate
                                    , MovementProtocol.OperDate                     AS OperDate_Protocol
                                    , MovementProtocol.MovementId                   AS Id
                                    , CAST (XPATH ('/XML/Field[@FieldName = "Статус"] /@FieldValue', MovementProtocol.ProtocolData :: XML)AS TEXT) AS ProtocolData_str
                                    , ROW_Number() OVER (Partition by MovementProtocol.MovementId, MovementProtocol.UserId ORDER BY MovementProtocol.OperDate) AS ord
                               FROM MovementProtocol
                                    INNER JOIN tmpUser ON tmpUser.UserId = MovementProtocol.UserId
                               WHERE MovementProtocol.OperDate >= inStartDate  AND MovementProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                                  AND CAST (XPATH ('/XML/Field[@FieldName = "Статус"]/@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT) <> '{}'
                               )    
  , tmpCount_Status AS (SELECT tmpMov_Protocol_Status.UserId
                             --, tmpMov_Protocol_Status.OperDate 
                             , CASE WHEN inIsDay = TRUE THEN tmpMov_Protocol_Status.OperDate ELSE inStartDate END AS OperDate
                             , SUM (CASE WHEN tmpMov_Protocol_Status.ProtocolData_str <> tmpMov_Protocol_2.ProtocolData_str AND tmpMov_Protocol_2.ProtocolData_str IS NOT NULL THEN 1 ELSE 0 END) AS Count
                        FROM tmpMov_Protocol_Status
                             LEFT JOIN tmpMov_Protocol_Status AS tmpMov_Protocol_2 
                                                              ON tmpMov_Protocol_2.UserId = tmpMov_Protocol_Status.UserId
                                                             AND tmpMov_Protocol_2.Id = tmpMov_Protocol_Status.Id
                                                             AND tmpMov_Protocol_2.Ord - 1 = tmpMov_Protocol_Status.Ord
                        GROUP BY tmpMov_Protocol_Status.UserId
                               , CASE WHEN inIsDay = TRUE THEN tmpMov_Protocol_Status.OperDate ELSE inStartDate END
                        )

         -- определяем
 , tmpTimeMotion_all AS (SELECT tmp.UserId, tmp.OperDate, MIN (tmp.OperDate_Protocol) AS OperDate_Start, MAX (tmp.OperDate_Protocol) AS OperDate_End
                         FROM (SELECT * FROM tmpMov_Protocol
                              UNION ALL
                               SELECT * FROM tmpMI_Protocol
                              ) AS tmp
                         GROUP BY tmp.UserId, tmp.OperDate
                        ) 
    -- находим время первого действия, время последнего действия
  , tmpTimeMotion AS (SELECT tmp.UserId
                           , CASE WHEN inIsDay = TRUE THEN tmp.OperDate       ELSE inStartDate END AS OperDate
                           , CASE WHEN inIsDay = TRUE THEN tmp.OperDate_Start ELSE NULL        END AS OperDate_Start
                           , CASE WHEN inIsDay = TRUE THEN tmp.OperDate_End   ELSE NULL        END AS OperDate_End
                             -- если Макс = Мин, захардкодил пока 1 что работал типа минуту
                           , SUM (CASE WHEN tmp.OperDate_End = tmp.OperDate_Start
                                            THEN 1
                                       ELSE EXTRACT (HOUR   FROM (tmp.OperDate_End - tmp.OperDate_Start)) * 60
                                          + EXTRACT (MINUTE FROM (tmp.OperDate_End - tmp.OperDate_Start))
                                  END)  AS Minute_calc
                           , SUM (tmp.OperDate_End - tmp.OperDate_Start)      AS Time_calc
                      FROM tmpTimeMotion_all AS tmp
                      GROUP BY tmp.UserId
                             , CASE WHEN inIsDay = TRUE THEN tmp.OperDate       ELSE inStartDate END
                             , CASE WHEN inIsDay = TRUE THEN tmp.OperDate_Start ELSE NULL        END
                             , CASE WHEN inIsDay = TRUE THEN tmp.OperDate_End   ELSE NULL        END
                      )


-------------------------------------
     -- определяем мин дату старта посменных графиков работы, 
     , tmpStartDate AS (SELECT MIN (COALESCE (ObjectDate_DayOffPeriod.ValueData, inStartDate) ) :: TDateTime AS OperDate
                        FROM (SELECT DISTINCT tmpUser.SheetWorkTimeId FROM tmpUser) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_SheetWorkTime_DayKind 
                                                  ON ObjectLink_SheetWorkTime_DayKind.ObjectId  = tmp.SheetWorkTimeId
                                                 AND ObjectLink_SheetWorkTime_DayKind.DescId = zc_ObjectLink_SheetWorkTime_DayKind()
                                                 AND ObjectLink_SheetWorkTime_DayKind.ChildObjectId = zc_Enum_DayKind_Period()
                             LEFT JOIN ObjectDate AS ObjectDate_DayOffPeriod
                                                  ON ObjectDate_DayOffPeriod.ObjectId = ObjectLink_SheetWorkTime_DayKind.ObjectId 
                                                 AND ObjectDate_DayOffPeriod.DescId = zc_ObjectDate_SheetWorkTime_DayOffPeriod()
                       )
       -- генеруруем список дат,
       , tmpDateList AS (SELECT GENERATE_SERIES (tmpStartDate.OperDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate
                         FROM tmpStartDate)
       -- к датам добавляем дни недели
       , tmpDateDay AS (SELECT tmpDateList.OperDate
                             , tmpWeekDay.Number
                        FROM tmpDateList
                             LEFT JOIN zfCalc_DayOfWeekName (tmpDateList.OperDate) AS tmpWeekDay ON 1=1
                        )
       -- выбираем Режимы работы с типом дня "по сменам", если у нас есть пользователи с таким режимом работы
       , tmpPeriod_All AS (SELECT ObjectLink_SheetWorkTime_DayKind.ObjectId AS SheetWorkTimeId
                                , ObjectDate_DayOffPeriod.ValueData :: TDateTime AS StartDate
                                , zfCalc_Word_Split (inValue:= ObjectString_DayOffPeriod.ValueData, inSep:= '/', inIndex:= 1)::TFloat AS DayWork
                                , zfCalc_Word_Split (inValue:= ObjectString_DayOffPeriod.ValueData, inSep:= '/', inIndex:= 2)::TFloat AS DayOff
                           FROM (SELECT DISTINCT tmpUser.SheetWorkTimeId FROM tmpUser) AS tmp
                                INNER JOIN ObjectLink AS ObjectLink_SheetWorkTime_DayKind 
                                                      ON ObjectLink_SheetWorkTime_DayKind.ObjectId  = tmp.SheetWorkTimeId
                                                     AND ObjectLink_SheetWorkTime_DayKind.DescId = zc_ObjectLink_SheetWorkTime_DayKind()
                                                     AND ObjectLink_SheetWorkTime_DayKind.ChildObjectId = zc_Enum_DayKind_Period()
                                LEFT JOIN ObjectString AS ObjectString_DayOffPeriod
                                                       ON ObjectString_DayOffPeriod.ObjectId = ObjectLink_SheetWorkTime_DayKind.ObjectId 
                                                      AND ObjectString_DayOffPeriod.DescId = zc_ObjectString_SheetWorkTime_DayOffPeriod()
                                LEFT JOIN ObjectDate AS ObjectDate_DayOffPeriod
                                                     ON ObjectDate_DayOffPeriod.ObjectId = ObjectLink_SheetWorkTime_DayKind.ObjectId 
                                                    AND ObjectDate_DayOffPeriod.DescId = zc_ObjectDate_SheetWorkTime_DayOffPeriod()
                           )
       -- определение рабочих/выходных дней посменных графиков работы
       , D  as (SELECT  row_number() OVER (PARTITION BY SheetWorkTimeId ORDER BY tmpDateDay.OperDate) as ID, * FROM tmpDateDay JOIN tmpPeriod_All ON tmpPeriod_All.StartDate <= tmpDateDay.OperDate)
       , D1 as (SELECT (D.ID) % (D.daywork + D.dayoff) as i, D.* FROM D)
       , D2 as (SELECT CASE WHEN ((D1.i > D1.DayWork) or (D1.i = 0 and  DayOff > 0)) THEN FALSE ELSE TRUE END AS IsWork, D1.* from D1)
       -- таблица посменных графиков работы
       , tmpPeriod AS (SELECT D2.OperDate 
                            , D2.IsWork 
                            , D2.SheetWorkTimeId
                            , D2.i
                       FROM D2
                       WHERE D2.OperDate >= inStartDate
                       ORDER BY 1, 3)
       -- таблица календарных графиков работы
       , tmpCalendar AS (SELECT ObjectLink_SheetWorkTime_DayKind.ObjectId AS SheetWorkTimeId
                              , tmpDateDay.OperDate 
                              , CASE WHEN tmpDateDay.Number IN (6,7) THEN FALSE ELSE TRUE END IsWork
                         FROM tmpDateDay
                              LEFT JOIN ObjectLink AS ObjectLink_SheetWorkTime_DayKind
                                                   ON ObjectLink_SheetWorkTime_DayKind.DescId = zc_ObjectLink_SheetWorkTime_DayKind()
                                                  AND ObjectLink_SheetWorkTime_DayKind.ChildObjectId = zc_Enum_DayKind_Calendar()
                         WHERE tmpDateDay.OperDate >= inStartDate
                         )
       -- таблица недельных графиков работы
       , tmpWeek AS (SELECT ObjectLink_SheetWorkTime_DayKind.ObjectId AS SheetWorkTimeId
                          , tmpDateDay.OperDate           
                          , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= tmpDateDay.Number) ::TFloat <> 0 THEN FALSE ELSE TRUE END IsWork
                     FROM tmpDateDay 
                          LEFT JOIN ObjectLink AS ObjectLink_SheetWorkTime_DayKind ON 1=1
                          LEFT JOIN ObjectString AS ObjectString_DayOffWeek
                                          ON ObjectString_DayOffWeek.ObjectId = ObjectLink_SheetWorkTime_DayKind.ObjectId  --Object_SheetWorkTime.Id
                                         AND ObjectString_DayOffWeek.DescId = zc_ObjectString_SheetWorkTime_DayOffWeek()
                     WHERE ObjectLink_SheetWorkTime_DayKind.DescId = zc_ObjectLink_SheetWorkTime_DayKind()
                       AND ObjectLink_SheetWorkTime_DayKind.ChildObjectId = zc_Enum_DayKind_Week()
                       AND  tmpDateDay.OperDate >= inStartDate
                     )
       -- таблица всех рабочих дней графиков 
       , tmpSheetWorkTime AS (SELECT tmpCalendar.SheetWorkTimeId, tmpCalendar.OperDate, tmpCalendar.IsWork
                              FROM tmpCalendar
                              WHERE tmpCalendar.IsWork = TRUE
                            UNION
                              SELECT tmpWeek.SheetWorkTimeId, tmpWeek.OperDate, tmpWeek.IsWork
                              FROM tmpWeek
                              WHERE tmpWeek.IsWork = TRUE
                            UNION
                              SELECT tmpPeriod.SheetWorkTimeId, tmpPeriod.OperDate, tmpPeriod.IsWork
                              FROM tmpPeriod
                              WHERE tmpPeriod.IsWork = TRUE
                             )
------------------------

     -- Результат 
     SELECT tmpUser.UserId
          , tmpUser.UserCode
          , tmpUser.UserName

          , CASE WHEN tmpLoginProtocol.isWork_current = 1
                      THEN 'Работает'
                 WHEN tmpLoginProtocol.isWork = 1 AND inIsDay = TRUE
                      THEN 'Завершил*'
                 ELSE 'Завершил'
            END :: TVarChar AS UserStatus

          , tmpUser.isErased
          , Object_Member.ValueData           AS MemberName 
          , Object_Position.ValueData         AS PositionName 
          , Object_Unit.Id                    AS UnitId
          , Object_Unit.ValueData             AS UnitName
          , Object_Branch.Id                  AS BranchId
          , Object_Branch.ValueData           AS BranchName
 
         , (SELECT tmp.DayOfWeekName FROM zfCalc_DayOfWeekName (COALESCE (tmpLoginProtocol.OperDate_Last, tmpLoginProtocol.OperDate)) AS tmp) AS DayOfWeekName
          , CASE WHEN inIsDay = TRUE THEN tmpLoginProtocol.OperDate ELSE NULL END ::TDateTime AS OperDate
          , COALESCE (tmpLoginProtocol.OperDate_Last, tmpLoginProtocol.OperDate) :: TDateTime AS OperDate_Last

            -- Время входа
          , COALESCE (tmpLogin_all.OperDate_Entry, tmpLoginProtocol.OperDate_Entry) :: TDateTime AS OperDate_Entry
            -- Время выхода
          , CASE WHEN tmpLoginProtocol.isWork = 1 AND tmpDay.OperDate = CURRENT_DATE THEN NULL ELSE COALESCE (tmpLogin_all.OperDate_Exit, tmpLoginProtocol.OperDate_Exit) END :: TDateTime AS OperDate_Exit

            -- Время первого действия
          , COALESCE (tmpTimeMotion_all.OperDate_Start, tmpTimeMotion.OperDate_Start) :: TDateTime AS OperDate_Start
            -- Время послед. действия
          , COALESCE (tmpTimeMotion_all.OperDate_End, tmpTimeMotion.OperDate_End) :: TDateTime AS OperDate_End

          , COALESCE (tmpMov.Mov_Count,0)   ::TFloat     AS Mov_Count           -- кол-во документов 
          , COALESCE (tmpMI.MI_Count,0)     ::TFloat     AS MI_Count            -- кол-во мувИтемов
            -- итого кол-во действий
          , (COALESCE (tmpMov.All_Count,0) + COALESCE (tmpMI.All_Count,0) -  COALESCE (tmpCount_Status.Count,0)) :: TFloat AS Count             --без операций проведения
          --, tmpLoginProtocol.Minute_Diff  :: TFloat AS Count
            -- отработал - Кол-во часов (по вх/вых)
          , CAST (tmpLoginProtocol.Minute_calc / 60 AS NUMERIC (16, 2))    :: TFloat AS Count_Prog
            -- отработал - Кол-во часов (по док.)
          , CAST (tmpTimeMotion.Minute_calc / 60 AS NUMERIC (16, 2))       :: TFloat AS Count_Work 
          
          , COALESCE (tmpCount_Status.Count,0)                             :: TFloat AS Count_status 


            -- отработал - Кол-во часов (по вх/вых)
          --, tmpLoginProtocol.Time_calc      :: Time AS Time_Prog
          , ((EXTRACT (DAY FROM (tmpLoginProtocol.Time_calc)) * 24 + EXTRACT (HOUR FROM (tmpLoginProtocol.Time_calc)))::tvarchar  ||':' ||
             lpad (EXTRACT (MINUTE FROM (tmpLoginProtocol.Time_calc))::tvarchar ,2, '0'))  ::TVarChar  AS Time_Prog
            -- отработал - Кол-во часов (по док.) 
          --, tmpTimeMotion.Time_calc         :: Time AS Time_Work
          , ((EXTRACT (DAY FROM (tmpTimeMotion.Time_calc)) * 24 + EXTRACT (HOUR FROM (tmpTimeMotion.Time_calc)))::tvarchar  ||':' ||
             lpad (EXTRACT (MINUTE FROM (tmpTimeMotion.Time_calc))::tvarchar ,2, '0'))  ::TVarChar  AS Time_Work
         
            -- Подсвечиваем красным если человек еще работает
          , CASE WHEN tmpLoginProtocol.isWork_current = 1
                 THEN zc_Color_Blue()
                 ELSE zc_Color_Black()
            END AS Color_Calc

     FROM tmpDay
          INNER JOIN tmpLoginProtocol ON tmpLoginProtocol.OperDate = tmpDay.OperDate
                                     AND (inIsShowAll = TRUE OR tmpLoginProtocol.Minute_Diff >= inDiff)
          LEFT JOIN tmpUser ON tmpUser.UserId =  tmpLoginProtocol.UserId 

          LEFT JOIN tmpLogin_all      ON tmpLogin_all.UserId   =  tmpLoginProtocol.UserId
                                     AND tmpLogin_all.OperDate = CURRENT_DATE
                                     AND inIsDay               = FALSE
          LEFT JOIN tmpTimeMotion_all ON tmpTimeMotion_all.UserId   =  tmpLoginProtocol.UserId
                                     AND tmpTimeMotion_all.OperDate = CURRENT_DATE
                                     AND inIsDay                    = FALSE

          LEFT JOIN (SELECT tmpMov_Protocol.UserId
                          , tmpMov_Protocol.OperDate
                          , COUNT (DISTINCT tmpMov_Protocol.Id) AS Mov_Count
                          , COUNT(*)                            AS All_Count
                     FROM tmpMov_Protocol
                     GROUP BY tmpMov_Protocol.UserId 
                            , tmpMov_Protocol.OperDate
                     ) AS tmpMov ON tmpMov.OperDate = tmpDay.OperDate
                                AND tmpMov.UserId   = tmpUser.UserId
          LEFT JOIN (SELECT tmpMI_Protocol.UserId 
                          , tmpMI_Protocol.OperDate
                          , COUNT (DISTINCT tmpMI_Protocol.Id) AS MI_Count
                          , COUNT(*)                           AS All_Count
                     FROM tmpMI_Protocol
                     GROUP BY tmpMI_Protocol.UserId 
                            , tmpMI_Protocol.OperDate
                     ) AS tmpMI ON tmpMI.OperDate = tmpDay.OperDate
                               AND tmpMI.UserId   = tmpUser.UserId
          LEFT JOIN tmpTimeMotion ON tmpTimeMotion.OperDate = tmpDay.OperDate
                                 AND tmpTimeMotion.UserId = tmpUser.UserId
                                
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId 
          
          LEFT JOIN tmpCount_Status ON tmpCount_Status.UserId = tmpUser.UserId
                                   AND tmpCount_Status.OperDate = tmpDay.OperDate
     -- WHERE COALESCE (tmpLoginProtocol.OperDate_Entry , zc_DateStart() ) <> zc_DateStart() 
    UNION 
     -- добавляем сотрудников, которые не работали в программе в рабочие дни согласно графиков работы
     SELECT tmpUser.UserId
          , tmpUser.UserCode
          , tmpUser.UserName

          ,  'Не работал'         :: TVarChar AS UserStatus

          , tmpUser.isErased
          , Object_Member.ValueData           AS MemberName 
          , Object_Position.ValueData         AS PositionName 
          , Object_Unit.Id                    AS UnitId
          , Object_Unit.ValueData             AS UnitName
          , Object_Branch.Id                  AS BranchId
          , Object_Branch.ValueData           AS BranchName
 
          , CASE WHEN inIsDay = TRUE THEN (SELECT tmp.DayOfWeekName FROM zfCalc_DayOfWeekName (tmpSheetWorkTime.OperDate) AS tmp) 
                                     ELSE (SELECT tmp.DayOfWeekName FROM zfCalc_DayOfWeekName (inEndDate) AS tmp)  
            END ::TVarChar  AS DayOfWeekName
          , CASE WHEN inIsDay = TRUE THEN tmpSheetWorkTime.OperDate ELSE NULL END      :: TDateTime AS OperDate
          , CASE WHEN inIsDay = TRUE THEN tmpSheetWorkTime.OperDate ELSE inEndDate  END      :: TDateTime AS OperDate_Last

              -- Время входа
          ,  zc_DateStart() :: TDateTime AS OperDate_Entry
            -- Время выхода
          ,  zc_DateStart() :: TDateTime AS OperDate_Exit

            -- Время первого действия
          ,  zc_DateStart() :: TDateTime AS OperDate_Start
            -- Время послед. действия
          ,  zc_DateStart() :: TDateTime AS OperDate_End

          , 0     ::TFloat     AS Mov_Count           -- кол-во документов 
          , 0     ::TFloat     AS MI_Count            -- кол-во мувИтемов
            -- итого кол-во действий
          , 0     :: TFloat AS Count
            -- отработал - Кол-во часов (по вх/вых)
          , 0     :: TFloat AS Count_Prog
            -- отработал - Кол-во часов (по док.)
          , 0     :: TFloat AS Count_Work
           --проведение документа 
          , 0     :: TFloat AS Count_status

            -- отработал - Кол-во часов (по вх/вых)
          , '00:00'  ::TVarChar  AS Time_Prog
            -- отработал - Кол-во часов (по док.) 
          , '00:00'  ::TVarChar  AS Time_Work
          
            -- Подсвечиваем красным если человек не работает
          , zc_Color_Red() AS Color_Calc
          
     FROM tmpSheetWorkTime
          LEFT JOIN tmpUser ON tmpUser.SheetWorkTimeId =  tmpSheetWorkTime.SheetWorkTimeId
          LEFT JOIN tmpLoginProtocol ON tmpLoginProtocol.OperDate = tmpSheetWorkTime.OperDate
                                    AND tmpLoginProtocol.UserId = tmpUser.UserId

          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId
     WHERE tmpLoginProtocol.UserId IS NULL
          AND inIsShowAll = TRUE
     GROUP BY tmpUser.UserId
            , tmpUser.UserCode
            , tmpUser.UserName
            , tmpUser.isErased
            , Object_Member.ValueData         
            , Object_Position.ValueData       
            , Object_Unit.Id                  
            , Object_Unit.ValueData           
            , Object_Branch.Id                  
            , Object_Branch.ValueData           
            , CASE WHEN inIsDay = TRUE THEN (SELECT tmp.DayOfWeekName FROM zfCalc_DayOfWeekName (tmpSheetWorkTime.OperDate) AS tmp) 
                   ELSE (SELECT tmp.DayOfWeekName FROM zfCalc_DayOfWeekName (inEndDate) AS tmp) END
            , CASE WHEN inIsDay = TRUE THEN tmpSheetWorkTime.OperDate ELSE inEndDate  END   
            , CASE WHEN inIsDay = TRUE THEN tmpSheetWorkTime.OperDate ELSE NULL END
             
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.24         * inPositionId
 07.11.16         *
*/

-- тест
-- SELECT * FROM gpReport_UserProtocol (inStartDate:= '07.11.2022', inEndDate:= '11.11.2022', inBranchId:= 0, inUnitId:= 0 , inUserId:= 0, inIsDay:=False,  inIsShowAll:= FALSE, inDiff:= 0, inSession:= '5');
-- select * from gpReport_UserProtocol(inStartDate := ('06.12.2023')::TDateTime , inEndDate := ('07.12.2023')::TDateTime , inBranchId := 0 , inUnitId := 0 , inUserId := 9761338 , inisDay := True , inisShowAll := True , inDiff := 10 ,  inSession := '9457':: TVarchar);