-- Function: gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LossDebt(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , BranchId Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , UnitId Integer, UnitName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , AmountDebet TFloat, AmountKredit TFloat
             , SummDebet TFloat, SummKredit TFloat
             , Summ_100301 TFloat
             , ContainerId TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , AmountCurrencyDebet TFloat, AmountCurrencyKredit TFloat
             , isCalculated Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_LossDebt());
     vbUserId:= lpGetUserBySession (inSession);

     IF inShowAll THEN 

     -- Результат
     RETURN QUERY 
     WITH 
     tmpMIContainer AS (SELECT MIContainer.MovementItemId
                             , SUM (MIContainer.Amount) AS Summ_100301
                        FROM MovementItemContainer AS MIContainer
                        WHERE MIContainer.MovementId = inMovementId
                          AND MIContainer.AccountId = zc_Enum_Account_100301()
                        GROUP BY MIContainer.MovementItemId
                        )


       SELECT 0  :: Integer                            AS Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract.ContractId                 AS ContractId
            , View_Contract.ContractCode               AS ContractCode
            , View_Contract.InvNumber                  AS ContractName
            , View_Contract.ContractTagName            AS ContractTagName

            , Object_Juridical.Id                      AS JuridicalId
            , Object_Juridical.ObjectCode              AS JuridicalCode
            , Object_Juridical.ValueData               AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO AS OKPO
            , Object_JuridicalGroup.ValueData          AS JuridicalGroupName 
            
            , Object_JuridicalBasis.Id                 AS JuridicalBasisId
            , Object_JuridicalBasis.ObjectCode         AS JuridicalBasisCode
            , Object_JuridicalBasis.ValueData          AS JuridicalBasisName 
                        
            , 0  :: Integer                   AS PartnerId
            , 0  :: Integer                   AS PartnerCode
            , '' :: TVarChar                  AS PartnerName
            , 0 :: Integer                    AS BranchId
            , '' :: TVarChar                  AS BranchName
            , Object_PaidKind.Id              AS PaidKindId
            , Object_PaidKind.ValueData       AS PaidKindName
            , 0  :: Integer                   AS UnitId
            , '' :: TVarChar                  AS UnitName
            , 0  :: Integer                   AS CurrencyId
            , '' :: TVarChar                  AS CurrencyName
                                            
           , 0   :: TFloat                    AS AmountDebet
           , 0   :: TFloat                    AS AmountKredit
           , 0   :: TFloat                    AS SummDebet
           , 0   :: TFloat                    AS SummKredit
           , 0   :: TFloat                    AS Summ_100301
                                              
           , 0   :: TFloat                    AS ContainerId

           , 0   :: TFloat                    AS CurrencyPartnerValue
           , 0   :: TFloat                    AS ParPartnerValue
           , 0   :: TFloat                    AS AmountCurrencyDebet
           , 0   :: TFloat                    AS AmountCurrencyKredit
                                              

                                            
           , TRUE                             AS isCalculated
           , FALSE                            AS isErased
                  
       FROM Object AS Object_Juridical
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id
                                                           AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                           AND View_Contract.isErased = FALSE

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

            LEFT JOIN (SELECT MovementItem.ObjectId AS JuridicalId
                            , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                            , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
                            , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId
                            , COALESCE (MILinkObject_JuridicalBasis.ObjectId, 0) AS JuridicalBasisId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     =  zc_MI_Master()
                                             AND MovementItem.isErased   =  tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                                             ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_JuridicalBasis.DescId = zc_MILinkObject_JuridicalBasis()            
                      ) AS tmpMI ON tmpMI.JuridicalId = Object_Juridical.Id
                                AND tmpMI.InfoMoneyId = COALESCE (View_InfoMoney.InfoMoneyId, 0)
                                AND tmpMI.ContractId = COALESCE (View_Contract.ContractId, 0)
                                AND tmpMI.PaidKindId = COALESCE (Object_PaidKind.Id, 0)
                                AND tmpMI.JuridicalBasisId = COALESCE (View_Contract.JuridicalBasisId, zc_Juridical_Basis())

            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = COALESCE (View_Contract.JuridicalBasisId, zc_Juridical_Basis())

     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       AND tmpMI.JuridicalId IS NULL

      UNION ALL
       SELECT MovementItem.Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract_InvNumber.ContractId               AS ContractId
            , View_Contract_InvNumber.ContractCode             AS ContractCode
            , View_Contract_InvNumber.InvNumber                AS ContractName
            , View_Contract_InvNumber.ContractTagName          AS ContractTagName

            , Object_Juridical.Id                              AS JuridicalId
            , Object_Juridical.ObjectCode                      AS JuridicalCode
            , Object_Juridical.ValueData                       AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO         AS OKPO
            , Object_JuridicalGroup.ValueData                  AS JuridicalGroupName 

            , Object_JuridicalBasis.Id                         AS JuridicalBasisId
            , Object_JuridicalBasis.ObjectCode                 AS JuridicalBasisCode
            , Object_JuridicalBasis.ValueData                  AS JuridicalBasisName     

            , Object_Partner.Id                                AS PartnerId
            , Object_Partner.ObjectCode                        AS PartnerCode
            , Object_Partner.ValueData                         AS PartnerName
            , Object_Branch.Id                                 AS BranchId
            , Object_Branch.ValueData                          AS BranchName
                                                             
            , Object_PaidKind.Id                               AS PaidKindId
            , Object_PaidKind.ValueData                        AS PaidKindName
            , Object_Unit.Id                                   AS UnitId
            , Object_Unit.ValueData                            AS UnitName
            , Object_Currency.Id                               AS CurrencyId
            , Object_Currency.ValueData                        AS CurrencyName

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END                                     :: TFloat AS AmountDebet
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END                                     :: TFloat AS AmountKredit

           , CASE WHEN MIFloat_Summ.ValueData > 0
                       THEN MIFloat_Summ.ValueData
                  ELSE 0
             END                                     :: TFloat AS SummDebet
           , CASE WHEN MIFloat_Summ.ValueData < 0
                       THEN -1 * MIFloat_Summ.ValueData
                  ELSE 0
             END                                     :: TFloat AS SummKredit

            , tmpMIContainer.Summ_100301             :: TFloat AS Summ_100301

            , MIFloat_ContainerId.ValueData          :: TFloat AS ContainerId

            , MIFloat_CurrencyPartnerValue.ValueData :: TFloat AS CurrencyPartnerValue
            , MIFloat_ParPartnerValue.ValueData      :: TFloat AS ParPartnerValue

            , CASE WHEN MIFloat_AmountCurrency.ValueData > 0
                       THEN MIFloat_AmountCurrency.ValueData
                       ELSE 0
              END                                    :: TFloat AS AmountCurrencyDebet

            , CASE WHEN MIFloat_AmountCurrency.ValueData < 0
                       THEN -1 * MIFloat_AmountCurrency.ValueData
                       ELSE 0
              END                                    :: TFloat AS AmountCurrencyKredit

            , MIBoolean_Calculated.ValueData                   AS isCalculated

            , MovementItem.isErased                            AS isErased
                  
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
       
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId 
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyPartnerValue
                                        ON MIFloat_CurrencyPartnerValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_CurrencyPartnerValue.DescId = zc_MIFloat_CurrencyPartnerValue()
            LEFT JOIN MovementItemFloat AS MIFloat_ParPartnerValue
                                        ON MIFloat_ParPartnerValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ParPartnerValue.DescId = zc_MIFloat_ParPartnerValue()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountCurrency 
                                        ON MIFloat_AmountCurrency.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountCurrency.DescId = zc_MIFloat_AmountCurrency()
                                       
            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                          ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
                                                                     AND View_Contract_InvNumber.JuridicalId = Object_Juridical.Id

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId
            
            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                             ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                            AND MILinkObject_JuridicalBasis.DescId = zc_MILinkObject_JuridicalBasis()            
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = CASE WHEN MILinkObject_JuridicalBasis.ObjectId > 0
                                                                                         THEN MILinkObject_JuridicalBasis.ObjectId
                                                                                         ELSE COALESCE (View_Contract_InvNumber.JuridicalBasisId, zc_Juridical_Basis()) 
                                                                                    END

      ;

     ELSE

     -- Результат
     RETURN QUERY 
     WITH 
     tmpMIContainer AS (SELECT MIContainer.MovementItemId
                             , SUM (MIContainer.Amount) AS Summ_100301
                        FROM MovementItemContainer AS MIContainer
                        WHERE MIContainer.MovementId = inMovementId
                          AND MIContainer.AccountId = zc_Enum_Account_100301()
                        GROUP BY MIContainer.MovementItemId
                        )
       SELECT MovementItem.Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract_InvNumber.ContractId               AS ContractId
            , View_Contract_InvNumber.ContractCode             AS ContractCode
            , View_Contract_InvNumber.InvNumber                AS ContractName
            , View_Contract_InvNumber.ContractTagName          AS ContractTagName

            , Object_Juridical.Id                              AS JuridicalId
            , Object_Juridical.ObjectCode                      AS JuridicalCode
            , Object_Juridical.ValueData                       AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO         AS OKPO
            , Object_JuridicalGroup.ValueData                  AS JuridicalGroupName
            
            , Object_JuridicalBasis.Id                         AS JuridicalBasisId
            , Object_JuridicalBasis.ObjectCode                 AS JuridicalBasisCode
            , Object_JuridicalBasis.ValueData                  AS JuridicalBasisName

            , Object_Partner.Id                                AS PartnerId
            , Object_Partner.ObjectCode                        AS PartnerCode
            , Object_Partner.ValueData                         AS PartnerName
            , Object_Branch.Id                                 AS BranchId
            , Object_Branch.ValueData                          AS BranchName
            , Object_PaidKind.Id                               AS PaidKindId
            , Object_PaidKind.ValueData                        AS PaidKindName
            , Object_Unit.Id                                   AS UnitId
            , Object_Unit.ValueData                            AS UnitName
            , Object_Currency.Id                               AS CurrencyId
            , Object_Currency.ValueData                        AS CurrencyName

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END                                     :: TFloat AS AmountDebet
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END                                     :: TFloat AS AmountKredit

           , CASE WHEN MIFloat_Summ.ValueData > 0
                       THEN MIFloat_Summ.ValueData
                  ELSE 0
             END                                     :: TFloat AS SummDebet
           , CASE WHEN MIFloat_Summ.ValueData < 0
                       THEN -1 * MIFloat_Summ.ValueData
                  ELSE 0
             END                                     :: TFloat AS SummKredit

            , tmpMIContainer.Summ_100301             :: TFloat AS Summ_100301

            , MIFloat_ContainerId.ValueData          :: TFloat AS ContainerId
            
            , MIFloat_CurrencyPartnerValue.ValueData :: TFloat AS CurrencyPartnerValue
            , MIFloat_ParPartnerValue.ValueData      :: TFloat AS ParPartnerValue
            
            , CASE WHEN MIFloat_AmountCurrency.ValueData > 0
                       THEN MIFloat_AmountCurrency.ValueData
                       ELSE 0
              END                                    :: TFloat AS AmountCurrencyDebet

            , CASE WHEN MIFloat_AmountCurrency.ValueData < 0
                       THEN -1 * MIFloat_AmountCurrency.ValueData
                       ELSE 0
              END                                    :: TFloat AS AmountCurrencyKredit

            , MIBoolean_Calculated.ValueData                   AS isCalculated
            , MovementItem.isErased                            AS isErased
                  
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
       
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId 
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId AND (ObjectLink_Partner_Juridical.ChildObjectId = MovementItem.ObjectId OR MILinkObject_Partner.ObjectId IS NULL OR MIFloat_ContainerId.ValueData > 0)
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyPartnerValue
                                        ON MIFloat_CurrencyPartnerValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_CurrencyPartnerValue.DescId = zc_MIFloat_CurrencyPartnerValue()
            LEFT JOIN MovementItemFloat AS MIFloat_ParPartnerValue
                                        ON MIFloat_ParPartnerValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ParPartnerValue.DescId = zc_MIFloat_ParPartnerValue()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountCurrency 
                                        ON MIFloat_AmountCurrency.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountCurrency.DescId = zc_MIFloat_AmountCurrency()
                                                                              
            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                          ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
           
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
                                                                     AND View_Contract_InvNumber.JuridicalId = Object_Juridical.Id

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                             ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                            AND MILinkObject_JuridicalBasis.DescId = zc_MILinkObject_JuridicalBasis()            
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = CASE WHEN MILinkObject_JuridicalBasis.ObjectId > 0
                                                                                         THEN MILinkObject_JuridicalBasis.ObjectId
                                                                                         ELSE COALESCE (View_Contract_InvNumber.JuridicalBasisId, zc_Juridical_Basis()) 
                                                                                    END

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id
      ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.10.18         *
 31.07.17         *
 19.14.16         *
 07.09.14                                        * add Branch...
 27.08.14                                        * add Partner...
 25.08.14                                        * add JuridicalGroupName
 06.03.14                                        * add zc_Enum_ContractStateKind_Close
 16.01.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
