-- Function: gpReport_GoodsMI_Loss ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()


DROP FUNCTION IF EXISTS gpReport_GoodsMI_Loss (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Loss (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --Loss списаниe
    IN inGoodsGroupId Integer   ,
    IN inFromId       Integer   ,
    IN inToId         Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , TradeMarkName TVarChar
             , AmountOut_Weight TFloat, AmountOut_Sh TFloat, SummOut_Total TFloat, SummOut TFloat, SummOut_60000 TFloat 
             , AmountIn_Weight TFloat, AmountIn_Sh TFloat,  SummIn_Total TFloat, SummIn TFloat, SummIn_60000 TFloat
             )   
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

      vbUserId:= lpGetUserBySession (inSession);

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods()
         UNION 
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Fuel();
    END IF;


    CREATE TEMP TABLE _tmpUnit_From (UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit_To (UnitId Integer) ON COMMIT DROP;

    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inFromId <> 0 
    THEN
        INSERT INTO _tmpUnit_From (UnitId)
           SELECT inFromId AS UnitId union SELECT inToId AS UnitId where inDescId <> zc_Movement_Loss();
    ELSE
        INSERT INTO _tmpUnit_From (UnitId)
                                                   
               SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Car();

    END IF;  

    IF inToId <> 0 
    THEN
        INSERT INTO _tmpUnit_To (UnitId)
           SELECT inToId AS UnitId union SELECT inFromId AS UnitId where inDescId <> zc_Movement_Loss();
           
    ELSE
        INSERT INTO _tmpUnit_To (UnitId)
   
               SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Car();
              
    END IF;


    -- Результат
    RETURN QUERY
    
     SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , (tmpOperationGroup.AmountOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOut_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountOut ELSE 0 END) :: TFloat AS AmountOut_Sh
         , tmpOperationGroup.SummOut_Total :: TFloat AS SummOut_Total
         , tmpOperationGroup.SummOut :: TFloat AS SummOut
         , tmpOperationGroup.SummOut_60000 :: TFloat AS SummOut_60000
         
         , (tmpOperationGroup.AmountIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountIn_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountIn ELSE 0 END) :: TFloat AS AmountIn_Sh
         , tmpOperationGroup.SummIn_Total :: TFloat AS SummIn_Total
         , tmpOperationGroup.SummIn :: TFloat AS SummIn
         , tmpOperationGroup.SummIn_60000 :: TFloat AS SummIn_60000

     FROM (SELECT tmpContainer.GoodsId
                , COALESCE (ContainerLO_GoodsKind.ObjectId,0) AS GoodsKindId
                , SUM (tmpContainer.AmountOut) :: TFloat         AS AmountOut 
                , SUM (tmpContainer.SummOut)   :: TFloat         AS SummOut_Total
                , SUM ( CASE WHEN COALESCE(Object_Account_View.AccountDirectionId,0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) :: TFloat  AS SummOut
                , SUM ( CASE WHEN Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) :: TFloat  AS SummOut_60000

                , SUM (tmpContainer.AmountIn) :: TFloat          AS AmountIn 
                , SUM (tmpContainer.SummIn) :: TFloat            AS SummIn_Total
                , SUM ( CASE WHEN COALESCE(Object_Account_View.AccountDirectionId,0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn ELSE 0 END) :: TFloat  AS SummIn
                , SUM ( CASE WHEN Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn ELSE 0 END) :: TFloat  AS SummIn_60000

                
           FROM (SELECT MIContainer.ContainerId AS ContainerId
                      , MIContainer.ObjectId_analyzer AS GoodsId 
                      , COALESCE(MIContainer.AccountId,0) AS AccountId 

                      , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN -1*COALESCE (MIContainer.Amount,0) ELSE 0 END) AS SummOut
                      , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Count() THEN -1*COALESCE (MIContainer.Amount,0) ELSE 0 END) AS AmountOut

                      , CASE WHEN inDescId = zc_Movement_Loss() Then 0
                         ELSE
                           SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)
                         END AS SummIn

                      , CASE WHEN inDescId = zc_Movement_Loss() Then 0
                         ELSE
                           SUM (CASE WHEN MIContainer.isActive = True AND MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) 
                         END AS AmountIn
                    
                   FROM MovementItemContainer AS MIContainer 
                        INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                        INNER JOIN _tmpUnit_From ON _tmpUnit_From.UnitId = MIContainer.WhereObjectId_analyzer
                        Left  JOIN _tmpUnit_To   ON _tmpUnit_To.UnitId   = MIContainer.AnalyzerId
                    
                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                   AND MIContainer.MovementDEscId = inDescId
                --   And MIContainer.isActive = True
                   And (_tmpUnit_To.UnitId>0 or inDescId = zc_Movement_Loss())
                   and  COALESCE(MIContainer.AccountId,0) <> zc_Enum_Account_100301 ()   --            AS AccountId
                   
                 group by MIContainer.ContainerId
                        , MIContainer.ObjectId_analyzer 
                        , COALESCE(MIContainer.AccountId,0)
                        --, MIContainer.ContainerId_analyzer 
                       -- , MIContainer.WhereObjectId_analyzer --, MIContainer.AnalyzerId
                       -- , MIContainer.DescId--, MIContainer.isActive 
                 ) as tmpContainer
                         
                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId =  tmpContainer.ContainerId
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpContainer.AccountId
                    
                 GROUP BY tmpContainer.GoodsId
                        , COALESCE (ContainerLO_GoodsKind.ObjectId,0) 
          
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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.15         * 

   
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Loss (inStartDate:= '01.01.2013', inEndDate:= '31.12.2013',  inDescId:= 1, inGoodsGroupId:= 0, inUnitGroupId:=0, inUnitId:= 0, inFromId:=0, inToId:=0, inSession:= zfCalc_UserAdmin());
--select * from gpReport_GoodsMI_Loss(inStartDate := ('03.06.2015')::TDateTime , inEndDate := ('03.06.2015')::TDateTime , inDescId := 7 , inGoodsGroupId := 0 , inFromId := 0 , inToId := 0 ,  inSession := '5');
