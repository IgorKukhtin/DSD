-- Function: gpGet_Movement_ChangePercent()

DROP FUNCTION IF EXISTS gpGet_Movement_ChangePercent (Integer, Boolean, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ChangePercent(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, isMask Boolean, InvNumber TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_ChangePercent_Mask (ioId        := inMovementId
                                                          , inOperDate  := inOperDate
                                                          , inSession   := inSession); 
     END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 	     	                    AS Id
             , FALSE                                AS isMask
             , tmpInvNum.InvNumber              AS InvNumber
             , CAST ('' as TVarChar)            AS InvNumberPartner
             , inOperDate			            AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name              	AS StatusName

             , CAST (FALSE AS Boolean)          AS Checked
             , CAST (False as Boolean)          AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 AS TFloat)               AS ChangePercent

             , CAST (0 as TFloat)       AS TotalCountKg
             , CAST (0 as TFloat)       AS TotalCountSh
             , CAST (0 as TFloat)       AS TotalCount
             , CAST (0 as TFloat)       AS TotalSummMVAT
             , CAST (0 as TFloat)       AS TotalSummPVAT
             , CAST (0 as TFloat)       AS TotalSumm

             , 0	                    AS FromId
             , CAST ('' as TVarChar)	AS FromName
             , 0                        AS ToId
             , CAST ('' as TVarChar)    AS ToName
             , 0                        AS PartnerId
             , CAST ('' as TVarChar)    AS PartnerName

              , 0                     	AS ContractId
             , CAST ('' as TVarChar) 	AS ContractName

             , 0                     	AS PaidKindId
             , CAST ('' as TVarChar) 	AS PaidKindName

             , Object_TaxKind.Id        AS DocumentTaxKindId
             , Object_TaxKind.ValueData AS DocumentTaxKindName
             , CAST ('' as TVarChar) 	AS Comment

          FROM (SELECT CAST (NEXTVAL ('movement_ChangePercent_seq') AS TVarChar) AS InvNumber) AS tmpInvNum
               LEFT JOIN lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status ON 1 = 1
               LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate 
               LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = zc_Enum_DocumentTaxKind_ChangePercent()
         ;


     ELSE

     RETURN QUERY
       SELECT
             Movement.Id			            AS Id
           , FALSE                              AS isMask
           , Movement.InvNumber			        AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Movement.OperDate			        AS OperDate
           , Object_Status.ObjectCode    	       AS StatusCode
           , Object_Status.ValueData     	       AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)        AS Checked
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)   AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData    AS VATPercent
           , MovementFloat_ChangePercent.ValueData AS ChangePercent

           , MovementFloat_TotalCountKg.ValueData  AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData  AS TotalCountSh
           , MovementFloat_TotalCount.ValueData    AS TotalCount

           , MovementFloat_TotalSummMVAT.ValueData AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData     AS TotalSumm

           , Object_From.Id                   AS FromId
           , Object_From.ValueData            AS FromName
           , Object_To.Id                     AS ToId
           , Object_To.ValueData              AS ToName
           , Object_Partner.Id                AS PartnerId
           , Object_Partner.ValueData         AS PartnerName

           , View_Contract.ContractId     	  AS ContractId
           , View_Contract.InvNumber          AS ContractName

           , Object_PaidKind.Id           	  AS PaidKindId
           , Object_PaidKind.ValueData        AS PaidKindName

           , Object_TaxKind.Id                AS DocumentTaxKindId
           , Object_TaxKind.ValueData         AS DocumentTaxKindName
           , MovementString_Comment.ValueData AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            
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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract     
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId
            --LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ChangePercent();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ChangePercent(inMovementId := 40859 , inMask:=False, inOperDate := '25.01.2014',  inSession := '5');
