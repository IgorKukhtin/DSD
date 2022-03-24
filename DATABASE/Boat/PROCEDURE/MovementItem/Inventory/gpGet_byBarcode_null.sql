-- Function: gpGet_byBarcode_null()

DROP FUNCTION IF EXISTS gpGet_byBarcode_null (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_byBarcode_null(
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

       SELECT ''::TVarChar AS BarCode
            , ''::TVarChar AS PartNumber
            , 1 ::TFloat   AS Amount;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.22         *
*/

-- тест
-- SELECT * FROM gpGet_byBarcode_null (inSession:= zfCalc_UserAdmin());
