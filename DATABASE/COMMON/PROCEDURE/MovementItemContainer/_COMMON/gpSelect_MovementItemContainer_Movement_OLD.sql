-- Запрос возвращает все проводки по документу
-- Function: gpSelect_MovementItemContainer_Movement_OLD()

DROP FUNCTION IF EXISTS gpSelect_MovementItemContainer_Movement_OLD (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement_OLD(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber Integer, OperDate TDateTime
             , AccountCode Integer, DebetAmount TFloat, DebetAccountGroupName TVarChar, DebetAccountDirectionName TVarChar, DebetAccountName TVarChar
             , KreditAmount TFloat, KreditAccountGroupName TVarChar, KreditAccountDirectionName TVarChar, KreditAccountName  TVarChar
             , Price TFloat
             , AccountOnComplete Boolean, DirectionObjectCode Integer, DirectionObjectName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , BusinessCode Integer, BusinessName TVarChar
             , GoodsGroupCode Integer, GoodsGroupName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , GoodsKindName TVarChar
             , ObjectCostId Integer, MIId_Parent Integer, GoodsCode_Parent Integer, GoodsName_Parent TVarChar, GoodsKindName_Parent TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MIContainer_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!проводки только у Админа!!!
     IF 1=0 -- OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 10898)) -- Отчеты (управленческие)
     THEN

     RETURN QUERY 
       SELECT
             zfConvert_StringToNumber (tmpMovementItemContainer.InvNumber) AS InvNumber
           , tmpMovementItemContainer.OperDate
           , CAST (Object_Account_View.AccountCode AS Integer) AS AccountCode

           , CAST (CASE WHEN tmpMovementItemContainer.isActive = TRUE THEN tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS DebetAmount
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN Object_Account_View.AccountGroupName ELSE NULL END  AS TVarChar) AS DebetAccountGroupName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN Object_Account_View.AccountDirectionName ELSE NULL END  AS TVarChar) AS DebetAccountDirectionName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN Object_Account_View.AccountName_all ELSE NULL END  AS TVarChar) AS DebetAccountName

           , CAST (CASE WHEN tmpMovementItemContainer.isActive = FALSE THEN -1 * tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS KreditAmount
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN Object_Account_View.AccountGroupName ELSE NULL END  AS TVarChar) AS KreditAccountGroupName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN Object_Account_View.AccountDirectionName ELSE NULL END  AS TVarChar) AS KreditAccountDirectionName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN Object_Account_View.AccountName_all ELSE NULL END  AS TVarChar) AS KreditAccountName

           , CAST (ABS(tmpMovementItemContainer.Price) AS TFloat) AS Price
           , Object_Account_View.onComplete AS AccountOnComplete
           , tmpMovementItemContainer.DirectionObjectCode
           , CAST (tmpMovementItemContainer.DirectionObjectName AS TVarChar) AS DirectionObjectName
           , tmpMovementItemContainer.BranchCode
           , tmpMovementItemContainer.BranchName
           , tmpMovementItemContainer.BusinessCode
           , tmpMovementItemContainer.BusinessName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.DestinationObjectCode
           , tmpMovementItemContainer.DestinationObjectName
           , tmpMovementItemContainer.JuridicalBasisCode
           , tmpMovementItemContainer.JuridicalBasisName
           , tmpMovementItemContainer.GoodsKindName
           , tmpMovementItemContainer.ObjectCostId
           , tmpMovementItemContainer.MIId_Parent
           , tmpMovementItemContainer.GoodsCode_Parent
           , tmpMovementItemContainer.GoodsName_Parent
           , tmpMovementItemContainer.GoodsKindName_Parent
           , tmpMovementItemContainer.InfoMoneyCode
           , tmpMovementItemContainer.InfoMoneyName
           , tmpMovementItemContainer.InfoMoneyCode_Detail
           , tmpMovementItemContainer.InfoMoneyName_Detail
       FROM 
           (SELECT 
                  Movement.InvNumber
                , MovementItemContainer.OperDate
                , SUM (MovementItemContainer.Amount)  AS Amount
                , MovementItemContainer.isActive
                , Container.ObjectId

                , Object_Direction.ObjectCode AS DirectionObjectCode
                , CASE WHEN Object_ProfitLoss_View.ProfitLossName_all IS NOT NULL
                            THEN Object_ProfitLoss_View.ProfitLossName_all
                       ELSE Object_Direction.ValueData
                  END AS DirectionObjectName


                , Object_Branch.ObjectCode    AS BranchCode
                , Object_Branch.ValueData     AS BranchName
                , Object_Business.ObjectCode  AS BusinessCode
                , Object_Business.ValueData   AS BusinessName

                , Object_GoodsGroup.ObjectCode  AS GoodsGroupCode
                , Object_GoodsGroup.ValueData   AS GoodsGroupName

                , Object_Destination.ObjectCode AS DestinationObjectCode
                , Object_Destination.ValueData  AS DestinationObjectName

                , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
                , Object_JuridicalBasis.ValueData  AS JuridicalBasisName

                , Object_GoodsKind.ValueData    AS GoodsKindName
                , ContainerObjectCost.ObjectCostId
                , COALESCE (MovementItem_Parent.Id, MovementItem.Id) AS MIId_Parent
                , Object_Goods_Parent.ObjectCode      AS GoodsCode_Parent
                , Object_Goods_Parent.ValueData       AS GoodsName_Parent
                , Object_GoodsKind_Parent.ValueData   AS GoodsKindName_Parent
                , lfObject_InfoMoney.InfoMoneyCode
                , lfObject_InfoMoney.InfoMoneyName
                , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
                , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail
                , CASE WHEN Movement.DescId = zc_Movement_ProductionSeparate()
                          THEN tmpSumm_ProductionSeparate.Price
                       WHEN SUM (MovementItem.Amount) <> 0
                          THEN -SUM (MovementItemContainer.Amount) / SUM (MovementItem.Amount)
                       ELSE 0
                  END AS Price
            FROM (SELECT inMovementId AS MovementId UNION ALL SELECT Id AS MovementId FROM Movement WHERE ParentId = inMovementId) AS tmpMovement
                 JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmpMovement.MovementId
                                           AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                 LEFT JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                 LEFT JOIN MovementItemContainer AS MIContainer_Parent ON MIContainer_Parent.Id = MovementItemContainer.ParentId
                                                                      AND Container.ObjectId = zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"

                 LEFT JOIN Movement ON Movement.Id = MovementItemContainer.MovementId
                 LEFT JOIN (SELECT MovementItemContainer.MovementItemId
                                 , CASE WHEN MovementItem.Amount <> 0 THEN SUM (CASE WHEN MovementItemContainer.isActive THEN 1 ELSE -1 END * MovementItemContainer.Amount) / MovementItem.Amount ELSE 0 END AS Price
                            FROM MovementItemContainer
                                 LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                            WHERE MovementItemContainer.MovementId = inMovementId
                              AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                            GROUP BY MovementItemContainer.MovementItemId, MovementItem.Amount
                           ) AS tmpSumm_ProductionSeparate ON tmpSumm_ProductionSeparate.MovementItemId = MovementItemContainer.MovementItemId
                                                          AND Movement.DescId = zc_Movement_ProductionSeparate()

                 LEFT JOIN ContainerObjectCost ON ContainerObjectCost.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerObjectCost.ObjectCostDescId = zc_ObjectCost_Basis()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_ProfitLoss
                                               ON ContainerLinkObject_ProfitLoss.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                              AND ContainerLinkObject_ProfitLoss.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis ON ContainerLO_JuridicalBasis.ContainerId = MovementItemContainer.ContainerId
                                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                                            AND ContainerLO_JuridicalBasis.ObjectId > 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                               ON ContainerLinkObject_Juridical.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                              AND ContainerLinkObject_Juridical.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Founder
                                               ON ContainerLinkObject_Founder.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Founder.DescId = zc_ContainerLinkObject_Founder()
                                              AND ContainerLinkObject_Founder.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                               ON ContainerLinkObject_Member.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Member.DescId = zc_ContainerLinkObject_Member()
                                              AND ContainerLinkObject_Member.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                               ON ContainerLinkObject_Unit.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                              AND ContainerLinkObject_Unit.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                               ON ContainerLinkObject_Car.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                              AND ContainerLinkObject_Car.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                               ON ContainerLinkObject_Cash.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Cash.DescId = zc_ContainerLinkObject_Cash()
                                              AND ContainerLinkObject_Cash.ObjectId <> 0
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                               ON ContainerLinkObject_BankAccount.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
                                              AND ContainerLinkObject_BankAccount.ObjectId <> 0
                 LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = COALESCE (ContainerLinkObject_ProfitLoss.ObjectId, COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, COALESCE (ContainerLinkObject_Founder.ObjectId, COALESCE (ContainerLinkObject_Member.ObjectId, COALESCE (ContainerLinkObject_Car.ObjectId, ContainerLinkObject_Unit.ObjectId)))))))

                 -- вот так "не просто" выбираем филиал
                 /*LEFT JOIN (SELECT MAX (MovementItemReport.MovementItemId) AS MovementItemId, ReportContainerLink.ContainerId
                            FROM MovementItemReport
                                 JOIN ReportContainerLink ON ReportContainerLink.ReportContainerId = MovementItemReport.ReportContainerId
                                                         AND ReportContainerLink.AccountId = zc_Enum_Account_100301()
                            WHERE MovementItemReport.MovementId = inMovementId
                            GROUP BY ReportContainerLink.ContainerId
                           ) AS MIReport_MI ON MIReport_MI.ContainerId = MovementItemContainer.ContainerId*/
                 -- вот так "просто" выбираем филиал
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                  ON MILinkObject_Branch.MovementItemId = MovementItemContainer.MovementItemId -- MIReport_MI.MovementItemId -- COALESCE (MovementItemContainer.MovementItemId, MIReport_MI.MovementItemId)
                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                 LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                               ON ContainerLinkObject_Business.ContainerId = MovementItemContainer.ContainerId -- COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                                              AND ContainerLinkObject_Business.ObjectId <> 0
                 LEFT JOIN Object AS Object_Business ON Object_Business.Id = ContainerLinkObject_Business.ObjectId

                 LEFT JOIN Object_ProfitLoss_View ON Object_ProfitLoss_View.ProfitLossId = ContainerLinkObject_ProfitLoss.ObjectId

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                               ON ContainerLinkObject_InfoMoney.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                              -- AND 1=0
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                               ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                              -- AND 1=0
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = CASE WHEN COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) = 0 THEN ContainerLinkObject_InfoMoney.ObjectId ELSE ContainerLinkObject_InfoMoneyDetail.ObjectId END
                                                                                   AND zc_isHistoryCost_byInfoMoneyDetail() = TRUE

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                               ON ContainerLinkObject_Goods.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                              -- AND 1=0
                 LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = ContainerLinkObject_Goods.ObjectId

                 LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ContainerLO_JuridicalBasis.ObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ContainerLinkObject_Goods.ObjectId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                               ON ContainerLinkObject_GoodsKind.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                              AND 1=0
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ContainerLinkObject_GoodsKind.ObjectId

                 LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId

                 LEFT JOIN MovementItemContainer AS MIContainer_Master ON MIContainer_Master.Id = MovementItemContainer.ParentId
                 LEFT JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.Id = MIContainer_Master.MovementItemId
                 LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = COALESCE (MovementItem_Parent.ObjectId, MovementItem.ObjectId)

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = COALESCE (MIContainer_Master.MovementItemId, MovementItem.Id)
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = MILinkObject_GoodsKind.ObjectId

            GROUP BY Movement.InvNumber
                   , MovementItemContainer.OperDate
                   , Container.ObjectId
                   , MovementItemContainer.Id
                   , MovementItemContainer.isActive
                   , Object_Branch.ObjectCode
                   , Object_Branch.ValueData
                   , Object_Business.ObjectCode
                   , Object_Business.ValueData
                   , Object_Direction.ObjectCode
                   , Object_Direction.ValueData
                   , Object_ProfitLoss_View.ProfitLossName_all
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Destination.ObjectCode
                   , Object_Destination.ValueData
                   , Object_GoodsKind.ValueData
                   , ContainerObjectCost.ObjectCostId
                   , COALESCE (MovementItem_Parent.Id, MovementItem.Id)
                   , Object_Goods_Parent.ObjectCode
                   , Object_Goods_Parent.ValueData
                   , Object_GoodsKind_Parent.ValueData
                   , Object_JuridicalBasis.ObjectCode
                   , Object_JuridicalBasis.ValueData
                   , lfObject_InfoMoney.InfoMoneyCode
                   , lfObject_InfoMoney.InfoMoneyName
                   , lfObject_InfoMoney_Detail.InfoMoneyCode
                   , lfObject_InfoMoney_Detail.InfoMoneyName
                   , Movement.DescId
                   , tmpSumm_ProductionSeparate.Price
           ) AS tmpMovementItemContainer
           LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpMovementItemContainer.ObjectId
           LEFT JOIN ObjectLink AS ObjectLink_AccountKind
                                ON ObjectLink_AccountKind.ObjectId = tmpMovementItemContainer.ObjectId
                               AND ObjectLink_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
     ;
     END IF;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement_OLD (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.08.14                                        * add !!!проводки только у Админа!!!
 10.08.14                                        * add вот так "просто" выбираем филиал
 27.01.14                                        * add zc_ContainerLinkObject_JuridicalBasis
 13.01.14                                        * add Branch : вот так "не просто" выбираем филиал
 21.12.13                                        * Personal -> Member
 01.11.13                                        * change DebetAccountName and KreditAccountName
 31.10.13                                        * add InvNumber and OperDate
 21.10.13                                        * add zc_ContainerLinkObject_Business
 12.10.13                                        * rename to DirectionObject and DestinationObject
 06.10.13                                        * add ParentId = inMovementId
 02.10.13                                        * calc DebetAccountName and KreditAccountName
 08.09.13                                        * add zc_ContainerLinkObject_ProfitLoss
 02.09.13                        * убрал коды счетов
 25.08.13                                        * add zc_Enum_AccountKind_Active
 10.08.13                                        * add isActive
 06.08.13                                        * add MIId_Parent
 05.08.13                                        * add Goods_Parent and InfoMoney
 11.07.13                                        * add zc_ObjectLink_Account_AccountKind
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        * rename AccountId to ObjectId
 03.07.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemContainer_Movement_OLD (inMovementId:= 338, inSession:= '2')
/*
Код об.напр.
DirectionObjectCode

Объект направление
DirectionObjectName

Код об.назн.
DestinationObjectCode

Объект назначение
DestinationObjectName
*/