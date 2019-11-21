-- Function: gpSelect_Object_GlobalConst()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst(
    IN inIP          TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar, EnumName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbValueData_new TVarChar;
   DECLARE vbOperDate_new TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
       WITH tmpProcess AS (SELECT ROW_NUMBER() OVER (ORDER BY query_start) AS Ord
                                , *
                           FROM pg_stat_activity WHERE state = 'active' and query NOT LIKE '%gpSelect_Object_GlobalConst%')
          , tmpProcess_All AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess)
          , tmpProcess_HistoryCost AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpInsertUpdate_HistoryCost%' OR query LIKE '%gpComplete_All_Sybase%')
          , tmpProcess_Cash AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Cash%')
          , tmpProcess_Check AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Check%')
          , tmpProcess_Send AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Send%')
          , tmpProcess_Inv AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Inventory%')
          , tmpProcess_RepOth AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpReport%')
          , tmpProcess_Vacuum AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%VACUUM%')
       -- Результат
       SELECT 1::Integer AS Id
            , CURRENT_TIMESTAMP::TDateTime AS OperDate
            , ('Кол-во АП = <' || COALESCE ((SELECT Res FROM tmpProcess_All), '0') || '> из которых :'

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') <> '0'
                                       THEN ' Чеки. = <' || COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Vacuum), '0') <> '0'
                                       THEN ' ВАКУУМ = <' || COALESCE ((SELECT Res FROM tmpProcess_Vacuum), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') <> '0'
                                       THEN ' Касса. = <'   || COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Inv), '0') <> '0'
                                       THEN ' Инвент. = <' || COALESCE ((SELECT Res FROM tmpProcess_Inv), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Send), '0') <> '0'
                                       THEN ' Перем. = <' || COALESCE ((SELECT Res FROM tmpProcess_Send), '0') || '>'
                                  ELSE ''
                             END

                          || ' Отч. = <'   || COALESCE ((SELECT Res FROM tmpProcess_RepOth), '0') || '>'

                 ) :: TVarChar AS ValueText
            , '' :: TVarChar AS EnumName
       UNION ALL
       SELECT (Ord + 1)::Integer, query_start:: TDateTime , query:: TVarChar , ''::TVarChar
       FROM tmpProcess
       WHERE tmpProcess.Ord <= 3
       ORDER BY 1
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst (TVarChar, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий. О.В.
 21.11.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GlobalConst ('', zfCalc_UserAdmin())