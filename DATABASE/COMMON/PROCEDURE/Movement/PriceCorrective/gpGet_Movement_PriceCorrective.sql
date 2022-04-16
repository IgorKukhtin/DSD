-- Function: gpGet_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS gpGet_Movement_PriceCorrective (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PriceCorrective(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , MovementId_Tax Integer, InvNumber_Tax TVarChar
             , Checked Boolean
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , InvNumberPartner TVarChar, InvNumberMark TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , StartDateTax TDateTime
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PriceCorrective());
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_pricecorrective_seq') AS TVarChar) AS InvNumber

             , inOperDate			                 	AS OperDate
             , zc_Enum_Status_UnComplete()              AS StatusId
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , 0                                        AS MovementId_Tax
             , '' :: TVarChar                           AS InvNumber_Tax
             , FALSE :: Boolean                         AS Checked
             , CAST (False as Boolean)                  AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                       AS TotalCount
             , CAST (0 as TFloat)                       AS TotalSummMVAT
             , CAST (0 as TFloat)                       AS TotalSummPVAT

             , CAST ('' as TVarChar) 	                AS InvNumberPartner
             , CAST ('' as TVarChar) 	                AS InvNumberMark

             , 0                     	                AS FromId
             , CAST ('' as TVarChar) 	                AS FromName
             , 0                                        AS ToId
             , CAST ('' as TVarChar)                    AS ToName
             , 0                                        AS PartnerId
             , CAST ('' as TVarChar)                    AS PartnerName
             , 0                     	                AS PaidKindId
             , CAST ('' as TVarChar)	                AS PaidKindName
             , 0                     	                AS ContractId
             , CAST ('' as TVarChar)                    AS ContractName
             , 0                                        AS DocumentTaxKindId
             , CAST ('' as TVarChar)                    AS DocumentTaxKindName 
             , 0                                        AS BranchId
             , CAST ('' as TVarChar)                    AS BranchName
             , (DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '4 MONTH') :: TDateTime AS StartDateTax
             , CAST ('' as TVarChar)                    AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
               --LEFT JOIN Object AS Object_To ON Object_To.Id = 8461                                      
         ;
     ELSE

     RETURN QUERY
       WITH tmpMovementTax AS (SELECT Movement.*
                                    , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                               FROM Movement
                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                            AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                               WHERE Movement.Id = (SELECT DISTINCT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId)
                              )
       -- Результат
       SELECT
             Movement.Id
           , Movement.InvNumber

           , Movement.OperDate
           , Movement.StatusId
           , Object_Status.ObjectCode          	    AS StatusCode
           , Object_Status.ValueData         	    AS StatusName

           , Movement.ParentId                      AS MovementId_Tax
           , (zfConvert_StringToNumber (Movement_Parent.InvNumberPartner) || ' от ' || Movement_Parent.OperDate :: Date :: TVarChar ) :: TVarChar AS InvNumber_Tax
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean   AS Checked

           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent

           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT

           , COALESCE(MovementString_InvNumberPartner.ValueData, CAST ('' as TVarChar)) AS InvNumberPartner
           , COALESCE(MovementString_InvNumberMark.ValueData, CAST ('' as TVarChar))    AS InvNumberMark

           , Object_From.Id                    	    AS FromId
           , Object_From.ValueData             	    AS FromName
           , Object_To.Id                      	    AS ToId
           , Object_To.ValueData               	    AS ToName
           , Object_Partner.Id                      AS PartnerId
           , Object_Partner.ValueData               AS PartnerName
           , Object_PaidKind.Id                	    AS PaidKindId
           , Object_PaidKind.ValueData         	    AS PaidKindName
           , View_Contract_InvNumber.ContractId     AS ContractId
           , View_Contract_InvNumber.InvNumber      AS ContractName

           , Object_TaxKind.Id                	    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         	    AS DocumentTaxKindName    
           , Object_Branch.Id                       AS BranchId
           , Object_Branch.ValueData                AS BranchName
           , (DATE_TRUNC ('MONTH', Movement.OperDate) - INTERVAL '4 MONTH') :: TDateTime AS StartDateTax
           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
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

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId = Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

--add Tax
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MovementLinkObject_Branch.ObjectId

            -- Налоговая
            LEFT JOIN tmpMovementTax AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_PriceCorrective()
       ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_PriceCorrective (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Манько Д.А.
 26.03.19         * add Checked
 17.06.14         * add inInvNumberPartner
                      , inInvNumberMark
 29.05.14         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_PriceCorrective (inMovementId:= 8491746, inOperDate := '25.05.2014', inSession:= zfCalc_UserAdmin())
