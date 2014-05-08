-- Function: gpSelect_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransferDebtIn (TDateTime, TDateTime, Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransferDebtIn(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inIsErased       Boolean ,
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, OKPO_From TVarChar
             , ToId Integer, ToName TVarChar, OKPO_To TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar, ContractTagFromName TVarChar
             , ContractToId Integer, ContractToName TVarChar, ContractTagToName TVarChar
             , PaidKindFromName TVarChar, PaidKindToName TVarChar
             , InfoMoneyGroupName_from TVarChar, InfoMoneyDestinationName_from TVarChar, InfoMoneyCode_from Integer, InfoMoneyName_from TVarChar
             , InfoMoneyGroupName_to TVarChar, InfoMoneyDestinationName_to TVarChar, InfoMoneyCode_to Integer, InfoMoneyName_to TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransferDebtIn());
     vbUserId:= inSession;

     --
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )
     SELECT
             Movement.Id	                        AS Id
           , Movement.InvNumber		                AS InvNumber
           , Movement.OperDate		                AS OperDate
           , Object_Status.ObjectCode    		AS StatusCode
           , Object_Status.ValueData     		AS StatusName
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm

           , Object_From.Id                    		AS FromId
           , Object_From.ValueData             		AS FromName
           , View_JuridicalDetails_From.OKPO            AS OKPO_From
           , Object_To.Id                      		AS ToId
           , Object_To.ValueData               		AS ToName
           , View_JuridicalDetails_To.OKPO              AS OKPO_To

           , Object_Partner.ObjectCode                  AS PartnerCode
           , Object_Partner.ValueData               	AS PartnerName

           , View_Contract_InvNumberFrom.ContractId      AS ContractFromId
           , View_Contract_InvNumberFrom.InvNumber       AS ContractFromName
           , View_Contract_InvNumberFrom.ContractTagName AS ContractTagFromName
           , View_Contract_InvNumberTo.ContractId        AS ContractToId
           , View_Contract_InvNumberTo.InvNumber         AS ContractToName
           , View_Contract_InvNumberTo.ContractTagName   AS ContractTagToName

           , Object_PaidKindFrom.ValueData        AS PaidKindFromName
           , Object_PaidKindTo.ValueData          AS PaidKindToName
      
           , View_InfoMoneyFrom.InfoMoneyGroupName            AS InfoMoneyGroupName_from
           , View_InfoMoneyFrom.InfoMoneyDestinationName      AS InfoMoneyDestinationName_from
           , View_InfoMoneyFrom.InfoMoneyCode                 AS InfoMoneyCode_from
           , View_InfoMoneyFrom.InfoMoneyName                 AS InfoMoneyName_from

           , View_InfoMoneyTo.InfoMoneyGroupName              AS InfoMoneyGroupName_to
           , View_InfoMoneyTo.InfoMoneyDestinationName        AS InfoMoneyDestinationName_to
           , View_InfoMoneyTo.InfoMoneyCode                   AS InfoMoneyCode_to
           , View_InfoMoneyTo.InfoMoneyName                   AS InfoMoneyName_to

       FROM tmpStatus
            INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_TransferDebtIn() AND Movement.StatusId = tmpStatus.StatusId
            INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()                                               
            
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS View_JuridicalDetails_From ON View_JuridicalDetails_From.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS View_JuridicalDetails_To ON View_JuridicalDetails_To.JuridicalId = Object_To.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                         ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumberFrom ON View_Contract_InvNumberFrom.ContractId = MovementLinkObject_ContractFrom.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyFrom ON View_InfoMoneyFrom.InfoMoneyId = View_Contract_InvNumberFrom.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                         ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                        AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumberTo ON View_Contract_InvNumberTo.ContractId = MovementLinkObject_ContractTo.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyTo ON View_InfoMoneyTo.InfoMoneyId = View_Contract_InvNumberTo.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindFrom
                                         ON MovementLinkObject_PaidKindFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKindFrom.DescId = zc_MovementLinkObject_PaidKindFrom()
            LEFT JOIN Object AS Object_PaidKindFrom ON Object_PaidKindFrom.Id = MovementLinkObject_PaidKindFrom.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                         ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
            LEFT JOIN Object AS Object_PaidKindTo ON Object_PaidKindTo.Id = MovementLinkObject_PaidKindTo.ObjectId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TransferDebtIn (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.05.14                                        * add tmpRoleAccessKey
 07.05.14                                        * add Partner...
 03.05.14                                        * all
 25.04.14  		  *
 */

-- ����
-- SELECT * FROM gpSelect_Movement_TransferDebtIn (inStartDate:= '01.02.2014', inEndDate:= '01.02.2014', inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
