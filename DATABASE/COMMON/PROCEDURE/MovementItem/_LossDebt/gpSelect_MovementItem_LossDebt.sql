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
             , JuridicalId Integer, JuridicalName TVarChar
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

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id =MovementItem.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.01.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
