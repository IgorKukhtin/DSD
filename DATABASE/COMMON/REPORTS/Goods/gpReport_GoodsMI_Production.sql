-- Function: gpReport_GoodsMI_Production ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Production (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --������������ ���������� (8) , ���������� (9)
    IN inIsActive     Boolean   ,  -- ������ true/ ������ false
    IN inUnitId       Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationCode Integer, LocationName TVarChar
             , LocationCode_by Integer, LocationName_by TVarChar
             , Amount TFloat, Amount_Weight TFloat, Amount_Sh TFloat
             , Summ_zavod TFloat, Summ_branch TFloat, Summ_60000 TFloat
             , Price_zavod TFloat, Price_branch TFloat
             , OperDate TDateTime
             )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
      vbUserId:= lpGetUserBySession (inSession);

      vbIsGroup:= (inSession = '');

     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- ������� -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


    -- ���������
    RETURN QUERY

     WITH -- ����������� �� ������
          _tmpGoods AS -- (GoodsId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
          UNION
           SELECT Object.Id AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )
    , _tmpUnit AS
          (-- �������������
           SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
          )
    -- ���������
    SELECT Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , Object_PartionGoods.ValueData              AS PartionGoods

         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName
         , Object_Location_by.ObjectCode AS LocationCode_by
         , Object_Location_by.ValueData  AS LocationName_by

         , tmpOperationGroup.Amount        :: TFloat AS Amount
         , tmpOperationGroup.Amount_Weight :: TFloat AS Amount_Weight
         , tmpOperationGroup.Amount_Sh     :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ_zavod  :: TFloat AS Summ_zavod
         , tmpOperationGroup.Summ_branch :: TFloat AS Summ_branch
         , tmpOperationGroup.Summ_60000  :: TFloat AS Summ_60000

         , CASE WHEN tmpOperationGroup.Amount <> 0 THEN tmpOperationGroup.Summ_zavod / tmpOperationGroup.Amount ELSE 0 END :: TFloat AS Price_zavod
         , CASE WHEN tmpOperationGroup.Amount <> 0 THEN tmpOperationGroup.Summ_branch / tmpOperationGroup.Amount ELSE 0 END :: TFloat AS Price_branch

         , tmpOperationGroup.OperDate

     FROM (SELECT tmpContainer.UnitId
                , tmpContainer.UnitId_by
                , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END AS GoodsId
                , tmpContainer.GoodsKindId
                , tmpContainer.OperDate
                , CLO_PartionGoods.ObjectId AS PartionGoodsId
                , SUM (tmpContainer.Amount) AS Amount
                , SUM (tmpContainer.Amount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS Amount_Weight
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.Amount ELSE 0 END) AS Amount_sh
                , SUM (tmpContainer.Summ) AS Summ_zavod
                , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.Summ ELSE 0 END) AS Summ_branch
                , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.Summ ELSE 0 END) AS Summ_60000

           FROM (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                      , MIContainer.WhereObjectId_analyzer AS UnitId
                      , MIContainer.ObjectExtId_Analyzer   AS UnitId_by
                      , MIContainer.ObjectId_Analyzer      AS GoodsId
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                      , CASE WHEN vbIsGroup = TRUE THEN zc_DateStart() ELSE MIContainer.OperDate END AS OperDate
                      , COALESCE (MIContainer.AccountId, 0)  AS AccountId
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS Amount
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS Summ
                 FROM _tmpUnit
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.WhereObjectId_analyzer = _tmpUnit.UnitId
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                      AND MIContainer.isActive = inIsActive
                                                      AND MIContainer.MovementDescId = inDescId
                      -- LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                 -- WHERE _tmpGoods.GoodsId > 0 OR inGoodsGroupId = 0
                 GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectExtId_Analyzer
                        , MIContainer.ObjectId_Analyzer
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END
                        , CASE WHEN vbIsGroup = TRUE THEN zc_DateStart() ELSE MIContainer.OperDate END
                        , COALESCE (MIContainer.AccountId, 0)
               ) AS tmpContainer
               INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId
               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                             ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                            AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
               LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpContainer.AccountId
           GROUP BY tmpContainer.UnitId
                  , tmpContainer.UnitId_by
                  , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END
                  , tmpContainer.GoodsKindId
                  , tmpContainer.OperDate
                  , CLO_PartionGoods.ObjectId

          ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.UnitId
          LEFT JOIN Object AS Object_Location_by ON Object_Location_by.Id = tmpOperationGroup.UnitId_by
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

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

  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.08.15                                        * all
 21.08.14         *
*/

-- ����
-- SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inDescId:= zc_Movement_ProductionSeparate(), inIsActive:= TRUE,  inUnitId:=0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inDescId:= zc_Movement_ProductionSeparate(), inIsActive:= FALSE, inUnitId:=0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inDescId:= zc_Movement_ProductionUnion(),    inIsActive:= TRUE,  inUnitId:=0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inDescId:= zc_Movement_ProductionUnion(),    inIsActive:= FALSE, inUnitId:=0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
