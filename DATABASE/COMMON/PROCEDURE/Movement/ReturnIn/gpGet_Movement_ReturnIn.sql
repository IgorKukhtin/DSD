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
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , JuridicalId_From Integer, JuridicalName_From TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , PriceListInId Integer, PriceListInName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , StartDateTax TDateTime
             , MovementId_Partion Integer, PartionMovementName TVarChar
             , MemberId Integer, MemberName TVarChar, MemberInsertName TVarChar
             , MemberExpId Integer, MemberExpName TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , ReasonId Integer, ReasonName  TVarChar
             , Comment TVarChar
             , isPromo Boolean
             , isList Boolean
             , isPrinted Boolean
             , isWeighing_inf Boolean  
             , MovementId_OrderReturnTare Integer
             , InvNumber_OrderReturnTare  TVarChar 
             
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
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
             , inOperDate                               AS OperDatePartner
             , CAST (False as Boolean)                  AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                       AS ChangePercent
             , CAST (0 as TFloat)                       AS TotalCount
             , CAST (0 as TFloat)                       AS TotalSummMVAT
             , CAST (0 as TFloat)                       AS TotalSummPVAT
             , CAST (0 as TFloat)                       AS TotalSumm
             , CAST (0 as TFloat)                       AS CurrencyPartnerValue
             , CAST (0 as TFloat)                       AS ParPartnerValue
             , 0                                        AS FromId
             , CAST ('' as TVarChar)                    AS FromName
             , Object_To.Id                             AS ToId
             , Object_To.ValueData                      AS ToName
             , 0                                        AS PaidKindId
             , CAST ('' as TVarChar)                    AS PaidKindName
             , 0                                        AS ContractId
             , CAST ('' as TVarChar)                    AS ContractName
             , CAST ('' AS TVarChar)                    AS ContractTagName
             , ObjectCurrency.Id                        AS CurrencyDocumentId	-- грн
             , ObjectCurrency.ValueData                 AS CurrencyDocumentName
             , 0                                        AS CurrencyPartnerId
             , CAST ('' as TVarChar)                    AS CurrencyPartnerName

             , 0                                        AS JuridicalId_From
             , CAST ('' as TVarChar)                    AS JuridicalName_From

             , Object_PriceList.Id                      AS PriceListId
             , Object_PriceList.ValueData               AS PriceListName
             , CAST (0  AS INTEGER)                     AS PriceListInId
             , CAST ('' AS TVarChar)                    AS PriceListInName
             , 0                                        AS DocumentTaxKindId
             , CAST ('' as TVarChar)                    AS DocumentTaxKindName
             , (DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '4 MONTH') :: TDateTime AS StartDateTax
             , 0                                        AS MovementId_Partion
             , CAST ('' as TVarChar)                    AS PartionMovementName
             , 0                                        AS MemberId
             , CAST ('' AS TVarChar)                    AS MemberName
             , CAST ('' AS TVarChar)                    AS MemberInsertName

             , 0                                        AS MemberExpId
             , CAST ('' AS TVarChar)                    AS MemberExpName

             , 0                   	                    AS ReestrKindId
             , CAST ('' AS TVarChar)                    AS ReestrKindName 

             , 0                   	                    AS SubjectDocId
             , CAST ('' AS TVarChar)                    AS SubjectDocName

             , 0                                        AS ReasonId
             , CAST ('' AS TVarChar)                    AS ReasonName 

             , CAST ('' as TVarChar)                    AS Comment
             , CAST (FALSE AS Boolean)                  AS isPromo 
             , CAST (FALSE AS Boolean)                  AS isList
             , CAST (FALSE AS Boolean)                  AS isPrinted
             , CAST (FALSE AS Boolean)                  AS isWeighing_inf  
             ,  0                                       AS MovementId_OrderReturnTare
             , '' :: TVarChar                           AS InvNumber_OrderReturnTare

             , 0                   			            AS MovementId_TransportGoods
             , '' :: TVarChar                           AS InvNumber_TransportGoods
             , inOperDate                               AS OperDate_TransportGoods

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
               LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN 0 = COALESCE ((SELECT BranchId FROM tmpBranch), 0)
                                                                         THEN 8461 -- !!!Склад Возвратов!!!

                                                                    WHEN 8374 = COALESCE ((SELECT BranchId FROM tmpBranch), 0) -- филиал Одесса
                                                                         THEN 346094 -- !!!Склад возвратов ф.Одесса!!!

                                                                    WHEN 301310 = (SELECT BranchId FROM tmpBranch) -- филиал Запорожье
                                                                       --THEN 309599 -- !!!Склад возвратов ф.Запорожье!!!
                                                                         THEN 8461 -- !!!Склад Возвратов!!!

                                                                    WHEN 8377 = (SELECT BranchId FROM tmpBranch) -- филиал Кр.Рог
                                                                         THEN 428366 -- Склад возвратов ф.Кривой Рог

                                                                    WHEN 8373 = (SELECT BranchId FROM tmpBranch) -- филиал Николаев (Херсон)
                                                                         THEN 428364 -- Склад возвратов ф.Николаев (Херсон)

                                                                    WHEN 8381 = (SELECT BranchId FROM tmpBranch) -- филиал Харьков
                                                                         THEN 409007 -- Склад возвратов ф.Харьков

                                                                    WHEN 8375 = (SELECT BranchId FROM tmpBranch) -- филиал Черкассы (Кировоград)
                                                                         THEN 428363 -- Склад возвратов ф.Черкассы (Кировоград)

                                                                    WHEN 8379  = (SELECT BranchId FROM tmpBranch) -- филиал Киев
                                                                         THEN 428365 -- Склад возвратов ф.Киев

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
          , tmpPriceList AS (SELECT Object_PriceList.Id AS PriceListId, Object_PriceList.ValueData AS PriceListName
                             FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                                       , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                                       , inMovementDescId := zc_Movement_ReturnIn()
                                                                       , inOperDate_order := NULL
                                                                       , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                       , inDayPrior_PriceReturn:= 0
                                                                       , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                                       , inOperDatePartner_order:= NULL
                                                           ) AS tmp
                                  LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmp.PriceListId
                             LIMIT 1
                            )
        -- взвешивание контрагент
        , tmpWeighingPartner AS (SELECT DISTINCT Movement.ParentId
                                 FROM Movement
                                 WHERE Movement.ParentId = inMovementId
                                   AND Movement.DescId = zc_Movement_WeighingPartner()
                                )


       SELECT
             Movement.Id
           , Movement.InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
           , Movement.OperDate
        -- , Movement.ParentId AS ParentId
        -- , (Movement_Parent.InvNumber || ' от ' || Movement_Parent.OperDate :: Date :: TVarChar ) :: TVarChar AS InvNumber_Parent
           , COALESCE (Movement.ParentId, 0) :: Integer AS ParentId
           , COALESCE ((Movement_Parent.InvNumber || ' от ' || Movement_Parent.OperDate :: Date :: TVarChar ), '') :: TVarChar AS InvNumber_Parent
           , Movement.StatusId
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
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
           , MovementFloat_CurrencyPartnerValue.ValueData  AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData       AS ParPartnerValue
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

           , Object_JuridicalFrom.id             AS JuridicalId_From
           , Object_JuridicalFrom.ValueData      AS JuridicalName_From

           , (SELECT tmpPriceList.PriceListId   FROM tmpPriceList) AS PriceListId
           , (SELECT tmpPriceList.PriceListName FROM tmpPriceList) AS PriceListName

           , Object_PriceListIn.Id                    AS PriceListInId
           , Object_PriceListIn.ValueData :: TVarChar AS PriceListInName

           , Object_TaxKind.Id                	    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         	    AS DocumentTaxKindName

           , (DATE_TRUNC ('MONTH', MovementDate_OperDatePartner.ValueData) - INTERVAL '4 MONTH') :: TDateTime AS StartDateTax

           , tmpMI.MovementId                       AS MovementId_Partion
           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

           , Object_Member.Id                       AS MemberId
           , Object_Member.ValueData                AS MemberName
           , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_MemberInsert.ValueData ELSE '' END :: TVarChar AS MemberInsertName
           , Object_MemberExp.Id                    AS MemberExpId
           , Object_MemberExp.ValueData             AS MemberExpName

           , Object_ReestrKind.Id             	    AS ReestrKindId
           , Object_ReestrKind.ValueData       	    AS ReestrKindName

           , Object_SubjectDoc.Id                   AS SubjectDocId
           , Object_SubjectDoc.ValueData            AS SubjectDocName

           , 0                   		    AS ReasonId
           , CAST ('' AS TVarChar)                  AS ReasonName 

           , MovementString_Comment.ValueData       AS Comment

           , COALESCE (MovementBoolean_Promo.ValueData, FALSE):: Boolean AS isPromo
           , COALESCE (MovementBoolean_List.ValueData, FALSE) :: Boolean AS isList
           , COALESCE (MovementBoolean_Print.ValueData, False):: Boolean AS isPrinted
           , CASE WHEN tmpWeighingPartner.ParentId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isWeighing_inf

           , Movement_OrderReturnTare.Id                                                                                                    AS MovementId_OrderReturnTare
           , ('№ ' || Movement_OrderReturnTare.InvNumber || ' от ' || Movement_OrderReturnTare.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_OrderReturnTare

           , Movement_TransportGoods.Id             AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber      AS InvNumber_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) AS OperDate_TransportGoods

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

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId =  Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

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
            
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId =  Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberExp
                                         ON MovementLinkObject_MemberExp.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberExp.DescId = zc_MovementLinkObject_MemberExp()
            LEFT JOIN Object AS Object_MemberExp ON Object_MemberExp.Id = MovementLinkObject_MemberExp.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceListIn
                                         ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
            LEFT JOIN Object AS Object_PriceListIn ON Object_PriceListIn.Id = MovementLinkObject_PriceListIn.ObjectId

--add Tax
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN Object as ObjectCurrencycyDocumentInf 
                             on ObjectCurrencycyDocumentInf.descid= zc_Object_Currency()
                            AND ObjectCurrencycyDocumentInf.id = 14461
--
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId = Movement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_MemberInsert ON Object_MemberInsert.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmpWeighingPartner ON tmpWeighingPartner.ParentId = Movement.Id

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_OrderReturnTare
                                           ON MovementLinkMovement_OrderReturnTare.MovementId = Movement.Id
                                          AND MovementLinkMovement_OrderReturnTare.DescId = zc_MovementLinkMovement_OrderReturnTare()
            LEFT JOIN Movement AS Movement_OrderReturnTare ON Movement_OrderReturnTare.Id = MovementLinkMovement_OrderReturnTare.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId
 
         WHERE Movement.Id     =  inMovementId
           AND Movement.DescId = zc_Movement_ReturnIn();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Манько Д.А.
 16.02.23         * TransportGoods
 14.03.22         *
 12.05.18         *
 14.05.16         *
 10.05.16         * add StartDateTax
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
