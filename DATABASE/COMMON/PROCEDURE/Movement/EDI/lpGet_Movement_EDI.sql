-- Function: lpGet_Movement_EDI (Integer, Integer)

DROP FUNCTION IF EXISTS lpGet_Movement_EDI (Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_Movement_EDI(
    IN inMovementId      Integer  , -- ÍÎ˛˜ ƒÓÍÛÏÂÌÚ‡
    IN inUserId          Integer    -- ÔÓÎ¸ÁÓ‚‡ÚÂÎ¸
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, OperDateTax TDateTime, InvNumberTax TVarChar
             , TotalCountPartner TFloat
             , TotalSumm TFloat
             , OKPO TVarChar, JuridicalName TVarChar
             , GLNCode TVarChar,  GLNPlaceCode TVarChar
             , JuridicalId_Find Integer, JuridicalNameFind TVarChar, PartnerNameFind TVarChar

             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , UnitId Integer, UnitName TVarChar

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
             , isError Boolean
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
       WITH tmpMLO_Contract AS (SELECT * FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
          , tmpObject_Contract AS (SELECT * FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpMLO_Contract.ObjectId FROM tmpMLO_Contract))
          , tmpMLM_child AS (SELECT * FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId)
          , tmp AS
      (SELECT
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
           , Object_Juridical.Id                    AS JuridicalId_Find
           , Object_Juridical.ValueData             AS JuridicalNameFind
           , Object_Partner.ValueData               AS PartnerNameFind

           , View_Contract_InvNumber.Id             AS ContractId
           , View_Contract_InvNumber.ObjectCode     AS ContractCode
           , View_Contract_InvNumber.ValueData      AS ContractName
           , Object_ContractTag.ValueData           AS ContractTagName

           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName

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
           , COALESCE(MovementBoolean_Error.ValueData, false) AS isError

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementBoolean AS MovementBoolean_Error
                                      ON MovementBoolean_Error.MovementId =  Movement.Id
                                     AND MovementBoolean_Error.DescId = zc_MovementBoolean_Error()

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

            LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()


          --LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN tmpObject_Contract AS View_Contract_InvNumber ON View_Contract_InvNumber.Id = MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                 ON ObjectLink_Contract_ContractTag.ObjectId = View_Contract_InvNumber.Id
                                AND ObjectLink_Contract_ContractTag.DescId   = zc_ObjectLink_Contract_ContractTag()
            LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN tmpMLM_child AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN tmpMLM_child AS MovementLinkMovement_MasterEDI
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

            LEFT JOIN tmpMLM_child AS MovementLinkMovement_ChildEDI
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

            LEFT JOIN tmpMLM_child AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Tax()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = COALESCE (MovementLinkMovement_Tax.MovementId, MovementLinkMovement_TaxCorrective_Tax.MovementChildId)
                                              AND Movement_Tax.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Tax
                                     ON MovementString_InvNumberPartner_Tax.MovementId =  Movement_Tax.Id
                                    AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMLM_child AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                AND Movement_Order.StatusId = zc_Enum_Status_Complete()

       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.Id = inMovementId
      )
     , tmp_find AS (SELECT MAX (COALESCE (tmp.MovementId_Order, 0)) AS Id_find FROM tmp)

       -- –ÂÁÛÎ¸Ú‡Ú
       SELECT * FROM tmp WHERE COALESCE (tmp.MovementId_Order, 0) IN (SELECT tmp_find.Id_find FROM tmp_find)
       LIMIT 1
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpGet_Movement_EDI (Integer, Integer) OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 04.03.15                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM lpGet_Movement_EDI (inMovementId:= 1130125, inUserId:= 5)
