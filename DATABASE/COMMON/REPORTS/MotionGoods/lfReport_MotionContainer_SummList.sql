-- Function: lfReport_MotionContainer_SummList ()

DROP FUNCTION IF EXISTS  lfReport_MotionContainer_SummList (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION lfReport_MotionContainer_SummList (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime
)
RETURNS TABLE  (ContainerId_Goods Integer, LocationId Integer, GoodsId INTEGER
              , StartSumm TFloat, IncomeSumm TFloat, SendInSumm TFloat, SendOutSumm TFloat, SaleSumm TFloat
              , ReturnOutSumm TFloat, ReturnInSumm TFloat, LossSumm TFloat , InventorySumm TFloat
              , EndSumm TFloat)  
AS
$BODY$
BEGIN

    RETURN QUERY        
    SELECT  lfContainer_SummList.ContainerId_Goods -- счет количественный
          , lfContainer_SummList.LocationId
          , lfContainer_SummList.GoodsId
          , CAST (lfContainer_SummList.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS TFloat) AS StartSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Income() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS TFloat)   AS IncomeSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0 ) AS TFloat)  AS SendInSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS SendOutSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)      AS SaleSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnOut() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS ReturnOutSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)  AS ReturnInSumm
          , CAST (COALESCE (SUM (CASE WHEN (Movement.DescId = zc_Movement_Loss() OR Movement.DescId = zc_Movement_Transport()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat)      AS LossSumm
          , CAST (COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS InventorySumm
          , CAST (lfContainer_SummList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS TFloat) AS EndSumm
          
    FROM lfSELECT_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000()) AS lfObject_Account -- -20000; "Запасы"     -- написать функцию lfGet_Object_Account_byAccountGroup
        
        LEFT JOIN lfReport_Container_SummList () AS lfContainer_SummList ON lfContainer_SummList.AccountId = lfObject_Account.AccountId
                                             
        LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = lfContainer_SummList.ContainerId
                                                      AND MIContainer.OperDate >= inStartDate
        LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                           
        GROUP BY lfContainer_SummList.Amount
               , lfContainer_SummList.LocationId
               , lfContainer_SummList.ContainerId_Goods
               , lfContainer_SummList.GoodsId
        HAVING (lfContainer_SummList.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0);
            
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lfReport_MotionContainer_SummList (TDateTime, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.13         *  
*/

-- тест
/*

CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;

INSERT INTO _tmpGoods (GoodsId) SELECT  Id FROM Object WHERE DescId = zc_Object_Goods(); 
INSERT INTO _tmpLocation (LocationId) SELECT  Id FROM Object WHERE DescId = zc_Object_Unit() UNION ALL SELECT Id FROM Object WHERE DescId = zc_Object_Personal();

SELECT * FROM lfReport_MotionContainer_SummList (inStartDate:= '01.01.2013', inEndDate:= '01.01.2013') as lfMotionContainer_SummList
left join object as object_Goods on object_Goods.Id = lfMotionContainer_SummList.GoodsId 
left join object as object_Location on object_Location.Id = lfMotionContainer_SummList.LocationId ;



*/