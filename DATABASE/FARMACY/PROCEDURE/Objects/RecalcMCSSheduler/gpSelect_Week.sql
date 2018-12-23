-- Function: gpSelect_Week()

DROP FUNCTION IF EXISTS gpSelect_Week(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Week(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS TABLE (
     Id Integer, 
     Name TVarChar
     )
AS
$BODY$
BEGIN

  RETURN QUERY
  SELECT 1::Integer, 'Понедельник'::TVarChar
  UNION ALL
  SELECT 2::Integer, 'Вторник'::TVarChar
  UNION ALL
  SELECT 3::Integer, 'Среда'::TVarChar
  UNION ALL
  SELECT 4::Integer, 'Четверг'::TVarChar
  UNION ALL
  SELECT 5::Integer, 'Пятница'::TVarChar
  UNION ALL
  SELECT 6::Integer, 'Суббота'::TVarChar
  UNION ALL
  SELECT 7::Integer, 'Воскресенье'::TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Week (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.12.18                                                       *
*/

-- тест
-- select * from gpSelect_Week(inSession := '3');