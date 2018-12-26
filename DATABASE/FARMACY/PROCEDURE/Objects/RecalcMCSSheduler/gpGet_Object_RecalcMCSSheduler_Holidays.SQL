DROP FUNCTION IF EXISTS gpGet_Object_RecalcMCSSheduler_Holidays(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RecalcMCSSheduler_Holidays(
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TABLE (BeginHolidays TDateTime
             , EndHolidays TDateTime
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbId Integer;
BEGIN
    -- Результат

    IF EXISTS (SELECT 1 FROM Object WHERE DescId = zc_Object_RecalcMCSSheduler())
    THEN
      SELECT Min(Id)
      INTO vbId
      FROM Object
      WHERE DescId = zc_Object_RecalcMCSSheduler();

      RETURN QUERY
            SELECT
                 ObjectDate_BeginHolidays.ValueData     AS Period
               , ObjectDate_EndHolidays.ValueData       AS Period1
            FROM
                Object AS Object_RecalcMCSSheduler

                 LEFT JOIN ObjectDate AS ObjectDate_BeginHolidays
                                       ON ObjectDate_BeginHolidays.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectDate_BeginHolidays.DescId = zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays()
                 LEFT JOIN ObjectDate AS ObjectDate_EndHolidays
                                       ON ObjectDate_EndHolidays.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectDate_EndHolidays.DescId = zc_ObjectFloat_RecalcMCSSheduler_EndHolidays()
            WHERE
                Object_RecalcMCSSheduler.Id = vbId;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RecalcMCSSheduler_Holidays(TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий. О.В.
 25.12.18                                                                       *
*/

-- тест
-- select * from gpGet_Object_RecalcMCSSheduler_Holidays(inSession := '3');