-- FunctiON: gpGet_Movement_SaleASset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_SaleASset (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SaleASset(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSessiON           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , Comment TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSessiON, zc_Enum_Process_Get_Movement_SaleASset());
     vbUserId:= lpGetUserBySessiON (inSessiON);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_SaleASset_seq') AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , inOperDate                       AS OperDatePartner

             , CAST (False AS Boolean)          AS PriceWithVAT
             , CAST (20 AS TFloat)              AS VATPercent
             
             , CAST (1 AS TFloat)               AS CurrencyValue
             , CAST (1 AS TFloat)               AS ParValue
             , CAST (1 AS TFloat)               AS CurrencyPartnerValue
             , CAST (1 AS TFloat)               AS ParPartnerValue

             , 0                     AS FromId
             , CAST ('' AS TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' AS TVarChar) AS ToName
             
             , 0                     AS PaidKindId
             , CAST ('' AS TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' AS TVarChar) AS ContractName

             , ObjectCurrency.Id         AS CurrencyDocumentId	-- грн
             , ObjectCurrency.ValueData  AS CurrencyDocumentName
           
             , 0                     AS CurrencyPartnerId
             , CAST ('' AS TVarChar) AS CurrencyPartnerName

             , CAST ('' AS TVarChar) AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              JOIN Object AS ObjectCurrency ON ObjectCurrency.descid= zc_Object_Currency()
                                            AND ObjectCurrency.id = 14461;	             -- грн
     ELSE
       RETURN QUERY 
       
       WITH 
         -- результат
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

             , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData          AS VATPercent
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent

             , MovementFloat_CurrencyValue.ValueData                            AS CurrencyValue
             , COALESCE (MovementFloat_ParValue.ValueData, 1)        :: TFloat  AS ParValue
             , MovementFloat_CurrencyPartnerValue.ValueData                     AS CurrencyPartnerValue
             , COALESCE (MovementFloat_ParPartnerValue.ValueData, 1) :: TFloat  AS ParPartnerValue

             , Object_From.Id                        AS FromId
             , Object_From.ValueData                 AS FromName
             , Object_To.Id                          AS ToId
             , Object_To.ValueData                   AS ToName
             , Object_PaidKind.Id                    AS PaidKindId
             , Object_PaidKind.ValueData             AS PaidKindName
             , View_Contract_InvNumber.ContractId    AS ContractId
             , View_Contract_InvNumber.InvNumber     AS ContractName

             , COALESCE (Object_CurrencyDocument.Id, ObjectCurrencycyDocumentInf.Id)                AS CurrencyDocumentId
             , COALESCE (Object_CurrencyDocument.ValueData, ObjectCurrencycyDocumentInf.ValueData)  AS CurrencyDocumentName
             , Object_CurrencyPartner.Id             AS CurrencyPartnerId
             , Object_CurrencyPartner.ValueData      AS CurrencyPartnerName

             , MovementString_Comment.ValueData          AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                       ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()

            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                       ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId
	    
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_SaleASset();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.20         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_SaleASset (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSessiON:= zfCalc_UserAdmin())
