-- Function: gpSelect_Log_CashRemains()

DROP FUNCTION IF EXISTS gpSelect_Log_CashRemains (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Log_CashRemains(
    IN inStartDate     TDateTime , -- Дата
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('day', inStartDate);
    vbDateEnd := vbDateStart + INTERVAL '1 day';

    vbUserId := lpGetUserBySession (inSession);

    OPEN cur1 FOR 
    WITH tmpOldNew AS (
      SELECT ROW_NUMBER() OVER (PARTITION BY EmployeeWorkLog.CashSessionId, 
                                             EmployeeWorkLog.UnitId,
                                             EmployeeWorkLog.UserId ORDER BY EmployeeWorkLog.DateLogIn DESC) AS Ord
           , EmployeeWorkLog.CashSessionId      AS CashSessionId
           , EmployeeWorkLog.UnitId
           , EmployeeWorkLog.UserId
           , COALESCE (EmployeeWorkLog.OldProgram, FALSE)   AS OldProgram
           , COALESCE (EmployeeWorkLog.OldServise, FALSE)    AS OldServise
      FROM EmployeeWorkLog
      WHERE EmployeeWorkLog.DateLogIn >= vbDateStart AND EmployeeWorkLog.DateLogIn < vbDateEnd)  

    SELECT EmployeeWorkLog.CashSessionId      AS CashSessionId
         , OUnit.objectcode   AS UnitCode
         , OUnit.valuedata    AS UnitName
         , OUser.objectcode   AS UserCode
         , OUser.valuedata    AS UserName
         , to_char(MIN(EmployeeWorkLog.DateLogIn), 'HH24:MI:SS') AS TimeLogIn
         , to_char(MAX(EmployeeWorkLog.DateZReport), 'HH24:MI:SS') AS TimeZReport
         , to_char(MAX(EmployeeWorkLog.DateLogOut), 'HH24:MI:SS') AS TimeLogOut
         , tmpOldNew.OldProgram
         , tmpOldNew.OldServise
         , Object_Position.ValueData  AS PositionName                   
         , CASE WHEN tmpOldNew.OldProgram = True OR tmpOldNew.OldServise = True
           THEN TRUE ELSE FALSE END AS isErased
    FROM EmployeeWorkLog
         LEFT JOIN Object AS OUnit ON OUnit.id = EmployeeWorkLog.UnitId
         LEFT JOIN Object AS OUser ON OUser.id = EmployeeWorkLog.UserId
         LEFT JOIN tmpOldNew AS tmpOldNew ON tmpOldNew.CashSessionId = EmployeeWorkLog.CashSessionId 
                                       AND tmpOldNew.UnitId = EmployeeWorkLog.UnitId
                                       AND tmpOldNew.UserId = EmployeeWorkLog.UserId
                                       AND tmpOldNew.Ord = 1
 
         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = EmployeeWorkLog.UserId
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

         LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
         
    WHERE EmployeeWorkLog.DateLogIn >= vbDateStart AND EmployeeWorkLog.DateLogIn < vbDateEnd
    GROUP BY EmployeeWorkLog.CashSessionId,
             OUnit.objectcode, OUnit.valuedata,
             OUser.objectcode, OUser.valuedata, 
             tmpOldNew.OldProgram, tmpOldNew.OldServise,
             Object_Position.ValueData
             
             
             
    ORDER BY 1, 2, 4; --Log_CashRemains.CashSessionId, OUnit.valuedata, OUser.valuedata;
    RETURN NEXT cur1;

    OPEN cur2 FOR 
    SELECT EmployeeWorkLog.CashSessionId   AS CashSessionId
         , OUnit.objectcode                AS UnitCode
         , OUnit.valuedata                 AS UnitName   
    FROM EmployeeWorkLog
         INNER JOIN (SELECT CashSessionId
                     FROM
                       (SELECT CashSessionId
                       FROM EmployeeWorkLog
                            INNER JOIN Object AS OUnit ON OUnit.id = EmployeeWorkLog.UnitId
                       WHERE EmployeeWorkLog.DateLogIn >= vbDateStart AND EmployeeWorkLog.DateLogIn < vbDateEnd 
                       GROUP BY CashSessionId,
                                OUnit.objectcode, OUnit.valuedata
                       ORDER BY CashSessionId, OUnit.valuedata) AS T1
                     GROUP BY CashSessionId
                     HAVING COUNT(*) > 1) AS T2 ON T2.CashSessionId = EmployeeWorkLog.CashSessionId
         INNER JOIN Object AS OUnit ON OUnit.id = EmployeeWorkLog.UnitId
    WHERE EmployeeWorkLog.DateLogIn >= vbDateStart AND EmployeeWorkLog.DateLogIn < vbDateEnd 
    GROUP BY EmployeeWorkLog.CashSessionId,
             OUnit.objectcode, OUnit.valuedata
    ORDER BY 1, 2; --CashSessionId, OUnit.valuedata;
        
    RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 24.01.19         *
 12.01.19         *
 06.01.19         *
 20.10.18         *
*/

-- тест
-- 

select * from gpSelect_Log_CashRemains(inStartDate := ('14.04.2022')::TDateTime ,  inSession := '3');