-- Function: gpGet_OperDate()

DROP FUNCTION IF EXISTS gpGet_OperDate(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OperDate(
   OUT OperDate              TDateTime,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TDateTime
AS
$BODY$
BEGIN
  OperDate := CURRENT_DATE;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.04.20                                                       *
*/

-- SELECT * FROM gpGet_OperDate (inSession := zfCalc_UserAdmin())