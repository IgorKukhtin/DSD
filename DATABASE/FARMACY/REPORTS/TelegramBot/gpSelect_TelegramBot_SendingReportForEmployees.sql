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
/*     SELECT 1, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckSiteCount (''3'')'::TVarChar
     UNION ALL
*/
     SELECT 2, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824,908475844'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsOrdersEIC (''3'')'::TVarChar
/*     UNION ALL
     SELECT 3, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsDeltaEIC (''3'')'::TVarChar
     UNION ALL
     SELECT 4, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsDeltaWeekEIC (''3'')'::TVarChar
*/
     UNION ALL
     SELECT 5, (CURRENT_DATE + INTERVAL '18 HOUR')::TDateTime, '568330367,300408824,908475844'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckDeliverySite (''3'')'::TVarChar
     UNION ALL
     SELECT 6, (DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') + INTERVAL '1 MONTH' + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824,908475844'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsDeltaMonthEIC (''3'')'::TVarChar
     UNION ALL
     SELECT 7, (DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') + INTERVAL '1 MONTH' + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824,908475844'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckSiteCountMonth (''3'')'::TVarChar

     UNION ALL
     SELECT 8, (CURRENT_DATE + INTERVAL '9 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckRed (''3'')'::TVarChar
     UNION ALL
     SELECT 9, (CURRENT_DATE + INTERVAL '12 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckRed (''3'')'::TVarChar
     UNION ALL
     SELECT 10, (CURRENT_DATE + INTERVAL '18 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckRed (''3'')'::TVarChar
     UNION ALL
     SELECT 11, (CURRENT_DATE + INTERVAL '21 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckRed (''3'')'::TVarChar
     UNION ALL
     SELECT 12, (CURRENT_DATE + INTERVAL '8 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_PublishedSite (''3'')'::TVarChar
     UNION ALL
     SELECT 13, (DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') + INTERVAL '1 MONTH' + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824,908475844'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_PopulMobileApplication (''3'')'::TVarChar
     UNION ALL
     SELECT 14, (CURRENT_DATE + INTERVAL '11 HOUR')::TDateTime, '568330367,300408824,1612960715'::TVarChar, ''::TVarChar
     UNION ALL
     SELECT 14, (CURRENT_DATE + INTERVAL '17 HOUR')::TDateTime, '568330367,300408824,1612960715'::TVarChar, ''::TVarChar

/*     UNION ALL
     SELECT 100, CURRENT_DATE::TDateTime, ''::TVarChar, 'SELECT * FROM gpSelect_TelegramBot_TestMessage (:OperDate, ''3'')'::TVarChar*/
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