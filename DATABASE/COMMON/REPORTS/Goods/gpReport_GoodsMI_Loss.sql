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
             , Amount_Weight TFloat, Amount_Sh TFloat
             , Summ TFloat
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


    -- Результат
    RETURN QUERY
    
     SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ :: TFloat AS Summ

     FROM (SELECT tmpContainer.GoodsId
                , COALESCE (ContainerLO_GoodsKind.ObjectId,0) AS GoodsKindId
                , ABS (SUM (tmpContainer.Amount)):: TFloat          AS Amount 
                , ABS (SUM (tmpContainer.Summ)) :: TFloat           AS Summ

           FROM (SELECT MIContainer.ContainerId AS ContainerId
                    --  , MIContainer.WhereObjectId_analyzer AS FromId  
                   --   , MIContainer.MovementId
                      , MIContainer.ObjectId_analyzer AS GoodsId 
                      , MIContainer.ContainerId_analyzer    
                      
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN COALESCE (MIContainer.Amount,0) ELSE 0 end ) AS Summ
                      , SUM ( CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 end ) AS Amount
                     
                   FROM MovementItemContainer AS MIContainer 
                        JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                        --JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = MIContainer.MovementId
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                   AND MIContainer.MovementDEscId = inDescId
                   and ( MIContainer.WhereObjectId_analyzer = inFromId or inFromId = 0)
                   And MIContainer.isActive = True
                   AND (MovementLinkObject_To.ObjectId = inToid Or inToid=0)
                 group by MIContainer.ContainerId, MIContainer.ObjectId_analyzer , MIContainer.ContainerId_analyzer 
                        , MIContainer.WhereObjectId_analyzer
                     --    ,  MIContainer.MovementId 
                 ,MovementLinkObject_To.ObjectId
                 ) as tmpContainer
                    /*  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = tmpContainer.MovementId
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                       */                          
                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId =  tmpContainer.ContainerId
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                     
                    --WHERE (MovementLinkObject_To.ObjectId = inToid Or inToid=0)
                       
                      GROUP BY tmpContainer.GoodsId
                             , COALESCE (ContainerLO_GoodsKind.ObjectId,0) ---,MovementLinkObject_To.ObjectId
          
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
