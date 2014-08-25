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
             , ContractId Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , UnitId Integer, UnitName TVarChar
             , AmountDebet TFloat, AmountKredit TFloat
             , SummDebet TFloat, SummKredit TFloat
             , isCalculated Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_LossDebt());
     vbUserId:= inSession;

     IF inShowAll THEN 

     -- Результат
     RETURN QUERY 

       SELECT 0 :: Integer AS Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract.ContractId
            , View_Contract.InvNumber AS ContractName

            , Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ValueData  AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO
            , Object_JuridicalGroup.ValueData AS JuridicalGroupName
            , Object_PaidKind.Id          AS PaidKindId
            , Object_PaidKind.ValueData   AS PaidKindName
            , 0 :: Integer   AS UnitId
            , '' :: TVarChar AS UnitName

           , 0 :: TFloat AS AmountDebet
           , 0 :: TFloat AS AmountKredit
           , 0 :: TFloat AS SummDebet
           , 0 :: TFloat AS SummKredit

            , TRUE AS isCalculated

            , FALSE  AS isErased
                  
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
                      ) AS tmpMI ON tmpMI.JuridicalId = Object_Juridical.Id
                                AND tmpMI.InfoMoneyId = COALESCE (View_InfoMoney.InfoMoneyId, 0)
                                AND tmpMI.ContractId = COALESCE (View_Contract.ContractId, 0)
                                AND tmpMI.PaidKindId = COALESCE (Object_PaidKind.Id, 0)

     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       AND tmpMI.JuridicalId IS NULL

      UNION ALL
       SELECT MovementItem.Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract_InvNumber.ContractId
            , View_Contract_InvNumber.InvNumber AS ContractName

            , Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ValueData  AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO
            , Object_JuridicalGroup.ValueData AS JuridicalGroupName
            , Object_PaidKind.Id          AS PaidKindId
            , Object_PaidKind.ValueData   AS PaidKindName
            , Object_Unit.Id              AS UnitId
            , Object_Unit.ValueData       AS UnitName

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountDebet
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountKredit

           , CASE WHEN MIFloat_Summ.ValueData > 0
                       THEN MIFloat_Summ.ValueData
                  ELSE 0
             END::TFloat AS SummDebet
           , CASE WHEN MIFloat_Summ.ValueData < 0
                       THEN -1 * MIFloat_Summ.ValueData
                  ELSE 0
             END::TFloat AS SummKredit

            , MIBoolean_Calculated.ValueData AS isCalculated

            , MovementItem.isErased       AS isErased
                  
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
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId
      ;

     ELSE

     -- Результат
     RETURN QUERY 
       SELECT MovementItem.Id

            , View_InfoMoney.InfoMoneyGroupName
            , View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , View_Contract_InvNumber.ContractId
            , View_Contract_InvNumber.InvNumber AS ContractName

            , Object_Juridical.Id         AS JuridicalId
            , Object_Juridical.ValueData  AS JuridicalName
            , ObjectHistory_JuridicalDetails_View.OKPO
            , Object_JuridicalGroup.ValueData AS JuridicalGroupName
            , Object_PaidKind.Id          AS PaidKindId
            , Object_PaidKind.ValueData   AS PaidKindName
            , Object_Unit.Id              AS UnitId
            , Object_Unit.ValueData       AS UnitName

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountDebet
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountKredit

           , CASE WHEN MIFloat_Summ.ValueData > 0
                       THEN MIFloat_Summ.ValueData
                  ELSE 0
             END::TFloat AS SummDebet
           , CASE WHEN MIFloat_Summ.ValueData < 0
                       THEN -1 * MIFloat_Summ.ValueData
                  ELSE 0
             END::TFloat AS SummKredit

            , MIBoolean_Calculated.ValueData AS isCalculated

            , MovementItem.isErased       AS isErased
                  
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
       
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id =MovementItem.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

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
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId
      ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.08.14                                        * add JuridicalGroupName
 06.03.14                                        * add zc_Enum_ContractStateKind_Close
 16.01.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
