-- Function: gpReport_ProfitLoss()

-- DROP FUNCTION gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , ProfitLossCode Integer, ProfitLossName  TVarChar, OnComplete Boolean
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
             , BusinessCode Integer, BusinessName TVarChar
             , ByObjectCode Integer, ByObjectName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());

     RETURN QUERY 
      SELECT
             lfObject_ProfitLoss.ProfitLossGroupCode                AS ProfitLossGroupCode
           , lfObject_ProfitLoss.ProfitLossGroupName                AS ProfitLossGroupName
           , lfObject_ProfitLoss.ProfitLossDirectionCode            AS ProfitLossDirectionCode
           , lfObject_ProfitLoss.ProfitLossDirectionName            AS ProfitLossDirectionName
           , lfObject_ProfitLoss.ProfitLossCode                     AS ProfitLossCode
           , lfObject_ProfitLoss.ProfitLossName                     AS ProfitLossName
           , lfObject_ProfitLoss.onComplete                         AS OnComplete

           , lfObject_InfoMoney.InfoMoneyCode
           , lfObject_InfoMoney.InfoMoneyName
           , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail

           , Object_Business.ObjectCode   AS BusinessCode
           , Object_Business.ValueData    AS BusinessName
           , Object_by.ObjectCode         AS ByObjectCode
           , Object_by.ValueData          AS ByObjectName
           , Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName

           , CAST (tmpProfitLoss.Amount AS TFloat)

      FROM lfSelect_Object_ProfitLoss() AS lfObject_ProfitLoss
           LEFT JOIN (SELECT tmpMIContainer.ContainerId
                           , tmpMIContainer.ContainerId_Parent
                           , -1 * tmpMIContainer.Amount
                           , ContainerLinkObject_ProfitLoss.ObjectId AS ProfitLossId
                      FROM (SELECT Container.Id AS ContainerId
                                 , MIContainer_Parent.ContainerId AS ContainerId_Parent
                                 , SUM (MIContainer.Amount) AS Amount
                            FROM Container
                                 JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = Container.Id
                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                           AND MIContainer.isActive = FALSE -- !!! что бы не попали операции переброски накопленной прибыль прошлого месяца в долг по прибыли
                                 LEFT JOIN MovementItemContainer AS MIContainer_Parent ON MIContainer_Parent.Id = MIContainer.ParentId
                            WHERE Container.ObjectId = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                              AND Container.DescId = zc_Container_Summ()
                            GROUP BY Container.Id
                                   , MIContainer_Parent.ContainerId
                           ) AS tmpMIContainer
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_ProfitLoss
                                                         ON ContainerLinkObject_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                        AND ContainerLinkObject_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                     ) AS tmpProfitLoss ON tmpProfitLoss.ProfitLossId = lfObject_ProfitLoss.ProfitLossId

           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                         ON ContainerLinkObject_Business.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                         ON ContainerLinkObject_InfoMoney.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                         ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                         ON ContainerLinkObject_Juridical.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                        AND 1=1
           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                         ON ContainerLinkObject_Personal.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                                        AND 1=1
           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                         ON ContainerLinkObject_Unit.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                        AND 1=1
           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                         ON ContainerLinkObject_Goods.ContainerId = tmpProfitLoss.ContainerId_Parent
                                        AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                        AND 1=1

           LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
           LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, ContainerLinkObject_InfoMoney.ObjectId)
                                                                             AND zc_isHistoryCost_byInfoMoneyDetail() = TRUE

           LEFT JOIN Object AS Object_Business ON Object_Business.Id = ContainerLinkObject_Business.ObjectId
           LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (ContainerLinkObject_Juridical.ObjectId, COALESCE (ContainerLinkObject_Personal.ObjectId, ContainerLinkObject_Unit.ObjectId))
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ContainerLinkObject_Goods.ObjectId
      ;
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.13                                        *
 27.08.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '01.01.2012', inEndDate:= '01.02.2013', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
