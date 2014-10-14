-- Function: gpSelect_Movement_ZakazInternal()

 DROP FUNCTION IF EXISTS gpSelect_Movement_EDI (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, OperDateTax TDateTime, InvNumberTax TVarChar
             , TotalCountPartner TFloat
             , TotalSumm TFloat
             , OKPO TVarChar, JuridicalName TVarChar
             , GLNCode TVarChar,  GLNPlaceCode TVarChar
             , JuridicalNameFind TVarChar, PartnerNameFind TVarChar

             , MovementId_Sale Integer
             , OperDatePartner_Sale TDateTime, InvNumber_Sale TVarChar
             , FromName_Sale TVarChar, ToName_Sale TVarChar
             , TotalCountPartner_Sale TFloat
             , TotalSumm_Sale TFloat

             , MovementId_Tax Integer
             , OperDate_Tax TDateTime, InvNumberPartner_Tax TVarChar

             , MovementId_TaxCorrective Integer
             , OperDate_TaxCorrective TDateTime, InvNumberPartner_TaxCorrective TVarChar

             , MovementId_Order Integer
             , OperDate_Order TDateTime, InvNumber_Order TVarChar

             , DescName TVarChar
             , isCheck Boolean
             , isElectron Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_EDI());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode    AS StatusCode
           , Object_Status.ValueData     AS StatusName

           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner

           , MovementDate_OperDateTax.ValueData             AS OperDateTax
           , MovementString_InvNumberTax.ValueData          AS InvNumberTax

           , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
          
           , MovementString_OKPO.ValueData          AS OKPO 
           , MovementString_JuridicalName.ValueData AS JuridicalName

           , MovementString_GLNCode.ValueData       AS GLNCode
           , MovementString_GLNPlaceCode.ValueData  AS GLNPlaceCode
           , Object_Juridical.ValueData             AS JuridicalNameFind
           , Object_Partner.ValueData               AS PartnerNameFind

           , COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId) :: Integer AS MovementId_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale
           , Movement_Sale.InvNumber                        AS InvNumber_Sale
           , Object_From_Sale.ValueData                     AS FromName_Sale
           , Object_To_Sale.ValueData                       AS ToName_Sale
           , MovementFloat_TotalCountPartner_Sale.ValueData AS TotalCountPartner_Sale
           , MovementFloat_TotalSumm_Sale.ValueData         AS TotalSumm_Sale

           , COALESCE (MovementLinkMovement_Tax.MovementId, MovementLinkMovement_TaxCorrective_Tax.MovementChildId) :: Integer AS MovementId_Tax
           , Movement_Tax.OperDate                          AS OperDate_Tax
           , MovementString_InvNumberPartner_Tax.ValueData  AS InvNumberPartner_Tax

           , MovementLinkMovement_ChildEDI.MovementId                 AS MovementId_TaxCorrective
           , Movement_TaxCorrective.OperDate                          AS OperDate_Tax
           , MovementString_InvNumberPartner_TaxCorrective.ValueData  AS InvNumberPartner_Tax

           , MovementLinkMovement_Order.MovementId          AS MovementId_Order
           , Movement_Order.OperDate                        AS OperDate_Order
           , Movement_Order.InvNumber                       AS InvNumber_Order

           , MovementDesc.ItemName AS DescName

           , CASE WHEN (MovementLinkMovement_Sale.MovementId IS NOT NULL OR MovementLinkMovement_MasterEDI.MovementId IS NOT NULL)
                   AND (COALESCE (MovementFloat_TotalCountPartner.ValueData, 0) <> COALESCE (MovementFloat_TotalCountPartner_Sale.ValueData, 0)
                     OR COALESCE (MovementFloat_TotalSumm_Sale.ValueData, 0) <> COALESCE (MovementFloat_TotalSumm.ValueData, 0))
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isCheck
           , COALESCE(MovementBoolean_Electron.ValueData, false) AS isElectron

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementString AS MovementString_Desc
                                     ON MovementString_Desc.MovementId =  Movement.Id
                                    AND MovementString_Desc.DescId = zc_MovementString_Desc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_JuridicalName
                                     ON MovementString_JuridicalName.MovementId =  Movement.Id
                                    AND MovementString_JuridicalName.DescId = zc_MovementString_JuridicalName()
            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
            LEFT JOIN MovementString AS MovementString_GLNCode
                                     ON MovementString_GLNCode.MovementId =  Movement.Id
                                    AND MovementString_GLNCode.DescId = zc_MovementString_GLNCode()
            LEFT JOIN MovementString AS MovementString_GLNPlaceCode
                                     ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                    AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateTax
                                   ON MovementDate_OperDateTax.MovementId =  Movement.Id
                                  AND MovementDate_OperDateTax.DescId = zc_MovementDate_OperDateTax()
            LEFT JOIN MovementString AS MovementString_InvNumberTax
                                     ON MovementString_InvNumberTax.MovementId =  Movement.Id
                                    AND MovementString_InvNumberTax.DescId = zc_MovementString_InvNumberTax()
                                   
            LEFT JOIN MovementString AS MovementString_MovementDesc
                                     ON MovementString_MovementDesc.MovementId =  Movement.Id
                                    AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
            LEFT JOIN MovementDesc ON MovementDesc.Code =  MovementString_MovementDesc.ValueData

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                           ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId)
                                               -- AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Sale
                                   ON MovementDate_OperDatePartner_Sale.MovementId =  Movement_Sale.Id
                                  AND MovementDate_OperDatePartner_Sale.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner_Sale
                                    ON MovementFloat_TotalCountPartner_Sale.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountPartner_Sale.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_Sale
                                    ON MovementFloat_TotalSumm_Sale.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalSumm_Sale.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Sale
                                         ON MovementLinkObject_From_Sale.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From_Sale.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From_Sale ON Object_From_Sale.Id = MovementLinkObject_From_Sale.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To_Sale
                                         ON MovementLinkObject_To_Sale.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To_Sale.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To_Sale ON Object_To_Sale.Id = MovementLinkObject_To_Sale.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                           ON MovementLinkMovement_ChildEDI.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TaxCorrective_Tax
                                           ON MovementLinkMovement_TaxCorrective_Tax.MovementId = MovementLinkMovement_ChildEDI.MovementId
                                          AND MovementLinkMovement_TaxCorrective_Tax.DescId = zc_MovementLinkMovement_Child()

            LEFT JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = MovementLinkMovement_ChildEDI.MovementId
                                                        -- AND Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner_TaxCorrective
                                     ON MovementString_InvNumberPartner_TaxCorrective.MovementId =  Movement_TaxCorrective.Id
                                    AND MovementString_InvNumberPartner_TaxCorrective.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Tax()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = COALESCE (MovementLinkMovement_Tax.MovementId, MovementLinkMovement_TaxCorrective_Tax.MovementChildId)
                                              AND Movement_Tax.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Tax
                                     ON MovementString_InvNumberPartner_Tax.MovementId =  Movement_Tax.Id
                                    AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                AND Movement_Order.StatusId = zc_Enum_Status_Complete()

       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         -- AND MovementString_OKPO.ValueData IN ('36387233', '36387249', '38916588')
         -- *** AND (Movement_TaxCorrective.Id IS NULL OR Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete())
         -- *** AND (Movement_Sale.Id IS NULL OR Movement_Sale.StatusId = zc_Enum_Status_Complete())

       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_EDI (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        * rem --***
 20.07.14                                        * ALL
 15.05.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_EDI (inStartDate:= '01.07.2014', inEndDate:= '31.07.2014', inSession:= '2')
