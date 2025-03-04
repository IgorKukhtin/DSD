-- Function: gpGet_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective (Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ключ Документа 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, isMask Boolean, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean
             , isElectron Boolean, DateisElectron TDateTime, DateRegistered TDateTime, InvNumberRegistered TVarChar
             , isNPP_calc Boolean, DateisNPP_calc TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, INN_From TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , ToId Integer, ToName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , DocumentMasterId Integer, DocumentMasterName TVarChar, isPartner Boolean
             , DocumentChildId Integer, DocumentChildName TVarChar
             , InvNumberBranch TVarChar
             , BranchId Integer, BranchName TVarChar
             , Comment TVarChar
             , isINN Boolean
             , isAuto Boolean
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbAccessKey Integer;
   DECLARE vbBranchId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TaxCorrective());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMask, FALSE) = TRUE
     THEN
         inMovementId := gpInsert_Movement_TaxCorrective_Mask (ioId        := inMovementId
                                                             , inOperDate  := inOperDate
                                                             , inSession   := inSession
                                                              );
     END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         vbAccessKey:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());
         vbBranchId:= zfGet_Branch_AccessKey (vbAccessKey);

         RETURN QUERY
         SELECT
               0                                    AS Id
             , FALSE                                AS isMask
             , tmpInvNumber.InvNumber               AS InvNumber
             , inOperDate                           AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name                   AS StatusName
             , CAST (False as Boolean)              AS Checked
             , CAST (False as Boolean)              AS Document
             , CAST (False as Boolean)              AS isElectron
             , inOperDate                           AS DateisElectron
             , inOperDate                           AS DateRegistered
             , CAST ('' as TVarChar)                AS InvNumberRegistered
             , CAST (False as Boolean)              AS isNPP_calc
             , CURRENT_TIMESTAMP       :: TDateTime AS DateisNPP_calc
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), inOperDate, tmpInvNumber.InvNumberBranch) :: TVarChar AS InvNumberPartner
             , 0                                    AS FromId
             , CAST ('' as TVarChar)                AS FromName
             , CAST ('' as TVarChar)                AS INN_From
             , 0                                    AS PartnerId
             , CAST ('' as TVarChar)                AS PartnerName
             , Object_Juridical_Basis.Id            AS ToId
             , Object_Juridical_Basis.ValueData     AS ToName
             , 0                                    AS ContractId
             , CAST ('' as TVarChar)                AS ContractName
             , CAST ('' as TVarChar)                AS ContractTagName
             , 0                                    AS TaxKindId
             , CAST ('' as TVarChar)                AS TaxKindName
             , 0                                    AS DocumentMasterId
             , CAST ('' as TVarChar)                AS DocumentMasterName
             , CAST (False as Boolean)              AS isPartner     -- признак Акт недовоза из документа возврата
             , 0                                    AS DocumentChildId
             , CAST ('' as TVarChar)                AS DocumentChildName
             , tmpInvNumber.InvNumberBranch         AS InvNumberBranch
             , Object_Branch.Id                     AS BranchId
             , Object_Branch.ValueData              AS BranchName
             , ''                       :: TVarChar AS Comment
             , FALSE                    :: Boolean  AS isINN
             , FALSE                    :: Boolean  AS isAuto

          FROM (SELECT CAST (NEXTVAL ('movement_taxcorrective_seq') AS TVarChar) AS InvNumber
                     , CASE WHEN inOperDate >= '01.01.2016'
                                 THEN ''
                            ELSE COALESCE ((SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.ObjectId = vbBranchId AND ObjectString.DescId = zc_objectString_Branch_InvNumber()), '')
                       END :: TVarChar AS InvNumberBranch

                     , vbBranchId AS BranchId
               ) AS tmpInvNumber
          LEFT JOIN lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status ON 1=1
          LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
          LEFT JOIN Object AS Object_Juridical_Basis ON Object_Juridical_Basis.Id = zc_Juridical_Basis()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpInvNumber.BranchId;

     ELSE

     RETURN QUERY
     WITH 
     tmpMovement AS (SELECT *
                     FROM Movement
                     WHERE Movement.Id = inMovementId
                       AND Movement.DescId = zc_Movement_TaxCorrective()
                     )

   , tmpMovementFloat AS (SELECT MovementFloat.*
                          FROM MovementFloat
                          WHERE MovementFloat.MovementId = inMovementId
                            AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                       , zc_MovementFloat_TotalSummMVAT()
                                                       , zc_MovementFloat_TotalSummPVAT()
                                                       , zc_MovementFloat_VATPercent() )
                          )

   , tmpMovementBoolean AS (SELECT MovementBoolean.*
                            FROM MovementBoolean
                            WHERE MovementBoolean.MovementId = inMovementId
                              AND MovementBoolean.DescId IN (zc_MovementBoolean_Checked()
                                                           , zc_MovementBoolean_Document()
                                                           , zc_MovementBoolean_Electron()
                                                           , zc_MovementBoolean_NPP_calc() 
                                                           , zc_MovementBoolean_PriceWithVAT()
                                                           , zc_MovementBoolean_isAuto())
                            )

   , tmpMovementDate AS (SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId = inMovementId
                           AND MovementDate.DescId IN (zc_MovementDate_DateRegistered()
                                                     , zc_MovementDate_NPP_calc() )
                         )

   , tmpMovementString AS (SELECT MovementString.*
                          FROM MovementString
                          WHERE MovementString.MovementId = inMovementId
                            AND MovementString.DescId IN (zc_MovementString_Comment()
                                                        , zc_MovementString_FromINN()
                                                        , zc_MovementString_InvNumberBranch()
                                                        , zc_MovementString_InvNumberPartner()
                                                        , zc_MovementString_InvNumberRegistered() )
                          )

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
           , COALESCE (MovementDate_DateRegistered.ValueData,Movement.OperDate) AS DateRegistered
           , MovementString_InvNumberRegistered.ValueData                       AS InvNumberRegistered

           , COALESCE (MovementBoolean_NPP_calc.ValueData, FALSE) ::Boolean AS isNPP_calc
           , COALESCE (MovementDate_NPP_calc.ValueData, CURRENT_TIMESTAMP) :: TDateTime  AS DateisNPP_calc
          
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)       AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData                             AS VATPercent
           , MovementFloat_TotalCount.ValueData                             AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData                          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData                          AS TotalSummPVAT
           , MovementString_InvNumberPartner.ValueData                      AS InvNumberPartner
           , Object_From.Id                    			                    AS FromId
           , Object_From.ValueData             			                    AS FromName

           , CASE WHEN Movement.Id IN (-- Corr
                                       7943509
                                     , 8066170
                                     , 8066171
                                     , 8066169
                                     , 8464974
                                     , 8465476
                                     , 8465802
                                     , 8479936
                                     , 8462887
                                     , 8462999
                                     , 8463007
                                     , 8488900
                                     , 8464619
                                      )
                  THEN '100000000000'
                  ELSE COALESCE (MovementString_FromINN.ValueData, ObjectHistory_JuridicalDetails_View.INN)
             END :: TVarChar AS INN_From

           , Object_Partner.Id                 			                    AS PartnerId
           , Object_Partner.ValueData          			                    AS PartnerName
           , Object_To.Id                      			                    AS ToId
           , Object_To.ValueData               			                    AS ToName
           , Object_Contract.ContractId        			                    AS ContractId
           , Object_Contract.Invnumber         			                    AS ContractName
           , Object_Contract.ContractTagName                                        AS ContractTagName
           , Object_TaxKind.Id                			                    AS TaxKindId
           , Object_TaxKind.ValueData         			                    AS TaxKindName
           , Movement_DocumentMaster.Id                                       AS DocumentMasterId
           , CASE WHEN Movement_DocumentMaster.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       THEN COALESCE (Object_StatusMaster.ValueData, '') || ' ' || Movement_DocumentMaster.InvNumber
                  ELSE Movement_DocumentMaster.InvNumber
             END :: TVarChar AS DocumentMasterName

           , COALESCE (MovementBoolean_isPartner.ValueData, FALSE) :: Boolean AS isPartner     -- признак Акт недовоза из документа возврата
           , Movement_DocumentChild.Id                                        AS DocumentChildId
           , CASE WHEN Movement_DocumentChild.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       THEN COALESCE (Object_StatusChild.ValueData, '') || ' ' || MS_DocumentChild_InvNumberPartner.ValueData
                  ELSE MS_DocumentChild_InvNumberPartner.ValueData
             END :: TVarChar AS DocumentChildName
           , MovementString_InvNumberBranch.ValueData                         AS InvNumberBranch

           , Object_Branch.Id                       AS BranchId
           , Object_Branch.ValueData                AS BranchName

           , MovementString_Comment.ValueData       AS Comment

           , CASE WHEN COALESCE (MovementString_FromINN.ValueData, '') <> '' THEN TRUE ELSE FALSE END AS isINN
           , COALESCE (MovementBoolean_isAuto.ValueData, False)                           :: Boolean  AS isAuto

       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Checked
                                         ON MovementBoolean_Checked.MovementId =  Movement.Id
                                        AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Document
                                         ON MovementBoolean_Document.MovementId =  Movement.Id
                                        AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Electron
                                         ON MovementBoolean_Electron.MovementId = Movement.Id
                                        AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_NPP_calc
                                         ON MovementBoolean_NPP_calc.MovementId = Movement.Id
                                        AND MovementBoolean_NPP_calc.DescId = zc_MovementBoolean_NPP_calc()

            LEFT JOIN tmpMovementDate AS MovementDate_DateRegistered
                                      ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                     AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN tmpMovementDate AS MovementDate_NPP_calc
                                      ON MovementDate_NPP_calc.MovementId =  Movement.Id
                                     AND MovementDate_NPP_calc.DescId = zc_MovementDate_NPP_calc()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_isAuto
                                         ON MovementBoolean_isAuto.MovementId = Movement.Id
                                        AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementString AS MovementString_FromINN
                                        ON MovementString_FromINN.MovementId = Movement.Id
                                       AND MovementString_FromINN.DescId = zc_MovementString_FromINN()
                                       AND MovementString_FromINN.ValueData  <> ''

            LEFT JOIN tmpMovementString AS MovementString_InvNumberRegistered
                                        ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                       AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberBranch
                                        ON MovementString_InvNumberBranch.MovementId = Movement.Id
                                       AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

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

            LEFT JOIN Object_contract_invnumber_view AS Object_Contract ON Object_Contract.contractid = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MovementLinkObject_Branch.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentMaster
                                           ON MovementLinkMovement_DocumentMaster.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentMaster.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_DocumentMaster.MovementChildId
            LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_DocumentMaster.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                      ON MovementBoolean_isPartner.MovementId = Movement_DocumentMaster.Id
                                     AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentChild
                                           ON MovementLinkMovement_DocumentChild.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentChild.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_DocumentChild.MovementChildId
            LEFT JOIN Object AS Object_StatusChild ON Object_StatusChild.Id = Movement_DocumentChild.StatusId

            LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner
                                     ON MS_DocumentChild_InvNumberPartner.MovementId = MovementLinkMovement_DocumentChild.MovementChildId
                                    AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
       ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective (Integer, Boolean, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.

 07.12.21         *
 10.03.20         *
 17.12.18         * InvNumberRegistered
 01.04.18         * 
 04.12.15         * add isPartner
 16.03.15         * add inMask
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 24.04.14                                                        * add zc_MovementString_InvNumberBranch
 15.04.14                                                        *   + Partner
 27.02.14                                                        *
 17.02.14                                                        *   fix is default is null
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_TaxCorrective (inMovementId:= 0, inOperDate:=CURRENT_DATE, inSession:= '2')
-- SELECT * FROM gpGet_Movement_TaxCorrective(inMovementId := 40859 , inMask:= FALSE, inOperDate := '25.01.2014',  inSession := '5');
--select * from gpGet_Movement_TaxCorrective(inMovementId := 16067441 , inMask := 'False' , inOperDate := ('01.05.2021')::TDateTime ,  inSession := '5');
