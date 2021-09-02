-- Function: gpReport_TelegramBot_CheckSiteCountMonth()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_CheckSiteCountMonth (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_CheckSiteCountMonth(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbCountPrevM Integer;
   DECLARE vbCountCurrM Integer;
   DECLARE vbSummCurrM TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     IF date_part('DAY',  CURRENT_DATE)::Integer = 1
     THEN
       SELECT SUM(Report.CountCurr), SUM(Report.SummCurr)
       INTO vbCountCurrM, vbSummCurrM
       FROM gpReport_Movement_CheckSiteCount(inStartDate := DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY')
                                           , inEndDate := DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY'
                                           , inSession := inSession) AS Report;     
       
       SELECT SUM(Report.CountCurr)
       INTO vbCountPrevM
       FROM gpReport_Movement_CheckSiteCount(inStartDate := DATE_TRUNC ('month', DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY') - INTERVAL '1 DAY')
                                           , inEndDate := DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY') - INTERVAL '1 DAY'
                                           , inSession := inSession) AS Report;     

       -- Результат
       RETURN QUERY
       SELECT 
        ('За '||zfCalc_MonthYearName(DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY'))||CHR(13)||'Чеков '||zfConvert_IntToString (COALESCE(vbCountCurrM, 0))||
           ' на сумму '||zfConvert_FloatToString (COALESCE(vbSummCurrM, 0)::TFloat)||
           ' грн. процент изменения '||CASE WHEN vbCountPrevM < vbCountCurrM THEN ' + ' ELSE '' END||
           zfConvert_FloatToString (COALESCE(CASE WHEN COALESCE(vbCountPrevM, 0) = 0 THEN 0 ELSE Round(vbCountCurrM::TFloat / vbCountPrevM::TFloat * 100.0 - 100.0, 2) END, 0)::TFloat)||' %'      
         )::Text;

     END IF;
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

select * from gpReport_TelegramBot_CheckSiteCountMonth(inSession := '3');     