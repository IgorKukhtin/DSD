-- Function: gpSelect_MovementItem_ReturnIn_Detail_Commerc()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn_Detail_Commerc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn_Detail_Commerc(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , Amount TFloat, Summa TFloat
             , ContractId_bonus Integer, ContractCode_bonus Integer, ContractName_bonus TVarChar
             , ContractId Integer, ContractCode Integer, ContractName  TVarChar
             , ContractConditionKindId Integer, ContractConditionKindCode Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindCode Integer, BonusKindName  TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased Boolean

             -- дата, з якої діє ціна. 
             , StartDate_fact      TDateTime    --Дата з (факт)
             , StartDate_In        TDateTime    --Дата з (база)
             , StartDate_Plan      TDateTime    --Дата з (план)
  
             , Price_fact            TFloat  --«Ціна факт по договору» - цена факт по прайсу со скидкой
             , Summ_fact             TFloat  --Сумма 
             , Price_In              TFloat  --«Ціна вхідна» - цена вход. по прайсу (База 
             , Summ_In               TFloat  --Сумма         
             , Price_Plan            TFloat  --«Ціна план по договору» -- цена факт по прайсу со скидкой
             , Summ_Plan             TFloat  --Сумма 
             , Price_BonusFirst      TFloat  --«Ціна Бонус (1) план по договору» та суму -  «Ціна план по договору» * Загальний % бонусу з формую оплати «БН».
             , Summ_BonusFirst       TFloat  --Сумма 
             , Price_BonusSecond     TFloat  --«Ціна Бонус (2) план по договору» та суму -  «Ціна план по договору» * Загальний % бонусу з формую оплати «НАЛ».
             , Summ_BonusSecond      TFloat  --Сумма 
             , PricePlan_BonusFirst  TFloat  --«Ціна Бонус (1) факт по договору» та суму - «Ціна факт по договору» * Загальний % бонусу з формую оплати «БН».
             , SummPlan_BonusFirst   TFloat  --Сумма
             , PricePlan_BonusSecond TFloat  -- «Ціна Бонус (2) факт по договору» та суму - «Ціна факт по договору» * Загальний % бонусу з формую оплати «НАЛ».
             , SummPlan_BonusSecond  TFloat  --Сумма
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDatePartner TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- Результат
     RETURN QUERY
       WITH tmpMI_Detail AS (SELECT MovementItem.Id
                                  , MovementItem.ParentId
                                  , MovementItem.Amount
                                  , MovementItem.ObjectId                  AS ContractId_bonus
                                  , MILO_Contract.ObjectId                 AS ContractId
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
           , 0                               :: TFloat AS Summa
           , Object_Contract_bonus.Id                  AS ContractId_bonus
           , Object_Contract_bonus.ObjectCode          AS ContractCode_bonus
           , Object_Contract_bonus.ValueData           AS ContractName_bonus

           , Object_Contract.Id                        AS ContractId
           , Object_Contract.ObjectCode                AS ContractCode
           , Object_Contract.ValueData                 AS ContractName
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
            INNER JOIN Object AS Object_Contract_bonus ON Object_Contract_bonus.Id = tmpMI_Detail.ContractId_bonus AND Object_Contract_bonus.DescId = zc_Object_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpMI_Detail.ContractId
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
 27.05.26         *
*/


-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnIn_Detail_Commerc (inMovementId:= 20155651 ,  inIsErased:= FALSE, inSession:= '9818')     --34384969 
