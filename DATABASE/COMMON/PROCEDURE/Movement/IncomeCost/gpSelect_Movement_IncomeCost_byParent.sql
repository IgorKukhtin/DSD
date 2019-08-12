-- Function: gpSelect_Movement_IncomeCost_byParent()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Cost (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeCost_byParent (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeCost_byParent(
    IN inParentId    Integer   ,
    IN inIsErased    Boolean   ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MasterMovementId integer, InvNumber Integer, MasterInvNumber Integer
             , OperDate TDateTime, MasterOperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, MasterStatusCode Integer, MasterStatusName TVarChar
             , DescId Integer, ItemName TVarChar
             , Comment TVarChar, MasterComment TVarChar
             , AmountCost TFloat, AmountCost_Master TFloat
             , JuridicalCode Integer, JuridicalName TVarChar
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
      , tmpMovement AS (SELECT Movement.Id                                   AS Id
                             , Movement_Master.Id                            AS MasterMovementId
                             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                             , zfConvert_StringToNumber (Movement_Master.InvNumber) AS MasterInvNumber
                             , Movement.OperDate                             AS OperDate
                             , Movement_Master.OperDate                      AS MasterOperDate
                             , Object_Status.ObjectCode                      AS StatusCode
                             , Object_Status.ValueData                       AS StatusName
                             , Object_StatusMaster.ObjectCode                AS MasterStatusCode
                             , Object_StatusMaster.ValueData                 AS MasterStatusName

                             , MovementDescMaster.Id                         AS DescId
                             , MovementDescMaster.ItemName                   AS ItemName
                             , MovementString_Comment.ValueData              AS Comment
                             , MovementString_CommentMaster.ValueData        AS MasterComment

                             , MovementFloat_AmountCost.ValueData            AS AmountCost
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MovementFloat_AmountCost_Master.ValueData, 0) + COALESCE (MovementFloat_AmountMemberCost_Master.ValueData, 0) ELSE 0 END :: TFloat AS AmountCost_Master

                             , Movement_Master.Id AS MovementId_master

                        FROM Movement
                             INNER JOIN  tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                     ON MovementFloat_AmountCost.MovementId = Movement.Id
                                                    AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
                             LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                                     ON MovementFloat_MovementId.MovementId = Movement.Id
                                                    AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
                             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementFloat_MovementId.ValueData :: Integer
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost_Master
                                                     ON MovementFloat_AmountCost_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_AmountCost_Master.DescId     = zc_MovementFloat_AmountCost()
                             LEFT JOIN MovementFloat AS MovementFloat_AmountMemberCost_Master
                                                     ON MovementFloat_AmountMemberCost_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_AmountMemberCost_Master.DescId     = zc_MovementFloat_AmountMemberCost()

                             LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId

                             LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_Master.StatusId

                             LEFT JOIN MovementString AS MovementString_CommentMaster
                                                      ON MovementString_CommentMaster.MovementId = Movement_Master.Id
                                                     AND MovementString_CommentMaster.DescId     = zc_MovementString_Comment()

                        WHERE Movement.ParentId = inParentId
                          AND Movement.DescId   = zc_Movement_IncomeCost()
                       )
     , tmpMI_master AS (SELECT tmpMovement.MovementId_master
                             , 0                                            AS JuridicalCode
                             , STRING_AGG (Object_Juridical.ValueData, ';') AS JuridicalName

                             , 0 AS InfoMoneyCode
                             , STRING_AGG (Object_InfoMoney_View.InfoMoneyName, ';') AS InfoMoneyName
                             , STRING_AGG (Object_InfoMoney_View.InfoMoneyName_all, ';') AS InfoMoneyName_all
                        FROM tmpMovement
                             LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_master
                                                   AND MovementItem.DescId     = zc_MI_Master()
                             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                        GROUP BY tmpMovement.MovementId_master
                       )
         -- Результат
         SELECT  tmpMovement.Id
               , tmpMovement.MasterMovementId
               , tmpMovement.InvNumber
               , tmpMovement.MasterInvNumber
               , tmpMovement.OperDate
               , tmpMovement.MasterOperDate
               , tmpMovement.StatusCode
               , tmpMovement.StatusName
               , tmpMovement.MasterStatusCode
               , tmpMovement.MasterStatusName

               , tmpMovement.DescId
               , tmpMovement.ItemName
               , tmpMovement.Comment
               , tmpMovement.MasterComment

               , tmpMovement.AmountCost
               , tmpMovement.AmountCost_Master

               , tmpMI_master.JuridicalCode :: Integer
               , tmpMI_master.JuridicalName :: TVarChar

               , tmpMI_master.InfoMoneyCode :: Integer
               , tmpMI_master.InfoMoneyName :: TVarChar
               , tmpMI_master.InfoMoneyName_all :: TVarChar
         FROM tmpMovement
              LEFT JOIN tmpMI_master ON tmpMI_master.MovementId_master = tmpMovement.MovementId_master
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.19         *
 27.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeCost_byParent (inParentId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
