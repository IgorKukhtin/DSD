-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankAccount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, InvNumber TVarChar, OperDate TDateTime
             , ServiceDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountSumm TFloat
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar, BankId Integer, BankName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InvNumberInvoice TVarChar
             , BankAccountPartnerId Integer
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY
       SELECT
             0 :: Integer AS Id
           , 0 :: Integer AS ParentId
           , CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                  AS OperDate
           , inOperDate AS OperDate
           , DATE_TRUNC ('MONTH', inOperDate - INTERVAL '1 MONTH') :: TDateTime AS ServiceDate
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
           , 0                                                 AS PartnerId
           , '':: TVarChar                                     AS PartnerName
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

           , 0                                                 AS MovementId_Invoice
           , CAST ('' as TVarChar)                             AS InvNumber_Invoice
           , CAST ('' as TVarChar)                             AS Comment_Invoice
             -- Счет(клиента)
           , CAST ('' AS TVarChar)                             AS InvNumberInvoice
           , CAST (0 AS Integer)                               AS BankAccountPartnerId
       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
      ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.ParentId
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId_Value > 0 THEN Movement.OperDate WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , COALESCE (MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
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
           , Object_Partner.Id                 AS PartnerId
           , Object_Partner.ValueData          AS PartnerName
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

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
           , MS_Comment_Invoice.ValueData        AS Comment_Invoice
             -- Счет(клиента)
           , MovementString_InvNumberInvoice.ValueData ::TVarChar AS InvNumberInvoice

           , MILinkObject_BankAccount.ObjectId   AS BankAccountPartnerId
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

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MS_Comment_Invoice
                                     ON MS_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MS_Comment_Invoice.DescId = zc_MovementString_Comment()

             -- Счет(клиента)
            LEFT JOIN MovementString AS MovementString_InvNumberInvoice
                                     ON MovementString_InvNumberInvoice.MovementId = Movement.Id
                                    AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

            LEFT JOIN Object_BankAccount_View AS View_BankAccount ON View_BankAccount.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                             ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()

       WHERE Movement.Id =  inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.09.18         *
 26.07.16         * invoice
 21.07.16         *
 14.11.14                                        * add Currency...
 07.05.14                                        * add inMovementId_Value
 25.01.14                                        * add inOperDate
 17.01.14                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_BankAccount (inMovementId:= 0, inMovementId_Value:= 29481490, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
