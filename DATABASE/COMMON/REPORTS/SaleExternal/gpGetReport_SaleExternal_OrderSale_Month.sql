-- Function: gpGetReport_SaleExternal_OrderSale_Month()

DROP FUNCTION IF EXISTS gpGetReport_SaleExternal_OrderSale_Month (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGetReport_SaleExternal_OrderSale_Month(
    IN inOperDate           TDateTime , -- месяц прогноза
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Month_1 TVarChar, Month_2 TVarChar, Month_3 TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --определяем период 3 мес для расчета прогноза
     inOperDate  := DATE_TRUNC ('MONTH', inOperDate);  --первое число месяца
     
     RETURN QUERY
 

       -- Результат
       SELECT (inOperDate - INTERVAL '3 MONTH') ::TDateTime AS Month_1
            , (inOperDate - INTERVAL '2 MONTH') ::TDateTime AS Month_2
            , (inOperDate - INTERVAL '1 MONTH') ::TDateTime AS Month_3
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.21          *
*/

-- тест
-- SELECT * FROM gpGetReport_SaleExternal_OrderSale_Month (inOperDate:= '01.01.2021', inSession:= zfCalc_UserAdmin()) 
