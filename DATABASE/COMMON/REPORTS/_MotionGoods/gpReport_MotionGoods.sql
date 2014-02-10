-- Function: gpReport_MotionGoods()

DROP FUNCTION IF EXISTS gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods(
    IN inStartDate    TDateTime , -- 
    IN inEndDate      TDateTime , --
    IN inUnitGroupId  Integer,    -- группа подразделений на самом деле это подразделение, 
    IN inLocationId       Integer,    -- подразделение
    IN inGoodsGroupId Integer,    -- группа товара 
    IN inGoodsId      Integer,    -- товар
    
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , PartionGoodsId Integer, PartionGoodsCode Integer, PartionGoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , AssetToId Integer, AssetToCode Integer, AssetToName TVarChar
             , MeasureName TVarChar , Weight TFloat

             , StartSumm TFloat, IncomeSumm TFloat, SendInSumm TFloat, SendOutSumm TFloat, SaleSumm TFloat
             , ReturnOutSumm TFloat, ReturnInSumm TFloat, LossSumm TFloat , InventorySumm TFloat, EndSumm TFloat

             , StartCount_Sh TFloat, IncomeCount_Sh TFloat, SendInCount_Sh TFloat, SendOutCount_Sh TFloat, SaleCount_Sh TFloat
             , ReturnOutCount_Sh TFloat, ReturnInCount_Sh TFloat, LossCount_Sh TFloat , InventoryCount_Sh TFloat, EndCount_Sh TFloat

             , StartCount TFloat, IncomeCount TFloat, SendInCount TFloat, SendOutCount TFloat, SaleCount TFloat
             , ReturnOutCount TFloat, ReturnInCount TFloat, LossCount TFloat , InventoryCount TFloat, EndCount TFloat
              
               )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());

     -- таблица - 
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

    IF inGoodsGroupId <> 0 
    THEN 
       INSERT INTO _tmpGoods (GoodsId)
          SELECT lfObject_Goods_byGoodsGroup.GoodsId
          FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0 
         THEN 
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE 
             INSERT INTO _tmpGoods (GoodsId)
              SELECT Id FROM Object WHERE DescId = zc_Object_Goods()
             UNION
              SELECT Id FROM Object WHERE DescId = zc_Object_Fuel();
         END IF;
    END IF;

   IF inUnitGroupId <> 0 
   THEN 
      INSERT INTO _tmpLocation (LocationId)
         SELECT lfObject_Unit_List.LocationId
         FROM  lfSELECT_Object_Unit_List (inUnitGroupId) AS lfObject_Unit_List;
   ELSE 
       IF inLocationId <> 0 
       THEN 
          INSERT INTO _tmpLocation (LocationId)
             SELECT inLocationId;
       ELSE 
          INSERT INTO _tmpLocation (LocationId)
             SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
            UNION all
             SELECT Id FROM Object WHERE DescId = zc_Object_Member()
            UNION all
             SELECT Id FROM Object WHERE DescId = zc_Object_Car();
       END IF;      
   END IF;

     RETURN QUERY 

      SELECT _tmp_All.GoodsId, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName  
           , _tmp_All.LocationId , Object_Location.ObjectCode  AS LocationCode, Object_Location.ValueData  AS LocationName
           , _tmp_All.PartionGoodsId, Object_PartionGoods.ObjectCode AS PartionGoodsCode, Object_PartionGoods.ValueData AS PartionGoodsName
           , _tmp_All.GoodsKindId, Object_GoodsKind.ObjectCode  AS GoodsKindCode, Object_GoodsKind.ValueData  AS GoodsKindName
           , _tmp_All.AssetToId, Object_AssetTo.ObjectCode  AS AssetToCode, Object_AssetTo.ValueData  AS AssetToName

           , Object_Measure.ValueData     AS MeasureName
           , ObjectFloat_Weight.ValueData AS Weight

           , CAST (SUM (_tmp_All.StartSumm) AS TFloat)     AS StartSumm
           , CAST (SUM (_tmp_All.IncomeSumm) AS TFloat)    AS IncomeSumm
           , CAST (SUM (_tmp_All.SendInSumm) AS TFloat)    AS SendInSumm
           , CAST (SUM (_tmp_All.SendOutSumm) AS TFloat)   AS SendOutSumm
           , CAST (SUM (_tmp_All.SaleSumm) AS TFloat)      AS SaleSumm
           , CAST (SUM (_tmp_All.ReturnOutSumm) AS TFloat) AS ReturnOutSumm
           , CAST (SUM (_tmp_All.ReturnInSumm) AS TFloat)  AS ReturnInSumm
           , CAST (SUM (_tmp_All.LossSumm) AS TFloat)      AS LossSumm
           , CAST (SUM (_tmp_All.InventorySumm) AS TFloat) AS InventorySumm
           , CAST (SUM (_tmp_All.EndSumm) AS TFloat)       AS EndSumm

           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.StartCount) ELSE 0 END AS TFloat) AS StartCount_Sh
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.IncomeCount) ELSE 0 END AS TFloat) AS IncomeCount_Sh   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.SendInCount) ELSE 0 END AS TFloat) AS SendInCount_Sh   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.SendOutCount) ELSE 0 END AS TFloat) AS SendOutCount_Sh           
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.SaleCount) ELSE 0 END AS TFloat) AS SaleCount_Sh           
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.ReturnOutCount) ELSE 0 END AS TFloat) AS ReturnOutCount_Sh           
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.ReturnInCount) ELSE 0 END AS TFloat) AS ReturnInCount_Sh           
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.LossCount) ELSE 0 END AS TFloat) AS LossCount_Sh           
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.InventoryCount) ELSE 0 END AS TFloat) AS InventoryCount_Sh           
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN SUM (_tmp_All.EndCount) ELSE 0 END AS TFloat) AS EndCount_Sh           

           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.StartCount)*ObjectFloat_Weight.ValueData) ELSE  SUM (_tmp_All.StartCount) END AS TFloat) AS StartCount
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.IncomeCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.IncomeCount) END AS TFloat) AS IncomeCount     
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.SendInCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.SendInCount)  END AS TFloat) AS SendInCount   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.SendOutCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.SendOutCount) END AS TFloat) AS SendOutCount   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.SaleCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.SaleCount) END AS TFloat) AS SaleCount
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.ReturnOutCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.ReturnOutCount) END AS TFloat) AS ReturnOutCount   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.ReturnInCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.ReturnInCount) END AS TFloat) AS ReturnInCount   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.LossCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.LossCount) END AS TFloat) AS LossWeight   
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.InventoryCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.InventoryCount) END AS TFloat) AS InventoryCount 
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (SUM (_tmp_All.EndCount)*ObjectFloat_Weight.ValueData) ELSE SUM (_tmp_All.EndCount) END AS TFloat) AS EndCount
   
           
      FROM 
           (SELECT  lfMotionContainer_List.GoodsId
                  , lfMotionContainer_List.LocationId   
                  , ContainerLinkObject_PartionGoods.ObjectId   AS PartionGoodsId
                  , lfMotionContainer_List.ContainerId_Goods
                  , ContainerLinkObject_GoodsKind.ObjectId      AS GoodsKindId
                  , ContainerLinkObject_AssetTo.ObjectId        AS AssetToId
                  
                  , lfMotionContainer_List.StartSumm 
		  , lfMotionContainer_List.IncomeSumm
                  , lfMotionContainer_List.SendInSumm 
                  , lfMotionContainer_List.SendOutSumm
                  , lfMotionContainer_List.SaleSumm
                  , lfMotionContainer_List.ReturnOutSumm
                  , lfMotionContainer_List.ReturnInSumm                 
                  , lfMotionContainer_List.LossSumm
                  , lfMotionContainer_List.InventorySumm
                  , lfMotionContainer_List.EndSumm 
            
                  , lfMotionContainer_List.StartCount     AS StartCount           
                  , lfMotionContainer_List.IncomeCount    AS IncomeCount 
                  , lfMotionContainer_List.SendInCount    AS SendInCount    
                  , lfMotionContainer_List.SendOutCount   AS SendOutCount   
                  , lfMotionContainer_List.SaleCount      AS SaleCount      
                  , lfMotionContainer_List.ReturnOutCount AS ReturnOutCount 
                  , lfMotionContainer_List.ReturnInCount  AS ReturnInCount  
                  , lfMotionContainer_List.LossCount      AS LossCount      
                  , lfMotionContainer_List.InventoryCount AS InventoryCount 
                  , lfMotionContainer_List.EndCount       AS EndCount
                   
                   
            FROM lfReport_MotionContainer_List (inStartDate, inEndDate) AS lfMotionContainer_List
             
                LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_PartionGoods ON ContainerLinkObject_PartionGoods.Containerid = lfMotionContainer_List.GoodsId
                                              AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_GoodsKind ON ContainerLinkObject_GoodsKind.Containerid = lfMotionContainer_List.GoodsId
                                              AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                LEFT JOIN  ContainerLinkObject AS ContainerLinkObject_AssetTo ON ContainerLinkObject_AssetTo.Containerid = lfMotionContainer_List.GoodsId
                                              AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo() 
                                               
           ) AS _tmp_All
      
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmp_All.GoodsId
      
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = _tmp_All.LocationId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = _tmp_All.PartionGoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmp_All.GoodsKindId
          LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = _tmp_All.AssetToId
      
      GROUP BY _tmp_All.GoodsId, Object_Goods.ObjectCode, Object_Goods.ValueData
             , _tmp_All.LocationId , Object_Location.ObjectCode, Object_Location.ValueData
             , _tmp_All.PartionGoodsId, Object_PartionGoods.ObjectCode, Object_PartionGoods.ValueData
             , _tmp_All.GoodsKindId, Object_GoodsKind.ObjectCode, Object_GoodsKind.ValueData
             , _tmp_All.AssetToId, Object_AssetTo.ObjectCode, Object_AssetTo.ValueData 
             , Object_Measure.ValueData 
             , Object_Measure.Id
            , ObjectFloat_Weight.ValueData;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.13         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inSession:= '2') 
