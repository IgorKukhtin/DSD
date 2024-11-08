-- Function: gpSelect_Movement_Sale()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean   ,
    IN inIsErased           Boolean   ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , PriceWithVAT Boolean
             , PaymentDate TDateTime
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat, TotalCountSh TFloat, TotalCountKg TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSummChange TFloat, TotalSumm TFloat, TotalSummCurrency TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat 
             , isCurrencyUser Boolean
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalName_To TVarChar, OKPO_To TVarChar, RetailName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteGroupName TVarChar, RouteName TVarChar, PersonalName TVarChar
             , RetailName_order TVarChar
             , PartnerName_order TVarChar
             , PriceListName TVarChar
             , PriceListInName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , OperDate_TransportGoods_calc TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar, PersonalDriverName_TTN TVarChar, PersonalName_4_TTN TVarChar
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , isEdiOrdspr_partner Boolean, isEdiInvoice_partner Boolean, isEdiDesadv_partner Boolean
             , isError Boolean
             , isPrinted Boolean
             , isPromo Boolean
             , isPav Boolean 
             , isTotalSumm_GoodsReal Boolean  --Расчет суммы по схеме - Товар (факт)
             , MovementPromo TVarChar
             , InsertDate TDateTime
             , InsertDate_order TDateTime
             , InsertDatediff_min TFloat
             , Comment TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
             , MovementId_ReturnIn Integer, InvNumber_ReturnInFull TVarChar
             , PersonalSigningName TVarChar
             , PersonalCode_Collation Integer
             , PersonalName_Collation TVarChar
             , UnitName_Collation TVarChar
             , BranchName_Collation TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

      -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     IF 1=1
     THEN
          -- Результат
          RETURN QUERY
          SELECT * FROM gpSelect_Movement_Sale_DATA (inStartDate        := inStartDate
                                                   , inEndDate          := inEndDate
                                                   , inIsPartnerDate    := inIsPartnerDate
                                                   , inIsErased         := inIsErased
                                                   , inJuridicalBasisId := inJuridicalBasisId
                                                   , inUserId           := vbUserId
                                                    );
     ELSE


     -- !!!т.к. нельзя когда много данных в гриде!!!
     IF inStartDate + (INTERVAL '100 DAY') <= inEndDate
     THEN
         inStartDate:= inEndDate + (INTERVAL '1 DAY');
     END IF;

     -- 
     vbText:= (SELECT STRING_AGG (tmp.RetV, ' UNION ALL ')
               FROM (SELECT 'SELECT * FROM gpSelect_Movement_Sale_DATA (inStartDate        := ' || CHR(39) || (inStartDate :: TDateTime + (tmpList.Ord :: TVarChar || ' DAY') :: INTERVAL) || CHR(39)
                                                                 || ' , inEndDate          := ' || CHR(39) || (inStartDate :: TDateTime + (tmpList.Ord :: TVarChar || ' DAY') :: INTERVAL) || CHR(39)
                                                                 || ' , inIsPartnerDate    := ' || inIsPartnerDate    :: TVarChar
                                                                 || ' , inIsErased         := ' || inIsErased         :: TVarChar
                                                                 || ' , inJuridicalBasisId := ' || inJuridicalBasisId :: TVarChar
                                                                 || ' , inUserId           := ' || vbUserId           :: TVarChar
                                                                 || '  )' AS RetV
                     FROM (SELECT GENERATE_SERIES (0, EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (inEndDate) - zfConvert_DateTimeWithOutTZ (inStartDate))) :: Integer) AS Ord) AS tmpList
                    ) AS tmp);
     

     --
     IF vbText <> ''
     THEN

         -- Результат
         RETURN QUERY
         EXECUTE vbText;
         
     ELSE
         -- Результат
         RETURN;

     END IF;
     END IF;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.07.24         *
 24.10.17         * add Movement_Transport_Reestr
 05.10.16         * add inJuridicalBasisId
 21.12.15         * add isPrinted
 25.11.15         * add Promo
 13.11.14                                        * add zc_Enum_Process_AccessKey_DocumentAll
 21.08.14                                        * add RouteName
 12.08.14                                        * add isEDI
 24.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 29.05.14                        * add isCOMDOC
 17.05.14                                        * add MS_InvNumberPartner_Master - всегда
 03.05.14                                        * add ContractTagName
 24.04.14                                        * ... Movement_DocumentMaster.Id
 12.04.14                                        * add CASE WHEN ...StatusId = zc_Enum_Status_Erased()
 31.03.14                                        * add TotalCount...
 28.03.14                                        * add TotalSummVAT
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 20.03.14                                        * add InvNumberPartner
 16.03.14                                        * add JuridicalName_To and OKPO_To
 13.02.14                                                        * add DocumentChild, DocumentTaxKind
 10.02.14                                        * add Object_RoleAccessKey_View
 05.02.14                                        * add Object_InfoMoney_View
 30.01.14                                                       * add inIsPartnerDate, inIsErased
 14.01.14                                        * add Object_Contract_InvNumber_View
 11.01.14                                        * add Checked, InvNumberOrder
 13.08.13                                        * add TotalCountPartner
 13.07.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale (inStartDate:= '01.03.2022', inEndDate:= '01.03.2022', inIsPartnerDate:= FALSE, inIsErased:= TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
