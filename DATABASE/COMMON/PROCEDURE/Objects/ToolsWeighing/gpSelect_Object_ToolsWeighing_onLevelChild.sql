-- Function: gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_onLevelChild(
    IN inBrancCode    Integer
  , IN inLevelChild  TVarChar
  , IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Number     Integer
             , Id         Integer
             , Code       Integer
             , Name       TVarChar
             , Value      TVarChar
               )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCount      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    IF inLevelChild = 'Service'
    THEN
    -- Результат
    RETURN QUERY
       SELECT 0 AS Number
            , 0 AS Id
            , 0 AS Code
            , tmp.Name :: TVarChar AS Name
            , gpGet_ToolsWeighing_Value ('Scale_' || inBrancCode, inLevelChild, '', tmp.Name, '1', inSession) AS Value
       FROM (SELECT 'SecondBeforeComplete' :: TVarChar AS Name
            ) AS tmp
       ORDER BY 1
       ;

    ELSE
    IF inLevelChild = 'Default'
    THEN
    -- Результат
    RETURN QUERY
       SELECT 0 AS Number
            , 0 AS Id
            , 0 AS Code
            , tmp.Name :: TVarChar AS Name
            , gpGet_ToolsWeighing_Value ('Scale_' || inBrancCode, inLevelChild, '', tmp.Name, CASE WHEN SUBSTRING (tmp.Name FROM 1 FOR 2) = 'is' THEN 'FALSE' ELSE '1' END, inSession) AS Value
       FROM (SELECT 'MovementNumber'         AS Name
       UNION SELECT 'TareCount'              AS Name
       UNION SELECT 'TareWeightNumber'       AS Name
       UNION SELECT 'ChangePercentAmountNumber' AS Name
       UNION SELECT 'PriceListNumber'        AS Name

       UNION SELECT 'isPreviewPrint'         AS Name
       UNION SELECT 'isTareWeightEnter'      AS Name

       UNION SELECT 'DayPrior_PriceReturn' AS Name
            ) AS tmp
       ORDER BY 1
       ;

    ELSE

    IF inLevelChild = 'TareCount'
    THEN
    -- определяется кол-во
    vbCount:= (SELECT gpGet_ToolsWeighing_Value ('Scale_'||inBrancCode, inLevelChild, '', 'Count', '1', inSession));
    -- Результат
    RETURN QUERY
       SELECT tmp.Number
            , 0 AS Id
            , 0 AS Code
            , '' :: TVarChar AS Name
            , '' :: TVarChar AS Value
       FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
      ;

    ELSE

    -- определяется кол-во
    vbCount:= (SELECT gpGet_ToolsWeighing_Value ('Scale_'||inBrancCode, inLevelChild, '', 'Count', '1', inSession));
    -- Результат
    RETURN QUERY
       SELECT tmp.Number
            , Object.Id
            , CASE WHEN inLevelChild = 'TareWeight'
                        THEN tmp.Number
                   WHEN inLevelChild = 'ChangePercentAmount'
                        THEN tmp.Number
                   ELSE Object.ObjectCode
              END :: Integer AS Code
            , CASE WHEN inLevelChild = 'TareWeight'
                        THEN tmp.Value || ' ' || Object_Measure.ValueData
                   WHEN inLevelChild = 'ChangePercentAmount'
                        THEN tmp.Value || ' %'
                   ELSE Object.ValueData
              END :: TVarChar AS Name
            , tmp.Value
       FROM (SELECT tmp.Number
                  , gpGet_ToolsWeighing_Value ('Scale_' || inBrancCode, inLevelChild, '', inLevelChild || CASE WHEN inLevelChild = 'PriceList' THEN 'Id' ELSE '' END || '_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, '0', inSession) AS Value
             FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
            ) AS tmp
            LEFT JOIN Object ON Object.Id = CAST (CASE WHEN tmp.Value <> '' AND inLevelChild = 'PriceList' THEN tmp.Value END AS Integer)
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = zc_Measure_Kg()
      UNION ALL
       SELECT 1000 AS Number
            , 0 AS Id
            , 0 AS Code
            , 'ввод вес тары' :: TVarChar  AS Name
            , '0' :: TVarChar AS Value
       FROM gpGet_ToolsWeighing_Value ('Scale_' || inBrancCode, 'Default', '', 'isTareWeightEnter', 'FALSE', inSession) AS tmp
       WHERE inLevelChild = 'TareWeight'
         AND tmp.tmp = 'TRUE'
       ORDER BY 1
       ;
    END IF;
    END IF;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.01.15                                        * all
 21.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (1, 'Default', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (1, 'Service', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (1, 'PriceList', zfCalc_UserAdmin())
