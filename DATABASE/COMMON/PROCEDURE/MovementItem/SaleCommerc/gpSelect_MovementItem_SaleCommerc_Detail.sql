-- Function: gpSelect_MovementItem_SaleCommerc_Detail()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SaleCommerc_Detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SaleCommerc_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , Amount TFloat--, Summa TFloat
             , ContractId_bonus Integer, ContractCode_bonus Integer, ContractName_bonus TVarChar
             , ContractId Integer, ContractCode Integer, ContractName  TVarChar
             , ContractId_Child Integer, ContractCode_Child Integer, ContractName_Child  TVarChar
             , ContractConditionKindId Integer, ContractConditionKindCode Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindCode Integer, BonusKindName  TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDatePartner TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат
     RETURN QUERY
       WITH tmpMI_Detail AS (SELECT MovementItem.Id
                                  , MovementItem.ParentId
                                  , MovementItem.Amount
                                  , MovementItem.ObjectId                  AS ContractId_bonus
                                  , MILO_Contract.ObjectId                 AS ContractId
                                  , MILO_ContractChild.ObjectId            AS ContractId_Child
                                  , MILO_ContractConditionKind.ObjectId    AS ContractConditionKindId
                                  , MILO_BonusKind.ObjectId                AS BonusKindId
                                  , MILinkObject_PaidKind.ObjectId         AS PaidKindId
                                  , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                                  , MovementItem.isErased
                             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Detail()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
 
                                  LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                                   ON MILO_Contract.MovementItemId = MovementItem.Id
                                                                  AND MILO_Contract.DescId = zc_MILinkObject_Contract()
 
                                  LEFT JOIN MovementItemLinkObject AS MILO_ContractChild
                                                                   ON MILO_ContractChild.MovementItemId = MovementItem.Id
                                                                  AND MILO_ContractChild.DescId = zc_MILinkObject_ContractChild()

                                  LEFT JOIN MovementItemLinkObject AS MILO_ContractConditionKind
                                                                   ON MILO_ContractConditionKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()

                                  LEFT JOIN MovementItemLinkObject AS MILO_BonusKind
                                                                   ON MILO_BonusKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_BonusKind.DescId = zc_MILinkObject_BonusKind()
                                
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()                                  
                          )
 
       -- Результат
       SELECT
             tmpMI_Detail.Id
           , tmpMI_Detail.ParentId

           , tmpMI_Detail.Amount             :: TFloat AS Amount
           --, (vbTotalSumm * tmpMI_Detail.Amount / 100) :: TFloat AS Summa
           , Object_Contract_bonus.Id                  AS ContractId_bonus
           , Object_Contract_bonus.ObjectCode          AS ContractCode_bonus
           , Object_Contract_bonus.ValueData           AS ContractName_bonus

           , Object_Contract.Id                        AS ContractId
           , Object_Contract.ObjectCode                AS ContractCode
           , Object_Contract.ValueData                 AS ContractName
           , Object_Contract_Child.Id                  AS ContractId_Child
           , Object_Contract_Child.ObjectCode          AS ContractCode_Child
           , Object_Contract_Child.ValueData           AS ContractName_Child
           , Object_ContractConditionKind.Id           AS ContractConditionKindId
           , Object_ContractConditionKind.ObjectCode   AS ContractConditionKindCode
           , Object_ContractConditionKind.ValueData    AS ContractConditionKindName
           , Object_BonusKind.Id                       AS BonusKindId
           , Object_BonusKind.ObjectCode               AS BonusKindCode
           , Object_BonusKind.ValueData                AS BonusKindName
           , Object_PaidKind.Id                        AS PaidKindId
           , Object_PaidKind.ValueData                 AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , tmpMI_Detail.isErased
       FROM tmpMI_Detail
            LEFT JOIN Object AS Object_Contract_bonus ON Object_Contract_bonus.Id = tmpMI_Detail.ContractId_bonus
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpMI_Detail.ContractId
            LEFT JOIN Object AS Object_Contract_Child ON Object_Contract_Child.Id = tmpMI_Detail.ContractId_Child
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpMI_Detail.ContractConditionKindId
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpMI_Detail.BonusKindId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMI_Detail.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpMI_Detail.InfoMoneyId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.26         *
*/


-- тест
-- SELECT * FROM gpSelect_MovementItem_SaleCommerc_Detail (inMovementId:= 20155651 ,  inIsErased:= FALSE, inSession:= '9818')     --34384969 
