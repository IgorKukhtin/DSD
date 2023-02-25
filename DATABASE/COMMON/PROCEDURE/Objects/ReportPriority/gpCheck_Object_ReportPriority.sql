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


      --
      --inProcName:= '';

      RETURN QUERY
        WITH tmpProcess AS (SELECT * FROM pg_stat_activity WHERE state ILIKE 'active')
            , tmpCount AS (SELECT COUNT (*) :: Integer AS Res FROM tmpProcess WHERE query ILIKE ('%' || inProcName || '%'))
            , tmpSecond AS (SELECT CASE WHEN 25 < (SELECT COUNT(*) FROM tmpProcess)
                                             THEN 60

                                        WHEN 2 < (SELECT tmpCount.Res FROM tmpCount)
                                             AND inProcName ILIKE 'gpReport_MotionGoods'
                                             THEN 25

                                        WHEN 1 < (SELECT tmpCount.Res FROM tmpCount)
                                             AND inProcName ILIKE 'gpReport_GoodsBalance'
                                             THEN 25

                                        WHEN inProcName ILIKE 'gpReport_MotionGoods'
                                          OR inProcName ILIKE 'gpReport_GoodsBalance'
                                             THEN 0

                                        WHEN 0 < (SELECT tmpCount.Res FROM tmpCount)
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
                              || ' <' || (SELECT COUNT (*) AS Res FROM tmpProcess) :: TVarChar || '>.'
                              || CHR (13)
                              || 'Время ожидания = <' || tmpSecond.Value :: TVarChar || '> секунд.'

                    WHEN 25 THEN '(' || (SELECT COUNT(*) FROM tmpSecond) :: TVarChar || ') '
                              || 'Ваш запрос не может быть выполнен, т.к. аналогичный запрос уже выполняется'
                              || ' другим' || CASE WHEN 1 < (SELECT tmpCount.Res FROM tmpCount) THEN 'и' ELSE '' END
                              || ' (' || (SELECT tmpCount.Res FROM tmpCount) :: TVarChar || ')'
                              || ' пользовател' || CASE WHEN 1 < (SELECT tmpCount.Res FROM tmpCount) THEN 'ями' ELSE 'ем' END
                              || '.'
                              || CHR (13)
                              || 'Время ожидания = <' || tmpSecond.Value :: TVarChar || '> секунд.'
                              || CHR (13)
                              || 'АП = <' || (SELECT COUNT (*) AS Res FROM tmpProcess) :: TVarChar || '>.'

                    ELSE ' <' || (SELECT COUNT (*) AS Res FROM tmpProcess) :: TVarChar || '>'
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
-- WITH tmpProcess AS (SELECT * FROM pg_stat_activity WHERE state ILIKE 'active') SELECT COUNT(*) FROM tmpProcess WHERE query ILIKE ('%gpReport_MotionGoods%')
-- SELECT * FROM gpCheck_Object_ReportPriority (inProcName:= 'gpReport_MotionGoods', inSession:= zfCalc_UserAdmin())
