-- Function: gpSelect_Movement_IncomeCost_byInvoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeCost_byInvoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeCost_byInvoice(
    IN inMovementId_Invoice       Integer , --
    IN inIsErased                 Boolean   , -- ���������� ��������� ��/���
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, MasterMovementId integer, InvNumber Integer, MasterInvNumber Integer
             , OperDate TDateTime, MasterOperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, MasterStatusCode Integer, MasterStatusName TVarChar
             , DescId Integer, ItemName TVarChar
             , Comment TVarChar
             , MasterComment TVarChar
             , MovementId_Income Integer
             , InvNumber_Income Integer
             , OperDate_Income TDateTime
             , DescId_Income Integer,ItemName_Income TVarChar
             , StatusCode_Income Integer
             , FromId Integer, FromCode Integer, FromName TVarChar  -- ���������, ��� ������
               -- ����� ������ ��� ���
             , AmountCost TFloat
               -- ����� ���� ��� ���
             , AmountCost_Master TFloat
               -- ����� ���� � ���
             --, AmountCostVAT_Master TFloat
               --
             , ObjectCode Integer, ObjectName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )

      , tmpCost AS (SELECT MovementFloat_MovementId.MovementId
                         , MovementFloat_MovementId.ValueData :: Integer = inMovementId_Invoice
                    FROM MovementFloat AS MovementFloat_MovementId
                    WHERE MovementFloat_MovementId.ValueData :: Integer = inMovementId_Invoice   ---MovementFloat_MovementId.MovementId = Movement.Id
                      AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
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

                             , Movement_Income.Id                                   AS MovementId_Income
                             , zfConvert_StringToNumber (Movement_Income.InvNumber) AS InvNumber_Income
                             , Movement_Income.OperDate                             AS OperDate_Income
                             , MovementDescIncome.Id                                AS DescId_Income
                             , MovementDescIncome.ItemName                          AS ItemName_Income
                             , Object_StatusIncome.ObjectCode                       AS StatusCode_Income

                             , MovementFloat_AmountCost.ValueData            AS AmountCost
                             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN COALESCE (MovementFloat_AmountCost_Master.ValueData, 0) ELSE 0 END :: TFloat AS AmountCost_Master

                             , Movement_Master.Id AS MovementId_master

                        FROM tmpCost
                             INNER JOIN Movement ON Movement.Id = tmpCost.MovementId
                                                AND Movement.DescId = zc_Movement_IncomeCost()

                             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                     ON MovementFloat_AmountCost.MovementId = Movement.Id
                                                    AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
                             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = inMovementId_Invoice
 
                             LEFT JOIN MovementFloat AS MovementFloat_AmountCost_Master
                                                     ON MovementFloat_AmountCost_Master.MovementId = Movement_Master.Id
                                                    AND MovementFloat_AmountCost_Master.DescId     = zc_MovementFloat_AmountCost()
 
                             LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId
 
                             LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_Master.StatusId
 
                             LEFT JOIN MovementString AS MovementString_CommentMaster
                                                      ON MovementString_CommentMaster.MovementId = Movement_Master.Id
                                                     AND MovementString_CommentMaster.DescId = zc_MovementString_Comment()
 
                             LEFT JOIN Movement     AS Movement_Income     ON Movement_Income.Id     = Movement.ParentId
                             LEFT JOIN MovementDesc AS MovementDescIncome  ON MovementDescIncome.Id  = Movement_Income.DescId
                             LEFT JOIN Object       AS Object_StatusIncome ON Object_StatusIncome.Id = Movement_Income.StatusId
                       )
                       
     , tmpMI_master AS (SELECT tmpMovement.MovementId_master
                             , 0                                            AS ObjectCode
                             , STRING_AGG (Object_Object.ValueData, ';') AS ObjectName
                        FROM tmpMovement

                             LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_master
                                                   AND MovementItem.DescId     = zc_MI_Master()
                             LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId

                        GROUP BY tmpMovement.MovementId_master
                       )

         -- ���������
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

               , tmpMovement.MovementId_Income
               , tmpMovement.InvNumber_Income
               , tmpMovement.OperDate_Income
               , tmpMovement.DescId_Income
               , tmpMovement.ItemName_Income
               , tmpMovement.StatusCode_Income

               , Object_From.Id          AS FromId
               , Object_From.ObjectCode  AS FromCode
               , Object_From.ValueData   AS FromName

               , tmpMovement.AmountCost
               , tmpMovement.AmountCost_Master

               , tmpMI_master.ObjectCode :: Integer
               , tmpMI_master.ObjectName :: TVarChar

               , Object_Insert.ValueData              AS InsertName
               , MovementDate_Insert.ValueData        AS InsertDate
               , Object_Update.ValueData              AS UpdateName
               , MovementDate_Update.ValueData        AS UpdateDate
         FROM tmpMovement
              LEFT JOIN tmpMI_master ON tmpMI_master.MovementId_master = tmpMovement.MovementId_master

              LEFT JOIN MovementDate AS MovementDate_Insert
                                     ON MovementDate_Insert.MovementId = tmpMovement.Id
                                    AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
              LEFT JOIN MovementLinkObject AS MLO_Insert
                                           ON MLO_Insert.MovementId = tmpMovement.Id
                                          AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

              LEFT JOIN MovementDate AS MovementDate_Update
                                     ON MovementDate_Update.MovementId = tmpMovement.Id
                                    AND MovementDate_Update.DescId = zc_MovementDate_Update()
              LEFT JOIN MovementLinkObject AS MLO_Update
                                           ON MLO_Update.MovementId = tmpMovement.Id
                                          AND MLO_Update.DescId = zc_MovementLinkObject_Update()
              LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              LEFT JOIN Object AS Object_From   ON Object_From.Id   = MovementLinkObject_From.ObjectId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_IncomeCost_byInvoice (inMovementId_Invoice:= 72, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
