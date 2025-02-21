-- 
DROP FUNCTION IF EXISTS gpGet_Object_MessagePersonalServiceLast (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MessagePersonalServiceLast(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (SessionCode Integer
             , StartDate TDateTime, EndDate TDateTime
              )
AS
$BODY$
 DECLARE vbCode Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MessagePersonalService());

  vbCode := (SELECT MAX (Object.ObjectCode) FROM Object WHERE Object.DescId = zc_Object_MessagePersonalService());

  RETURN QUERY
  SELECT vbCode                            AS SessionCode
       , MIN (ObjectDate_Insert.ValueData) ::TDateTime AS StartDate
       , MAX (ObjectDate_Insert.ValueData) ::TDateTime AS EndDate
  FROM Object AS Object_MessagePersonalService
       LEFT JOIN ObjectDate AS ObjectDate_Insert
                            ON ObjectDate_Insert.ObjectId = Object_MessagePersonalService.Id
                           AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert() 
  WHERE Object_MessagePersonalService.DescId = zc_Object_MessagePersonalService()
    AND Object_MessagePersonalService.ObjectCode = vbCode;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.25         *
*/

-- тест
--  SELECT * FROM gpGet_Object_MessagePersonalServiceLast ('2'::TVarChar)
