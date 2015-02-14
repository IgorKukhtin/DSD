-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankAccount(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat 
             , AmountOut TFloat 
             , AmountSumm TFloat 
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar, BankId Integer, BankName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                  AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
           
           , 0::TFloat                                         AS AmountIn
           , 0::TFloat                                         AS AmountOut
           , 0::TFloat                                         AS AmountSumm

           , ''::TVarChar                                      AS Comment
           , 0                                                 AS BankAccountId
           , '':: TVarChar                                     AS BankAccountName
           , 0                                                 AS BankId
           , '':: TVarChar                                     AS BankName
           , 0                                                 AS MoneyPlaceId
           , CAST ('' as TVarChar)                             AS MoneyPlaceName
           , 0                                                 AS InfoMoneyId
           , CAST ('' as TVarChar)                             AS InfoMoneyName
           , 0                                                 AS ContractId
           , ''::TVarChar                                      AS ContractInvNumber
           , 0                                                 AS UnitId
           , CAST ('' as TVarChar)                             AS UnitName
           , 0                                                 AS CurrencyId
           , CAST ('' as TVarChar)                             AS CurrencyName
           , 0 :: TFloat                                       AS CurrencyValue
           , 0 :: TFloat                                       AS ParValue
           , 0 :: TFloat                                       AS CurrencyPartnerValue
           , 0 :: TFloat                                       AS ParPartnerValue

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             Movement.Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
                      
           , CASE WHEN inMovementId = 0 
                       THEN 0
                  WHEN MILinkObject_Currency.ObjectId <> zc_Enum_Currency_Basis() AND MovementFloat_AmountCurrency.ValueData > 0 THEN
                       MovementFloat_AmountCurrency.ValueData
                  WHEN MovementItem.Amount > 0 THEN
                       MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountIn
           , CASE WHEN inMovementId = 0 
                       THEN 0
                  WHEN MILinkObject_Currency.ObjectId <> zc_Enum_Currency_Basis() AND MovementFloat_AmountCurrency.ValueData < 0 THEN
                       -1 * MovementFloat_AmountCurrency.ValueData
                  WHEN MovementItem.Amount < 0 THEN
                       -1 * MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountOut

           , MovementFloat_Amount.ValueData    AS AmountSumm

           , MIString_Comment.ValueData        AS Comment

           , View_BankAccount.Id               AS BankAccountId
           , View_BankAccount.Name             AS BankAccountName
           , View_BankAccount.BankId
           , View_BankAccount.BankName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all  AS InfoMoneyName
           , Object_Contract.Id                AS ContractId
           , Object_Contract.ValueData         AS ContractInvNumber
           , Object_Unit.Id                    AS UnitId
           , Object_Unit.ValueData             AS UnitName
           , Object_Currency.Id                AS CurrencyId
           , Object_Currency.ValueData         AS CurrencyName
           , MovementFloat_CurrencyValue.ValueData             AS CurrencyValue
           , MovementFloat_ParValue.ValueData                  AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData      AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData           AS ParPartnerValue
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN Object_BankAccount_View AS View_BankAccount ON View_BankAccount.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId
       WHERE Movement.Id =  inMovementId_Value;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_BankAccount (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 14.11.14                                        * add Currency...
 07.05.14                                        * add inMovementId_Value
 25.01.14                                        * add inOperDate
 17.01.14                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_BankAccount (inMovementId:= 0, inMovementId_Value:= 258394, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
