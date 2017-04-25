-- Function: gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_onLevelChild (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_onLevelChild (Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_onLevelChild(
    IN inIsCeh       Boolean   , --
    IN inBranchCode  Integer
  , IN inLevelChild  TVarChar
  , IN inSession     TVarChar       -- ������ ������������
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

   DECLARE vbLevelMain  TVarChar;
   DECLARE vbCount      Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!����� ����� - ������������ ������� �����!!!
    vbLevelMain:= CASE WHEN inIsCeh = TRUE THEN 'ScaleCeh_' || inBranchCode ELSE 'Scale_' || inBranchCode END;


    IF inLevelChild = 'Service'
    THEN
    -- ���������
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
    -- ���������
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
                                                   THEN zc_Enum_InfoMoney_30101() :: TVarChar -- ������ + ��������� + ������� ���������
                                              WHEN STRPOS (tmp.Name, 'isPrintPreview') > 0
                                                   THEN 'TRUE'
                                              WHEN STRPOS (tmp.Name, 'isBarCode') > 0
                                                   THEN 'TRUE'
                                              WHEN STRPOS (tmp.Name, 'isGoodsComplete') > 0
                                                   THEN 'TRUE'
                                              WHEN SUBSTRING (tmp.Name FROM 1 FOR 2) = 'is'
                                                   THEN 'FALSE'
                                              ELSE '1'
                                         END
                                       , inSession) AS Value
       FROM (SELECT 'MovementNumber'            AS Name
       UNION SELECT 'TareCount'                 AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'TareWeightNumber'          AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'ChangePercentAmountNumber' AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'PriceListNumber'           AS Name WHERE inIsCeh = FALSE

       UNION SELECT 'PrintCount'             AS Name
       UNION SELECT 'isPrintPreview'         AS Name

       UNION SELECT 'isBarCode'              AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isTareWeightEnter'      AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isPersonalComplete'     AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isPersonalLoss'         AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isTax'                  AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isTransport'            AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isEnterPrice'           AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'isDriverReturn'         AS Name WHERE inIsCeh = FALSE

       UNION SELECT 'DayPrior_PriceReturn' AS Name WHERE inIsCeh = FALSE

       UNION SELECT 'isGoodsComplete'    AS Name
       UNION SELECT 'InfoMoneyId_income' AS Name WHERE 1=0 AND inIsCeh = FALSE
       UNION SELECT 'InfoMoneyId_sale'   AS Name WHERE 1=0 AND inIsCeh = FALSE

       UNION SELECT 'isBox'              AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'BoxCount'           AS Name WHERE inIsCeh = FALSE
       UNION SELECT 'BoxCode'            AS Name WHERE inIsCeh = FALSE

       UNION SELECT 'Exception_WeightDiff' AS Name WHERE inIsCeh = FALSE

       UNION SELECT 'WeightSkewer1'        AS Name WHERE inIsCeh = TRUE
       UNION SELECT 'WeightSkewer2'        AS Name WHERE inIsCeh = TRUE

       UNION SELECT 'PeriodPartionGoodsDate' AS Name WHERE inIsCeh = TRUE

            ) AS tmp
       ORDER BY 1
       ;

    ELSE

    IF inLevelChild = 'TareCount' AND inIsCeh = FALSE
    THEN
    -- ������������ ���-��
    vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', 'Count', '1', inSession));
    -- ���������
    RETURN QUERY
       SELECT tmp.Number
            , 0 AS Id
            , 0 AS Code
            , '' :: TVarChar AS Name
            , '' :: TVarChar AS Value
       FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
      ;

    ELSE

    IF inIsCeh = FALSE
    THEN
    -- ������������ ���-��
    vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, inLevelChild, '', 'Count', '1', inSession));
    -- ���������
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
            , '���� ��� ����' :: TVarChar  AS Name
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.01.15                                        * all
 21.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (TRUE, 1, 'Default', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (TRUE, 1, 'Service', zfCalc_UserAdmin())
--
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 1, 'PriceList', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 4, 'Default', zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_onLevelChild (FALSE, 1, 'Service', zfCalc_UserAdmin())
