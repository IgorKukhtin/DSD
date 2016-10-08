 -- Function: gpReport_HistoryCostView_NEW()

DROP FUNCTION IF EXISTS gpReport_HistoryCostView (TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HistoryCostView(
    IN inStartDate          TDateTime , --
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
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, GoodsKindName_complete TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, AssetToCode Integer, AssetToName TVarChar

             , CountStart TFloat
             , CountStart_Weight TFloat

             , CountIncome TFloat
             , CountIncome_Weight TFloat

             , Count_calc TFloat
             , Count_calc_Weight TFloat

             , CountOut TFloat
             , CountOut_Weight TFloat

             , CountCalc_External TFloat
             , CountCalc_External_Weight TFloat
           
             , SummStart TFloat
             , SummIncome TFloat             
             , Summ_calc TFloat
             , SummOut TFloat
             , SummCalc_External TFloat
             , Summ_Diff TFloat

             , PriceStart TFloat
             , PriceIncome TFloat
             , PriceCalc TFloat
             , PriceOut TFloat
             , PriceCalcExternal TFloat
             
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , ContainerId_Summ Integer
             , LineNum Integer
             , LocationName_inf TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
 
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    --vbUserId:= lpGetUserBySession (inSession);

    -- таблица -
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;

    -- подразделение или место учета (МО, Авто)
    IF COALESCE (inLocationId, 0) = 0
    THEN
       INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
              SELECT Object.Id
                   , tmpCLODesc.DescId
                   , tmpDesc.ContainerDescId
              FROM Object
                   LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
                   LEFT JOIN (SELECT zc_ContainerLinkObject_Car() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId) AS tmpCLODesc ON 1 = 1
              WHERE Object.DescId IN (zc_Object_Unit(), zc_Object_Member(), zc_Object_Personal(), zc_Object_Car())
           UNION ALL
              SELECT 0 AS Id
                   , tmpCLODesc.DescId
                   , tmpDesc.ContainerDescId
              FROM Object
                   LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
                   LEFT JOIN (SELECT zc_ContainerLinkObject_Car() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId) AS tmpCLODesc ON 1 = 1
              WHERE Object.Id = zc_Juridical_Basis();
    ELSE
       INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
              SELECT Object.Id AS LocationId
                   , CASE WHEN Object.DescId = zc_Object_Unit()   THEN zc_ContainerLinkObject_Unit() 
                          WHEN Object.DescId = zc_Object_Car()    THEN zc_ContainerLinkObject_Car() 
                          WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                     END AS DescId
                   , tmpDesc.ContainerDescId
              FROM Object
                   LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId/* UNION SELECT zc_Container_Summ() AS ContainerDescId */) AS tmpDesc ON 1 = 1
              WHERE Object.Id = inLocationId;
    END IF;
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation;

    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
       THEN
           INSERT INTO _tmpGoods (GoodsId)
                   SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect;
    ELSE
       IF COALESCE (inGoodsId, 0) <> 0
          THEN
              INSERT INTO _tmpGoods (GoodsId)
                     SELECT inGoodsId AS GoodsId;
       END IF;
    END IF;
    -- Результат
    RETURN QUERY
    WITH 
   tmpHistoryCost AS ( SELECT CASE WHEN inIsInfoMoney = TRUE THEN HistoryCost.ContainerId ELSE 0 END AS ContainerId
                            , _tmpLocation.LocationId
                            , _tmpLocation.ContainerDescId
                            , CLO_Goods.ObjectId           AS GoodsId
                            , CLO_GoodsKind.ObjectId       AS GoodsKindId
                            , CLO_PartionGoods.ObjectId    AS PartionGoodsId
                            , CLO_AssetTo.ObjectId         AS AssetToId
                            , CLO_Car.ObjectId             AS CarId
                            , CLO_Account.ObjectId         AS AccountId
                            , HistoryCost.StartDate
                            , HistoryCost.EndDate
                         --   , HistoryCost.Price
                            , SUM (HistoryCost.StartCount)    AS StartCount
                            , SUM (HistoryCost.StartSumm)     AS StartSumm
                            , SUM (HistoryCost.IncomeCount)   AS IncomeCount
                            , SUM (HistoryCost.IncomeSumm)    AS IncomeSumm
                            , SUM (HistoryCost.CalcCount)     AS CalcCount
                            , SUM (HistoryCost.CalcSumm)      AS CalcSumm
                            , SUM (HistoryCost.OutCount)      AS OutCount
                            , SUM (HistoryCost.OutSumm)       AS OutSumm
                         --   , HistoryCost.Price_External
                            , SUM (HistoryCost.CalcCount_External) AS CalcCount_External
                            , SUM (HistoryCost.CalcSumm_External)  AS CalcSumm_External
                            , SUM (HistoryCost.Summ_Diff)          AS Summ_Diff
                            --, HistoryCost.MovementItemId_Diff
            
                      FROM HistoryCost -- limit 10
                            INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = HistoryCost.ContainerId
                            INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                   AND _tmpLocation.DescId = ContainerLinkObject.DescId

                            LEFT JOIN ContainerLinkObject AS CLO_Goods 
                                   ON CLO_Goods.ContainerId = HistoryCost.ContainerId
                                  AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                   --AND (CLO_Goods.ObjectId = inGoodsId OR inGoodsId = 0)
                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = CLO_Goods.ObjectId

                            LEFT JOIN ContainerLinkObject AS CLO_Unit 
                                   ON CLO_Unit.ContainerId = HistoryCost.ContainerId
                                  AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                         -- AND CLO_Unit.ObjectId = 301309 -- подразделениеlimit 10

                        --   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = CLO_Goods.ObjectId

                         /*   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                   ON CLO_InfoMoney.ContainerId =  HistoryCost.ContainerId
                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
*/
                         --   LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId

                            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                   ON CLO_GoodsKind.ContainerId = HistoryCost.ContainerId
                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                   ON CLO_PartionGoods.ContainerId = HistoryCost.ContainerId
                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                            LEFT JOIN ContainerLinkObject AS CLO_AssetTo
                                   ON CLO_AssetTo.ContainerId = HistoryCost.ContainerId
                                  AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                            LEFT JOIN ContainerLinkObject AS CLO_Car 
                                   ON CLO_Car.ContainerId = HistoryCost.ContainerId
                                  AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
                            LEFT JOIN ContainerLinkObject AS CLO_Account
                                   ON CLO_Account.ContainerId = HistoryCost.ContainerId
                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                  AND _tmpLocation.ContainerDescId = zc_Container_Count()

                      WHERE inStartDate >= HistoryCost.StartDate AND inStartDate < HistoryCost.EndDate

                      GROUP BY CASE WHEN inIsInfoMoney = TRUE THEN HistoryCost.ContainerId ELSE 0 END
                             , _tmpLocation.LocationId
                             , _tmpLocation.ContainerDescId
                             , CLO_Goods.ObjectId
                             , CLO_GoodsKind.ObjectId
                             , CLO_PartionGoods.ObjectId
                             , CLO_AssetTo.ObjectId 
                             , CLO_Car.ObjectId
                             , CLO_Account.ObjectId
                             , HistoryCost.StartDate
                             , HistoryCost.EndDate
                           --  , HistoryCost.Price
                            -- , HistoryCost.Price_External
                            -- , HistoryCost.MovementItemId_Diff
                      )

   -- Результат
   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        , CAST (COALESCE(Object_GoodsKind_complete.ValueData, '') AS TVarChar) AS GoodsKindName_complete
        , Object_Measure.ValueData       AS MeasureName
        , ObjectFloat_Weight.ValueData   AS Weight

        , CAST (COALESCE(Object_PartionGoods.Id, 0) AS Integer)           AS PartionGoodsId
        , CASE WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0
                    THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := Object_PartionGoods.ValueData
                                                          , inOperDate        := ObjectDate_PartionGoods_Value.ValueData
                                                          , inPrice           := ObjectFloat_PartionGoods_Price.ValueData
                                                          , inUnitName_Partion:= Object_Unit.ValueData
                                                          , inStorageName     := Object_Storage.ValueData
                                                          , inGoodsName       := ''
                                                           )
               ELSE COALESCE (Object_PartionGoods.ValueData, '')
          END :: TVarChar AS PartionGoodsName

        , Object_AssetTo.ObjectCode      AS AssetToCode
        , Object_AssetTo.ValueData       AS AssetToName

        , CAST (tmpHistoryCost.StartCount          AS TFloat) AS CountStart
        , CAST (tmpHistoryCost.StartCount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountStart_Weight
     
        , CAST (tmpHistoryCost.IncomeCount         AS TFloat) AS CountIncome
        , CAST (tmpHistoryCost.IncomeCount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END         AS TFloat) AS CountIncome_Weight
      
        , CAST (tmpHistoryCost.CalcCount      AS TFloat) AS Count_calc
        , CAST (tmpHistoryCost.CalcCount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END      AS TFloat) AS Count_calc_Weight

        , CAST (tmpHistoryCost.OutCount        AS TFloat) AS CountOut
        , CAST (tmpHistoryCost.OutCount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END        AS TFloat) AS CountOut_Weight

        , CAST (tmpHistoryCost.CalcCount_External  AS TFloat) AS CountCalc_External
        , CAST (tmpHistoryCost.CalcCount_External * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountCalc_External_Weight

        , CAST (tmpHistoryCost.StartSumm          AS TFloat) AS SummStart
        , CAST (tmpHistoryCost.IncomeSumm         AS TFloat) AS SummIncome
        , CAST (tmpHistoryCost.CalcSumm           AS TFloat) AS Summ_calc
        , CAST (tmpHistoryCost.OutSumm            AS TFloat) AS SummOut
        , CAST (tmpHistoryCost.CalcSumm_External  AS TFloat) AS SummCalc_External
        , CAST (tmpHistoryCost.Summ_Diff          AS TFloat) AS Summ_Diff


        , CAST (CASE WHEN tmpHistoryCost.StartCount <> 0
                          THEN tmpHistoryCost.StartSumm / tmpHistoryCost.StartCount
                     ELSE 0
                END AS TFloat) AS Price_Start

        , CAST (CASE WHEN tmpHistoryCost.IncomeCount <> 0
                          THEN tmpHistoryCost.IncomeSumm / tmpHistoryCost.IncomeCount
                     ELSE 0
                END AS TFloat) AS PriceIncome
       
        , CAST (CASE WHEN tmpHistoryCost.CalcCount <> 0
                          THEN tmpHistoryCost.CalcSumm / tmpHistoryCost.CalcCount
                     ELSE 0
                END AS TFloat) AS PriceCalc

        , CAST (CASE WHEN tmpHistoryCost.OutCount <> 0
                          THEN tmpHistoryCost.OutSumm / tmpHistoryCost.OutCount
                     ELSE 0
                END AS TFloat) AS PriceOut
        , CAST (CASE WHEN tmpHistoryCost.CalcCount_External <> 0
                          THEN tmpHistoryCost.CalcSumm_External / tmpHistoryCost.CalcCount_External
                     ELSE 0
                END AS TFloat) AS PriceCalcExternal
      --  , CAST (tmpHistoryCost.Price_External AS TFloat) AS PriceExternal

        , View_InfoMoney.InfoMoneyId
        , View_InfoMoney.InfoMoneyCode
        , View_InfoMoney.InfoMoneyGroupName
        , View_InfoMoney.InfoMoneyDestinationName
        , View_InfoMoney.InfoMoneyName
        , View_InfoMoney.InfoMoneyName_all

        , View_InfoMoneyDetail.InfoMoneyId              AS InfoMoneyId_Detail
        , View_InfoMoneyDetail.InfoMoneyCode            AS InfoMoneyCode_Detail
        , View_InfoMoneyDetail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
        , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
        , View_InfoMoneyDetail.InfoMoneyName            AS InfoMoneyName_Detail
        , View_InfoMoneyDetail.InfoMoneyName_all        AS InfoMoneyName_all_Detail

        , tmpHistoryCost.ContainerId                    AS ContainerId_Summ
        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

        , CAST( CASE WHEN COALESCE(Object_Car.ValueData,'') <> '' THEN Object_Car.ValueData ELSE COALESCE(Object_Location.ValueData,'') END  AS TVarChar)  AS LocationName_inf
      FROM tmpHistoryCost

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = tmpHistoryCost.ContainerId
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId
        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = tmpHistoryCost.ContainerId
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpHistoryCost.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpHistoryCost.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpHistoryCost.LocationId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpHistoryCost.LocationId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN tmpHistoryCost.CarId > 0 THEN tmpHistoryCost.CarId WHEN Object_Location_find.DescId = zc_Object_Car() THEN Object_Location_find.Id END -- CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpHistoryCost.LocationId END
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN tmpHistoryCost.LocationId = tmpHistoryCost.CarId OR Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpHistoryCost.LocationId END -- CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpHistoryCost.LocationId END
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = CASE WHEN tmpHistoryCost.CarId > 0 THEN zc_Object_Car() ELSE Object_Location_find.DescId END

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                             ON ObjectLink_GoodsKindComplete.ObjectId = tmpHistoryCost.PartionGoodsId
                            AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
        LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = ObjectLink_GoodsKindComplete.ChildObjectId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpHistoryCost.PartionGoodsId
        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpHistoryCost.AssetToId

                                    LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId = tmpHistoryCost.PartionGoodsId
                                                        AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                                    LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                         ON ObjectLink_Unit.ObjectId = tmpHistoryCost.PartionGoodsId
                                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
                                    LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                         ON ObjectLink_Storage.ObjectId = tmpHistoryCost.PartionGoodsId
                                                        AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                    LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId
                                    LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                         ON ObjectDate_PartionGoods_Value.ObjectId = tmpHistoryCost.PartionGoodsId
                                                        AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                                          ON ObjectFloat_PartionGoods_Price.ObjectId = tmpHistoryCost.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpHistoryCost.AccountId
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.10.16         *
*/

-- тест

-- 
--SELECT * from gpReport_HistoryCostView (inStartDate:= '01.07.2016', inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 1826, inIsInfoMoney:= true, inSession := zfCalc_UserAdmin());
