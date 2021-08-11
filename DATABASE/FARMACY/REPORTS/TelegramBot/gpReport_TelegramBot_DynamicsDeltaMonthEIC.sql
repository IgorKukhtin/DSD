-- Function: gpReport_TelegramBot_DynamicsDeltaMonthEIC()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_DynamicsDeltaMonthEIC (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_DynamicsDeltaMonthEIC(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TVarChar
             , CountNeBoleyCurr Integer
             , CountTabletkiCurr Integer
             , CountLiki24Curr Integer
             , CountAllCurr Integer
             , CountNeBoleyPrev Integer
             , CountTabletkiPrev Integer
             , CountLiki24Prev Integer
             , CountAllPrev Integer
             , CountNeBoley TFloat
             , CountTabletki TFloat
             , CountLiki24 TFloat
             , CountAll TFloat
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат
     RETURN QUERY
     WITH tmpDynamicsOrdersEIC AS (SELECT DynamicsOrdersEIC.* 
                                        , DATE_TRUNC ('MONTH', DynamicsOrdersEIC.OperDate):: TDateTime as OperDateStart 
                                   FROM gpReport_Movement_DynamicsOrdersEIC(inStartDate := '01.03.2021'::TDateTime
                                                                          , inEndDate := CURRENT_DATE - INTERVAL '1 DAY'
                                                                          , inSession := inSession) AS DynamicsOrdersEIC),
          tmpDynamicsOrdersEICSum AS (SELECT tmpDynamicsOrdersEIC.OperDateStart
                                           , SUM(tmpDynamicsOrdersEIC.CountNeBoley)::Integer   AS CountNeBoley
                                           , SUM(tmpDynamicsOrdersEIC.CountTabletki)::Integer  AS CountTabletki
                                           , SUM(tmpDynamicsOrdersEIC.CountLiki24)::Integer    AS CountLiki24
                                           , SUM(tmpDynamicsOrdersEIC.CountAll)::Integer       AS CountAll
                                      FROM tmpDynamicsOrdersEIC
                                      GROUP BY tmpDynamicsOrdersEIC.OperDateStart)                                       
     SELECT 
            (zfConvert_IntToString((ROW_NUMBER() OVER (ORDER BY tmpDynamicsOrdersEIC.OperDateStart))::INTEGER, 3)::TVArChar||'. '||
            zfCalc_MonthYearName(tmpDynamicsOrdersEIC.OperDateStart))::TVArChar  AS OperText
          , tmpDynamicsOrdersEIC.CountNeBoley
          , tmpDynamicsOrdersEIC.CountTabletki
          , tmpDynamicsOrdersEIC.CountLiki24
          , tmpDynamicsOrdersEIC.CountAll
          , DynamicsOrdersEIC.CountNeBoley
          , DynamicsOrdersEIC.CountTabletki
          , DynamicsOrdersEIC.CountLiki24
          , DynamicsOrdersEIC.CountAll
          , CASE WHEN COALESCE(DynamicsOrdersEIC.CountNeBoley, 0) = 0 THEN 0 ELSE Round(tmpDynamicsOrdersEIC.CountNeBoley::TFloat / DynamicsOrdersEIC.CountNeBoley::TFloat * 100.0 - 100.0, 2) END::TFloat    AS DeltaNeBoley
          , CASE WHEN COALESCE(DynamicsOrdersEIC.CountTabletki, 0) = 0 THEN 0 ELSE Round(tmpDynamicsOrdersEIC.CountTabletki::TFloat / DynamicsOrdersEIC.CountTabletki::TFloat * 100.0 - 100.0, 2) END::TFloat AS DeltaTabletki
          , CASE WHEN COALESCE(DynamicsOrdersEIC.CountLiki24, 0) = 0 THEN 0 ELSE Round(tmpDynamicsOrdersEIC.CountLiki24::TFloat / DynamicsOrdersEIC.CountLiki24::TFloat * 100.0 - 100.0, 2) END::TFloat       AS DeltaLiki24
          , CASE WHEN COALESCE(DynamicsOrdersEIC.CountAll, 0) = 0 THEN 0 ELSE Round(tmpDynamicsOrdersEIC.CountAll::TFloat / DynamicsOrdersEIC.CountAll::TFloat * 100.0 - 100.0, 2) END::TFloat                AS DeltaAll
     FROM tmpDynamicsOrdersEICSum AS tmpDynamicsOrdersEIC
     
          LEFT JOIN tmpDynamicsOrdersEICSum AS DynamicsOrdersEIC
                                            ON DynamicsOrdersEIC.OperDateStart =  tmpDynamicsOrdersEIC.OperDateStart - INTERVAL '1 MONTH'
          
     WHERE tmpDynamicsOrdersEIC.OperDateStart >= '01.04.2021'::TDateTime
     ORDER BY  tmpDynamicsOrdersEIC.OperDateStart;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.07.21                                                       * 
*/

-- тест

select * FROM gpReport_TelegramBot_DynamicsDeltaMonthEIC(inSession := '3');