-- Function: gpSelect_Movement_IncomeCost_byParent()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Cost (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeCost_byParent (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeCost_byParent(
    IN inParentId    Integer   ,
    IN inIsErased    Boolean   ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId_Master Integer
             , InvNumber Integer
             , InvNumber_Master TVarChar
             , OperDate TDateTime, OperDate_Master TDateTime
             , StatusCode Integer, StatusName TVarChar, StatusCode_Master Integer, StatusName_Master TVarChar
             , DescId_Master Integer, ItemName_Master TVarChar
             , Comment TVarChar, Comment_Master TVarChar
             , AmountCost TFloat, Amount_Master TFloat, AmountNotVAT_Master TFloat, VATPercent_Master TFloat
             , PartnerCode_Master Integer, PartnerName_Master TVarChar
             , InfoMoneyCode_Master Integer, InfoMoneyGroupName_Master TVarChar, InfoMoneyDestinationName_Master TVarChar, InfoMoneyName_Master TVarChar, InfoMoneyName_all_Master TVarChar
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
      , tmpMovement AS (SELECT Movement.Id                                    AS Id
                             , Movement_Master.Id                             AS MovementId_Master
                             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
                             , zfCalc_InvNumber_isErased ('', Movement_Master.InvNumber, Movement_Master.OperDate, Movement_Master.StatusId) AS InvNumber_Master
                             , Movement.OperDate                              AS OperDate
                             , Movement_Master.OperDate                       AS OperDate_Master
                             , Object_Status.ObjectCode                       AS StatusCode
                             , Object_Status.ValueData                        AS StatusName
                             , Object_StatusMaster.ObjectCode                 AS StatusCode_Master
                             , Object_StatusMaster.ValueData                  AS StatusName_Master
                                                                              
                             , MovementDescMaster.Id                          AS DescId_Master
                             , MovementDescMaster.ItemName                    AS ItemName_Master
                             , MovementString_Comment.ValueData               AS Comment
                             , MovementString_CommentMaster.ValueData         AS Comment_Master
                             
                             , Object_Partner.ObjectCode                      AS PartnerCode_Master
                             , Object_Partner.ValueData                       AS PartnerName_Master

                             , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode_Master
                             , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName_Master
                             , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName_Master
                             , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName_Master
                             , Object_InfoMoney_View.InfoMoneyName_all        AS InfoMoneyName_all_Master

                              -- без НДС
                             , MovementFloat_AmountCost.ValueData             AS AmountCost

                               -- с НДС
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN -1 * MovementFloat_Amount_Master.ValueData ELSE 0 END :: TFloat AS Amount_Master
                               -- без НДС
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount_Master.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END :: TFloat AS AmountNotVAT_Master
                             
                             , MovementFloat_VATPercent.ValueData AS VATPercent_Master

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
                             LEFT JOIN MovementFloat AS MovementFloat_Amount_Master
                                                     ON MovementFloat_Amount_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_Amount_Master.DescId     = zc_MovementFloat_Amount()

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

                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId = Movement_Master.Id
                                                    AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()

                             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MLO_Object.ObjectId
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MLO_InfoMoney.ObjectId

                        WHERE Movement.ParentId = inParentId
                          AND Movement.DescId   = zc_Movement_IncomeCost()
                       )
         -- Результат
         SELECT  tmpMovement.Id
               , tmpMovement.MovementId_Master
               , tmpMovement.InvNumber
               , tmpMovement.InvNumber_Master
               , tmpMovement.OperDate
               , tmpMovement.OperDate_Master
               , tmpMovement.StatusCode
               , tmpMovement.StatusName
               , tmpMovement.StatusCode_Master
               , tmpMovement.StatusName_Master

               , tmpMovement.DescId_Master
               , tmpMovement.ItemName_Master
               , tmpMovement.Comment
               , tmpMovement.Comment_Master

               , tmpMovement.AmountCost
               , tmpMovement.Amount_Master
               , tmpMovement.AmountNotVAT_Master
               , tmpMovement.VATPercent_Master

               , tmpMovement.PartnerCode_Master
               , tmpMovement.PartnerName_Master

               , tmpMovement.InfoMoneyCode_Master
               , tmpMovement.InfoMoneyGroupName_Master
               , tmpMovement.InfoMoneyDestinationName_Master
               , tmpMovement.InfoMoneyName_Master
               , tmpMovement.InfoMoneyName_all_Master

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
