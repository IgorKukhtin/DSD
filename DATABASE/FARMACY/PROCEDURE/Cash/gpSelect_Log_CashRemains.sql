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
    SELECT CashSessionId      AS CashSessionId
         , OUnit.objectcode   AS UnitCode
         , OUnit.valuedata    AS UnitName
         , OUser.objectcode   AS UserCode
         , OUser.valuedata    AS UserName
    FROM Log_CashRemains
         INNER JOIN Object AS OUnit ON OUnit.id = Log_CashRemains.UnitId
         INNER JOIN Object AS OUser ON OUser.id = Log_CashRemains.UserId
    WHERE Log_CashRemains.DateStart >= vbDateStart AND Log_CashRemains.DateStart < vbDateEnd 
    GROUP BY CashSessionId,
             OUnit.objectcode, OUnit.valuedata,
             OUser.objectcode, OUser.valuedata
    ORDER BY CashSessionId, OUnit.valuedata, OUser.valuedata;
    RETURN NEXT cur1;

    OPEN cur2 FOR 
    SELECT Log_CashRemains.CashSessionId   AS CashSessionId
         , OUnit.objectcode                AS UnitCode
         , OUnit.valuedata                 AS UnitName   
    FROM Log_CashRemains
         INNER JOIN (SELECT CashSessionId
                     FROM
                       (SELECT CashSessionId
                       FROM Log_CashRemains
                            INNER JOIN Object AS OUnit ON OUnit.id = Log_CashRemains.UnitId
                       WHERE Log_CashRemains.DateStart >= vbDateStart AND Log_CashRemains.DateStart < vbDateEnd 
                       GROUP BY CashSessionId,
                                OUnit.objectcode, OUnit.valuedata
                       ORDER BY CashSessionId, OUnit.valuedata) AS T1
                     GROUP BY CashSessionId
                     HAVING COUNT(*) > 1) AS T2 ON T2.CashSessionId = Log_CashRemains.CashSessionId
         INNER JOIN Object AS OUnit ON OUnit.id = Log_CashRemains.UnitId
    WHERE Log_CashRemains.DateStart >= vbDateStart AND Log_CashRemains.DateStart < vbDateEnd 
    GROUP BY Log_CashRemains.CashSessionId,
             OUnit.objectcode, OUnit.valuedata
    ORDER BY CashSessionId, OUnit.valuedata;
    RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 20.10.18         *
*/

-- тест
-- select * from gpSelect_Log_CashRemains(inStartDate := ('20.10.2018')::TDateTime ,  inSession := '3');