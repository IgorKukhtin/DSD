-- Function: gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_onLevelChild (Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_onLevelChild(
    IN inIsCeh       Boolean   , --
    IN inBranchCode  Integer
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

   DECLARE vbIsSticker  Boolean;
   DECLARE vbLevelMain  TVarChar;
   DECLARE vbCount      Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!очень важно - захардкодили главную ветку!!!
    vbLevelMain:= CASE WHEN inIsCeh = TRUE THEN 'ScaleCeh_' || inBranchCode ELSE 'Scale_' || inBranchCode END;


    -- !!!важно - Печать этикеток - определили по BranchCode!!!
    vbIsSticker:= inBranchCode > 1000;


    IF inLevelChild = 'Service'
    THEN
    -- Результат
    RETURN QUERY
       SELECT 0 AS Number
            , 0 AS Id
            , 0 AS Code
            , tmp.Name :: TVarChar AS Name
            , gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', tmp.Name, '1', inSession) AS Value
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
                , gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', tmp.Name
                                           , CASE WHEN STRPOS (tmp.Name, 'Exception_WeightDiff') > 0
                                                       THEN '0.010'
                                                  WHEN STRPOS (tmp.Name, 'Weight') > 0
                                                       THEN '0'
                                                  WHEN STRPOS (tmp.Name, 'InfoMoneyId_income') > 0
                                                       THEN '0'
                                                  WHEN STRPOS (tmp.Name, 'InfoMoneyId_sale') > 0
                                                       THEN zc_Enum_InfoMoney_30101() :: TVarChar -- Доходы + Продукция + Готовая продукция
                                                  WHEN STRPOS (tmp.Name, 'isPrintPreview') > 0
                                                       THEN 'TRUE'
                                                  WHEN STRPOS (tmp.Name, 'isBarCode') > 0
                                                       THEN 'TRUE'
                                                  WHEN STRPOS (tmp.Name, 'isGoodsComplete') > 0
                                                       THEN 'TRUE'
                                                  WHEN STRPOS (tmp.Name, 'isCloseInventory') > 0
                                                       THEN 'TRUE'

                                                  WHEN STRPOS (tmp.Name, 'isPersonalStick')  > 0
                                                    OR ((STRPOS (tmp.Name, 'isPersonalComplete') > 0)
                                                    AND (LENGTH (tmp.Name) = LENGTH ('isPersonalComplete1'))
                                                       )
                                                       THEN 'TRUE'

                                                  -- !!! всем остальным
                                                  WHEN SUBSTRING (tmp.Name FROM 1 FOR 2) = 'is'
                                                       THEN 'FALSE'

                                                  WHEN STRPOS (tmp.Name, 'Id') > 0
                                                       THEN '0'
                                                  WHEN STRPOS (tmp.Name, 'DiffSaleOrder') > 0
                                                       THEN '20'

                                                  WHEN STRPOS (tmp.Name, 'LightColor_1') > 0
                                                       THEN '1118719'  -- Red
                                                  WHEN STRPOS (tmp.Name, 'LightColor_2') > 0
                                                       THEN '8978431'  -- Yelow
                                                  WHEN STRPOS (tmp.Name, 'LightColor_3') > 0
                                                       THEN '11987626' -- GreenL
                                                       
                                                  WHEN STRPOS (tmp.Name, 'PeriodPartionGoodsDate') > 0
                                                       THEN '100'
                                                       
                                                  WHEN STRPOS (tmp.Name, 'Limit_Second_save_MI') > 0
                                                       THEN '0'
                                                       
                                                  ELSE '1'
                                             END
                                           , inSession) AS Value
           FROM (SELECT 'MovementNumber'            AS Name
           UNION SELECT 'TareCount'                 AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'TareWeightNumber'          AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'ChangePercentAmountNumber' AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'PriceListNumber'           AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE

           UNION SELECT 'PrintCount'             AS Name
           UNION SELECT 'isPrintPreview'         AS Name

           UNION SELECT 'isSticker_Weight'       AS Name WHERE vbIsSticker = TRUE
           UNION SELECT 'isBarCode'              AS Name WHERE inIsCeh = FALSE
           UNION SELECT 'isTareWeightEnter'      AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalComplete'     AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalComplete1'    AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalComplete2'    AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalComplete3'    AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalComplete4'    AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalComplete5'    AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalStick1'       AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPersonalLoss'         AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isTax'                  AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isTransport'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isEnterPrice'           AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isDriverReturn'         AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isCheckDelete'          AS Name WHERE inIsCeh = FALSE
           UNION SELECT 'isPartionDate'          AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isReason'               AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isPartionGoods_20103'   AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'isAsset'                AS Name WHERE/*inIsCeh = FALSE AND*/ vbIsSticker = FALSE
           UNION SELECT 'isReReturnIn'           AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
         --UNION SELECT 'isCloseInventory'       AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
         --UNION SELECT 'isCloseInventory'       AS Name WHERE inIsCeh = TRUE  AND vbIsSticker = FALSE

           -- Режим ScaleCeh - маркировка/сортировка
           UNION SELECT 'isModeSorting'          AS Name WHERE inIsCeh = TRUE
           UNION SELECT 'LightColor_1'           AS Name WHERE inIsCeh = TRUE
           UNION SELECT 'LightColor_2'           AS Name WHERE inIsCeh = TRUE
           UNION SELECT 'LightColor_3'           AS Name WHERE inIsCeh = TRUE
           

           UNION SELECT 'DayPrior_PriceReturn'   AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE

           UNION SELECT 'Limit_Second_save_MI'   AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE

           UNION SELECT 'isGoodsComplete'        AS Name
           UNION SELECT 'InfoMoneyId_income'     AS Name WHERE 1=0 AND inIsCeh = FALSE
           UNION SELECT 'InfoMoneyId_sale'       AS Name WHERE 1=0 AND inIsCeh = FALSE

           UNION SELECT 'isBox'                  AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'BoxCount'               AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'BoxCode'                AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE

           UNION SELECT 'Exception_WeightDiff'   AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE

           UNION SELECT 'WeightSkewer1'          AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE
           UNION SELECT 'WeightSkewer2'          AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE

           UNION SELECT 'WeightTare1'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare2'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare3'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare4'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare5'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare6'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare7'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare8'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare9'            AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE
           UNION SELECT 'WeightTare10'           AS Name WHERE inIsCeh = FALSE AND vbIsSticker = FALSE

           UNION SELECT 'isCalc_sht'             AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE

           UNION SELECT 'isGet_Unit'             AS Name WHERE /*inIsCeh = FALSE AND*/ vbIsSticker = FALSE

           UNION SELECT 'UnitId1'                AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE
           UNION SELECT 'UnitId2'                AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE
           UNION SELECT 'UnitId3'                AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE
           UNION SELECT 'UnitId4'                AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE
           UNION SELECT 'UnitId5'                AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE

           UNION SELECT 'UnitId1_sep'            AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE
           UNION SELECT 'UnitId2_sep'            AS Name WHERE inIsCeh = TRUE AND vbIsSticker = FALSE

           UNION SELECT 'PeriodPartionGoodsDate' AS Name WHERE /*inIsCeh = TRUE AND*/ vbIsSticker = FALSE

           UNION SELECT 'BranchId'               AS Name WHERE inIsCeh = FALSE
           UNION SELECT 'DiffSaleOrder'          AS Name WHERE inIsCeh = FALSE
           
           UNION SELECT 'isOperDatePartner'      AS Name WHERE inIsCeh = FALSE

                ) AS tmp
           ORDER BY 1
           ;

        ELSE

            IF inLevelChild = 'TareCount' AND inIsCeh = FALSE AND vbIsSticker = FALSE
            THEN
            -- определяется кол-во
            vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', 'Count', '1', inSession));
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

            IF inLevelChild = 'PrinterSticker' -- AND vbIsSticker = TRUE
            THEN
            -- определяется кол-во
            vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', 'Count', CASE WHEN inIsCeh = TRUE THEN '1' ELSE '2' END, inSession));
            --
            IF COALESCE (vbCount, 0) = 0
            THEN
                 RAISE EXCEPTION 'Ошибка.vbCount = <%> <%> <%>', vbCount, vbLevelMain, inLevelChild;
            END IF;
            -- Результат
            RETURN QUERY
               SELECT tmp.Number
                    , 0          AS Id
                    , tmp.Number AS Code
                    , tmp.Value  AS Name
                    , tmp.Value  AS Value
               FROM (SELECT tmp.Number
                          , gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', inLevelChild || '_' || tmp.Number, CASE WHEN inIsCeh = TRUE THEN 'not print' ELSE inLevelChild || '_' || tmp.Number END, inSession) AS Value
                     FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
                    ) AS tmp
              ;

            ELSE

                IF inIsCeh = FALSE AND vbIsSticker = FALSE
                THEN
                    -- определяется кол-во
                    vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', 'Count', '1', inSession));
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
                                  , gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', inLevelChild || CASE WHEN inLevelChild = 'PriceList' THEN 'Id' ELSE '' END || '_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, '0', inSession) AS Value
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
                       FROM gpGet_ToolsWeighing_Value (vbLevelMain, 'Default', '', 'isTareWeightEnter', 'FALSE', inSession) AS tmp
                       WHERE inLevelChild = 'TareWeight'
                         AND tmp.tmp = 'TRUE'
                       ORDER BY 1
                       ;
                END IF;
            END IF;
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
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (TRUE, 201, 'PrinterSticker', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (TRUE, 1, 'Service', zfCalc_UserAdmin())
--
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 1, 'PriceList', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 4, 'Default', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 1, 'Service', zfCalc_UserAdmin()) ORDER BY 4
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 1001, 'PrinterSticker', zfCalc_UserAdmin()) ORDER BY 4
