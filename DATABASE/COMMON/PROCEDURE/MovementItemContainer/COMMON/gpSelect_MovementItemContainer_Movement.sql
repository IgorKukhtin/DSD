-- Запрос возвращает все проводки по документу
-- Function: gpSelect_MovementItemContainer_Movement()

-- DROP FUNCTION gpSelect_MovementItemContainer_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (DebetAmount TFloat, DebetAccountGroupCode Integer, DebetAccountGroupName TVarChar, DebetAccountDirectionCode Integer, DebetAccountDirectionName TVarChar, DebetAccountCode Integer, DebetAccountName  TVarChar
             , KreditAmount TFloat, KreditAccountGroupCode Integer, KreditAccountGroupName TVarChar, KreditAccountDirectionCode Integer, KreditAccountDirectionName TVarChar, KreditAccountCode Integer, KreditAccountName  TVarChar
             , Price TFloat
             , AccountOnComplete Boolean, ByObjectCode Integer, ByObjectName TVarChar, GoodsGroupCode Integer, GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , ObjectCostId Integer, MIId_Parent Integer, GoodsCode_Parent Integer, GoodsName_Parent TVarChar, GoodsKindName_Parent TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItemContainer_Movement());

     RETURN QUERY 
       SELECT
             CAST (CASE WHEN tmpMovementItemContainer.isActive = TRUE THEN tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS DebetAmount
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountGroupCode ELSE NULL END  AS Integer) AS DebetAccountGroupCode
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountGroupName ELSE NULL END  AS TVarChar) AS DebetAccountGroupName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountDirectionCode ELSE NULL END  AS Integer) AS DebetAccountDirectionCode
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountDirectionName ELSE NULL END  AS TVarChar) AS DebetAccountDirectionName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountCode ELSE NULL END  AS Integer) AS DebetAccountCode
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountName ELSE NULL END  AS TVarChar) AS DebetAccountName

           , CAST (CASE WHEN tmpMovementItemContainer.isActive = FALSE THEN -1 * tmpMovementItemContainer.Amount ELSE 0 END AS TFloat) AS KreditAmount
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountGroupCode ELSE NULL END  AS Integer) AS KreditAccountGroupCode
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountGroupName ELSE NULL END  AS TVarChar) AS KreditAccountGroupName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountDirectionCode ELSE NULL END  AS Integer) AS KreditAccountDirectionCode
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountDirectionName ELSE NULL END  AS TVarChar) AS KreditAccountDirectionName
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountCode ELSE NULL END  AS Integer) AS KreditAccountCode
           , CAST (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Active() THEN lfObject_Account.AccountName ELSE NULL END  AS TVarChar) AS KreditAccountName

           , CAST (tmpMovementItemContainer.Price AS TFloat) AS Price
           , lfObject_Account.onComplete AS AccountOnComplete
           , tmpMovementItemContainer.ByObjectCode
           , tmpMovementItemContainer.ByObjectName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.GoodsCode
           , tmpMovementItemContainer.GoodsName
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
                  SUM (MovementItemContainer.Amount)  AS Amount
                , MovementItemContainer.isActive
                , Container.ObjectId
                , Object_by.ObjectCode         AS ByObjectCode
                , Object_by.ValueData          AS ByObjectName
                , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
                , Object_GoodsGroup.ValueData  AS GoodsGroupName
                , Object_Goods.ObjectCode      AS GoodsCode
                , Object_Goods.ValueData       AS GoodsName
                , Object_GoodsKind.ValueData   AS GoodsKindName
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
            FROM MovementItemContainer
                 LEFT JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                 LEFT JOIN MovementItemContainer AS MIContainer_Parent ON MIContainer_Parent.Id = MovementItemContainer.ParentId
                                                                      AND Container.ObjectId = zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"

                 LEFT JOIN Movement ON Movement.Id = inMovementId
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
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                               ON ContainerLinkObject_Juridical.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                               ON ContainerLinkObject_Personal.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                               ON ContainerLinkObject_Unit.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                 LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (ContainerLinkObject_Juridical.ObjectId, COALESCE (ContainerLinkObject_Personal.ObjectId, ContainerLinkObject_Unit.ObjectId))

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
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ContainerLinkObject_Goods.ObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ContainerLinkObject_Goods.ObjectId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                               ON ContainerLinkObject_GoodsKind.ContainerId = COALESCE (MIContainer_Parent.ContainerId, MovementItemContainer.ContainerId)
                                              AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                              -- AND 1=0
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ContainerLinkObject_GoodsKind.ObjectId

                 LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId

                 LEFT JOIN MovementItemContainer AS MIContainer_Master ON MIContainer_Master.Id = MovementItemContainer.ParentId
                 LEFT JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.Id = MIContainer_Master.MovementItemId
                 LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = COALESCE (MovementItem_Parent.ObjectId, MovementItem.ObjectId)

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = COALESCE (MIContainer_Master.MovementItemId, MovementItem.Id)
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = MILinkObject_GoodsKind.ObjectId

            WHERE MovementItemContainer.MovementId = inMovementId
              AND MovementItemContainer.DescId = zc_MIContainer_Summ()
            GROUP BY Container.ObjectId
                   , MovementItemContainer.Id
                   , MovementItemContainer.isActive
                   , Object_by.ObjectCode
                   , Object_by.ValueData
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Goods.ObjectCode
                   , Object_Goods.ValueData
                   , Object_GoodsKind.ValueData
                   , ContainerObjectCost.ObjectCostId
                   , COALESCE (MovementItem_Parent.Id, MovementItem.Id)
                   , Object_Goods_Parent.ObjectCode
                   , Object_Goods_Parent.ValueData
                   , Object_GoodsKind_Parent.ValueData
                   , lfObject_InfoMoney.InfoMoneyCode
                   , lfObject_InfoMoney.InfoMoneyName
                   , lfObject_InfoMoney_Detail.InfoMoneyCode
                   , lfObject_InfoMoney_Detail.InfoMoneyName
                   , Movement.DescId
                   , tmpSumm_ProductionSeparate.Price
           ) AS tmpMovementItemContainer
           LEFT JOIN lfSelect_Object_Account() AS lfObject_Account ON lfObject_Account.AccountId = tmpMovementItemContainer.ObjectId
           LEFT JOIN ObjectLink AS ObjectLink_AccountKind
                                ON ObjectLink_AccountKind.ObjectId = tmpMovementItemContainer.ObjectId
                               AND ObjectLink_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
     ;
     
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 14089, inSession:= '2')
