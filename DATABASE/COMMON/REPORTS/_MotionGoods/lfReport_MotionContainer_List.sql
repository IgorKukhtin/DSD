-- Function: lfReport_MotionContainer_List ()

-- DROP FUNCTION lfReport_MotionContainer_List ();

CREATE OR REPLACE FUNCTION lfReport_MotionContainer_List (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime
)
RETURNS TABLE  (ContainerId_Goods Integer, LocationId Integer, GoodsId INTEGER
              , StartSumm TFloat, IncomeSumm TFloat, SendInSumm TFloat, SendOutSumm TFloat, SaleSumm TFloat, ReturnOutSumm TFloat, ReturnInSumm TFloat, LossSumm TFloat , InventorySumm TFloat, EndSumm TFloat
              , StartCount TFloat, IncomeCount TFloat, SendInCount TFloat, SendOutCount TFloat, SaleCount TFloat, ReturnOutCount TFloat, ReturnInCount TFloat, LossCount TFloat , InventoryCount TFloat, EndCount TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY   

    SELECT _tmpContainerAll.ContainerId_Goods
		 , _tmpContainerAll.GoodsId
		 , _tmpContainerAll.LocationId

         , CAST (SUM(_tmpContainerAll.StartSumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.IncomeSumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.SendInSumm) AS TFloat) 
         , CAST (SUM(_tmpContainerAll.SendOutSumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.SaleSumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.ReturnOutSumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.ReturnInSumm) AS TFloat)                 
         , CAST (SUM(_tmpContainerAll.LossSumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.InventorySumm) AS TFloat)
         , CAST (SUM(_tmpContainerAll.EndSumm) AS TFloat)
 
         , CAST (SUM(_tmpContainerAll.StartCount) AS TFloat)           
         , CAST (SUM(_tmpContainerAll.IncomeCount) AS TFloat)    AS IncomeCount 
         , CAST (SUM(_tmpContainerAll.SendInCount) AS TFloat)    AS SendInCount    
         , CAST (SUM(_tmpContainerAll.SendOutCount) AS TFloat)   AS SendOutCount   
         , CAST (SUM(_tmpContainerAll.SaleCount) AS TFloat)      AS SaleCount      
         , CAST (SUM(_tmpContainerAll.ReturnOutCount) AS TFloat) AS ReturnOutCount 
         , CAST (SUM(_tmpContainerAll.ReturnInCount) AS TFloat)  AS ReturnInCount  
         , CAST (SUM(_tmpContainerAll.LossCount) AS TFloat)      AS LossCount      
         , CAST (SUM(_tmpContainerAll.InventoryCount) AS TFloat) AS InventoryCount 
         , CAST (SUM(_tmpContainerAll.EndCount) AS TFloat)
    FROM
		(SELECT lfMotionContainer_SummList.ContainerId_Goods
              , lfMotionContainer_SummList.GoodsId  
			  , lfMotionContainer_SummList.LocationId
              
			  , lfMotionContainer_SummList.StartSumm
			  , lfMotionContainer_SummList.IncomeSumm
			  , lfMotionContainer_SummList.SendInSumm 
			  , lfMotionContainer_SummList.SendOutSumm
			  , lfMotionContainer_SummList.SaleSumm
			  , lfMotionContainer_SummList.ReturnOutSumm
			  , lfMotionContainer_SummList.ReturnInSumm                 
			  , lfMotionContainer_SummList.LossSumm
			  , lfMotionContainer_SummList.InventorySumm
			  , lfMotionContainer_SummList.EndSumm
            
              , CAST (0 as TFloat)  AS StartWeight
			  , CAST (0 as TFloat)  AS IncomeWeight
			  , CAST (0 as TFloat)  AS SendInWeight
			  , CAST (0 as TFloat)  AS SendOutWeight
			  , CAST (0 as TFloat)  AS SaleWeight
			  , CAST (0 as TFloat)  AS ReturnOutWeight
			  , CAST (0 as TFloat)  AS ReturnInWeight
			  , CAST (0 as TFloat)  AS LossWeight
              , CAST (0 as TFloat)  AS InventoryWeight
              , CAST (0 as TFloat)  AS EndWeight
              
         FROM lfRepor_MotionContainer_SummList(inStartDate, inEndDate) AS lfMotionContainer_SummList
        UNION ALL
         SELECT lfMotionContainer_CountList.ContainerId_Goods
              , lfMotionContainer_CountList.GoodsId 
              , lfMotionContainer_CountList.LocationId   
 
              , 0 AS StartSumm
              , 0 AS IncomeSumm
              , 0 AS SendInSumm
              , 0 AS SendOutSumm
              , 0 AS SaleSumm
              , 0 AS ReturnOutSumm
              , 0 AS ReturnInSumm
              , 0 AS LossSumm
              , 0 AS InventorySumm
              , 0 AS EndSumm
              , lfMotionContainer_CountList.StartCount     AS StartCount           
              , lfMotionContainer_CountList.IncomeCount    AS IncomeCount 
              , lfMotionContainer_CountList.SendInCount    AS SendInCount    
              , lfMotionContainer_CountList.SendOutCount   AS SendOutCount   
              , lfMotionContainer_CountList.SaleCount      AS SaleCount      
              , lfMotionContainer_CountList.ReturnOutCount AS ReturnOutCount 
              , lfMotionContainer_CountList.ReturnInCount  AS ReturnInCount  
              , lfMotionContainer_CountList.LossCount      AS LossCount      
              , lfMotionContainer_CountList.InventoryCount AS InventoryCount 
              , lfMotionContainer_CountList.EndCount       AS EndCount
      
                      -- список количественных контейнеров (получили остатки и движение)
               FROM lfReport_MotionContainer_CountList(inStartDate, inEndDate) AS lfMotionContainer_CountList

           ) AS _tmpContainerAll

           GROUP BY _tmpContainerAll.ContainerId_Goods
                  , _tmpContainerAll.GoodsId
                  , _tmpContainerAll.LocationId;
                      
                      
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lfReport_MotionContainer_List (TDateTime, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.09.13         *                        
 
 */
 -- тест
/*


CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT  Id FROM Object WHERE DescId = zc_Object_Goods() and id = 3009; 
INSERT INTO _tmpLocation (LocationId) SELECT  Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Personal() and id =0;

SELECT * FROM lfReport_MotionContainer_List (inStartDate:= '10.01.2013', inEndDate:= '10.01.2013');


*/
