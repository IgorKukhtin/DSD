-- Function: gpGet_Scale_OperDate (TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_Scale_OperDate (TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_OperDate (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_OperDate(
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
      SELECT DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) :: TDateTime AS OperDate;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_OperDate (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_OperDate (zfCalc_UserAdmin())
