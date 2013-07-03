-- Запрос возвращает все проводки по документу
-- Function: gpSelect_MovementItemContainer_Movement()

-- DROP FUNCTION gpSelect_MovementItemContainer_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (DebetAmount TFloat, DebetAccountGroupCode Integer, DebetAccountGroupName TVarChar, DebetAccountDirectionCode Integer, DebetAccountDirectionName TVarChar, DebetAccountCode Integer, DebetAccountName  TVarChar
             , KreditAmount TFloat, KreditAccountGroupCode Integer, KreditAccountGroupName TVarChar, KreditAccountDirectionCode Integer, KreditAccountDirectionName TVarChar, KreditAccountCode Integer, KreditAccountName  TVarChar
             , ByObjectCode Integer, ByObjectName TVarChar, GoodsGroupCode Integer, GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar
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

           , tmpMovementItemContainer.ByObjectCode
           , tmpMovementItemContainer.ByObjectName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.GoodsCode
           , tmpMovementItemContainer.GoodsName
       FROM 
           (SELECT 
                  SUM (MovementItemContainer.Amount)  AS Amount
                , Container.AccountId
                , Object_by.ObjectCode         AS ByObjectCode
                , Object_by.ValueData          AS ByObjectName
                , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
                , Object_GoodsGroup.ValueData  AS GoodsGroupName
                , Object_Goods.ObjectCode      AS GoodsCode
                , Object_Goods.ValueData       AS GoodsName
            FROM MovementItemContainer
                 JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                               AND Container.DescId = zc_Container_Summ()
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

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                               ON ContainerLinkObject_Goods.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                              AND 1=0
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ContainerLinkObject_Goods.ObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ContainerLinkObject_Goods.ObjectId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            WHERE MovementItemContainer.MovementId = inMovementId
              AND MovementItemContainer.Amount > 0
            GROUP BY Container.AccountId
                   , Object_by.ObjectCode
                   , Object_by.ValueData
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Goods.ObjectCode
                   , Object_Goods.ValueData
           ) AS tmpMovementItemContainer
           LEFT JOIN lfSelect_Object_Account() AS lfObject_Account ON lfObject_Account.AccountId = tmpMovementItemContainer.AccountId

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

           , tmpMovementItemContainer.ByObjectCode
           , tmpMovementItemContainer.ByObjectName
           , tmpMovementItemContainer.GoodsGroupCode
           , tmpMovementItemContainer.GoodsGroupName
           , tmpMovementItemContainer.GoodsCode
           , tmpMovementItemContainer.GoodsName
       FROM 
           (SELECT 
                  -SUM (MovementItemContainer.Amount)  AS Amount
                , Container.AccountId
                , Object_by.ObjectCode         AS ByObjectCode
                , Object_by.ValueData          AS ByObjectName
                , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
                , Object_GoodsGroup.ValueData  AS GoodsGroupName
                , Object_Goods.ObjectCode      AS GoodsCode
                , Object_Goods.ValueData       AS GoodsName
            FROM MovementItemContainer
                 JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                               AND Container.DescId = zc_Container_Summ()
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

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                               ON ContainerLinkObject_Goods.ContainerId = MovementItemContainer.ContainerId
                                              AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                              AND 1=0
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ContainerLinkObject_Goods.ObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = ContainerLinkObject_Goods.ObjectId
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            WHERE MovementItemContainer.MovementId = inMovementId
              AND MovementItemContainer.Amount < 0
            GROUP BY Container.AccountId
                   , Object_by.ObjectCode
                   , Object_by.ValueData
                   , Object_GoodsGroup.ObjectCode
                   , Object_GoodsGroup.ValueData
                   , Object_Goods.ObjectCode
                   , Object_Goods.ValueData
           ) AS tmpMovementItemContainer
           LEFT JOIN lfSelect_Object_Account() AS lfObject_Account ON lfObject_Account.AccountId = tmpMovementItemContainer.AccountId
      ;
     
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 03.07.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 5140, inSession:= '2')
