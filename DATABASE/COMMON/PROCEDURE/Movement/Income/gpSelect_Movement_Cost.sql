-- Function: gpSelect_Movement_TransportChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost(
    IN inParentId    Integer   ,
    IN inIsErased    Boolean   ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, movementid integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, ItemName tvarchar, comment tvarchar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )

          SELECT Movement.Id AS Id
               , MovementFloat_MovementId.ValueData    ::Integer        AS MovementId
               , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
               , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
               , Movement.OperDate
               , Object_Status.ObjectCode                      AS StatusCode
               , Object_Status.ValueData                       AS StatusName
               , MovementDesc.ItemName
               , MovementString_Comment.ValueData              AS Comment
               , Object_InfoMoney_View.InfoMoneyCode
               , Object_InfoMoney_View.InfoMoneyName
               , Object_InfoMoney_View.InfoMoneyName_all
          FROM Movement
                          
             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement.Id 
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
             LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                      ON MovementFloat_MovementId.MovementId = Movement.Id 
                                     AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
             LEFT JOIN Movement AS Movement_Cost ON Movement_Cost.Id = CAST (MovementFloat_MovementId.ValueData  AS integer)                         

             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Cost.DescId

             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Cost.StatusId 
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Cost.StatusId                       

             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement_Cost.Id
                                   AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

          WHERE Movement.ParentId  = inParentId
            AND Movement.DescId in (zc_Movement_CostService() , zc_Movement_CostTransport())
          
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cost (inParentId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
