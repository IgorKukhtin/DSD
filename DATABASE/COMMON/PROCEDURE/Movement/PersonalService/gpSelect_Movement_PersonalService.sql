-- Function: gpSelect_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , Amount TFloat
             , PersonalId Integer, PersonalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PositionId Integer, PositionName TVarChar
             , inComment TVarChar
              )
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MIDate_ServiceDate.ValueData AS ServiceDate           
           , MovementItem.Amount 

           , Object_Personal.Id           AS PersonalId
           , Object_Personal.ValueData    AS PersonalName

           , Object_PaidKind.Id           AS PaidKindId
           , Object_PaidKind.ValueData    AS PaidKindName
   
           , Object_InfoMoney_View.InfoMoneyId          
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Unit.Id               AS UnitId
           , Object_Unit.ValueData        AS UnitName

           , Object_Contract.Id           AS ContractId
           , Object_Contract.ValueData    AS ContractName

           , Object_Position.Id           AS PositionId
           , Object_Position.ValueData    AS PositionName
           , MIString_Comment.ValueData        AS Comment
 
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                   ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                  AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
       WHERE Movement.DescId = zc_Movement_PersonalService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.14                         *
 12.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
