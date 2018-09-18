-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- ������� ��.����
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_Parent TVarChar, BankSInvNumber_Parent TVarChar, ParentId Integer
             , OperDate TDateTime
             , ServiceDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountSumm TFloat 
             , AmountCurrency TFloat
             , Comment TVarChar
             , BankAccountName TVarChar, BankName TVarChar, MFO TVarChar
             , JuridicalName TVarChar, OKPO_BankAccount TVarChar
             , MoneyPlaceId Integer , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar, OKPO TVarChar, OKPO_Parent TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , PartnerBankName TVarChar, PartnerBankMFO TVarChar, PartnerBankAccountName TVarChar
             , isCopy Boolean
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , (Movement_BankStatementItem.InvNumber || ' �� ' || Movement_BankStatement.OperDate :: Date :: TVarChar || ' (' ||  Movement_BankStatement.InvNumber :: TVarChar || ')' ) :: TVarChar AS InvNumber_Parent
           , Movement_BankStatementItem.InvNumber AS BankSInvNumber_Parent
           , Movement.ParentId
           , Movement.OperDate
           , MIDate_ServiceDate.ValueData  AS ServiceDate
           , Object_Status.ObjectCode      AS StatusCode
           , Object_Status.ValueData       AS StatusName
           , CASE WHEN MovementItem.Amount > 0 THEN
                       MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN
                       -1 * MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountOut
           , MovementFloat_Amount.ValueData         AS AmountSumm
           , MovementFloat_AmountCurrency.ValueData AS AmountCurrency

           , MIString_Comment.ValueData        AS Comment
           , Object_BankAccount_View.Name      AS BankAccountName
           , Object_BankAccount_View.BankName  AS BankName
           , Object_BankAccount_View.MFO       AS MFO
           , Object_BankAccount_View.JuridicalName  AS JuridicalName
           , View_JuridicalDetails_BankAccount.OKPO AS OKPO_BankAccount
           , Object_MoneyPlace.Id              AS MoneyPlaceId 
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , (Object_MoneyPlace.ValueData || COALESCE (' * '|| Object_Bank.ValueData, '')) :: TVarChar AS MoneyPlaceName
           , ObjectDesc.ItemName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , MovementString_OKPO.ValueData     AS OKPO_Parent
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , Object_Contract_InvNumber_View.ContractCode
           , Object_Contract_InvNumber_View.InvNumber  AS ContractInvNumber
           , Object_Contract_InvNumber_View.ContractTagName
           , Object_Unit.ObjectCode            AS UnitCode
           , Object_Unit.ValueData             AS UnitName
           , Object_Currency.ValueData         AS CurrencyName 
           , MovementFloat_CurrencyValue.ValueData             AS CurrencyValue
           , MovementFloat_ParValue.ValueData                  AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData      AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData           AS ParPartnerValue
           , Partner_BankAccount_View.BankName
           , Partner_BankAccount_View.MFO
           , Partner_BankAccount_View.Name      AS BankAccountName
           , COALESCE(MovementBoolean_isCopy.ValueData, FALSE) AS isCopy

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
           , MS_Comment_Invoice.ValueData        AS Comment_Invoice

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_BankAccount()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Movement AS Movement_BankStatementItem ON Movement_BankStatementItem.Id = Movement.ParentId
            LEFT JOIN Movement AS Movement_BankStatement ON Movement_BankStatement.Id = Movement_BankStatementItem.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpStatus.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_isCopy
                                      ON MovementBoolean_isCopy.MovementId = Movement.Id
                                     AND MovementBoolean_isCopy.DescId = zc_MovementBoolean_isCopy()

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

            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement_BankStatementItem.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementItem.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS View_JuridicalDetails_BankAccount ON View_JuridicalDetails_BankAccount.JuridicalId = Object_BankAccount_View.JuridicalId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_MoneyPlace.Id

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = MILinkObject_Contract.ObjectId

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
            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = MILinkObject_BankAccount.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                      -- ��� � ����� 
                                      --AND MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_60101() -- ���������� ����� + ���������� �����
                                      --AND MILinkObject_MoneyPlace.ObjectId > 0
            ;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 06.10.16         * add inJuridicalBasisId
 21.07.16         *
 08.04.15         * add isCopy
 14.11.14                                        * add Currency...
 27.09.14                                        * add ContractTagName
 18.06.14                         * add Object_BankAccount_View
 18.03.14                                        * add zc_ObjectLink_BankAccount_Bank
 03.02.14                                        * add inIsErased
 29.01.14                                        * add InvNumber_Parent
 15.01.14                         * 
 */

-- ����
-- SELECT * FROM gpSelect_Movement_BankAccount (inStartDate:= '30.01.2015', inEndDate:= '01.01.2015', inJuridicalBasisId:=0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
