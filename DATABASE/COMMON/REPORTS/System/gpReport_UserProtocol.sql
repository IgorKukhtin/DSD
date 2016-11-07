-- Function: gpReport_UserProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_UserProtocol (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_UserProtocol(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inBranchId    Integer , --
    IN inUnitId      Integer , --
    IN inUserId      Integer , --
    IN inisDay       Boolean , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar, isErased Boolean
             , MemberName TVarChar
             , PositionName TVarChar
             , UnitName TVarChar
             , BranchName TVarChar
             , OperDate TDateTime
             , OperDate_Entry TDateTime
             , OperDate_Exit TDateTime
             , OperDate_Start TDateTime
             , OperDate_End TDateTime
             , Mov_Count TFloat             
             , MI_Count TFloat

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
                        WHERE View_Personal.isErased = FALSE
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
  , tmpData AS (SELECT generate_series(inStartDate, inEndDate, '1 day'::interval) as OperDate
                WHERE inisDay = TRUE
               UNION 
                SELECT inStartDate as OperDate
                WHERE inisDay = FALSE)
  -- 
  , tmpLoginProtocol AS (SELECT LoginProtocol.UserId
                              , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',LoginProtocol.operDate) ELSE inStartDate END  AS OperDate
                              , CASE WHEN inisDay = TRUE THEN min(LoginProtocol.OperDate) ELSE inStartDate END  AS OperDate_Entry
                              , CASE WHEN inisDay = TRUE THEN max(LoginProtocol.OperDate) ELSE inEndDate END  AS OperDate_Exit
                         FROM LoginProtocol
                              INNER JOIN tmpUser ON tmpUser.UserId = LoginProtocol.UserId
                         WHERE DATE_TRUNC ('DAY', LoginProtocol.operDate) between inStartDate AND inEndDate
                         GROUP BY LoginProtocol.UserId
                                 , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',LoginProtocol.operDate) ELSE inStartDate END
                        ) 
  -- Данные из протокола документа
  , tmpMov_Protocol AS (SELECT MovementProtocol.UserId
                                , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',MovementProtocol.operDate) ELSE inStartDate END AS OperDate
                                , MovementProtocol.OperDate AS OperDate_Protocol
                                , MovementProtocol.MovementId AS Id
                        FROM MovementProtocol
                             INNER JOIN tmpUser ON tmpUser.UserId = MovementProtocol.UserId
                        WHERE DATE_TRUNC ('DAY',MovementProtocol.operDate) between inStartDate AND inEndDate
                           ) 
  -- Данные из протокола строк документа
  , tmpMI_Protocol AS (SELECT MovementItemProtocol.UserId
                                , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',MovementItemProtocol.operDate) ELSE inStartDate END AS OperDate
                                , MovementItemProtocol.OperDate AS OperDate_Protocol
                                , MovementItemProtocol.MovementItemId AS Id
                       FROM MovementItemProtocol
                            INNER JOIN tmpUser ON tmpUser.UserId = MovementItemProtocol.UserId
                       WHERE DATE_TRUNC ('DAY',MovementItemProtocol.operDate) between inStartDate AND inEndDate
                           ) 

  -- находим время первого действия, время последнего действия
  , tmpTimeMotion AS (SELECT tmp.UserId, tmp.OperDate, min(tmp.OperDate_Protocol) AS OperDate_Start, max(tmp.OperDate_Protocol) AS OperDate_End
                      FROM (SELECT *
                            FROM tmpMov_Protocol
                           UNION 
                            SELECT *
                            FROM tmpMI_Protocol) as tmp 
                      WHERE inisDay = TRUE
                      GROUP BY tmp.UserId, tmp.OperDate
                      )
 
     SELECT tmpUser.UserId
          , tmpUser.UserCode
          , tmpUser.UserName
          , tmpUser.isErased
          , Object_Member.ValueData    AS MemberName 
          , Object_Position.ValueData  AS PositionName 
          , Object_Unit.ValueData      AS UnitName
          , Object_Branch.ValueData    AS BranchName
 
          , tmpData.OperDate                ::TDateTime
          , tmpLoginProtocol.OperDate_Entry ::TDateTime                         -- время входа
          , CASE WHEN tmpLoginProtocol.OperDate_Exit < tmpTimeMotion.OperDate_End 
                 THEN tmpTimeMotion.OperDate_End 
                 ELSE tmpLoginProtocol.OperDate_Exit  
            END                             ::TDateTime  AS OperDate_Exit       -- время выхода
          , tmpTimeMotion.OperDate_Start    ::TDateTime                         -- время первого действия
          , tmpTimeMotion.OperDate_End      ::TDateTime                         -- время последнего действия
          , COALESCE (tmpMov.Mov_Count,0)   ::TFloat     AS Mov_Count           -- кол-во документов 
          , COALESCE (tmpMI.MI_Count,0)     ::TFloat     AS MI_Count            -- кол-во мувИтемов
     FROM tmpUser
          LEFT JOIN tmpData ON 1=1
          LEFT JOIN tmpLoginProtocol ON tmpLoginProtocol.OperDate = tmpData.OperDate
                                    AND tmpLoginProtocol.UserId = tmpUser.UserId

          LEFT JOIN (SELECT tmpMov_Protocol.UserId 
                          , tmpMov_Protocol.OperDate
                          , Count(DISTINCT tmpMov_Protocol.Id) AS Mov_Count
                     FROM tmpMov_Protocol
                     GROUP BY tmpMov_Protocol.UserId 
                            , tmpMov_Protocol.OperDate
                     ) AS tmpMov ON tmpMov.OperDate = tmpData.OperDate
                                AND tmpMov.UserId   = tmpUser.UserId
          LEFT JOIN (SELECT tmpMI_Protocol.UserId 
                          , tmpMI_Protocol.OperDate
                          , Count(DISTINCT tmpMI_Protocol.Id) AS MI_Count
                     FROM tmpMI_Protocol
                     GROUP BY tmpMI_Protocol.UserId 
                            , tmpMI_Protocol.OperDate
                     ) AS tmpMI ON tmpMI.OperDate = tmpData.OperDate
                               AND tmpMI.UserId   = tmpUser.UserId
          LEFT JOIN tmpTimeMotion ON tmpTimeMotion.OperDate = tmpData.OperDate
                                 AND tmpTimeMotion.UserId = tmpUser.UserId
                                
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId
     WHERE COALESCE (tmpLoginProtocol.OperDate_Entry , zc_DateStart() ) <> zc_DateStart() 
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
 --select * from gpReport_UserProtocol(inStartDate := ('07.11.2016')::TDateTime , inEndDate := ('07.11.2016')::TDateTime , inBranchId := 0 , inUnitId := 0 , inUserId := 76913 , inisDay := 'True' ,  inSession := '5');

