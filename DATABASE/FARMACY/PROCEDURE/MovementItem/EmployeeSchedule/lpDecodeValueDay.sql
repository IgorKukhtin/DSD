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
                    WHEN 4 THEN '7:00'
                    WHEN 5 THEN '12:00'
                    WHEN 7 THEN '21:00'
                    WHEN 9 THEN 'В'
                    ELSE NULL END);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpDecodeValueDay (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.05.19                                                       *
 11.12.18                                                       *
 09.12.18                                                       *
*/

-- тест
-- select * from lpDecodeValueDay(inId := 2, inValue := '0400000000000000000000000000000');