-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId          Integer  , -- ключ Документа
    IN inOperDate            TDateTime, -- ключ Документа
    IN inChangePercentAmount TFloat , -- Расчет по % скидки вес
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat, ChangePercentAmount TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat 
             , isCurrencyUser Boolean
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , InvNumberOrder TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , PriceListInId Integer, PriceListInName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_Order Integer
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , isCOMDOC Boolean
             , isPrinted Boolean
             , isPromo Boolean
             , isTotalSumm_GoodsReal Boolean   --Расчет суммы по схеме - Товар (факт)
             , Comment TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
             , MovementId_ReturnIn Integer, InvNumber_ReturnInFull TVarChar
             , PartionGoodsDate TDateTime
              )
AS
$BODY$
  DECLARE vbContractId      Integer;
  DECLARE vbContractName    TVarChar;
  DECLARE vbContractTagName TVarChar;
  DECLARE vbMovementId_Transport Integer;
  DECLARE vbInvNumber_Transport  TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Невозможно открыть пустой документ.';
    END IF;


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
             , CAST (FALSE AS Boolean)                      AS isCurrencyUser

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
             , CAST (0  AS INTEGER)                         AS PriceListInId
             , CAST ('' AS TVarChar) 			    AS PriceListInName
             , 0                     			    AS DocumentTaxKindId
             , CAST ('' AS TVarChar) 			    AS DocumentTaxKindName
             , 0                     			    AS MovementId_Master
             , CAST ('' AS TVarChar) 			    AS InvNumberPartner_Master
             , 0                     			    AS MovementId_Order
             , 0                                    AS MovementId_TransportGoods
             , '' :: TVarChar                     	    AS InvNumber_TransportGoods
             , inOperDate                                   AS OperDate_TransportGoods
             , 0                                        AS MovementId_Transport
             , '' :: TVarChar                           AS InvNumber_Transport
             , 0                                        AS ReestrKindId
             , '' :: TVarChar                           AS ReestrKindName
             , FALSE                                    AS isCOMDOC
             , CAST (FALSE AS Boolean)                  AS isPrinted
             , CAST (FALSE AS Boolean)                  AS isPromo   
             , CAST (FALSE AS Boolean)                  AS isTotalSumm_GoodsReal
             , CAST ('' as TVarChar)                    AS Comment

             , 0                                        AS MovementId_Production
             , CAST ('' AS TVarChar)                    AS InvNumber_ProductionFull
             , 0                                        AS MovementId_ReturnIn
             , CAST ('' AS TVarChar)                    AS InvNumber_ReturnInFull
             , inOperDate                               AS PartionGoodsDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object as Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis();
     ELSE

         -- Поиск - отдельно для скорости
         vbMovementId_Transport:= (WITH tmpMF_MovementItemId AS (SELECT MF.ValueData :: Integer AS ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId())
                                      , tmpMI_reestr AS (SELECT MI.MovementId, MI.isErased
                                                         FROM MovementItem AS MI
                                                         WHERE MI.Id = (SELECT tmpMF_MovementItemId.ValueData FROM tmpMF_MovementItemId)
                                                        )
                           , tmpMLM_Transport_reestr AS (SELECT MLM.MovementChildId
                                                         FROM MovementLinkMovement AS MLM
                                                         WHERE MLM.MovementId = (SELECT tmpMI_reestr.MovementId FROM tmpMI_reestr WHERE tmpMI_reestr.isErased = FALSE)
                                                           AND MLM.DescId     = zc_MovementLinkMovement_Transport()
                                                        )
                                  , tmpMLM_Transport AS (SELECT MLM.MovementChildId
                                                         FROM MovementLinkMovement AS MLM
                                                         WHERE MLM.MovementId = inMovementId
                                                           AND MLM.DescId     = zc_MovementLinkMovement_Transport()
                                                        )
                                   SELECT COALESCE (tmpMLM_Transport_reestr.MovementChildId, tmpMLM_Transport.MovementChildId)
                                   FROM (SELECT inMovementId AS MovementId) AS tmp
                                        LEFT JOIN tmpMLM_Transport_reestr ON 1=1
                                        LEFT JOIN tmpMLM_Transport        ON 1=1
                                  );
         --
         vbInvNumber_Transport := (SELECT '№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate)
                                       ||' ('  || Object_Car.ValueData || ' / ' || Object_PersonalDriver.ValueData || ')'
                                   FROM Movement
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                                     ON MovementLinkObject_Car.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                        LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                     ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                                    AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                                        LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
                                   WHERE Movement.Id = vbMovementId_Transport
                                  );
         --RAISE EXCEPTION 'Ошибка.<%>', vbInvNumber_Transport;
    

         -- Поиск Договора - отдельно для скорости
         SELECT View_Contract_InvNumber.ContractId    	    AS ContractId
              , View_Contract_InvNumber.InvNumber     	    AS ContractName
              , View_Contract_InvNumber.ContractTagName     AS ContractTagName
                INTO vbContractId, vbContractName, vbContractTagName
         FROM MovementLinkObject AS MovementLinkObject_Contract
             LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
         WHERE MovementLinkObject_Contract.MovementId = inMovementId
           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
           ;

         -- Результат
         RETURN QUERY
           WITH tmpMS  AS (SELECT * FROM MovementString       WHERE MovementString.MovementId       = inMovementId)
              , tmpMLO AS (SELECT * FROM MovementLinkObject   WHERE MovementLinkObject.MovementId   = inMovementId)
              , tmpMLM AS (SELECT * FROM MovementLinkMovement WHERE MovementLinkMovement.MovementId = inMovementId)
           SELECT
                 Movement.Id                                    AS Id
               , Movement.InvNumber                             AS InvNumber
               , Movement.OperDate                              AS OperDate
               , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
               , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
               , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked
               , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
               , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
               , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
               , MovementFloat_VATPercent.ValueData             AS VATPercent
               , MovementFloat_ChangePercent.ValueData          AS ChangePercent
               , inChangePercentAmount                          AS ChangePercentAmount

               , MovementFloat_CurrencyValue.ValueData          AS CurrencyValue
               , MovementFloat_ParValue.ValueData               AS ParValue
               , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
               , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue 
               , COALESCE (MovementBoolean_CurrencyUser.ValueData, FALSE) ::Boolean AS isCurrencyUser

               , Object_From.Id                    		    AS FromId
               , Object_From.ValueData             		    AS FromName
               , Object_To.Id                      		    AS ToId
               , Object_To.ValueData               		    AS ToName
               , Object_PaidKind.Id                		    AS PaidKindId
               , Object_PaidKind.ValueData         		    AS PaidKindName
               , vbContractId    	                            AS ContractId
               , vbContractName  	                            AS ContractName
               , vbContractTagName                                  AS ContractTagName
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
               , COALESCE (Object_PriceList.Id,        (SELECT tmp.PriceListId 
                                                        FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                                                                                  , inPartnerId      := MovementLinkObject_To.ObjectId
                                                                                                  , inMovementDescId := zc_Movement_Sale()
                                                                                                  , inOperDate_order := NULL :: TDateTime-- т.к. есть факт. дата
                                                                                                  , inOperDatePartner:= MovementDate_OperDatePartner.ValueData
                                                                                                  , inDayPrior_PriceReturn:= 0
                                                                                                  , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                                                                  , inOperDatePartner_order:= NULL
                                                                                                   ) AS tmp)) AS PriceListId
               , COALESCE (Object_PriceList.ValueData, (SELECT tmp.PriceListName
                                                        FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                                                                                  , inPartnerId      := MovementLinkObject_To.ObjectId
                                                                                                  , inMovementDescId := zc_Movement_Sale()
                                                                                                  , inOperDate_order := NULL :: TDateTime -- т.к. есть факт. дата
                                                                                                  , inOperDatePartner:= MovementDate_OperDatePartner.ValueData
                                                                                                  , inDayPrior_PriceReturn:= 0
                                                                                                  , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                                                                  , inOperDatePartner_order:= NULL
                                                                                                   ) AS tmp)) AS PriceListName

               , Object_PriceListIn.Id                    AS PriceListInId
               , Object_PriceListIn.ValueData :: TVarChar AS PriceListInName
               
               , Object_TaxKind.Id                		AS DocumentTaxKindId
               , Object_TaxKind.ValueData         		AS DocumentTaxKindName
               , MovementLinkMovement_Master.MovementChildId    AS MovementId_Master
               , CASE WHEN Movement_DocumentMaster.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                           THEN COALESCE (Object_StatusMaster.ValueData, '') || ' ' || MS_InvNumberPartner_Master.ValueData
                      ELSE MS_InvNumberPartner_Master.ValueData
                 END                                :: TVarChar AS InvNumberPartner_Master

               , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order

               , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
               , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
               , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) AS OperDate_TransportGoods

               , vbMovementId_Transport AS MovementId_Transport
               , vbInvNumber_Transport  AS InvNumber_Transport


               , Object_ReestrKind.Id             		    AS ReestrKindId
               , Object_ReestrKind.ValueData       		    AS ReestrKindName

               , COALESCE (MovementLinkMovement_Sale.MovementChildId, 0) <> 0 AS isCOMDOC
               , COALESCE (MovementBoolean_Print.ValueData, FALSE)            AS isPrinted
               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)            AS isPromo    
               , COALESCE (MovementBoolean_TotalSumm_GoodsReal.ValueData, FALSE) ::Boolean AS isTotalSumm_GoodsReal
               , MovementString_Comment.ValueData       AS Comment

               , COALESCE(Movement_Production.Id, -1)                         AS MovementId_Production
               , COALESCE(CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                           THEN '***'
                       WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                           THEN '*'
                       ELSE ''
                  END
               || zfCalc_PartionMovementName (Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
                 , ' ')                     :: TVarChar      AS InvNumber_ProductionFull

               , Movement_ReturnIn.Id                                                                                             AS MovementId_ReturnIn
               , ('№ ' || Movement_ReturnIn.InvNumber || ' от ' || Movement_ReturnIn.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_ReturnInFull

               , Movement.OperDate AS PartionGoodsDate
           FROM Movement
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                LEFT JOIN tmpMS AS MovementString_InvNumberOrder
                                         ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                        AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                          ON MovementBoolean_Checked.MovementId =  Movement.Id
                                         AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

                LEFT JOIN MovementBoolean AS MovementBoolean_CurrencyUser
                                          ON MovementBoolean_CurrencyUser.MovementId = Movement.Id
                                         AND MovementBoolean_CurrencyUser.DescId = zc_MovementBoolean_CurrencyUser()

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

                LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                          ON MovementBoolean_Print.MovementId =  Movement.Id
                                         AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

                LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                          ON MovementBoolean_Promo.MovementId =  Movement.Id
                                         AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

                LEFT JOIN MovementBoolean AS MovementBoolean_TotalSumm_GoodsReal
                                          ON MovementBoolean_TotalSumm_GoodsReal.MovementId =  Movement.Id
                                         AND MovementBoolean_TotalSumm_GoodsReal.DescId = zc_MovementBoolean_TotalSumm_GoodsReal()

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

                LEFT JOIN tmpMLO AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_RouteSorting
                                             ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                            AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
                LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_CurrencyPartner
                                             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
                LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                LEFT JOIN tmpMLO AS MovementLinkObject_PriceList
                                             ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                            AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_PriceListIn
                                             ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                            AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
                LEFT JOIN Object AS Object_PriceListIn ON Object_PriceListIn.Id = MovementLinkObject_PriceListIn.ObjectId

                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                               ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                              AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
                LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

                -- !!! без этого работает в 20 раз дольше!!!
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                               ON MovementLinkMovement_Transport.MovementId = NULL -- Movement.Id
                                              AND MovementLinkMovement_Transport.DescId     = zc_MovementLinkMovement_Transport()
                LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = NULL -- COALESCE (MLM_Transport_reestr.MovementChildId, MovementLinkMovement_Transport.MovementChildId)
                -- !!! без этого работает в 20 раз дольше!!!

                LEFT JOIN tmpMLO AS MovementLinkObject_ReestrKind
                                             ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                            AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
                LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

    --add Tax
                LEFT JOIN tmpMLM AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                           --AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
                LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_DocumentMaster.Id
                LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId -- Movement_DocumentMaster.Id
                                                                      AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                             ON MovementLinkObject_DocumentTaxKind.MovementId = Movement_DocumentMaster.Id -- MovementLinkMovement_Master.MovementChildId
                                            AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

               LEFT JOIN tmpMLM AS MovementLinkMovement_Sale
                                              ON MovementLinkMovement_Sale.MovementId = Movement.Id
                                             AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
               LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                                              ON MovementLinkMovement_Order.MovementId = Movement.Id
                                             AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
               LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
               LEFT JOIN MovementString AS MovementString_InvNumberPartner_Order
                                        ON MovementString_InvNumberPartner_Order.MovementId = Movement_Order.Id
                                       AND MovementString_InvNumberPartner_Order.DescId = zc_MovementString_InvNumberPartner()

               LEFT JOIN Object AS ObjectCurrencyDocumentInf ON ObjectCurrencyDocumentInf.Id = zc_Enum_Currency_Basis()

               LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                              ON MovementLinkMovement_Production.MovementChildId = Movement.Id
                                             AND MovementLinkMovement_Production.DescId          = zc_MovementLinkMovement_Production()
               LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId
               LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId

               LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ReturnIn
                                              ON MovementLinkMovement_ReturnIn.MovementId = Movement.Id
                                             AND MovementLinkMovement_ReturnIn.DescId     = zc_MovementLinkMovement_ReturnIn()
               LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MovementLinkMovement_ReturnIn.MovementChildId
              
           WHERE Movement.Id     = inMovementId
             AND Movement.DescId = zc_Movement_Sale()
             --AND COALESCE (Movement_Production.StatusId, 0) <> zc_Enum_Status_Erased()
           LIMIT 1
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.08.24         *
 15.07.24         *
 21.03.22         * 
 26.01.22         *
 04.07.18         *
 03.10.16         * add Movement_Production
 28.06.16         * add ReestrKind
 21.12.15         * add Print
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
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 40874, inOperDate:= CURRENT_DATE, inChangePercentAmount:= 1, inSession := zfCalc_UserAdmin());
