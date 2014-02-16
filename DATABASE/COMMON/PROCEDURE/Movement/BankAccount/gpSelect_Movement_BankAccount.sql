-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_Parent TVarChar, ParentId Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat 
             , AmountOut TFloat 
             , Comment TVarChar
             , BankAccountName TVarChar, BankName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, OKPO TVarChar, OKPO_Parent TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractInvNumber TVarChar
             , UnitName TVarChar
             , CurrencyName TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
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
           , (Movement_BankStatementItem.InvNumber || ' от ' || Movement_BankStatement.OperDate :: Date :: TVarChar || ' (' ||  Movement_BankStatementItem.ParentId :: TVarChar || ')' ) :: TVarChar AS InvNumber_Parent
           , Movement.ParentId
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           , CASE WHEN MovementItem.Amount > 0 THEN
                       MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN
                       - MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountOut
           , MIString_Comment.ValueData        AS Comment
           , Object_BankAccount_View.Name      AS BankAccountName
           , Object_BankAccount_View.BankName  AS BankName
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , MovementString_OKPO.ValueData     AS OKPO_Parent
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_Contract_InvNumber_View.InvNumber AS ContractInvNumber
           , Object_Unit.ValueData             AS UnitName
           , Object_Currency.ValueData         AS CurrencyName 
       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_BankAccount()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Movement AS Movement_BankStatementItem ON Movement_BankStatementItem.Id = Movement.ParentId
            LEFT JOIN Movement AS Movement_BankStatement ON Movement_BankStatement.Id = Movement_BankStatementItem.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement_BankStatementItem.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_MoneyPlace.Id

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
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.02.14                                        * add inIsErased
 29.01.14                                        * add InvNumber_Parent
 15.01.14                         * 
 */

-- тест
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inSession:= zfCalc_UserAdmin())
