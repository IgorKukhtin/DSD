-- Запрос возвращает все проводки по документу
-- Function: gpSelect_MovementItemContainer_Movement()

-- DROP FUNCTION gpSelect_MovementItemContainer_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (DebetAmount TFloat, DebetAccountGroupCode Integer, DebetAccountGroupName TVarChar, DebetAccountDirectionCode Integer, DebetAccountDirectionName TVarChar, DebetAccountCode Integer, DebetAccountName  TVarChar
             , KreditAmount TFloat, KreditAccountGroupCode Integer, KreditAccountGroupName TVarChar, KreditAccountDirectionCode Integer, KreditAccountDirectionName TVarChar, KreditAccountCode Integer, KreditAccountName  TVarChar
             , AccountOnComplete Boolean, ByObjectCode Integer, ByObjectName TVarChar, GoodsGroupCode Integer, GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , MIId_Parent Integer, GoodsCode_Parent Integer, GoodsName_Parent TVarChar, GoodsKindName_Parent TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItemContainer_Movement());

     RETURN QUERY 
       SELECT
             CAST (tmpMovementItemContainer.Amount AS TFloat) AS DebetAmount
           , lfObject_Account.AccountGroupCode                AS DebetAccountGroupCode
           , lfObject_Account.AccountGroupName                AS DebetAccountGroupName
           , lfObject_Account.AccountDirectionCode            AS DebetAccountDirectionCode
           , lfObject_Account.AccountDirectionName            AS DebetAccountDirectionName
           , lfObject_Account.AccountCode                     AS DebetAccountCode
           , lfObject_Account.AccountName                     AS DebetAccountName

           , CAST (NULL AS TFloat)          AS KreditAmount
           , CAST (NULL AS Integer)         AS KreditAccountGroupCode
           , CAST ('' AS TVarChar)          AS KreditAccountGroupName
           , CAST (NULL AS Integer)         AS KreditAccountDirectionCode
           , CAST ('' AS TVarChar)          AS KreditAccountDirectionName
           , CAST (NULL AS Integer)         AS KreditAccountCode
           , CAST ('' AS TVarChar)          AS KreditAccountName

           , lfObject_Account.onComplete AS AccountOnComplete
           , tmpMovementItemContainer.ByObjectCode
           , tmpMovementItemContainer.ByObjectName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.GoodsCode
           , tmpMovementItemContainer.GoodsName
           , tmpMovementItemContainer.GoodsKindName
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
                , Container.ObjectId
                , Object_by.ObjectCode         AS ByObjectCode
                , Object_by.ValueData          AS ByObjectName
                , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
                , Object_GoodsGroup.ValueData  AS GoodsGroupName
                , Object_Goods.ObjectCode      AS GoodsCode
                , Object_Goods.ValueData       AS GoodsName
                , Object_GoodsKind.ValueData   AS GoodsKindName
                , COALESCE (MovementItem_Parent.Id, MovementItem.Id) AS MIId_Parent
                , Object_Goods_Parent.ObjectCode      AS GoodsCode_Parent
                , Object_Goods_Parent.ValueData       AS GoodsName_Parent
                , Object_GoodsKind_Parent.ValueData   AS GoodsKindName_Parent
                , lfObject_InfoMoney.InfoMoneyCode
                , lfObject_InfoMoney.InfoMoneyName
                , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
                , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail
            FROM MovementItemContainer
                 JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                               AND Container.DescId = zc_Container_Summ()
                 LEFT JOIN ObjectLink AS ObjectLink_AccountKind
                                      ON ObjectLink_AccountKind.ObjectId = Container.ObjectId
                                     AND ObjectLink_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                               ON ContainerLinkObject_Juridical.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                               ON ContainerLinkObject_Personal.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                               ON ContainerLinkObject_Unit.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                 LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (ContainerLinkObject_Juridical.ObjectId, COALESCE (ContainerLinkObject_Personal.ObjectId, ContainerLinkObject_Unit.ObjectId))

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                               ON ContainerLinkObject_InfoMoney.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                              -- AND 1=0
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                               ON ContainerLinkObject_InfoMoneyDetail.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                              -- AND 1=0
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = CASE WHEN COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) = 0 THEN ContainerLinkObject_InfoMoney.ObjectId ELSE ContainerLinkObject_InfoMoneyDetail.ObjectId END

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                               ON ContainerLinkObject_Goods.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                              -- AND 1=0
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ContainerLinkObject_Goods.ObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ContainerLinkObject_Goods.ObjectId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                               ON ContainerLinkObject_GoodsKind.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                              -- AND 1=0
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ContainerLinkObject_GoodsKind.ObjectId

                 LEFT JOIN MovementItemContainer AS MovementItemContainer_Parent ON MovementItemContainer_Parent.Id = MovementItemContainer.ParentId

                 LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                 LEFT JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.Id = MovementItemContainer_Parent.MovementItemId
                 LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = COALESCE (MovementItem_Parent.ObjectId, MovementItem.ObjectId)

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = COALESCE (MovementItem_Parent.Id, MovementItem.Id)
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = MILinkObject_GoodsKind.ObjectId

            WHERE MovementItemContainer.MovementId = inMovementId
              -- AND COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Passive()
              AND MovementItemContainer.Amount >= 0
            GROUP BY Container.ObjectId
                   , MovementItemContainer.Id
                   , Object_by.ObjectCode
                   , Object_by.ValueData
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Goods.ObjectCode
                   , Object_Goods.ValueData
                   , Object_GoodsKind.ValueData
                   , COALESCE (MovementItem_Parent.Id, MovementItem.Id)
                   , Object_Goods_Parent.ObjectCode
                   , Object_Goods_Parent.ValueData
                   , Object_GoodsKind_Parent.ValueData
                   , lfObject_InfoMoney.InfoMoneyCode
                   , lfObject_InfoMoney.InfoMoneyName
                   , lfObject_InfoMoney_Detail.InfoMoneyCode
                   , lfObject_InfoMoney_Detail.InfoMoneyName
           ) AS tmpMovementItemContainer
           LEFT JOIN lfSelect_Object_Account() AS lfObject_Account ON lfObject_Account.AccountId = tmpMovementItemContainer.ObjectId

      UNION ALL
       SELECT
             CAST (NULL AS TFloat)          AS DebetAmount
           , CAST (NULL AS Integer)         AS DebetAccountGroupCode
           , CAST ('' AS TVarChar)          AS DebetAccountGroupName
           , CAST (NULL AS Integer)         AS DebetAccountDirectionCode
           , CAST ('' AS TVarChar)          AS DebetAccountDirectionName
           , CAST (NULL AS Integer)         AS DebetAccountCode
           , CAST ('' AS TVarChar)          AS DebetAccountName

           , CAST (tmpMovementItemContainer.Amount AS TFloat) AS KreditAmount
           , lfObject_Account.AccountGroupCode                AS KreditAccountGroupCode
           , lfObject_Account.AccountGroupName                AS KreditAccountGroupName
           , lfObject_Account.AccountDirectionCode            AS KreditAccountDirectionCode
           , lfObject_Account.AccountDirectionName            AS KreditAccountDirectionName
           , lfObject_Account.AccountCode                     AS KreditAccountCode
           , lfObject_Account.AccountName                     AS KreditAccountName

           , lfObject_Account.onComplete AS AccountOnComplete
           , tmpMovementItemContainer.ByObjectCode
           , tmpMovementItemContainer.ByObjectName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.GoodsCode
           , tmpMovementItemContainer.GoodsName
           , tmpMovementItemContainer.GoodsKindName
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
                  -SUM (MovementItemContainer.Amount)  AS Amount
                , Container.ObjectId
                , Object_by.ObjectCode         AS ByObjectCode
                , Object_by.ValueData          AS ByObjectName
                , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
                , Object_GoodsGroup.ValueData  AS GoodsGroupName
                , Object_Goods.ObjectCode      AS GoodsCode
                , Object_Goods.ValueData       AS GoodsName
                , Object_GoodsKind.ValueData   AS GoodsKindName
                , COALESCE (MovementItem_Parent.Id, MovementItem.Id) AS MIId_Parent
                , Object_Goods_Parent.ObjectCode      AS GoodsCode_Parent
                , Object_Goods_Parent.ValueData       AS GoodsName_Parent
                , Object_GoodsKind_Parent.ValueData   AS GoodsKindName_Parent
                , lfObject_InfoMoney.InfoMoneyCode
                , lfObject_InfoMoney.InfoMoneyName
                , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
                , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail
            FROM MovementItemContainer
                 JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                               AND Container.DescId = zc_Container_Summ()
                 LEFT JOIN ObjectLink AS ObjectLink_AccountKind
                                      ON ObjectLink_AccountKind.ObjectId = Container.ObjectId
                                     AND ObjectLink_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                               ON ContainerLinkObject_Juridical.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                               ON ContainerLinkObject_Personal.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                               ON ContainerLinkObject_Unit.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                 LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (ContainerLinkObject_Juridical.ObjectId, COALESCE (ContainerLinkObject_Personal.ObjectId, ContainerLinkObject_Unit.ObjectId))

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                               ON ContainerLinkObject_InfoMoney.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                              -- AND 1=0
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                               ON ContainerLinkObject_InfoMoneyDetail.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                              -- AND 1=0
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = CASE WHEN COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) = 0 THEN ContainerLinkObject_InfoMoney.ObjectId ELSE ContainerLinkObject_InfoMoneyDetail.ObjectId END

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                               ON ContainerLinkObject_Goods.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                              -- AND 1=0
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ContainerLinkObject_Goods.ObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ContainerLinkObject_Goods.ObjectId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                               ON ContainerLinkObject_GoodsKind.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                              -- AND 1=0
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ContainerLinkObject_GoodsKind.ObjectId

                 LEFT JOIN MovementItemContainer AS MovementItemContainer_Parent ON MovementItemContainer_Parent.Id = MovementItemContainer.ParentId

                 LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                 LEFT JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.Id = MovementItemContainer_Parent.MovementItemId
                 LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = COALESCE (MovementItem_Parent.ObjectId, MovementItem.ObjectId)

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = COALESCE (MovementItem_Parent.Id, MovementItem.Id)
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = MILinkObject_GoodsKind.ObjectId

            WHERE MovementItemContainer.MovementId = inMovementId
              -- AND ObjectLink_AccountKind.ChildObjectId = zc_Enum_AccountKind_Passive()
              AND MovementItemContainer.Amount < 0
            GROUP BY Container.ObjectId
                   , MovementItemContainer.Id
                   , Object_by.ObjectCode
                   , Object_by.ValueData
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Goods.ObjectCode
                   , Object_Goods.ValueData
                   , Object_GoodsKind.ValueData
                   , COALESCE (MovementItem_Parent.Id, MovementItem.Id)
                   , Object_Goods_Parent.ObjectCode
                   , Object_Goods_Parent.ValueData
                   , Object_GoodsKind_Parent.ValueData
                   , lfObject_InfoMoney.InfoMoneyCode
                   , lfObject_InfoMoney.InfoMoneyName
                   , lfObject_InfoMoney_Detail.InfoMoneyCode
                   , lfObject_InfoMoney_Detail.InfoMoneyName
           ) AS tmpMovementItemContainer
           LEFT JOIN lfSelect_Object_Account() AS lfObject_Account ON lfObject_Account.AccountId = tmpMovementItemContainer.ObjectId;
     
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.13                                        * add MIId_Parent
 05.08.13                                        * add Goods_Parent and InfoMoney
 11.07.13                                        * add zc_ObjectLink_Account_AccountKind
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        * rename AccountId to ObjectId
 03.07.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 7769, inSession:= '2')
