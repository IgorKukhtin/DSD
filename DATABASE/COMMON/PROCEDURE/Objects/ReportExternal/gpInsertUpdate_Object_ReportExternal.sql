-- Function: gpInsertUpdate_Object_ReportExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportExternal(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportExternal(
 INOUT ioId          Integer  ,    -- ид
    IN inName        TVarChar ,    -- Название функции (отчета)
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
DECLARE 
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());


     -- на всякий случай - найдем
     IF COALESCE (ioId, 0) = 0
     THEN 
         -- проверка - свойство должно быть установлено
         IF TRIM (COALESCE (inName, '')) = '' THEN
            RAISE EXCEPTION 'Ошибка.Не установлено значение <Name>.';
         END IF;
         -- поиск
         ioId:= (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_ReportExternal());
         -- если не нашли
         IF COALESCE (ioId, 0) = 0
         THEN 
             -- найдем первый - среди пустых
             ioId:= (SELECT MIN (Id) FROM Object WHERE TRIM (COALESCE (ValueData, '')) = '' AND DescId = zc_Object_ReportExternal());
         END IF;
     END IF;
     
     -- проверка уникальности для свойства <Название>
     IF TRIM (inName) <> '' THEN
       PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReportExternal(), inName);
     END IF;

     -- сохранили <Объект>
     ioId:= lpInsertUpdate_Object (ioId, zc_Object_ReportExternal(), CASE WHEN COALESCE (ioId, 0) = 0 THEN lfGet_ObjectCode (0, zc_Object_ReportExternal()) ELSE (SELECT ObjectCode FROM Object WHERE Id = ioId) END, inName);

     -- Ведение протокола
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*  
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.04.17                                                        *
*/

-- тест
-- UPDATE Object SET ValueData = '' WHERE DescId = zc_Object_ReportExternal() AND ValueData ilike 'gpReport_GoodsBalance';
-- SELECT * FROM Object WHERE DescId = zc_Object_ReportExternal() AND ValueData ilike 'gpSelectMobile_Object_GoodsListSale' ORDER BY Id DESC;
-- SELECT *, gpInsertUpdate_Object_ReportExternal (ioId:= Id, inName:= '', inSession:= zfCalc_UserAdmin()) FROM Object WHERE DescId = zc_Object_ReportExternal() AND Id = 0 ORDER BY Id;
--
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Account',                      inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_AccountExternal',              inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Account_Print',                inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Balance',                      inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ProfitLoss',                   inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ProfitLoss_grid',              inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Report_Wage',                  inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_SaleReturnIn',         inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_SaleReturnInUnit',     inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_SaleReturnInUnitNew',  inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_SaleReturnIn_BUH',     inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_SaleReturnIn_PaidKind',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_byMovement',           inSession:= zfCalc_UserAdmin()); -- ----
--
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Goods',                        inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsGroup',                   inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_SendOnPrice',          inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_Internal',             inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI',                      inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_IncomeByPartner',      inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_Production',           inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_Inventory',            inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Check_ReturnInToSale',         inSession:= zfCalc_UserAdmin()); -- +
--
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Branch_App1',           inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Branch_App7',           inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Branch_App7_New',       inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Branch_Cash',           inSession:= zfCalc_UserAdmin()); -- +
--
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ReceiptProductionAnalyze',    inSession:= zfCalc_UserAdmin()); -- - !!!
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ReceiptProductionOutAnalyze', inSession:= zfCalc_UserAdmin()); -- - !!!
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ReceiptSaleAnalyze',          inSession:= zfCalc_UserAdmin()); -- - !!!

-- -- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_OrderExternal',                inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_JuridicalDefermentPayment',    inSession:= zfCalc_UserAdmin()); -- + !!!
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_JuridicalDefermentPayment365', inSession:= zfCalc_UserAdmin()); -- + !!!
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_JuridicalDefermentDebet',      inSession:= zfCalc_UserAdmin()); -- + !!!
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_JuridicalSold',                inSession:= zfCalc_UserAdmin()); -- + !!!

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_TaxCorrective_Print', inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Tax_Load',            inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_1C_Load',             inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Sale',                inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Sale_Choice',         inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Sale_Transport',      inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Sale_reestr',         inSession:= zfCalc_UserAdmin()); -- +


-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_MovementItem_Sale',            inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_MovementItem_Sale_Order',      inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_MovementItem_ReturnIn',        inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_MovementItemChild_ReturnIn',   inSession:= zfCalc_UserAdmin()); -- +

-- *** SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_BankAccount',         inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Tax',                 inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_TaxCorrective',       inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Promo',               inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_WeighingPartner',     inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_WeighingPartner_Item',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_WeighingProduction',     inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_WeighingProduction_Item',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Scale_Partner',       inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Scale_Goods',         inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_HistoryCost',         inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ProductionUnion_Olap',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsTax',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelectMobile_Object_GoodsListSale',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelectMobile_Object_Juridical',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Personal',inSession:= zfCalc_UserAdmin()); -- +

-- -- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_CheckAmount_ReturnInToSale',inSession:= zfCalc_UserAdmin()); -- -

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_byMovementDiff',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_BankAccount',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Cash',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Branch_App7_Full',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_CheckBonus',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Check_ReturnInToLink',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_AccountMotion',inSession:= zfCalc_UserAdmin()); -- +


-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_CheckTaxCorrective',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MIProtocolUpdate',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MIProtocol',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_OrderExternal_Sale',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_Currency',inSession:= zfCalc_UserAdmin()); -- +


-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_LoginProtocol',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MIProtocol',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MIProtocolUpdate',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MovementProtocol',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MovementProtocolGroup',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_UserProtocol',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_StaffList',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_HolidayCompensation',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_HolidayPersonal',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_HolidayCompensation_zp',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_HolidayCompensation_day',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_CashPersonal_toPay',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_MotionGoodsWeek',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Report_Promo',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Check_Sale_TotalSum',inSession:= zfCalc_UserAdmin()); -- +

--!!!!!!!-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_MI_Reestr',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Transport',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Object_ContractPartnerChoice',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Object_ContractPartnerOrderChoice',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_ObjectHistory_PriceListItem',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_ProductionUnion_TaxExitUpdate',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpSelect_Movement_PersonalService_Item',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_TransportFuel',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Transport_ProfitLoss',inSession:= zfCalc_UserAdmin()); -- +
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_Transport_ProfitLossPartner',inSession:= zfCalc_UserAdmin()); -- +

-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsMI_ProductionUnion_TaxExit',inSession:= zfCalc_UserAdmin()); -- +


-- --!!! SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpReport_GoodsBalance',                 inSession:= zfCalc_UserAdmin()); -- + !!!

