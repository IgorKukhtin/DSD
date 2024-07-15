-- FunctiON: gpGet_Movement_IncomeASset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeASset (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeASset(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSessiON           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , isCurrencyUser Boolean
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, ToParentId Integer
             , PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , Comment TVarChar 
             , MovementId_Transport Integer, InvNumber_Transport TVarChar
             , InvoiceId Integer, InvoiceName TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSessiON, zc_Enum_Process_Get_Movement_IncomeASset());
     vbUserId:= lpGetUserBySessiON (inSessiON);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_IncomeASset_seq') AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , inOperDate                       AS OperDatePartner
             , CAST ('' AS TVarChar)            AS InvNumberPartner

             , CAST (False AS Boolean)          AS PriceWithVAT
             , CAST (20 AS TFloat)              AS VATPercent
             , CAST (0 AS TFloat)               AS ChangePercent
             
             , CAST (1 AS TFloat)               AS CurrencyValue
             , CAST (1 AS TFloat)               AS ParValue 
             , CAST (False as Boolean)          AS isCurrencyUser

             , 0                     AS FromId
             , CAST ('' AS TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' AS TVarChar) AS ToName
             , 0                     AS ToParentId
             , 0                     AS PaidKindId
             , CAST ('' AS TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' AS TVarChar) AS ContractName

            -- , ObjectCurrency.Id         AS CurrencyDocumentId	-- грн
            -- , ObjectCurrency.ValueData  AS CurrencyDocumentName
            --валюта подставляется из счета
             , 0                     AS CurrencyDocumentId
             , CAST ('' AS TVarChar) AS CurrencyDocumentName

             , 0                     AS CurrencyPartnerId
             , CAST ('' AS TVarChar) AS CurrencyPartnerName

             , CAST ('' AS TVarChar) 		    AS Comment

             , 0                                    AS MovementId_Transport
             , '' :: TVarChar                       AS InvNumber_Transport 

             , 0                                    AS InvoiceId
             , CAST ('' AS TVarChar) 	            AS InvoiceName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            /*  JOIN Object AS ObjectCurrency ON ObjectCurrency.descid= zc_Object_Currency()
                                            AND ObjectCurrency.id = 14461	             -- грн
            */
          ;
     ELSE
       RETURN QUERY 
       
       WITH 
            -- определение док. счета из строчной части
            tmpMI AS (SELECT MI_Invoice.MovementId AS MovementId
                      FROM MovementItem
                           INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementItemId()
                                                       AND MIFloat_MovementId.ValueData      > 0
                           INNER JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id       = MIFloat_MovementId.ValueData :: Integer
                                                                AND MI_Invoice.isErased = FALSE
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_MASter()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     > 0
                      ORDER BY MovementItem.Id DESC
                      LIMIT 1
                     )
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

             , MovementFloat_CurrencyValue.ValueData       AS CurrencyValue
             , COALESCE (MovementFloat_ParValue.ValueData, 1) :: TFloat  AS ParValue
             , COALESCE (MovementBoolean_CurrencyUser.ValueData, FALSE) ::Boolean AS isCurrencyUser

             , Object_From.Id                        AS FromId
             , Object_From.ValueData                 AS FromName
             , Object_To.Id                          AS ToId
             , Object_To.ValueData                   AS ToName
             , ObjectLink_Unit_Parent.ChildObjectId  AS ToParentId
             , Object_PaidKind.Id                    AS PaidKindId
             , Object_PaidKind.ValueData             AS PaidKindName
             , View_Contract_InvNumber.ContractId    AS ContractId
             , View_Contract_InvNumber.InvNumber     AS ContractName

             , COALESCE (Object_CurrencyDocument.Id, ObjectCurrencycyDocumentInf.Id)                AS CurrencyDocumentId
             , COALESCE (Object_CurrencyDocument.ValueData, ObjectCurrencycyDocumentInf.ValueData)  AS CurrencyDocumentName
             , Object_CurrencyPartner.Id             AS CurrencyPartnerId
             , Object_CurrencyPartner.ValueData      AS CurrencyPartnerName

             , MovementString_Comment.ValueData          AS Comment

             , Movement_Transport.Id                     AS MovementId_Transport
             , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar AS InvNumber_Transport

             , tmpMI.MovementId                          AS InvoiceId
             , zfCalc_PartiONMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvoiceName

       FROM Movement
            LEFT JOIN tmpMI ON 1 = 1
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = tmpMI.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
           
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementBoolean AS MovementBoolean_CurrencyUser
                                      ON MovementBoolean_CurrencyUser.MovementId = Movement.Id
                                     AND MovementBoolean_CurrencyUser.DescId = zc_MovementBoolean_CurrencyUser()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent 
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_To.Id 
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

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
	    
            LEFT JOIN Object AS ObjectCurrencycyDocumentInf 
                             ON ObjectCurrencycyDocumentInf.descid= zc_Object_Currency()
                            AND ObjectCurrencycyDocumentInf.id = 14461

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_IncomeASset();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.07.24         * isCurrencyUser
 06.10.16         * parce
 25.07.16         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomeASset (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSessiON:= zfCalc_UserAdmin())
