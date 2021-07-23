-- Function: gpReport_TelegramBot_DynamicsDeltaWeekEIC()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_DynamicsDeltaWeekEIC (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_DynamicsDeltaWeekEIC(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , CountNeBoley Integer
             , CountTabletki Integer
             , CountLiki24 Integer
             , CountAll Integer
             , CountNeBoleyPrev Integer
             , CountTabletkiPrev Integer
             , CountLiki24Prev Integer
             , CountAllPrev Integer
             , DeltaNeBoley TFloat
             , DeltaTabletki TFloat
             , DeltaLiki24 TFloat
             , DeltaAll TFloat
             
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
                                        , date_part('DOW', DynamicsOrdersEIC.OperDate) AS WeekId
                                   FROM gpReport_Movement_DynamicsOrdersEIC(inStartDate := '08.06.2021'::TDateTime - INTERVAL '7 DAY'
                                                                          , inEndDate := CURRENT_DATE - INTERVAL '1 DAY'
                                                                          , inSession := inSession) AS DynamicsOrdersEIC)
     SELECT tmpDynamicsOrdersEIC.OperDate
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
     FROM tmpDynamicsOrdersEIC
     
          LEFT JOIN tmpDynamicsOrdersEIC AS DynamicsOrdersEIC
                                         ON DynamicsOrdersEIC.OperDate =  tmpDynamicsOrdersEIC.OperDate - INTERVAL '7 DAY'
          
     WHERE tmpDynamicsOrdersEIC.OperDate >= '09.06.2021'::TDateTime
       AND tmpDynamicsOrdersEIC.WeekId = date_part('DOW', CURRENT_DATE - INTERVAL '1 DAY');

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

select * FROM gpReport_TelegramBot_DynamicsDeltaWeekEIC(inSession := '3');