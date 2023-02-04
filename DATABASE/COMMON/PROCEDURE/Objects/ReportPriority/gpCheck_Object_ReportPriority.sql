-- Function: gpCheck_Object_ReportPriority()

DROP FUNCTION IF EXISTS gpCheck_Object_ReportPriority (TVarChar);

CREATE OR REPLACE FUNCTION gpCheck_Object_ReportPriority(
    IN inProcName    TVarChar,           --
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Second_pause   Integer
             , Message_pause  Text
              )
AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReportPriority());

      RETURN QUERY
        WITH tmpProcess AS (SELECT * FROM pg_stat_activity WHERE state ILIKE 'active')
            , tmpSecond AS (SELECT CASE WHEN 25 < (SELECT COUNT(*) FROM tmpProcess)
                                             THEN 60
                                        WHEN 1 < (SELECT COUNT (*) AS Res FROM tmpProcess WHERE query ILIKE ('%' || inProcName || '%'))
                                             THEN 25
                                        ELSE 0
                                   END :: Integer AS Value
                           )
        -- Результат
        SELECT
               -- кол-во секунд ожидания
               tmpSecond.Value AS Second_pause
               -- сообщение во время ожидания
             , CASE tmpSecond.Value

                    WHEN 60 THEN 'Ваш запрос не может быть выполнен. Активных процессов = '
                              || ' <' || (SELECT COUNT (*) AS Res FROM tmpProcess WHERE query ILIKE ('%' || inProcName || '%')) :: TVarChar || '>.'
                              || CHR (13)
                              || 'Время ожидания = <' || tmpSecond.Value :: TVarChar || '> секунд.'

                    WHEN 25 THEN 'Ваш запрос не может быть выполнен, т.к. аналогичный запрос уже выполняется другим пользователем.'
                              || CHR (13)
                              || 'Время ожидания = <' || tmpSecond.Value :: TVarChar || '> секунд.'

                    ELSE ''
               END :: Text AS Message_pause
        FROM tmpSecond
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
  28.04.17                                                       *
*/

-- тест
-- SELECT * FROM gpCheck_Object_ReportPriority (inProcName:= '', inSession:= zfCalc_UserAdmin())
