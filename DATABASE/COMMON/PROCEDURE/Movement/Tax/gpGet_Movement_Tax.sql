-- Function: gpGet_Movement_Tax()

DROP FUNCTION IF EXISTS gpGet_Movement_Tax (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Tax (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Tax (Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Tax(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, isMask Boolean, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, isElectron Boolean, DateRegistered TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , INN_To TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , StartDateTax TDateTime
             , InvNumberBranch TVarChar
             , Comment TVarChar
             , isINN Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Tax());
     vbUserId := lpGetUserBySession (inSession);
     

     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_Tax_Mask (ioId        := inMovementId
                                               , inOperDate  := inOperDate
                                               , inSession   := inSession); 
     END If;



     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 					AS Id
             , FALSE                                    AS isMask
             , tmpInvNumber.InvNumber                   AS InvNumber
             , inOperDate				AS OperDate
             , Object_Status.Code               	AS StatusCode
             , Object_Status.Name              		AS StatusName
             , CAST (False as Boolean)         		AS Checked
             , CAST (False as Boolean)         		AS Document
             , CAST (False as Boolean)        		AS isElectron
             , inOperDate         	            	AS DateRegistered
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , lpInsertFind_Object_InvNumberTax (zc_Movement_Tax(), inOperDate, tmpInvNumber.InvNumberBranch) :: TVarChar AS InvNumberPartner
             , Object_Juridical_Basis.Id			AS FromId
             , Object_Juridical_Basis.ValueData		AS FromName
             , 0                     			AS ToId
             , CAST ('' as TVarChar) 			AS ToName
             , CAST ('' as TVarChar) 			AS INN_To
             , 0                               	        AS PartnerId
             , CAST ('' as TVarChar)           	        AS PartnerName
             , 0                     			AS ContractId
             , CAST ('' as TVarChar) 			AS ContractName
             , CAST ('' as TVarChar) 			AS ContractTagName
             , 0                     			AS TaxKindId
             , CAST ('' as TVarChar) 			AS TaxKindName
             , 0                   		        AS ReestrKindId
             , '' :: TVarChar                           AS ReestrKindName 
             , (DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '4 MONTH') :: TDateTime AS StartDateTax
             , tmpInvNumber.InvNumberBranch
             , CAST ('' as TVarChar) 		        AS Comment
             , CAST (False as Boolean)         		AS isINN

          FROM (SELECT CAST (NEXTVAL ('movement_tax_seq') AS TVarChar) AS InvNumber
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
             Movement.Id						AS Id
           , FALSE                                                      AS isMask

           , Movement.InvNumber                                         AS InvNumber
           , Movement.OperDate                                          AS OperDate

           , Object_Status.ObjectCode    				AS StatusCode
           , Object_Status.ValueData     				AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)        AS Checked
           , COALESCE (MovementBoolean_Document.ValueData, FALSE)       AS Document
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE)       AS isElectron
           , COALESCE (MovementDate_DateRegistered.ValueData,CAST (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) AS TDateTime)) AS DateRegistered
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)   AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Object_From.Id                    			AS FromId
           , Object_From.ValueData             			AS FromName--
           , Object_To.Id                      			AS ToId
           , Object_To.ValueData               			AS ToName
           , CASE WHEN Movement.Id IN (-- Tax
                                       6922620
                                     , 6922564
                                     , 6922609
                                     , 6922233
                                     , 6921599
                                     , 6922367
                                     , 6922254
                                     , 6922275
                                     , 8484674
                                     , 8486085
                                     , 8486839
                                     , 8487001
                                     , 8487359
                                      )
                  THEN '100000000000'
                  ELSE COALESCE (MovementString_ToINN.ValueData, ObjectHistory_JuridicalDetails_View.INN)
             END :: TVarChar AS INN_To


           , Object_Partner.Id                     		AS PartnerId
           , Object_Partner.ValueData              		AS PartnerName
           , Object_Contract.ContractId        			AS ContractId
           , Object_Contract.invnumber         			AS ContractName
           , Object_Contract.ContractTagName
           , Object_TaxKind.Id                			AS TaxKindId
           , Object_TaxKind.ValueData         			AS TaxKindName

           , Object_ReestrKind.Id             	                AS ReestrKindId
           , Object_ReestrKind.ValueData       	                AS ReestrKindName

           , (DATE_TRUNC ('MONTH', Movement.OperDate) - INTERVAL '4 MONTH') :: TDateTime AS StartDateTax
           , MovementString_InvNumberBranch.ValueData           AS InvNumberBranch
           , MovementString_Comment.ValueData                   AS Comment
           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, '') <> '' THEN TRUE ELSE FALSE END AS isINN

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId = Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()
            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId = Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId = Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_ToINN
                                     ON MovementString_ToINN.MovementId = Movement.Id
                                    AND MovementString_ToINN.DescId     = zc_MovementString_ToINN()
                                    AND MovementString_ToINN.ValueData  <> ''

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN object_contract_invnumber_view AS Object_Contract ON Object_Contract.contractid = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                                          AND MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementId
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = COALESCE (Movement_DocumentMaster.Id, Movement.Id)
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = COALESCE (Movement_DocumentMaster.Id, Movement.Id)
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Tax();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Tax (Integer, Boolean, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.03.18         * MovementString_ToINN
 01.12.16         * add ReestrKind
 10.05.16         * add StartDateTax
 26.01.15         * add Mask
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 24.04.14                                                        * add zc_MovementString_InvNumberBranch
 09.04.14                                        * add PartnerId
 27.02.14                                                        *
 09.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Tax (inMovementId:= 0, inOperDate:=CURRENT_DATE,inSession:= '2')
-- SELECT * FROM gpGet_Movement_Tax (inMovementId := 40859, inMask:= FALSE, inOperDate := '25.01.2014',  inSession := '5');
