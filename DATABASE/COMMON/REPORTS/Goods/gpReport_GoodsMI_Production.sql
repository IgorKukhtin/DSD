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
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , TradeMarkName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , Summ TFloat
             , Price TFloat
             , OperDate TDateTime
             )   
AS
$BODY$
    DECLARE vbDescId Integer;
BEGIN

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

    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ :: TFloat AS Summ

         , CASE WHEN tmpOperationGroup.Amount <> 0 THEN tmpOperationGroup.Summ / tmpOperationGroup.Amount ELSE 0 END :: TFloat AS Price

         , tmpOperationGroup.OperDate

     FROM (SELECT tmpOperation.GoodsId
                , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                , tmpOperation.OperDate
                , ABS (SUM (tmpOperation.Amount)):: TFloat          AS Amount
                , ABS (SUM (tmpOperation.Summ)) :: TFloat           AS Summ

           FROM (SELECT MIContainer.ContainerId
                      , MIContainer.ObjectId_Analyzer AS GoodsId       
                      , MIContainer.OperDate
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
                 GROUP BY MIContainer.ContainerId
                        , MIContainer.ObjectId_Analyzer
                        , MIContainer.OperDate
               ) AS tmpOperation

                      LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                       ON CLO_GoodsKind.ContainerId = tmpOperation.ContainerId
                                                      AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()

           GROUP BY tmpOperation.GoodsId
                  , CLO_GoodsKind.ObjectId
                  , tmpOperation.OperDate
                 
          ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId

          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

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
