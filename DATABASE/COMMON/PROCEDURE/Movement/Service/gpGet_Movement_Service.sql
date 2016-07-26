-- Function: gpGet_Movement_Service()

DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Service(
    IN inMovementId        Integer   , -- ���� ���������
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , AmountIn TFloat, AmountOut TFloat 
             , Comment TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , CostMovementId TVarChar, CostMovementInvNumber TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
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
           
           , CAST (CURRENT_DATE AS TDateTime) AS OperDatePartner
           , ''::TVarChar                     AS InvNumberPartner
           
           , 0::TFloat                        AS AmountIn
           , 0::TFloat                        AS AmountOut

           , ''::TVarChar                     AS Comment
           , 0                                AS JuridicalId
           , CAST ('' as TVarChar)            AS JuridicalName
           , 0                                AS PartnerId
           , CAST ('' as TVarChar)            AS PartnerName
           , 0                                AS InfoMoneyId
           , CAST ('' as TVarChar)            AS InfoMoneyName
           , 0                                AS ContractId
           , ''::TVarChar                     AS ContractInvNumber
           , 0                                AS UnitId
           , CAST ('' as TVarChar)            AS UnitName
           , 0                                AS PaidKindId
           , CAST ('' as TVarChar)            AS PaidKindName
           , CAST ('' as TVarChar)            AS CostMovementId
           , CAST ('' as TVarChar)            AS CostMovementInvNumber

           , 0                                AS MovementId_Invoice
           , CAST ('' as TVarChar)            AS InvNumber_Invoice

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;
  
     ELSE

     RETURN QUERY 
       SELECT
             inMovementId as Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('Movement_Service_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , COALESCE (MovementDate_OperDatePartner.ValueData, zc_DateStart()) AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                      
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

           , Object_Partner.Id                AS PartnerId
           , Object_Partner.ValueData         AS PartnerName

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
           , View_Contract_InvNumber.ContractId AS ContractId
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , Object_Unit.Id                   AS UnitId
           , Object_Unit.ValueData            AS UnitName
           , Object_PaidKind.Id               AS PaidKindId
           , Object_PaidKind.ValueData        AS PaidKindName

           , MovementString_MovementId.ValueData AS CostMovementId
           , tmpCost.strInvNumber    ::TVarChar  AS CostMovementInvNumber

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE(MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END
            
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_MovementId
                                     ON MovementString_MovementId.MovementId =  Movement.Id
                                    AND MovementString_MovementId.DescId = zc_MovementString_MovementId()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
           --
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)
 
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
            --LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber 
                                                     ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN (SELECT MovementFloat.ValueData AS MovementServiceId
                            , STRING_AGG ('� ' ||CAST(Movement_Income.InvNumber AS TVarChar) || ' o� '|| TO_CHAR(Movement_Income.Operdate , 'DD.MM.YYYY')|| '.' , ', ')  AS strInvNumber
                       FROM MovementFloat
                          LEFT JOIN Movement AS Movement_Cost on Movement_Cost.id = MovementFloat.Movementid
                                            AND Movement_Cost.StatusId <> zc_Enum_Status_Erased()
                          LEFT JOIN Movement AS Movement_Income on Movement_Income.id = Movement_Cost.ParentId
                       WHERE MovementFloat.DescId = zc_MovementFloat_MovementId()
                       GROUP BY MovementFloat.ValueData) AS tmpCost ON tmpCost.MovementServiceId = Movement.Id 
            
       WHERE Movement.Id =  inMovementId_Value;

   END IF;  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.07.16         *
 30.04.16         *
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner              
 19.02.14         * del ContractConditionKind )))
 28.01.14         * add ContractConditionKind
 22.01.14                                        * add inOperDate
 28.12.13                                        * add View_InfoMoney
 24.12.13                         * -- MovItem
 18.11.13                         * -- Add other properties
 07.11.13                         * -- Default on Get
 11.08.13         *

*/

-- ����
-- SELECT * FROM gpGet_Movement_Service (inMovementId:= 1, inMovementId_Value:= 0, inOperDate:= CURRENT_DATE,  inSession:= zfCalc_UserAdmin());
