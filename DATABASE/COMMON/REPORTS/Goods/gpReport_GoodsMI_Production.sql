-- Function: gpReport_GoodsMI_Production ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Production (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --производство смешивание (8) , разделение (9)
    IN inisActive     Boolean   ,  -- приход true/ расход false
    IN inGoodsGroupId Integer   ,
    IN inUnitId       Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationCode Integer, LocationName TVarChar
             , LocationCode_by Integer, LocationName_by TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , Summ TFloat
             , Price TFloat
             , OperDate TDateTime
             )   
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
      vbUserId:= lpGetUserBySession (inSession);

      vbIsGroup:= (inSession = '');


    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    /*ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();*/
         
    END IF;

   -- Результат
    RETURN QUERY
    
    -- ограничиваем
    WITH tmpUnit AS (SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect)

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

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ :: TFloat AS Summ

         , CASE WHEN tmpOperationGroup.Amount <> 0 THEN tmpOperationGroup.Summ / tmpOperationGroup.Amount ELSE 0 END :: TFloat AS Price

         , tmpOperationGroup.OperDate

     FROM (SELECT tmpContainer.UnitId
                , tmpContainer.UnitId_by
                , tmpContainer.GoodsId
                , tmpContainer.GoodsKindId
                , tmpContainer.OperDate
                , CLO_PartionGoods.ObjectId AS PartionGoodsId
                , ABS (SUM (tmpContainer.Amount))   AS Amount
                , ABS (SUM (tmpContainer.Summ))     AS Summ

           FROM (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                      , MIContainer.WhereObjectId_analyzer AS UnitId
                      , MIContainer.ObjectExtId_Analyzer   AS UnitId_by
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectId_Analyzer END AS GoodsId       
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                      , CASE WHEN vbIsGroup = TRUE THEN zc_DateStart() ELSE MIContainer.OperDate END AS OperDate
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS Amount
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS Summ
                 FROM tmpUnit
                      INNER JOIN MovementItemContainer AS MIContainer 
                                                       ON MIContainer.WhereObjectId_analyzer = tmpUnit.UnitId
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                      AND MIContainer.isActive = inIsActive
                                                      AND MIContainer.MovementDescId = inDescId
                      LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer

                 WHERE _tmpGoods.GoodsId > 0 OR inGoodsGroupId = 0
                 GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectExtId_Analyzer
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectId_Analyzer END
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END
                        , CASE WHEN vbIsGroup = TRUE THEN zc_DateStart() ELSE MIContainer.OperDate END
               ) AS tmpContainer

                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                               ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                              AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

           GROUP BY tmpContainer.UnitId
                  , tmpContainer.UnitId_by
                  , tmpContainer.GoodsId
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

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.15                                        * all
 21.08.14         * 
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.01.2015', inEndDate:= '31.01.2015',  inDescId:= 8, inisActive:='True' , inGoodsGroupId:= 0, inUnitId:=0, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.01.2015', inEndDate:= '31.01.2015',  inDescId:= 8, inisActive:='False' , inGoodsGroupId:= 0, inUnitId:=0, inSession:= zfCalc_UserAdmin());

-- inDescId:= 9 - разделение
--SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.08.2015', inEndDate:= '01.09.2015',  inDescId:= 9, inisActive:='True' , inGoodsGroupId:= 0, inUnitId:=0, inSession:= zfCalc_UserAdmin());
--SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.08.2015', inEndDate:= '01.09.2015',  inDescId:= 9, inisActive:='False' , inGoodsGroupId:= 0, inUnitId:=0, inSession:= zfCalc_UserAdmin());
