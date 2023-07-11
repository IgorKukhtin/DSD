-- Function: gpGet_FulfillmentPlanMobileApp()

DROP FUNCTION IF EXISTS gpGet_FulfillmentPlanMobileApp (TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_FulfillmentPlanMobileApp (
    IN inOperDate     TDateTime , --
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS TABLE (VisibleFielda Boolean)
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- Результат
     RETURN QUERY
     SELECT date_trunc('month', inOperDate) < '01.07.2023';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 11.07.23                                                        * 
*/

-- тест
-- SELECT * FROM gpGet_FulfillmentPlanMobileApp (inOperDate := ('22.07.2023')::TDateTime , inSession:= '3'); 