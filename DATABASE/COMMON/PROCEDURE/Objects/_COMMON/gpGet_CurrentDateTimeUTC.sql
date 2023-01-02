-- Function: gpGet_CurrentDateTimeUTC()

DROP FUNCTION IF EXISTS gpGet_CurrentDateTimeUTC(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CurrentDateTimeUTC(
   OUT outDateTime   TDateTime ,    -- константа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TDateTime
AS
$BODY$
BEGIN
	
  outDateTime := CURRENT_TIMESTAMP at time zone 'UTC';
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_CurrentDateTimeUTC(TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.12.22                                                       *   

*/

-- тест
-- 
select gpGet_CurrentDateTimeUTC('')