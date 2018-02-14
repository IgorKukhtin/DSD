-- Function: gpGet_ReportName_SaleReturnId()

DROP FUNCTION IF EXISTS gpGet_ReportName_SaleReturnId (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_ReportName_SaleReturnId (
    IN inMovementId          Integer  , -- 
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

       -- Результат
       SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'Print_Check' ELSE 'Print_Check_GoodsAccount' END
              INTO vbPrintFormName
       FROM Movement
       WHERE Movement.Id = inMovementId
       ;

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.18         *
*/

-- тест
-- SELECT * FROM gpGet_ReportName_SaleReturnId (inMovementId:= 1, inSession:= '5'); -- test