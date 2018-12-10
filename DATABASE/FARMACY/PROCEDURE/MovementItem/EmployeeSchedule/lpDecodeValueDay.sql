-- Function: lpGetEmployeeScheduleDay()

DROP FUNCTION IF EXISTS lpDecodeValueDay(Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpDecodeValueDay(
    IN inId  Integer,       -- ключ Документа
    IN inValue TVarChar
)
  RETURNS TVarChar 
AS
$BODY$
BEGIN
  RETURN(CASE SUBSTRING(inValue, inId, 1)::Integer
                    WHEN 1 THEN '8:00'
                    WHEN 2 THEN '9:00'
                    WHEN 3 THEN '10:00'
                    ELSE NULL END);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpDecodeValueDay (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.12.18                                                       *
*/

-- тест
-- select * from lpDecodeValueDay(inId := 2, inValue := '0100000000000000000000000000000');