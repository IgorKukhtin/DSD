-- Function: gpGet_byBarcode()

DROP FUNCTION IF EXISTS gpGet_byBarcode ( TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (BarCode    TVarChar
             , PartNumber TVarChar
             , Amount     TFloat
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

       SELECT inBarCode    AS BarCode
            , inPartNumber AS PartNumber
            , inAmount     AS Amount;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.22         *
*/

-- тест
-- SELECT * FROM gpGet_byBarcode (inBarCode:= '2210002798265'::TVarChar, inPartNumber:= 'czscz'::TVarChar, inAmount:=0, inSession:= zfCalc_UserAdmin());
