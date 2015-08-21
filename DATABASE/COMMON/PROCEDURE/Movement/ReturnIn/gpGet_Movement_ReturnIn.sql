-- Function: gpGet_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, InvNumberMark TVarChar, OperDate TDateTime
             , ParentId Integer, InvNumber_Parent TVarChar
             , StatusId Integer, StatusCode Integer, StatusName TVarChar, Checked Boolean
             , isPartner Boolean
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , CurrencyValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Partion Integer, PartionMovementName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         WITH tmpBranch AS (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_returnin_seq') AS TVarChar) AS InvNumber
             , '' :: TVarChar                           AS InvNumberPartner
             , '' :: TVarChar                           AS InvNumberMark
             , inOperDate				AS OperDate
             , 0                                        AS ParentId
             , '' :: TVarChar                           AS InvNumber_Parent
             , zc_Enum_Status_UnComplete()              AS StatusId
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , FALSE :: Boolean                         AS Checked
             , FALSE :: Boolean                         AS isPartner
             , inOperDate				AS OperDatePartner
             , CAST (False as Boolean)                  AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                       AS ChangePercent
             , CAST (0 as TFloat)                       AS TotalCount
             , CAST (0 as TFloat)                       AS TotalSummMVAT
             , CAST (0 as TFloat)                       AS TotalSummPVAT
             , CAST (0 as TFloat)                       AS TotalSumm
             , CAST (0 as TFloat)                       AS CurrencyValue
             , 0                     	                AS FromId
             , CAST ('' as TVarChar) 	                AS FromName
             , Object_To.Id                             AS ToId
             , Object_To.ValueData                      AS ToName
             , 0                     		        AS PaidKindId
             , CAST ('' as TVarChar)		        AS PaidKindName
             , 0                     		        AS ContractId
             , CAST ('' as TVarChar) 	                AS ContractName
             , CAST ('' AS TVarChar) 			AS ContractTagName
             , ObjectCurrency.Id                        AS CurrencyDocumentId	-- грн
             , ObjectCurrency.ValueData                 AS CurrencyDocumentName
             , 0                                        AS CurrencyPartnerId
             , CAST ('' as TVarChar)                    AS CurrencyPartnerName
             , Object_PriceList.Id                      AS PriceListId
             , Object_PriceList.ValueData               AS PriceListName
             , 0                     		        AS DocumentTaxKindId
             , CAST ('' as TVarChar) 		        AS DocumentTaxKindName
             , 0                     		        AS MovementId_Partion
             , CAST ('' as TVarChar) 		        AS PartionMovementName
             , CAST ('' as TVarChar) 		        AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
               LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN 0 = COALESCE ((SELECT BranchId FROM tmpBranch), 0)
                                                                         THEN 8461 -- !!!Склад Возвратов!!!
                                                                    WHEN 8374 = COALESCE ((SELECT BranchId FROM tmpBranch), 0) -- филиал Одесса
                                                                         THEN 346094 -- !!!Склад возвратов ф.Одесса!!!
                                                                    WHEN 301310 = (SELECT BranchId FROM tmpBranch) -- филиал Запорожье
                                                                         THEN 309599 -- !!!Склад возвратов ф.Запорожье!!!
                                                                    ELSE 0
                                                               END
               LEFT JOIN Object AS ObjectCurrency ON ObjectCurrency.descid= zc_Object_Currency()
                                                 AND ObjectCurrency.id = 14461 -- грн
         ;
     ELSE

     RETURN QUERY
       WITH tmpMI AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId
                      FROM MovementItem
                           INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                                       AND MIFloat_MovementId.ValueData > 0
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      ORDER BY MovementItem.Id DESC
                      LIMIT 1
                     )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
           , MovementString_InvNumberMark.ValueData AS InvNumberMark
           , Movement.OperDate
           , Movement.ParentId                          AS ParentId
           , (Movement_Parent.InvNumber || ' от ' || Movement_Parent.OperDate :: Date :: TVarChar ) :: TVarChar AS InvNumber_Parent
           , Movement.StatusId
           , Object_Status.ObjectCode          	    AS StatusCode
           , Object_Status.ValueData         	    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean   AS Checked
           , COALESCE (MovementBoolean_isPartner.ValueData, FALSE) :: Boolean AS isPartner
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , MovementFloat_CurrencyValue.ValueData  AS CurrencyValue
           , Object_From.Id                    	    AS FromId
           , Object_From.ValueData             	    AS FromName
           , Object_To.Id                      	    AS ToId
           , Object_To.ValueData               	    AS ToName
           , Object_PaidKind.Id                	    AS PaidKindId
           , Object_PaidKind.ValueData         	    AS PaidKindName
           , View_Contract_InvNumber.ContractId     AS ContractId
           , View_Contract_InvNumber.InvNumber      AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , COALESCE (Object_CurrencyDocument.Id, ObjectCurrencycyDocumentInf.Id)                AS CurrencyDocumentId
           , COALESCE (Object_CurrencyDocument.ValueData, ObjectCurrencycyDocumentInf.ValueData)  AS CurrencyDocumentName
           , Object_CurrencyPartner.Id              AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData       AS CurrencyPartnerName
           , (SELECT tmp.PriceListId   FROM lfGet_Object_Partner_PriceList (inContractId:= MovementLinkObject_Contract.ObjectId, inPartnerId:= MovementLinkObject_From.ObjectId, inOperDate:= MovementDate_OperDatePartner.ValueData) AS tmp) AS PriceListId
           , (SELECT tmp.PriceListName FROM lfGet_Object_Partner_PriceList (inContractId:= MovementLinkObject_Contract.ObjectId, inPartnerId:= MovementLinkObject_From.ObjectId, inOperDate:= MovementDate_OperDatePartner.ValueData) AS tmp) AS PriceListName

           , Object_TaxKind.Id                	    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         	    AS DocumentTaxKindName

           , tmpMI.MovementId                       AS MovementId_Partion
           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName
           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN tmpMI ON 1 = 1
            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = tmpMI.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                   ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                  AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.id = Movement.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
           
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                      ON MovementBoolean_isPartner.MovementId =  Movement.Id
                                     AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

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
            
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

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


--add Tax
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

         LEFT JOIN Object as ObjectCurrencycyDocumentInf 
                          on ObjectCurrencycyDocumentInf.descid= zc_Object_Currency()
                         AND ObjectCurrencycyDocumentInf.id = 14461

         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ReturnIn();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Манько Д.А.
 21.08.15         * add isPartner
 26.06.15         * add Comment, Parent
 24.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 23.04.14                                        * add InvNumberMark
 02.04.14                         * add InvNumberPartner
 13.02.14                                                            * add PriceList
 10.02.14                                                            * add TaxKind
 09.02.14                                        * add Object_Contract_InvNumber_View
 27.01.14                                                          * -Car -Driver +Checked +id=0
 17.07.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReturnIn (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
