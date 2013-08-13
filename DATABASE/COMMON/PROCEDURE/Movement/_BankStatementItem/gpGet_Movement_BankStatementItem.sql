-- Function: gpGet_Movement_BankStatementItem()

-- DROP FUNCTION gpGet_Movement_BankStatementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankStatementItem(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , Amount TFloat
             , OKPO TVarChar
             , InfoMoneyId  integer, InfoMoneyName  TVarChar
             , ContractId  integer, ContractName  TVarChar
             , UnitId  integer, UnitName  TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_BankStatementItem());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

           , MovementFloat_Amount.ValueData AS Amount
           , MovementString_OKPO.ValueData  AS OKPO

           , Object_InfoMoney.Id          AS InfoMoneyId
           , Object_InfoMoney.ValueData   AS InfoMoneyName
           
           , Object_Contract.Id           AS ContractId
           , Object_Contract.ValueData    AS ContractName          
        
           , Object_Unit.Id               AS UnitId
           , Object_Unit.ValueData        AS UnitName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
            
            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                         ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                        AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MovementLinkObject_InfoMoney.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_BankStatementItem();
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_BankStatementItem (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 13.08.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_BankStatementItem (inMovementId:= 1, inSession:= '2')
