-- Function: gpReport_GoodsBalance()

DROP FUNCTION IF EXISTS gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer,  Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inIsInfoMoney        Boolean,    --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, AssetToName TVarChar

             , CountStart TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_Weight TFloat

             , CountIncome TFloat
             , CountIncome_Weight TFloat
             , CountReturnOut TFloat
             , CountReturnOut_Weight TFloat

             , CountSendIn TFloat
             , CountSendIn_Weight TFloat
             , CountSendOut TFloat
             , CountSendOut_Weight TFloat

             , CountSendOnPriceIn TFloat
             , CountSendOnPriceIn_Weight TFloat
             , CountSendOnPriceOut TFloat
             , CountSendOnPriceOut_Weight TFloat

             , CountSale TFloat
             , CountSale_Weight TFloat
             , CountSale_10500 TFloat
             , CountSale_10500_Weight TFloat
             , CountSale_40208 TFloat
             , CountSale_40208_Weight TFloat

             , CountReturnIn TFloat
             , CountReturnIn_Weight TFloat
             , CountReturnIn_40208 TFloat
             , CountReturnIn_40208_Weight TFloat

             , CountLoss TFloat
             , CountLoss_Weight TFloat
             , CountInventory TFloat
             , CountInventory_Weight TFloat

             , CountProductionIn TFloat
             , CountProductionIn_Weight TFloat
             , CountProductionOut TFloat
             , CountProductionOut_Weight TFloat

             , CountTotalIn TFloat
             , CountTotalIn_Weight TFloat
             , CountTotalOut TFloat
             , CountTotalOut_Weight TFloat

             , SummStart TFloat
             , SummEnd TFloat
             , SummIncome TFloat
             , SummReturnOut TFloat
             , SummSendIn TFloat
             , SummSendOut TFloat
             , SummSendOnPriceIn TFloat
             , SummSendOnPriceOut TFloat
             , SummSale TFloat
             , SummSale_10500 TFloat
             , SummSale_40208 TFloat
             , SummReturnIn TFloat
             , SummReturnIn_40208 TFloat
             , SummLoss TFloat
             , SummInventory TFloat
             , SummInventory_RePrice TFloat
             , SummProductionIn TFloat
             , SummProductionOut TFloat
             , SummTotalIn TFloat
             , SummTotalOut TFloat

             , PriceStart TFloat
             , PriceEnd TFloat
             , PriceIncome TFloat
             , PriceReturnOut TFloat
             , PriceSendIn TFloat
             , PriceSendOut TFloat
             , PriceSendOnPriceIn TFloat
             , PriceSendOnPriceOut TFloat
             , PriceSale TFloat
             , PriceReturnIn TFloat
             , PriceLoss TFloat
             , PriceInventory TFloat
             , PriceProductionIn TFloat
             , PriceProductionOut TFloat
             , PriceTotalIn TFloat
             , PriceTotalOut TFloat

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , ContainerId_Summ Integer
             , LineNum Integer

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

   -- !!!меняются параметры для филиала!!!
   IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
   THEN
       inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
       inIsInfoMoney:= FALSE;
   END IF;


   SELECT 'AccountGroupName' AS AccountGroupName
        , 'AccountDirectionName' AS AccountDirectionName
        , AccountId AS AccountId, CAST (0 AS Integer) AS AccountCode, 'AccountName' AS AccountName, 'AccountName_all' AS AccountName_all
        , 'ObjectDesc.ItemName'          AS LocationDescName
        , CAST (0 AS Integer)            AS LocationId
        , CAST (1 AS Integer)            AS LocationCode
        , CAST ('LocationName' AS TVarChar)     AS LocationName
        , CAST (2 AS Integer)           AS CarCode
        , 'Object_Car.ValueData'           AS CarName
        , 'Object_GoodsGroup.ValueData'    AS GoodsGroupName
        , 'ObjectString_Goods_GroupNameFull.ValueData' AS GoodsGroupNameFull
        , CAST (0 AS Integer)            AS GoodsId
        , CAST (3 AS Integer)            AS GoodsCode
        , CAST ( 'GoodsName' AS TVarChar)        AS GoodsName
        , CAST (0 AS Integer)            AS GoodsKindId
        , CAST ( 'GoodsKindName' AS TVarChar)    AS GoodsKindName
        , 'Object_Measure.ValueData'       AS MeasureName
        , CAST (34 AS TFloat)   AS Weight
        , CAST (0 AS Integer)            AS PartionGoodsId
        , CAST ('PartionGoodsName' AS TVarChar)  AS PartionGoodsName
        , 'Object_AssetTo.ValueData'       AS AssetToName

        , CAST (4 AS TFloat) AS CountStart
        , CAST (5 AS TFloat) AS CountStart_Weight
        , CAST (6 AS TFloat) AS CountEnd
        , CAST (7 AS TFloat) AS CountEnd_Weight

        , CAST (8 AS TFloat) AS CountIncome
        , CAST (9 AS TFloat) AS CountIncome_Weight
        , CAST (10 AS TFloat) AS CountReturnOut
        , CAST (11 AS TFloat) AS CountReturnOut_Weight

        , CAST (12 AS TFloat)  AS CountSendIn
        , CAST (13 AS TFloat)  AS CountSendIn_Weight
        , CAST (14 AS TFloat) AS CountSendOut
        , CAST (15 AS TFloat)  AS CountSendOut_Weight

        , CAST (16 AS TFloat) AS CountSendOnPriceIn
        , CAST (17 AS TFloat) AS CountSendOnPriceIn_Weight
        , CAST (18 AS TFloat) AS CountSendOnPriceOut
        , CAST (19 AS TFloat)  AS CountSendOnPriceOut_Weight

        , CAST (20 AS TFloat) AS CountSale
        , CAST (21 AS TFloat)  AS CountSale_Weight
        , CAST (22 AS TFloat) AS CountSale_10500
        , CAST (23 AS TFloat)  AS CountSale_10500_Weight
        , CAST (34 AS TFloat) AS CountSale_40208
        , CAST (35 AS TFloat)  AS CountSale_40208_Weight

        , CAST (0 AS TFloat)  AS CountReturnIn
        , CAST (0 AS TFloat)  AS CountReturnIn_Weight
        , CAST (0 AS TFloat)  AS CountReturnIn_40208
        , CAST (0 AS TFloat)  AS CountReturnIn_40208_Weight

        , CAST (0 AS TFloat)  AS CountLoss
        , CAST (0 AS TFloat)  AS CountLoss_Weight
        , CAST (0 AS TFloat)  AS CountInventory
        , CAST (0 AS TFloat)  AS CountInventory_Weight

        , CAST (0 AS TFloat)  AS CountProductionIn
        , CAST (0 AS TFloat)  AS CountProductionIn_Weight
        , CAST (0 AS TFloat) AS CountProductionOut
        , CAST (0 AS TFloat) AS CountProductionOut_Weight

        , CAST (0 AS TFloat)  AS CountTotalIn
        , CAST (0 AS TFloat)  AS CountTotalIn_Weight
        , CAST (0 AS TFloat)  AS CountTotalOut
        , CAST (0 AS TFloat)  AS CountTotalOut_Weight

        , CAST (0 AS TFloat) AS SummStart
        ,CAST (0 AS TFloat)  AS SummEnd
        , CAST (0 AS TFloat)  AS SummIncome
        , CAST (0 AS TFloat)  AS SummReturnOut
        , CAST (0 AS TFloat)  AS SummSendIn
        , CAST (0 AS TFloat)  AS SummSendOut
        , CAST (0 AS TFloat)  AS SummSendOnPriceIn
        , CAST (0 AS TFloat) AS SummSendOnPriceOut
        ,CAST (0 AS TFloat) AS SummSale
        , CAST (0 AS TFloat)  AS SummSale_10500
        ,CAST (0 AS TFloat)  AS SummSale_40208
        , CAST (0 AS TFloat)  AS SummReturnIn
        , CAST (0 AS TFloat)  AS SummReturnIn_40208
        ,CAST (0 AS TFloat)  AS SummLoss
        , CAST (0 AS TFloat)  AS SummInventory
        , CAST (0 AS TFloat)  AS SummInventory_RePrice
        , CAST (0 AS TFloat) AS SummProductionIn
        , CAST (0 AS TFloat)  AS SummProductionOut
        , CAST (0 AS TFloat)  AS SummTotalIn
        , CAST (0 AS TFloat)  AS SummTotalOut

        , CAST (0 AS TFloat)  AS PriceStart
        , CAST (0 AS TFloat)  AS PriceEnd

        , CAST (0 AS TFloat) AS PriceIncome
        ,CAST (0 AS TFloat)  AS PriceReturnOut

        , CAST (0 AS TFloat)  AS PriceSendIn
        , CAST (0 AS TFloat)  AS PriceSendOut

        , CAST (0 AS TFloat)  AS PriceSendOnPriceIn
        , CAST (0 AS TFloat)  AS PriceSendOnPriceOut

        , CAST (0 AS TFloat)  AS PriceSale
        ,CAST (0 AS TFloat)  AS PriceReturnIn

        , CAST (0 AS TFloat) AS PriceLoss
        , CAST (0 AS TFloat)  AS PriceInventory
        , CAST (0 AS TFloat)  AS PriceProductionIn
        , CAST (0 AS TFloat)  AS PriceProductionOut

        , CAST (0 AS TFloat)  AS PriceTotalIn
        , CAST (0 AS TFloat)  AS PriceTotalOut
        , CAST (0 AS Integer) AS InfoMoneyId
        , CAST (7 AS Integer) AS InfoMoneyCode
        , 'View_InfoMoney.InfoMoneyGroupName' AS InfoMoneyGroupName
        , 'View_InfoMoney.InfoMoneyDestinationName' AS InfoMoneyDestinationName
        , 'View_InfoMoney.InfoMoneyName' AS InfoMoneyName
        , 'View_InfoMoney.InfoMoneyName_all' AS InfoMoneyName_all

        , CAST (0 AS Integer)               AS InfoMoneyId_Detail
        , CAST (0 AS Integer)            AS InfoMoneyCode_Detail
        , 'InfoMoneyGroupName'       AS InfoMoneyGroupName_Detail
        , 'View_InfoMoneyDetail.InfoMoneyDestinationName' AS InfoMoneyDestinationName_Detail
        , 'View_InfoMoneyDetail.InfoMoneyName'            AS InfoMoneyName_Detail
        , 'View_InfoMoneyDetail.InfoMoneyName_all'        AS InfoMoneyName_all_Detail

        , CAST (7 AS TFloat) AS ContainerId_Summ
        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.05.15         * 

*/

-- тест
-- SELECT * FROM gpReport_GoodsBalance (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= '2')
-- SELECT * from gpReport_GoodsBalance (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= TRUE, inSession := '5');
