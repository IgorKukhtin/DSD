-- Function: gpSelect_Movement_TransportChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost(
    IN inParentId    Integer   ,
    IN inIsErased    Boolean   ,
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, MasterMovementId integer, InvNumber Integer, MasterInvNumber Integer, MasterOperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, MasterStatusCode Integer, MasterStatusName TVarChar
             , ItemName tvarchar, Comment tvarchar, MasterComment tvarchar
             , JuridicalCode Integer, JuridicalName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
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

         SELECT  Movement.Id AS Id
               , Movement_Master.Id                            AS MasterMovementId
               , zfConvert_StringToNumber (Movement.InvNumber)      AS InvNumber
               , zfConvert_StringToNumber (Movement_Master.InvNumber) AS MasterInvNumber
               , Movement_Master.OperDate                        AS MasterOperDate
               , Object_Status.ObjectCode                      AS StatusCode
               , Object_Status.ValueData                       AS StatusName
               , Object_StatusMaster.ObjectCode                  AS MasterStatusCode
               , Object_StatusMaster.ValueData                   AS MasterStatusName
               
               , MovementDescMaster.ItemName
               , MovementString_Comment.ValueData              AS Comment
               , MovementString_CommentMaster.ValueData        AS MasterComment
               
               , Object_Juridical.ObjectCode      AS JuridicalCode
               , Object_Juridical.ValueData       AS JuridicalName
           
               , Object_InfoMoney_View.InfoMoneyCode
               , Object_InfoMoney_View.InfoMoneyName
               , Object_InfoMoney_View.InfoMoneyName_all
          FROM Movement 
             INNER JOIN  tmpStatus ON tmpStatus.StatusId = Movement.StatusId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId                                         
             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement.Id 
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
             LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                      ON MovementFloat_MovementId.MovementId = Movement.Id 
                                     AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = CAST (MovementFloat_MovementId.ValueData  AS integer)                         

             LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId

             LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_Master.StatusId                       

             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement_Master.Id
                                   AND MovementItem.DescId = zc_MI_Master()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

             LEFT JOIN MovementString AS MovementString_CommentMaster
                                      ON MovementString_CommentMaster.MovementId = Movement_Master.Id 
                                     AND MovementString_CommentMaster.DescId = zc_MovementString_Comment()
             
          WHERE Movement.ParentId = inParentId
            AND Movement.DescId in (zc_Movement_CostService() , zc_Movement_CostTransport())
          
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.04.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Cost (inParentId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
