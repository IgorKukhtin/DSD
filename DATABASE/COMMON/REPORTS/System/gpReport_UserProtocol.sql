-- Function: gpReport_UserProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_UserProtocol (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_UserProtocol(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inBranchId    Integer , --
    IN inUnitId      Integer , --
    IN inUserId      Integer , --
    IN inIsDay       Boolean , --
    IN inSession     TVarChar    -- сессия пользователя
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

             , Time_Prog   Time      
             , Time_Work   Time

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
                          , MAX (View_Personal.UnitId) AS UnitId
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
                FROM Object AS Object_User
                      LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                      LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = tmpPersonal.UnitId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                WHERE Object_User.DescId = zc_Object_User()
                  AND (Object_User.Id = inUserId OR inUserId =0)  
                  AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0) 
                  AND (tmpPersonal.UnitId = inUnitId OR inUnitId = 0) 
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
                          FROM LoginProtocol
                               INNER JOIN tmpUser ON tmpUser.UserId = LoginProtocol.UserId
                          WHERE LoginProtocol.OperDate >= inStartDate AND LoginProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                         -- AND POSITION (LOWER ('Подключение (виртуальное)') IN LOWER (LoginProtocol.ProtocolData)) > 0
                          GROUP BY LoginProtocol.UserId
                                 , DATE_TRUNC ('DAY', LoginProtocol.OperDate)
                         ) 
         -- определяем
       , tmpLoginLast AS (SELECT tmpLogin_all.UserId, MAX (tmpLogin_all.OperDate) AS OperDate
                          FROM tmpLogin_all
                          WHERE inIsDay = FALSE
                          GROUP BY tmpLogin_all.UserId
                         ) 
    -- определяем время Подключения и выхода из программы
  , tmpLoginProtocol AS (SELECT tmpLogin_all.UserId
                              , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate       ELSE inStartDate END AS OperDate
                              , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Entry ELSE NULL        END AS OperDate_Entry
                              , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Exit  ELSE NULL        END AS OperDate_Exit
                              , tmpLoginLast.OperDate                                                          AS OperDate_Last
                              , MAX (tmpLogin_all.isWork)  AS isWork
                              , SUM (EXTRACT (HOUR   FROM (tmpLogin_all.OperDate_Exit - tmpLogin_all.OperDate_Entry)) * 60
                                   + EXTRACT (MINUTE FROM (tmpLogin_all.OperDate_Exit - tmpLogin_all.OperDate_Entry))
                                    )  AS Minute_calc
                              , SUM (tmpLogin_all.OperDate_Exit - tmpLogin_all.OperDate_Entry)  AS Time_calc
                         FROM tmpLogin_all
                              LEFT JOIN tmpLoginLast ON tmpLoginLast.UserId = tmpLogin_all.UserId
                         GROUP BY tmpLogin_all.UserId
                                , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate       ELSE inStartDate END
                                , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Entry ELSE NULL        END
                                , CASE WHEN inIsDay = TRUE THEN tmpLogin_all.OperDate_Exit  ELSE NULL        END
                                , tmpLoginLast.OperDate
                         ) 

    -- Данные из протокола документа
  , tmpMov_Protocol AS (SELECT MovementProtocol.UserId
                             , DATE_TRUNC ('DAY', MovementProtocol.OperDate) AS OperDate
                             , MovementProtocol.OperDate                     AS OperDate_Protocol
                             , MovementProtocol.MovementId                   AS Id
                        FROM MovementProtocol
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
     -- Результат 
     SELECT tmpUser.UserId
          , tmpUser.UserCode
          , tmpUser.UserName

          , CASE WHEN tmpLoginProtocol.isWork = 1 AND COALESCE (tmpLoginProtocol.OperDate_Last, tmpLoginProtocol.OperDate) = CURRENT_DATE
                      THEN 'Работает'
                 WHEN tmpLoginProtocol.isWork = 1
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
          , CASE WHEN tmpLoginProtocol.isWork = 1 AND tmpDay.OperDate = CURRENT_DATE THEN NULL ELSE tmpLoginProtocol.OperDate_Exit END :: TDateTime
            -- Время первого действия
          , COALESCE (tmpTimeMotion_all.OperDate_Start, tmpTimeMotion.OperDate_Start) :: TDateTime AS OperDate_Start
            -- Время послед. действия
          , COALESCE (tmpTimeMotion_all.OperDate_End, tmpTimeMotion.OperDate_End) :: TDateTime AS OperDate_End

          , COALESCE (tmpMov.Mov_Count,0)   ::TFloat     AS Mov_Count           -- кол-во документов 
          , COALESCE (tmpMI.MI_Count,0)     ::TFloat     AS MI_Count            -- кол-во мувИтемов
            -- итого кол-во действий
          , (COALESCE (tmpMov.All_Count,0) + COALESCE (tmpMI.All_Count,0)) :: TFloat AS Count

            -- отработал - Кол-во часов (по вх/вых)
          , CAST (tmpLoginProtocol.Minute_calc / 60 AS NUMERIC (16, 2)) :: TFloat AS Count_Prog
            -- отработал - Кол-во часов (по док.)
          , CAST (tmpTimeMotion.Minute_calc / 60 AS NUMERIC (16, 2)) :: TFloat AS Count_Work


            -- отработал - Кол-во часов (по вх/вых)
          , tmpLoginProtocol.Time_calc      :: Time AS Time_Prog
            -- отработал - Кол-во часов (по док.) 
          , tmpTimeMotion.Time_calc         :: Time AS Time_Work


            -- Подсвечиваем красным если человек еще работает
          , CASE WHEN tmpLoginProtocol.isWork = 1 AND COALESCE (tmpLoginProtocol.OperDate_Last, tmpLoginProtocol.OperDate) = CURRENT_DATE
                 THEN zc_Color_Blue()
                 ELSE zc_Color_Black()
            END AS Color_Calc
     FROM tmpDay
          INNER JOIN tmpLoginProtocol ON tmpLoginProtocol.OperDate = tmpDay.OperDate
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
     -- WHERE COALESCE (tmpLoginProtocol.OperDate_Entry , zc_DateStart() ) <> zc_DateStart() 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.11.16         *
*/
-- тест
-- SELECT * FROM gpReport_UserProtocol (inStartDate:= '07.11.2016', inEndDate:= '11.11.2016', inBranchId:= 0, inUnitId:= 0, inUserId:= 0, inIsDay:=False, inSession:= '5');
