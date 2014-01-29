-- Function: gpGet_Movement_Service()

DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Service(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat 
             , Comment TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Service());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_Service_seq') AS TVarChar) AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime) AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           
           , 0::TFloat                        AS AmountIn
           , 0::TFloat                        AS AmountOut

           , ''::TVarChar                     AS Comment
           , 0                                AS JuridicalId
           , CAST ('' as TVarChar)            AS JuridicalName
           , 0                                AS InfoMoneyId
           , CAST ('' as TVarChar)            AS InfoMoneyName
           , 0                                AS ContractId
           , ''::TVarChar                     AS ContractInvNumber
           , 0                                AS UnitId
           , CAST ('' as TVarChar)            AS UnitName
           , 0                                AS PaidKindId
           , CAST ('' as TVarChar)            AS PaidKindName

           , 0                                AS ContractConditionKindId
           , CAST ('' as TVarChar)            AS ContractConditionKindName

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;
  
     ELSE

     RETURN QUERY 
       SELECT
             inMovementId as Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('Movement_Service_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
                      
           , CASE WHEN inMovementId = 0 
                       THEN 0
                  WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END :: TFloat AS AmountIn
           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN MovementItem.Amount < 0 
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END :: TFloat AS AmountOut

           , MIString_Comment.ValueData   AS Comment

           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ValueData       AS JuridicalName

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all AS InfoMoneyName
           , Object_Contract.Id               AS ContractId
           , Object_Contract.ValueData        AS ContractInvNumber
           , Object_Unit.Id                   AS UnitId
           , Object_Unit.ValueData            AS UnitName
           , Object_PaidKind.Id               AS PaidKindId
           , Object_PaidKind.ValueData        AS PaidKindName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

       WHERE Movement.Id =  inMovementId_Value;

   END IF;  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.14         * add ContractConditionKind
 22.01.14                                        * add inOperDate
 28.12.13                                        * add View_InfoMoney
 24.12.13                         * -- MovItem
 18.11.13                         * -- Add other properties
 07.11.13                         * -- Default on Get
 11.08.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Service (inMovementId:= 1, inOperDate:= CURRENT_DATE,  inSession:= zfCalc_UserAdmin());
