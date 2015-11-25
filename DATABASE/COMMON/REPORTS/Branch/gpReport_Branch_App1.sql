-- Function: gpReport_Branch_App1()

DROP FUNCTION IF EXISTS gpReport_Branch_App1 (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App1(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (BranchName TVarChar
             , SummStart TFloat, WeightStart TFloat, SummEnd TFloat, WeightEnd TFloat
             , SendOnPriceInSumm TFloat, SendOnPriceInWeight TFloat
             , ReturnInSumm TFloat, ReturnInWeight TFloat
             , ChangeSumm TFloat, ChangeWeight TFloat
             
             , SaleSumm TFloat, SaleWeight TFloat
             , SendOnPriceOutSumm TFloat, SendOnPriceOutWeight TFloat
             , ChangeAmountSumm TFloat, ChangeAmountWeight TFloat
             , LossSumm TFloat, LossWeight TFloat
             , InventorySumm TFloat, InventoryWeight TFloat   
             , PriceSumm TFloat          
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
          vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE _tmpBranch (BranchId Integer) ON COMMIT DROP; 
    
    -- Филиал
    IF COALESCE(inBranchId,0) = 0
    THEN
     --RAISE EXCEPTION 'Ошибка. Не выбран Филиал.';
       INSERT INTO _tmpBranch (BranchId)
           SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() and Object.Id <> zc_Branch_Basis();
    ELSE
       INSERT INTO _tmpBranch (BranchId)
           SELECT inBranchId;
    END IF;


    -- Результат
     RETURN QUERY
   WITH tmpUnitList AS (SELECT Object_Unit_View.* 
                        From _tmpBranch
                            INNER JOIN Object_Unit_View ON Object_Unit_View.BranchId = _tmpBranch.BranchId
                        )

  , tmpContainerList AS (SELECT * 
                         FROM tmpUnitList 
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.ObjectId = tmpUnitList.Id
                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
                             INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                           AND Container.DescId = zc_Container_Summ()
                             LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                         WHERE Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_20700() 
                        )

      , tmpGoods AS (SELECT tmpContainerList.BranchId
                          , tmpContainerList.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS SummStart 
                          , tmpContainerList.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount 
                                    ELSE 0 END) AS SummIn
                          , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount
                                    ELSE 0 END) AS SummOut

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate  THEN -1 * MIContainer.Amount                                        --Sale
                                    ELSE 0 END) AS SummSale
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                                         ---ReturnIn
                                    ELSE 0 END) AS SummReturnIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = TRUE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS SummSendOnPriceIn
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() AND MIContainer.isActive = FALSE AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount                              ---перемещение по цене
                                    ELSE 0 END) AS SummSendOnPriceOut                                        
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount                                     ---Списание
                                    ELSE 0 END) AS SummLoss 
                     FROM tmpContainerList
                          LEFT JOIN MovementItemContainer AS MIContainer 
                                                          ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                          AND MIContainer.OperDate >= inStartDate 
                     GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount, tmpContainerList.BranchId
                    )


/*, tmpGoodsMovement AS (SELECT  tmpContainerList.BranchId
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() AND MIContainer.isActive = true  THEN  MIContainer.Amount                                        --Sale
                                        ELSE 0 END) AS SummSale
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN  MIContainer.Amount                                         ---ReturnIn
                                        ELSE 0 END) AS SummReturnIn
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_SendOnPrice() THEN  MIContainer.Amount                              ---перемещение по цене
                                        ELSE 0 END) AS SummSendOnPrice
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss() THEN  MIContainer.Amount                                     ---Списание
                                        ELSE 0 END) AS SummLoss  
                       FROM tmpContainerList
                              inner JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.ContainerId = tmpContainerList.ContainerId 
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                         GROUP BY tmpContainerList.ContainerId, tmpContainerList.Amount , tmpContainerList.BranchId
           )
                
       */
 
  SELECT  Object_Branch.ValueData  ::TVarChar   AS BranchName

       
        , CAST (SUM (tmpAll.SummStart)         AS TFloat) AS SummStart
        , CAST (0         AS TFloat) AS WeightStart
        , CAST (SUM (tmpAll.SummEnd)           AS TFloat) AS SummEnd
        , CAST (0         AS TFloat) AS WeightEnd

        , CAST (SUM (tmpAll.SummSendOnPriceIn)            AS TFloat) AS SummSendOnPriceInSumm
        , CAST (0         AS TFloat) AS IncomeWeight
        
        , CAST (SUM (tmpAll.SummReturnIn)                 AS TFloat) AS ReturnInSumm
        , CAST (0         AS TFloat) AS ReturnInWeight
        , CAST (0         AS TFloat) AS ChangeSumm
        , CAST (0         AS TFloat) AS ChangeWeight

        , CAST (SUM (tmpAll.SummSale)                     AS TFloat) AS SaleSumm
        , CAST (0         AS TFloat) AS SaleWeight
        , CAST (SUM (tmpAll.SummSendOnPriceOut)           AS TFloat) AS SendOnPriceOutSumm
        , CAST (0         AS TFloat) AS SendWeight
        , CAST (0         AS TFloat) AS ChangeAmountSumm
        , CAST (0         AS TFloat) AS ChangeAmountWeight
        ,CAST (SUM (tmpAll.SummLoss)           AS TFloat) AS LossSumm
        , CAST (0         AS TFloat) AS LossWeight
        , CAST (0         AS TFloat) AS InventorySumm
        , CAST (0         AS TFloat) AS InventoryWeight
        , CAST (0         AS TFloat) AS PriceSumm
  
      FROM 
                  (SELECT tmpGoods.BranchId 
                        , CAST (SUM (tmpGoods.SummStart) AS NUMERIC (16, 2)) AS SummStart
                        , CAST (SUM (tmpGoods.SummEnd) AS NUMERIC (16, 2))   AS SummEnd
                        , CAST (SUM (tmpGoods.SummIn) AS NUMERIC (16, 2))      AS SummIn
                        , CAST (SUM (tmpGoods.SummOut) AS NUMERIC (16, 2))     AS SummOut
                        
                        , CAST (SUM (tmpGoods.SummSale) AS NUMERIC (16, 2))           AS SummSale
                        , CAST (SUM (tmpGoods.SummReturnIn) AS NUMERIC (16, 2))       AS SummReturnIn
                        , CAST (SUM (tmpGoods.SummSendOnPriceIn) AS NUMERIC (16, 2))  AS SummSendOnPriceIn
                        , CAST (SUM (tmpGoods.SummLoss) AS NUMERIC (16, 2))           AS SummLoss    
                        , CAST (SUM (tmpGoods.SummSendOnPriceOut) AS NUMERIC (16, 2)) AS SummSendOnPriceOut                    
                   FROM tmpGoods
                   GROUP BY tmpGoods.BranchId
               
                ) AS tmpAll

          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpAll.BranchId   --CASE WHEN COALESCE(inBranchId,0) <> 0 THEN inBranchId END
      GROUP BY  Object_Branch.ValueData  
      ORDER BY Object_Branch.ValueData 

      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.11.15         * 

*/

-- тест
--SELECT * FROM gpReport_Branch_App1 (inStartDate:= '01.11.2015'::TDateTime, inEndDate:= '03.11.2015'::TDateTime, inBranchId:= 8374, inSession:= zfCalc_UserAdmin())  --8374
--
--select * from gpReport_Branch_App1(inStartDate := ('02.08.2015')::TDateTime , inEndDate := ('03.08.2015')::TDateTime , inBranchId := 301310 ,  inSession := '5');