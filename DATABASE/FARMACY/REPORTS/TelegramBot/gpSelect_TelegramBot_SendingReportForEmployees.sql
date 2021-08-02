-- Function: gpSelect_TelegramBot_SendingReportForEmployees()

DROP FUNCTION IF EXISTS gpSelect_TelegramBot_SendingReportForEmployees (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TelegramBot_SendingReportForEmployees(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , DateSend TDateTime
             , ChatIDList TVarChar
             , SQL TVarChar
             
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
     SELECT 1, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckSiteCount (''3'')'::TVarChar
     UNION ALL
     SELECT 2, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsOrdersEIC (''3'')'::TVarChar
     UNION ALL
     SELECT 3, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsDeltaEIC (''3'')'::TVarChar
     UNION ALL
     SELECT 4, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsDeltaWeekEIC (''3'')'::TVarChar
     UNION ALL
     SELECT 5, (CURRENT_DATE + INTERVAL '18 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckDeliverySite (''3'')'::TVarChar
     UNION ALL
     SELECT 6, (DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') + INTERVAL '1 MONTH' + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsDeltaMonthEIC (''3'')'::TVarChar
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.06.21                                                       * 
*/

-- тест

select * from gpSelect_TelegramBot_SendingReportForEmployees(inSession := '3');