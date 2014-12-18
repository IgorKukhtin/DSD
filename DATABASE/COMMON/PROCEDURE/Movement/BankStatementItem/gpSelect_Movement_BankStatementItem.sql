-- Function: gpSelect_Movement_BankStatementItem()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankStatementItem (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankStatementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankStatementItem(
    IN inMovementId  Integer, --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , Debet TFloat, Kredit TFloat
             , AmountSumm TFloat, AmountCurrency TFloat
             , OKPO TVarChar, Juridicalname TVarChar, Comment TVarChar
             , LinkJuridicalId integer, LinkJuridicalName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractId integer, ContractName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , UnitId integer, UnitName TVarChar, CurrencyName TVarChar
             , BankAccount TVarChar, BankMFO TVarChar, BankName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , LinkBankId Integer, LinkBankName TVarChar
)
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankStatementItem());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , CASE SIGN(MovementFloat_Amount.ValueData) 
               WHEN 1
                 THEN MovementFloat_Amount.ValueData
               ELSE 
                 0 
             END::TFloat AS Debet
           , CASE SIGN(MovementFloat_Amount.ValueData) 
               WHEN 1
                 THEN 0
               ELSE 
                 - MovementFloat_Amount.ValueData 
             END::TFloat AS Kredit
           , MovementFloat_Amount.ValueData         AS AmountSumm
           , MovementFloat_AmountCurrency.ValueData AS AmountCurrency
           , MovementString_OKPO.ValueData  AS OKPO
           , MovementString_JuridicalName.ValueData AS JuridicalName
           , MovementString_Comment.ValueData AS Comment

           , Object_Juridical.Id          AS LinkJuridicalId
           , (Object_Juridical.ValueData || COALESCE (' * '|| Object_Bank.ValueData, '')) :: TVarChar AS LinkJuridicalName

           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName

           , View_Contract_InvNumber.ContractId
           , View_Contract_InvNumber.InvNumber AS ContractName          

           , MovementFloat_CurrencyValue.ValueData             AS CurrencyValue
           , MovementFloat_ParValue.ValueData                  AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData      AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData           AS ParPartnerValue

           , Object_Unit.Id               AS UnitId
           , Object_Unit.ValueData        AS UnitName
           , Object_Currency.ValueData    AS CurrencyName

           , MovementString_BankAccount.ValueData AS BankAccount
           , MovementString_BankMFO.ValueData AS BankMFO
           , MovementString_BankName.ValueData AS BankName

           , Object_BankAccount_View.Id          AS BankAccountId
           , Object_BankAccount_View.Name        AS BankAccountName
           , Object_BankAccount_View.BankId      AS LinkBankId
           , Object_BankAccount_View.BankName    AS LinkBankNameId

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId =  Movement.Id
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
            

            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()

            LEFT JOIN MovementString AS MovementString_BankAccount
                                     ON MovementString_BankAccount.MovementId =  Movement.Id
                                    AND MovementString_BankAccount.DescId = zc_MovementString_BankAccount()

            LEFT JOIN MovementString AS MovementString_BankMFO
                                     ON MovementString_BankMFO.MovementId =  Movement.Id
                                    AND MovementString_BankMFO.DescId = zc_MovementString_BankMFO()

            LEFT JOIN MovementString AS MovementString_BankName
                                     ON MovementString_BankName.MovementId =  Movement.Id
                                    AND MovementString_BankName.DescId = zc_MovementString_BankName()

            LEFT JOIN MovementString AS MovementString_JuridicalName
                                     ON MovementString_JuridicalName.MovementId =  Movement.Id
                                    AND MovementString_JuridicalName.DescId = zc_MovementString_JuridicalName()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                         ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                        AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Currency
                                         ON MovementLinkObject_Currency.MovementId = Movement.Id
                                        AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MovementLinkObject_Currency.ObjectId
          
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = MovementLinkObject_Juridical.ObjectId
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

       WHERE Movement.DescId = zc_Movement_BankStatementItem()
         AND Movement.ParentId = inMovementId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_BankStatementItem (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.14                                        * add zc_ObjectLink_BankAccount_Bank
 13.03.14                                        * add Object_InfoMoney_View
 15.11.13                        *              
 13.08.13         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_BankStatementItem (inMovementId:= 1, inSession:= '5')
