-- Function: gpSelect_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inPaidKindId  Integer   , 
    IN inIsErased    Boolean   ,
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
             , PositionId Integer, PositionName TVarChar
             , Comment TVarChar
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
             PersonalData.Id
           , PersonalData.InvNumber
           , PersonalData.OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           , PersonalData.ServiceDate
           , PersonalData.Amount
           , Object_Personal.Id                  AS PersonalId
           , Object_Personal.ValueData           AS PersonalName
           , Object_PaidKind.Id                  AS PaidKindName
           , Object_PaidKind.ValueData           AS PaidKindName
           , Object_InfoMoney_View.InfoMoneyId          
           , Object_InfoMoney_View.InfoMoneyName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , Object_Position.Id                   AS PositionId
           , Object_Position.ValueData            AS PositionName
           , PersonalData.Comment

FROM 
 (SELECT     Personal_Movement.Id
           , Personal_Movement.InvNumber
           , Personal_Movement.OperDate
           , Personal_Movement.StatusId
           , Personal_Movement.ServiceDate
           , Personal_Movement.Amount 
           , Personal_Movement.Comment
           , Personal_Movement.InfoMoneyId
           , Personal_Movement.PaidKindId          
           , COALESCE(Personal_Movement.PersonalId, Object_Personal_View.PersonalId) AS PersonalId     
           , COALESCE(Personal_Movement.PositionId, Object_Personal_View.PositionId) AS PositionId
           , COALESCE(Personal_Movement.UnitId, Object_Personal_View.UnitId)         AS UnitId
 FROM (
 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusId
           , MIDate_ServiceDate.ValueData    AS ServiceDate           
           , MovementItem.Amount 
           , MovementItem.ObjectId           AS PersonalId
           , MILinkObject_PaidKind.ObjectId  AS PaidKindId          
           , MILinkObject_Position.ObjectId  AS PositionId
           , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
           , MILinkObject_Unit.ObjectId      AS UnitId 
           , MIString_Comment.ValueData      AS Comment
 
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
       WHERE Movement.DescId = zc_Movement_PersonalService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (MILinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)) AS Personal_Movement 

           FULL JOIN 
            (SELECT * FROM Object_Personal_View
              WHERE ((Object_Personal_View.Official = TRUE AND inPaidKindId = zc_Enum_PaidKind_FirstForm())
                       OR (inPaidKindId <> zc_Enum_PaidKind_FirstForm())) ) AS Object_Personal_View

       ON Object_Personal_View.Personalid = Personal_Movement.PersonalId
                              AND Object_Personal_View.UnitId = Personal_Movement.UnitId 
                              AND Object_Personal_View.PositionId = Personal_Movement.PositionId ) AS PersonalData
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = PersonalData.PersonalId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = PersonalData.StatusId
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = PersonalData.InfoMoneyId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = PersonalData.PositionId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = PersonalData.PaidKindId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = PersonalData.UnitId;  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PersonalService (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.14                         *
 27.02.14                         *
 12.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
