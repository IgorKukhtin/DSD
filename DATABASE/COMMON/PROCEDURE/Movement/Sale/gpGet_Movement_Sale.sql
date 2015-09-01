-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inChangePercentAmount TFloat , -- Расчет по % скидки вес
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat, ChangePercentAmount TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , InvNumberOrder TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_Order Integer
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar
             , isCOMDOC Boolean
             , Comment TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
             , inOperDate				    AS OperDate
             , Object_Status.Code               	    AS StatusCode
             , Object_Status.Name              		    AS StatusName
             , CAST (FALSE AS Boolean)         		    AS Checked
             , inOperDate			     	    AS OperDatePartner
             , CAST ('' AS TVarChar)                        AS InvNumberPartner
             , CAST (False AS Boolean)                      AS PriceWithVAT
             , CAST (20 AS TFloat)                          AS VATPercent
             , CAST (0 AS TFloat)                           AS ChangePercent
             , inChangePercentAmount                        AS ChangePercentAmount

             , CAST (0 as TFloat)                           AS CurrencyValue
             , CAST (0 as TFloat)                           AS ParValue
             , CAST (0 as TFloat)                           AS CurrencyPartnerValue
             , CAST (0 as TFloat)                           AS ParPartnerValue

             , 0                     		            AS FromId
             , CAST ('' AS TVarChar)                        AS FromName
             , 0                     			    AS ToId
             , CAST ('' AS TVarChar) 			    AS ToName
             , 0                     			    AS PaidKindId
             , CAST ('' AS TVarChar) 			    AS PaidKindName
             , 0                     			    AS ContractId
             , CAST ('' AS TVarChar) 			    AS ContractName
             , CAST ('' AS TVarChar) 			    AS ContractTagName
             , 0                     			    AS RouteSortingId
             , CAST ('' AS TVarChar) 			    AS RouteSortingName
             , Object_Currency.Id                           AS CurrencyDocumentId
             , Object_Currency.ValueData                    AS CurrencyDocumentName
             , Object_Currency.Id                           AS CurrencyPartnerId
             , Object_Currency.ValueData                    AS CurrencyPartnerName
             , CAST ('' AS TVarChar) 			    AS InvNumberOrder
             , CAST (0  AS INTEGER)                         AS PriceListId
             , CAST ('' AS TVarChar) 			    AS PriceListName
             , 0                     			    AS DocumentTaxKindId
             , CAST ('' AS TVarChar) 			    AS DocumentTaxKindName
             , 0                     			    AS MovementId_Master
             , CAST ('' AS TVarChar) 			    AS InvNumberPartner_Master
             , 0                     			    AS MovementId_Order
             , 0                   			    AS MovementId_TransportGoods 
             , '' :: TVarChar                     	    AS InvNumber_TransportGoods 
             , inOperDate                                   AS OperDate_TransportGoods
             , 0                   			    AS MovementId_Transport
             , '' :: TVarChar                     	    AS InvNumber_Transport 
             , FALSE                                        AS isCOMDOC
             , CAST ('' as TVarChar) 		            AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object as Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis();
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode    		    AS StatusCode
           , Object_Status.ValueData     		    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , inChangePercentAmount                          AS ChangePercentAmount

           , MovementFloat_CurrencyValue.ValueData          AS CurrencyValue
           , MovementFloat_ParValue.ValueData               AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue

           , Object_From.Id                    		    AS FromId
           , Object_From.ValueData             		    AS FromName
           , Object_To.Id                      		    AS ToId
           , Object_To.ValueData               		    AS ToName
           , Object_PaidKind.Id                		    AS PaidKindId
           , Object_PaidKind.ValueData         		    AS PaidKindName
           , View_Contract_InvNumber.ContractId    	    AS ContractId
           , View_Contract_InvNumber.InvNumber     	    AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , Object_RouteSorting.Id        		    AS RouteSortingId
           , Object_RouteSorting.ValueData 		    AS RouteSortingName
           , COALESCE (Object_CurrencyDocument.Id, ObjectCurrencyDocumentInf.Id)                AS CurrencyDocumentId
           , COALESCE (Object_CurrencyDocument.ValueData, ObjectCurrencyDocumentInf.ValueData)  AS CurrencyDocumentName
           , Object_CurrencyPartner.Id                      AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData               AS CurrencyPartnerName
           , CASE WHEN TRIM (COALESCE (MovementString_InvNumberOrder.ValueData, '')) <> ''
                       THEN MovementString_InvNumberOrder.ValueData
                  WHEN MovementLinkMovement_Order.MovementChildId IS NOT NULL
                       THEN CASE WHEN Movement_Order.StatusId IN (zc_Enum_Status_Complete())
                                      THEN ''
                                 ELSE '???'
                            END
                         || CASE WHEN TRIM (COALESCE (MovementString_InvNumberPartner_Order.ValueData, '')) <> ''
                                      THEN MovementString_InvNumberPartner_Order.ValueData
                                 ELSE '***' || Movement_Order.InvNumber
                            END
             END :: TVarChar AS InvNumberOrder
           , COALESCE (Object_PriceList.Id,        (SELECT tmp.PriceListId   FROM lfGet_Object_Partner_PriceList (inContractId:= MovementLinkObject_Contract.ObjectId, inPartnerId:= MovementLinkObject_To.ObjectId, inOperDate:= MovementDate_OperDatePartner.ValueData) AS tmp)) AS PriceListId
           , COALESCE (Object_PriceList.ValueData, (SELECT tmp.PriceListName FROM lfGet_Object_Partner_PriceList (inContractId:= MovementLinkObject_Contract.ObjectId, inPartnerId:= MovementLinkObject_To.ObjectId, inOperDate:= MovementDate_OperDatePartner.ValueData) AS tmp)) AS PriceListName
           , Object_TaxKind.Id                		    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         		    AS DocumentTaxKindName
           , MovementLinkMovement_Master.MovementChildId    AS MovementId_Master
           , MS_InvNumberPartner_Master.ValueData           AS InvNumberPartner_Master
           , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) AS OperDate_TransportGoods

           , Movement_Transport.Id                     AS MovementId_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar AS InvNumber_Transport

           , COALESCE (MovementLinkMovement_Sale.MovementChildId, 0) <> 0 AS isCOMDOC
           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

