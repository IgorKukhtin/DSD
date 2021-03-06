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
             , AmountCost TFloat, AmountCost_Master TFloat, AmountCostNotVAT_Master TFloat
             , PartnerCode Integer, PartnerName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
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
                             
                             , Object_Partner.ObjectCode AS PartnerCode
                             , Object_Partner.ValueData  AS PartnerName

                             , Object_InfoMoney_View.InfoMoneyCode
                             , Object_InfoMoney_View.InfoMoneyGroupName
                             , Object_InfoMoney_View.InfoMoneyDestinationName
                             , Object_InfoMoney_View.InfoMoneyName
                             , Object_InfoMoney_View.InfoMoneyName_all

                              -- без НДС
                             , MovementFloat_AmountCost.ValueData            AS AmountCost

                               -- с НДС
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN -1 * MovementFloat_AmountCost_Master.ValueData ELSE 0 END :: TFloat AS AmountCost_Master
                               -- без НДС
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_AmountCost_Master.ValueData, ObjectFloat_TaxKind_Value.ValueData) ELSE 0 END :: TFloat AS AmountCostNotVAT_Master

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

                             -- Документ Счет
                             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementFloat_MovementId.ValueData :: Integer
                             -- Сумма по счету
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost_Master
                                                     ON MovementFloat_AmountCost_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_AmountCost_Master.DescId     = zc_MovementFloat_Amount()

                             LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId

                             LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_Master.StatusId

                             LEFT JOIN MovementString AS MovementString_CommentMaster
                                                      ON MovementString_CommentMaster.MovementId = Movement_Master.Id
                                                     AND MovementString_CommentMaster.DescId     = zc_MovementString_Comment()

                             LEFT JOIN MovementLinkObject AS MLO_Object
                                                          ON MLO_Object.MovementId = Movement_Master.Id
                                                         AND MLO_Object.DescId     = zc_MovementLinkObject_Object()
                             LEFT JOIN MovementLinkObject AS MLO_InfoMoney
                                                          ON MLO_InfoMoney.MovementId = Movement_Master.Id
                                                         AND MLO_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()

                             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MLO_Object.ObjectId
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MLO_InfoMoney.ObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                  ON ObjectLink_TaxKind.ObjectId = MLO_Object.ObjectId
                                                 AND ObjectLink_TaxKind.DescId   IN (zc_ObjectLink_Partner_TaxKind(), zc_ObjectLink_Client_TaxKind())
                             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                   ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                  AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()



                        WHERE Movement.ParentId = inParentId
                          AND Movement.DescId   = zc_Movement_IncomeCost()
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
               , tmpMovement.AmountCostNotVAT_Master

               , tmpMovement.PartnerCode
               , tmpMovement.PartnerName

               , tmpMovement.InfoMoneyCode
               , tmpMovement.InfoMoneyGroupName
               , tmpMovement.InfoMoneyDestinationName
               , tmpMovement.InfoMoneyName
               , tmpMovement.InfoMoneyName_all

         FROM tmpMovement
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
