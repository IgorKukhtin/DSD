-- Function: lfReport_MotionContainer_CountList ()

-- DROP FUNCTION lfReport_MotionContainer_CountList ();
                           
CREATE OR REPLACE FUNCTION lfReport_MotionContainer_CountList (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime
)
RETURNS TABLE  (ContainerId_Goods Integer, LocationId Integer, GoodsId INTEGER
              , StartCount  TFloat, IncomeCount TFloat, SendInCount TFloat, SendOutCount TFloat, SaleCount TFloat
              , ReturnOutCount TFloat, ReturnInCount TFloat, LossCount TFloat , InventoryCount TFloat
              , EndCount TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY        
    SELECT  lfMotionContainer_List.ContainerId_Goods
          , lfMotionContainer_List.LocationId AS LocationId
          , lfMotionContainer_List.GoodsId    AS GoodsId
          
          , CAST (lfMotionContainer_List.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS TFloat) AS StartCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)    AS IncomeCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)  AS SendInCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS SendOutCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)      AS SaleCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS ReturnOutCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)  AS ReturnInCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)      AS LossCount
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS InventoryCount
          , CAST (lfMotionContainer_List.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS EndCount
                      
    FROM lfReport_Container_CountList () AS lfMotionContainer_List               
        LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = lfMotionContainer_List.ContainerId_Goods
                                                      AND MIContainer.OperDate >= inStartDate
        LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId

    GROUP BY lfMotionContainer_List.Amount
           , lfMotionContainer_List.ContainerId_Goods 
           , lfMotionContainer_List.GoodsId
           , lfMotionContainer_List.LocationId
    HAVING (lfMotionContainer_List.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
        OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
        OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0);
        
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lfReport_MotionContainer_CountList (TDateTime, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.13         *  
*/

-- тест
/*


CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
INSERT INTO _tmpLocation (LocationId) SELECT Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Personal();

SELECT * FROM lfReport_MotionContainer_CountList (inStartDate:='2013-01-01', inEndDate :='2013-01-01');


*/