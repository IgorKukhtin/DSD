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
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);


      --
      --inProcName:= '';

      RETURN QUERY
        WITH tmpProcess AS (SELECT * FROM pg_stat_activity WHERE state ILIKE 'active' AND COALESCE (client_addr :: TVarChar, '') NOT ILIKE '192.168.0.199%')
         , tmpCount_all AS (SELECT COUNT (*) :: Integer AS Res FROM tmpProcess WHERE query ILIKE ('%' || inProcName || '(%')
                                                                                 --
                                                                                 AND inProcName NOT ILIKE '%Inventory%'
                                                                                 --
                                                                                 AND inProcName NOT ILIKE '%Complete_Movement_PersonalService%'
                                                                                 AND inProcName NOT ILIKE '%gpUpdate_Status_PersonalService%'
                          UNION ALL
                           SELECT COUNT (*) :: Integer AS Res FROM tmpProcess WHERE query ILIKE ('%Inventory%') AND inProcName ILIKE '%Inventory%'
                          UNION ALL
                           SELECT COUNT (*) :: Integer AS Res FROM tmpProcess WHERE (query ILIKE ('%Complete_Movement_PersonalService%')
                                                                                  OR query ILIKE ('%gpUpdate_Status_PersonalService%')
                                                                                    )
                                                                                AND (inProcName ILIKE '%Complete_Movement_PersonalService%'
                                                                                  OR inProcName ILIKE '%gpUpdate_Status_PersonalService%'
                                                                                    )
                          )
            , tmpCount AS (SELECT SUM (COALESCE (tmpCount_all.Res, 0)) :: Integer AS Res FROM tmpCount_all
                          )
            , tmpSecond AS (SELECT CASE WHEN vbUserId = 6561986 -- Брикова В.В.
                                          OR vbUserId = 5
                                             THEN 0

                                        WHEN 25 < (SELECT COUNT(*) FROM tmpProcess)
                                             THEN 60

                                        WHEN CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) BETWEEN 1 AND 10 THEN 0 ELSE 2 END
                                               < (SELECT tmpCount.Res FROM tmpCount)
                                             AND (inProcName ILIKE 'gpReport_JuridicalCollation'
                                                 )
                                             THEN 25

                                        WHEN 0 < (SELECT tmpCount.Res FROM tmpCount)
                                             AND (inProcName ILIKE 'gpReport_MotionGoods'
                                               OR inProcName ILIKE 'gpUpdate_Movement_ReturnIn_Auto'
                                                 )
                                             THEN 25

                                        WHEN 1 < (SELECT tmpCount.Res FROM tmpCount)
                                             AND (inProcName ILIKE 'gpReport_GoodsBalance'
                                               OR inProcName ILIKE 'gpReport_GoodsBalance_Server'
                                                 )
                                             THEN 25

                                        WHEN inProcName ILIKE 'gpReport_MotionGoods'
                                          OR inProcName ILIKE 'gpUpdate_Movement_ReturnIn_Auto'
                                          --
                                          OR inProcName ILIKE 'gpReport_GoodsBalance'
                                          OR inProcName ILIKE 'gpReport_GoodsBalance_Server'
                                          --
                                          OR inProcName ILIKE 'gpReport_JuridicalCollation'
                                          
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
-- SELECT * FROM gpCheck_Object_ReportPriority (inProcName:= 'Inventory', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpCheck_Object_ReportPriority (inProcName:= 'gpReport_MotionGoods', inSession:= zfCalc_UserAdmin())
