-- Function: gpSelect_Movement_TransferDebtIn()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_TransferDebtIn (TDateTime, TDateTime, Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransferDebtIn (TDateTime, TDateTime, Integer, Boolean,TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_TransferDebtIn(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- Главное юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , InvNumberPartner TVarChar, InvNumberMark TVarChar
             , Checked Boolean
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, OKPO_From TVarChar
             , ToId Integer, ToName TVarChar, OKPO_To TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , PartnerFromCode Integer, PartnerFromName TVarChar
             , ContractFromId Integer, ContractFromCode Integer, ContractFromName TVarChar, ContractTagFromName TVarChar
             , ContractToId Integer, ContractToCode Integer, ContractToName TVarChar, ContractTagToName TVarChar
             , PaidKindFromName TVarChar, PaidKindToName TVarChar
             , InfoMoneyGroupName_from TVarChar, InfoMoneyDestinationName_from TVarChar, InfoMoneyCode_from Integer, InfoMoneyName_from TVarChar
             , InfoMoneyGroupName_to TVarChar, InfoMoneyDestinationName_to TVarChar, InfoMoneyCode_to Integer, InfoMoneyName_to TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransferDebtIn());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     --
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAll AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId <> zc_Enum_Role_Bread() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAll) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAll) GROUP BY AccessKeyId
                              )
     SELECT
             Movement.Id	                        AS Id
           , Movement.InvNumber		                AS InvNumber
           , Movement.OperDate		                AS OperDate
           , Object_Status.ObjectCode    		AS StatusCode
           , Object_Status.ValueData     		AS StatusName
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_InvNumberMark.ValueData AS InvNumberMark
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent

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

           , Object_PartnerFrom.ObjectCode              AS PartnerFromCode
           , Object_PartnerFrom.ValueData              	AS PartnerFromName

           , View_Contract_InvNumberFrom.ContractId      AS ContractFromId
           , View_Contract_InvNumberFrom.ContractCode    AS ContractFromCode
           , View_Contract_InvNumberFrom.InvNumber       AS ContractFromName
           , View_Contract_InvNumberFrom.ContractTagName AS ContractTagFromName
           , View_Contract_InvNumberTo.ContractId        AS ContractToId
           , View_Contract_InvNumberTo.ContractCode      AS ContractToCode
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

           , Object_TaxKind.Id                	    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         	    AS DocumentTaxKindName
           , MovementString_Comment.ValueData       AS Comment

       FROM tmpStatus
            INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_TransferDebtIn() AND Movement.StatusId = tmpStatus.StatusId
            INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner                                                 -- Контрагент(кому)
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerFrom						--Контрагент(от кого)
                                         ON MovementLinkObject_PartnerFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerFrom.DescId = zc_MovementLinkObject_PartnerFrom()
            LEFT JOIN Object AS Object_PartnerFrom ON Object_PartnerFrom.Id = MovementLinkObject_PartnerFrom.ObjectId

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_TransferDebtIn (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.10.16         * add inJuridicalBasisId
 01.12.14         * add InvNumberMark               
 03.09.14         * add Checked
 20.06.14                                                       * add InvNumberPartner
 20.05.14                                        * add DocumentTaxKind...
 08.05.14                                        * add ChangePercent
 07.05.14                                        * add tmpRoleAccessKey
 07.05.14                                        * add Partner...
 03.05.14                                        * all
 25.04.14  		  *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_TransferDebtIn (inStartDate:= '01.02.2014', inEndDate:= '01.02.2014', inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
