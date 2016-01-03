-- Function: gpGet_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective (Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, isMask Boolean, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, isElectron Boolean, DateisElectron TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, PartnerId Integer, PartnerName TVarChar, ToId Integer, ToName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , DocumentMasterId Integer, DocumentMasterName TVarChar, isPartner Boolean
             , DocumentChildId Integer, DocumentChildName TVarChar
             , InvNumberBranch TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TaxCorrective());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_TaxCorrective_Mask (ioId        := inMovementId
                                                         , inOperDate  := inOperDate
                                                         , inSession   := inSession); 
     END If;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 				    AS Id
             , FALSE                                AS isMask
             , tmpInvNumber.InvNumber               AS InvNumber
             , inOperDate                           AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name              	    AS StatusName
             , CAST (False as Boolean)         	    AS Checked
             , CAST (False as Boolean)         	    AS Document
             , CAST (False as Boolean)        	    AS isElectron
             , inOperDate         	            AS DateisElectron
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), inOperDate, tmpInvNumber.InvNumberBranch) :: TVarChar AS InvNumberPartner
             , 0                     				AS FromId
             , CAST ('' as TVarChar) 				AS FromName
             , 0                                    AS PartnerId
             , CAST ('' as TVarChar)               	AS PartnerName
             , Object_Juridical_Basis.Id			AS ToId
             , Object_Juridical_Basis.ValueData		AS ToName
             , 0                     				AS ContractId
             , CAST ('' as TVarChar) 				AS ContractName
             , CAST ('' as TVarChar) 				AS ContractTagName
             , 0                     				AS TaxKindId
             , CAST ('' as TVarChar) 				AS TaxKindName
             , 0                     				AS DocumentMasterId
             , CAST ('' as TVarChar) 				AS DocumentMasterName
             , CAST (False as Boolean)                          AS isPartner     -- ������� ��� �������� �� ��������� ��������
             , 0                     				AS DocumentChildId
             , CAST ('' as TVarChar) 				AS DocumentChildName
             , tmpInvNumber.InvNumberBranch
             , CAST ('' as TVarChar) 		                AS Comment

          FROM (SELECT CAST (NEXTVAL ('movement_taxcorrective_seq') AS TVarChar) AS InvNumber
                     , CASE WHEN inOperDate >= '01.01.2016'
                                 THEN ''

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentKiev()
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportKiev())

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentOdessa()
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportOdessa())

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportZaporozhye())

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentKrRog() 
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportKrRog())

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentNikolaev()
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportNikolaev())

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentKharkov()
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportKharkov())

                            WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentCherkassi()
                                 THEN (SELECT ObjectString.ValueData FROM Object JOIN ObjectString ON ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = Object.Id WHERE Object.DescId = zc_object_Branch() AND Object.AccessKeyId = zc_Enum_Process_AccessKey_TrasportCherkassi())

                            ELSE ''
                       END :: TVarChar AS InvNumberBranch
               ) AS tmpInvNumber
          LEFT JOIN lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status ON 1=1
          LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
          LEFT JOIN Object AS Object_Juridical_Basis ON Object_Juridical_Basis.Id = zc_Juridical_Basis();

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id						    AS Id
           , FALSE                                                          AS isMask
           , Movement.InvNumber						    AS InvNumber
           , Movement.OperDate						    AS OperDate
           , Object_Status.ObjectCode    				    AS StatusCode
           , Object_Status.ValueData     				    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)            AS Checked
           , COALESCE (MovementBoolean_Document.ValueData, FALSE)           AS Document
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE)           AS isElectron
           , COALESCE (MovementDate_DateRegistered.ValueData,Movement.OperDate) AS DateisElectron
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)       AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData                             AS VATPercent
           , MovementFloat_TotalCount.ValueData                             AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData                          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData                          AS TotalSummPVAT
           , MovementString_InvNumberPartner.ValueData                      AS InvNumberPartner
           , Object_From.Id                    			                    AS FromId
           , Object_From.ValueData             			                    AS FromName
           , Object_Partner.Id                 			                    AS PartnerId
           , Object_Partner.ValueData          			                    AS PartnerName
           , Object_To.Id                      			                    AS ToId
           , Object_To.ValueData               			                    AS ToName
           , Object_Contract.ContractId        			                    AS ContractId
           , Object_Contract.invnumber         			                    AS ContractName
           , Object_Contract.ContractTagName
           , Object_TaxKind.Id                			                    AS TaxKindId
           , Object_TaxKind.ValueData         			                    AS TaxKindName
           , Movement_DocumentMaster.Id                                       AS DocumentMasterId
           , CAST(Movement_DocumentMaster.InvNumber as TVarChar)              AS DocumentMasterName
           , COALESCE (MovementBoolean_isPartner.ValueData, FALSE) :: Boolean AS isPartner     -- ������� ��� �������� �� ��������� ��������
           , Movement_DocumentChild.Id                                        AS DocumentChildId
           , CAST(MS_DocumentChild_InvNumberPartner.ValueData as TVarChar)    AS DocumentChildName
           , MovementString_InvNumberBranch.ValueData                         AS InvNumberBranch

           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId =  Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()
            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId = Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN object_contract_invnumber_view AS Object_Contract ON Object_Contract.contractid = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentMaster
                                           ON MovementLinkMovement_DocumentMaster.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentMaster.DescId = zc_MovementLinkMovement_Master()

            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_DocumentMaster.MovementChildId

            LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                      ON MovementBoolean_isPartner.MovementId = Movement_DocumentMaster.Id
                                     AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentChild
                                           ON MovementLinkMovement_DocumentChild.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentChild.DescId = zc_MovementLinkMovement_Child()

            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_DocumentChild.MovementChildId
            LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner ON MS_DocumentChild_InvNumberPartner.MovementId = MovementLinkMovement_DocumentChild.MovementChildId
                                                                         AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TaxCorrective();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective (Integer, Boolean, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.12.15         * add isPartner
 16.03.15         * add inMask
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 24.04.14                                                        * add zc_MovementString_InvNumberBranch
 15.04.14                                                        *   + Partner
 27.02.14                                                        *
 17.02.14                                                        *   fix is default is null
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_TaxCorrective (inMovementId:= 0, inOperDate:=CURRENT_DATE, inSession:= '2')
-- SELECT * FROM gpGet_Movement_TaxCorrective(inMovementId := 40859 , inMask:= FALSE, inOperDate := '25.01.2014',  inSession := '5');