--add Tax
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                         AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId -- Movement_DocumentMaster.Id
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement_DocumentMaster.Id -- MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                        ON MovementLinkMovement_Sale.MovementId = Movement.Id 
                                       AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                        ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                       AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
         LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
         LEFT JOIN MovementString AS MovementString_InvNumberPartner_Order
                                  ON MovementString_InvNumberPartner_Order.MovementId =  Movement_Order.Id
                                 AND MovementString_InvNumberPartner_Order.DescId = zc_MovementString_InvNumberPartner()

         LEFT JOIN Object AS ObjectCurrencyDocumentInf ON ObjectCurrencyDocumentInf.Id = zc_Enum_Currency_Basis()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Sale();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TFloat, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.06.15         * add inChangePercentAmount
 24.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 29.05.14                        * add isCOMDOC 
 17.05.14                                        * add Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 13.02.14                                                        * add DocumentChild, DocumentTaxKind
 31.01.14                                                        * add PriceList
 30.01.14                                                        * add inInvNumberPartner
 29.01.14                                                        * fix ContractName if empty
 16.01.14                                                        * MovementBoolean_Checked
 29.07.13         * add zc_MovementLinkObject_Personal
 14.07.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 1, inOperDate:=CURRENT_DATE,inSession:= '2')
-- SELECT * FROM gpGet_Movement_Sale(inMovementId := 40859 , inOperDate := '25.01.2014',  inSession := '5');
 --SELECT * FROM gpGet_Movement_Sale(inMovementId := 40874 , inOperDate := '25.01.2014',  inSession := '5');