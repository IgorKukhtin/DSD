-- Function: gpReport_GoodsMI_Production ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Production (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --производство смешивание (8) , разделение (9)
    IN inisActive     Boolean   ,  -- приход true/ расход false
    IN inGoodsGroupId Integer   ,
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
    DECLARE vbDescId Integer;
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         
    END IF;

   -- Результат
    RETURN QUERY
    
    -- ограничиваем по виду документа 
      WITH tmpMovement AS 
                        (SELECT Movement.Id AS MovementId
                         FROM Movement 
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId  = inDescId   
                         GROUP BY Movement.Id 
                         )


    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ :: TFloat AS Summ

     FROM (SELECT tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , ABS (SUM (tmpOperation.Amount)):: TFloat          AS Amount
                , ABS (SUM (tmpOperation.Summ)) :: TFloat           AS Summ

           FROM (SELECT MovementItem.ObjectId AS GoodsId       
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , SUM (COALESCE (MIContainer.Amount,0)) AS Summ
                      , 0 AS Amount
                      
                 FROM tmpMovement

                      JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementId = tmpMovement.MovementId
                                                AND MIContainer.DescId = zc_MIContainer_Summ()
                                                AND MIContainer.isActive = inisActive   --True / False
                      JOIN Container ON Container.Id = MIContainer.ContainerId

                      JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                           ) AS tmpAccount on tmpAccount.AccountID = Container.ObjectId

                      JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                       
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                      GROUP BY MovementItem.ObjectId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
              UNION
                
                  SELECT MovementItem.ObjectId AS GoodsId       
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , 0 AS Summ
                      , SUM (MIContainer.Amount) AS Amount
                 FROM tmpMovement

                      JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementId = tmpMovement.MovementId
                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                AND MIContainer.isActive = inisActive   --True / False
                      LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                                         
                      JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                       
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                 
                      LEFT JOIN MovementLinkObject AS MovementLO_From
                                                   ON MovementLO_From.MovementId = tmpMovement.MovementId
                                                  AND MovementLO_From.DescId = zc_MovementLinkObject_From()   
                      
                      GROUP BY MovementItem.ObjectId    
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                             , COALESCE (Container.ObjectId, 0) 


               ) AS tmpOperation

           GROUP BY tmpOperation.GoodsId
                  , tmpOperation.GoodsKindId
                 
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
ALTER FUNCTION gpReport_GoodsMI_Production (TDateTime, TDateTime, Integer, Boolean, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.14         * 
    
*/

-- тест
--SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.01.2014', inEndDate:= '31.01.2014',  inDescId:= 8, inisActive:='True' , inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
--SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.01.2014', inEndDate:= '31.01.2014',  inDescId:= 8, inisActive:='False' , inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());

--SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.08.2014', inEndDate:= '01.09.2014',  inDescId:= 9, inisActive:='True' , inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
--SELECT * FROM gpReport_GoodsMI_Production (inStartDate:= '01.08.2014', inEndDate:= '01.09.2014',  inDescId:= 9, inisActive:='False' , inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());


-- inDescId:= 9 - разделение