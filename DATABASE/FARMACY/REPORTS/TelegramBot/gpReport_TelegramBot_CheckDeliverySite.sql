-- Function: gpReport_TelegramBot_CheckDeliverySite()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_CheckDeliverySite (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_CheckDeliverySite(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbDeliveryCheckCurr Integer;
   DECLARE vbDeliveryCountCurr Integer;
   DECLARE vbDeliverySummCurr TFloat;
   DECLARE vbDeliveryPayCheckCurr Integer;
   DECLARE vbDeliveryPayCountCurr Integer;
   DECLARE vbDeliveryPaySummCurr TFloat;
   DECLARE vbDeliveryPaySummDeliveryCurr TFloat;
   
   DECLARE vbDeliveryCheckCurrM Integer;
   DECLARE vbDeliveryCountCurrM Integer;
   DECLARE vbDeliverySummCurrM TFloat;
   DECLARE vbDeliveryPayCheckCurrM Integer;
   DECLARE vbDeliveryPayCountCurrM Integer;
   DECLARE vbDeliveryPaySummCurrM TFloat;
   DECLARE vbDeliveryPaySummDeliveryCurrM TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     SELECT SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) = 0 THEN 1 ELSE 0 END)
          , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) = 0 THEN Report.TotalCount ELSE 0 END)
          , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) = 0 THEN Report.TotalSumm ELSE 0 END)
          
          , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN 1 ELSE 0 END)
          , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN Report.TotalCount ELSE 0 END)
          , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN Report.TotalSumm ELSE 0 END)
          , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN Report.SummaDelivery ELSE 0 END)
     INTO vbDeliveryCheckCurr, vbDeliveryCountCurr, vbDeliverySummCurr,
          vbDeliveryPayCheckCurr, vbDeliveryPayCountCurr, vbDeliveryPaySummCurr, vbDeliveryPaySummDeliveryCurr
     FROM gpReport_Movement_CheckDeliverySite(inStartDate := CURRENT_DATE - INTERVAL '1 DAY'
                                            , inEndDate := CURRENT_DATE - INTERVAL '1 DAY'
                                            , inIsErased := False
                                            , inSession := inSession) AS Report
     WHERE Report.StatusCode = 2;     
        
     IF date_part('DAY',  CURRENT_DATE)::Integer = 1
     THEN
       SELECT SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) = 0 THEN 1 ELSE 0 END)
            , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) = 0 THEN Report.TotalCount ELSE 0 END)
            , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) = 0 THEN Report.TotalSumm ELSE 0 END)
            
            , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN 1 ELSE 0 END)
            , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN Report.TotalCount ELSE 0 END)
            , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN Report.TotalSumm ELSE 0 END)
            , SUM(CASE WHEN COALESCE (Report.SummaDelivery, 0) <> 0 THEN Report.SummaDelivery ELSE 0 END)
       INTO vbDeliveryCheckCurrM, vbDeliveryCountCurrM, vbDeliverySummCurrM,
            vbDeliveryPayCheckCurrM, vbDeliveryPayCountCurrM, vbDeliveryPaySummCurrM, vbDeliveryPaySummDeliveryCurrM
       FROM gpReport_Movement_CheckDeliverySite(inStartDate := DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY')
                                           , inEndDate := DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY'
                                           , inIsErased := False
                                           , inSession := inSession) AS Report
       WHERE Report.StatusCode = 2;     
       
     END IF;

     -- Результат
     IF COALESCE(vbDeliveryPayCheckCurr, 0) <> 0 OR COALESCE(vbDeliveryCheckCurr, 0) <> 0 OR COALESCE(vbDeliveryPayCheckCurrM, 0) <> 0 OR COALESCE(vbDeliveryCheckCurrM, 0) <> 0
     THEN
       RETURN QUERY
       SELECT 
        ('За '||zfConvert_DateToString(CURRENT_DATE - INTERVAL '1 DAY')||CHR(13)
         ||CASE WHEN COALESCE(vbDeliveryPayCheckCurr, 0) <> 0 
                THEN CHR(13)||'Платная доставка - количество заказов '||zfConvert_IntToString (COALESCE(vbDeliveryPayCheckCurr, 0))||
                     ' на сумму '||zfConvert_FloatToString (COALESCE(vbDeliveryPaySummCurr, 0)::TFloat)||
                     ' грн. сумма доставки '||zfConvert_FloatToString (COALESCE(vbDeliveryPaySummDeliveryCurr, 0)::TFloat)||' грн.'
                ELSE '' END
         ||CASE WHEN COALESCE(vbDeliveryCheckCurr, 0) <> 0 
                THEN CHR(13)||'Бесплатная доставка - количество заказов '||zfConvert_IntToString (COALESCE(vbDeliveryCheckCurr, 0))||
                     ' грн. на сумму '||zfConvert_FloatToString (COALESCE(vbDeliverySummCurr, 0)::TFloat)||' грн.'
                ELSE '' END
        
        
            -- За предыдущий месяц 
         ||CASE WHEN date_part('DAY',  CURRENT_DATE)::Integer = 1 THEN CHR(13)||CHR(13)||
           
           'За '||zfCalc_MonthYearName(DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY'))||CHR(13)
           ||CASE WHEN COALESCE(vbDeliveryPayCheckCurrM, 0) <> 0 
                  THEN CHR(13)||'Платная доставка - количество заказов '||zfConvert_IntToString (COALESCE(vbDeliveryPayCheckCurrM, 0))||
                       ' на сумму '||zfConvert_FloatToString (COALESCE(vbDeliveryPaySummCurrM, 0)::TFloat)||
                       ' грн. сумма доставки '||zfConvert_FloatToString (COALESCE(vbDeliveryPaySummDeliveryCurrM, 0)::TFloat)||' грн.'
                  ELSE '' END
           ||CASE WHEN COALESCE(vbDeliveryCheckCurrM, 0) <> 0
                  THEN CHR(13)||'Бесплатная доставка - количество заказов '||zfConvert_IntToString (COALESCE(vbDeliveryCheckCurrM, 0))||
                       ' на сумму '||zfConvert_FloatToString (COALESCE(vbDeliverySummCurrM, 0)::TFloat)||' грн.'
                  ELSE '' END
         ELSE '' END
         )::Text;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_TelegramBot_CheckDeliverySite (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.06.21                                                       * 
*/

-- тест

select * from gpReport_TelegramBot_CheckDeliverySite(inSession := '3');     