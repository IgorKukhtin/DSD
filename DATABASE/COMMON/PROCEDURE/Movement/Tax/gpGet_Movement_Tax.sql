-- Function: gpGet_Movement_Tax()

DROP FUNCTION IF EXISTS gpGet_Movement_Tax (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Tax (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Tax (Integer, Boolean, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Tax(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, Registered Boolean, DateRegistered TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, PartnerId Integer, PartnerName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , InvNumberBranch TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
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
               0 									AS Id
             , tmpInvNumber.InvNumber                  AS InvNumber
             , inOperDate						 	AS OperDate
             , Object_Status.Code               	AS StatusCode
             , Object_Status.Name              		AS StatusName
             , CAST (False as Boolean)         		AS Checked
             , CAST (False as Boolean)         		AS Document
             , CAST (False as Boolean)        		AS Registered
             , inOperDate         	            	AS DateRegistered
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , lpInsertFind_Object_InvNumberTax (zc_Movement_Tax(), inOperDate, CASE WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentOdessa()
                                                                                          THEN '6' -- !!!Одесса!!!
                                                                                     ELSE ''
                                                                                END) ::TVarChar AS InvNumberPartner
             , Object_Juridical_Basis.Id			AS FromId
             , Object_Juridical_Basis.ValueData		AS FromName
             , 0                     				AS ToId
             , CAST ('' as TVarChar) 				AS ToName
             , 0                               		AS PartnerId
             , CAST ('' as TVarChar)           		AS PartnerName
             , 0                     				AS ContractId
             , CAST ('' as TVarChar) 				AS ContractName
             , CAST ('' as TVarChar) 				AS ContractTagName
             , 0                     				AS TaxKindId
             , CAST ('' as TVarChar) 				AS TaxKindName
             , CASE WHEN lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) = zc_Enum_Process_AccessKey_DocumentOdessa()
                         THEN '6' -- !!!Одесса!!!
                    ELSE ''
               END :: TVarChar   				AS InvNumberBranch

          FROM (SELECT CAST (NEXTVAL ('movement_tax_seq') AS TVarChar) AS InvNumber) AS tmpInvNumber
          LEFT JOIN lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status ON 1=1
          LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
          LEFT JOIN Object AS Object_Juridical_Basis ON Object_Juridical_Basis.Id = zc_Juridical_Basis();

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id						AS Id

           , Movement.InvNumber                                         AS InvNumber
           , Movement.OperDate                                          AS OperDate

           , Object_Status.ObjectCode    				AS StatusCode
           , Object_Status.ValueData     				AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)        AS Checked
           , COALESCE (MovementBoolean_Document.ValueData, FALSE)       AS Document
           , COALESCE (MovementBoolean_Registered.ValueData, FALSE)     AS Registered
           , COALESCE (MovementDate_DateRegistered.ValueData,CAST (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) AS TDateTime))AS DateRegistered
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
           , Object_Partner.Id                     		AS PartnerId
           , Object_Partner.ValueData              		AS PartnerName
           , Object_Contract.ContractId        			AS ContractId
           , Object_Contract.invnumber         			AS ContractName
           , Object_Contract.ContractTagName
           , Object_TaxKind.Id                			AS TaxKindId
           , Object_TaxKind.ValueData         			AS TaxKindName
           , MovementString_InvNumberBranch.ValueData   AS InvNumberBranch


       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId =  Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementBoolean AS MovementBoolean_Registered
                                      ON MovementBoolean_Registered.MovementId =  Movement.Id
                                     AND MovementBoolean_Registered.DescId = zc_MovementBoolean_Registered()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

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



       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Tax();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Tax (Integer, Boolean, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.01.15         * add Mask
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 24.04.14                                                        * add zc_MovementString_InvNumberBranch
 09.04.14                                        * add PartnerId
 27.02.14                                                        *
 09.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Tax (inMovementId:= 0, inOperDate:=CURRENT_DATE,inSession:= '2')
-- SELECT * FROM gpGet_Movement_Tax(inMovementId := 40859 , inOperDate := '25.01.2014',  inSession := '5');