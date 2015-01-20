-- Function: gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_onLevelChild(
    IN inScaleNum    Integer
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
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, inLevelChild, '', tmp.Name, '1', inSession) AS Value
       FROM (SELECT 'SecondBeforeComplete' AS Name
       UNION SELECT 'isPreviewPrint'       AS Name
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
            , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, inLevelChild, '', tmp.Name, '1', inSession) AS Value
       FROM (SELECT 'MovementNumber'       AS Name
       UNION SELECT 'PriceListNumber'      AS Name
       UNION SELECT 'TareCountNumber'      AS Name
       UNION SELECT 'TareWeightNumber'     AS Name
       UNION SELECT 'ChangePercentNumber'  AS Name
       UNION SELECT 'GoodsKindNumber'      AS Name
            ) AS tmp
       ORDER BY 1
       ;

    ELSE
    -- определяется кол-во
    vbCount:= (SELECT gpGet_ToolsWeighing_Value ('Scale_'||inScaleNum, inLevelChild, '', 'Count', '1', inSession));
    -- Результат
    RETURN QUERY
       SELECT tmp.Number
            , Object.Id
            , Object.ObjectCode AS Code
            , Object.ValueData  AS Name
            , tmp.Value
       FROM (SELECT tmp.Number
                  , gpGet_ToolsWeighing_Value ('Scale_' || inScaleNum, inLevelChild, '', inLevelChild || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, '0', inSession) AS Value
             FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
            ) AS tmp
            LEFT JOIN Object ON Object.Id = CAST (CASE WHEN tmp.Value <> '' AND inLevelChild = 'PriceList' THEN tmp.Value END AS Integer)
       ORDER BY 1
       ;
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
