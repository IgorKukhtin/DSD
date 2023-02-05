unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters, DateUtils,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, frxBarcode, dxSkinsdxBarPainter, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxTextEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, Vcl.ExtCtrls, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TMainForm = class(TAncestorMainForm)
    actMeasure: TdsdOpenForm;
    actJuridicalGroup: TdsdOpenForm;
    actGoodsProperty: TdsdOpenForm;
    actJuridical: TdsdOpenForm;
    actBusiness: TdsdOpenForm;
    actPartner: TdsdOpenForm;
    actIncome: TdsdOpenForm;
    actPaidKind: TdsdOpenForm;
    actContractKind: TdsdOpenForm;
    actUnitGroup: TdsdOpenForm;
    actUnit: TdsdOpenForm;
    actGoodsGroup: TdsdOpenForm;
    actGoodsMain: TdsdOpenForm;
    actGoodsKind: TdsdOpenForm;
    actBank: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    actCash: TdsdOpenForm;
    actCurrency: TdsdOpenForm;
    actBalance: TdsdOpenForm;
    actPriceListLoad: TdsdOpenForm;
    actContract: TdsdOpenForm;
    actOrderExternal: TdsdOpenForm;
    actOrderInternal: TdsdOpenForm;
    actPriceList: TdsdOpenForm;
    actNDSKind: TdsdOpenForm;
    actRetail: TdsdOpenForm;
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    actMovementLoad: TdsdOpenForm;
    actAdditionalGoods: TdsdOpenForm;
    actTestFormOpen: TdsdOpenForm;
    actSetDefault: TdsdOpenForm;
    actGoods: TdsdOpenForm;
    actGoodsPartnerCode: TdsdOpenForm;
    actGoodsPartnerCodeMaster: TdsdOpenForm;
    actPriceGroupSettings: TdsdOpenForm;
    actJuridicalSettings: TdsdOpenForm;
    actSaveData: TAction;
    actContactPerson: TdsdOpenForm;
    actJuridicalSettingsPriceList: TdsdOpenForm;
    actSearchGoods: TdsdOpenForm;
    actReportGoodsOrder: TdsdOpenForm;
    actOrderKind: TdsdOpenForm;
    actOrderInternalLite: TdsdOpenForm;
    miCommon: TMenuItem;
    miAdditionalGoods: TMenuItem;
    N1: TMenuItem;
    miGoodsPartnerCode: TMenuItem;
    miGoodsPartnerCodeMaster: TMenuItem;
    N4: TMenuItem;
    miUnit: TMenuItem;
    miJuridical: TMenuItem;
    N5: TMenuItem;
    miContract: TMenuItem;
    miContactPerson: TMenuItem;
    miLoad: TMenuItem;
    miImportGroup: TMenuItem;
    miMovementLoad: TMenuItem;
    miPriceListLoad: TMenuItem;
    miReports: TMenuItem;
    miBalance: TMenuItem;
    miReportGoodsOrder: TMenuItem;
    miSearchGoods: TMenuItem;
    miGoodsCommon: TMenuItem;
    miUser: TMenuItem;
    N6: TMenuItem;
    miRole: TMenuItem;
    miSetDefault: TMenuItem;
    N7: TMenuItem;
    miSaveData: TMenuItem;
    miPriceGroupSettings: TMenuItem;
    miJuridicalSettings: TMenuItem;
    N8: TMenuItem;
    miMeasure: TMenuItem;
    miNDSKind: TMenuItem;
    miRetail: TMenuItem;
    miOrderKind: TMenuItem;
    miImportType: TMenuItem;
    N9: TMenuItem;
    miImportSettings: TMenuItem;
    miImportExportLink: TMenuItem;
    N10: TMenuItem;
    miTest: TMenuItem;
    miDocuments: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    actReturnType: TdsdOpenForm;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    actLossDebt: TdsdOpenForm;
    N35: TMenuItem;
    N36: TMenuItem;
    N32: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    miReport_JuridicalSold: TMenuItem;
    miReport_JuridicalCollation: TMenuItem;
    actSendOnPrice: TdsdOpenForm;
    N42: TMenuItem;
    N43: TMenuItem;
    actMarginCategory: TdsdOpenForm;
    actMarginCategoryItem: TdsdOpenForm;
    actMarginCategoryReport: TdsdOpenForm;
    actMarginCategoryLink: TdsdOpenForm;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    actIncomePharmacy: TdsdOpenForm;
    N48: TMenuItem;
    actCheck: TdsdOpenForm;
    N49: TMenuItem;
    actCashRegister: TdsdOpenForm;
    N50: TMenuItem;
    actReport_GoodRemains: TdsdOpenForm;
    miReport_GoodRemains: TMenuItem;
    actPrice: TdsdOpenForm;
    N52: TMenuItem;
    actAlternativeGroup: TdsdOpenForm;
    N53: TMenuItem;
    miReprice: TMenuItem;
    actPaidType: TdsdOpenForm;
    N54: TMenuItem;
    actInventoryJournal: TdsdOpenForm;
    N55: TMenuItem;
    actLossJournal: TdsdOpenForm;
    N56: TMenuItem;
    actSendJournal: TdsdOpenForm;
    N57: TMenuItem;
    actCreateOrderFromMCS: TdsdOpenForm;
    N58: TMenuItem;
    actReportMovementCheckForm: TdsdOpenForm;
    miReportMovementCheckForm: TMenuItem;
    actReport_GoodsPartionMoveForm: TdsdOpenForm;
    miReport_GoodsPartionMoveForm: TMenuItem;
    actReport_GoodsPartionHistoryForm: TdsdOpenForm;
    miReport_GoodsPartionHistoryForm: TMenuItem;
    actReportSoldParamsFormOpen: TdsdOpenForm;
    N62: TMenuItem;
    actReport_SoldForm: TdsdOpenForm;
    miReport_SoldForm: TMenuItem;
    actReport_Sold_DayForm: TdsdOpenForm;
    miReport_Sold_DayForm: TMenuItem;
    actReport_Sold_DayUserForm: TdsdOpenForm;
    miReport_Sold_DayUserForm: TMenuItem;
    actSaleJournal: TdsdOpenForm;
    N66: TMenuItem;
    actReport_Movement_ByPartionGoodsForm: TdsdOpenForm;
    mniReport_Movement_ByPartionGoodsForm: TMenuItem;
    actPaymentJournal: TdsdOpenForm;
    N67: TMenuItem;
    actReasonDifferences: TdsdOpenForm;
    N68: TMenuItem;
    actReport_UploadBaDMForm: TdsdOpenForm;
    N69: TMenuItem;
    miReport_UploadBaDMForm: TMenuItem;
    actReport_UploadOptimaForm: TdsdOpenForm;
    miReport_UploadOptimaForm: TMenuItem;
    actRepriceJournal: TdsdOpenForm;
    N72: TMenuItem;
    actChangeIncomePaymentJournal: TdsdOpenForm;
    N73: TMenuItem;
    actForms: TdsdOpenForm;
    N74: TMenuItem;
    miPersonal: TMenuItem;
    actEducation: TdsdOpenForm;
    N75: TMenuItem;
    actPersonalGroup: TdsdOpenForm;
    actCalendar: TdsdOpenForm;
    actPosition: TdsdOpenForm;
    actPersonal: TdsdOpenForm;
    N76: TMenuItem;
    N77: TMenuItem;
    N78: TMenuItem;
    N79: TMenuItem;
    N80: TMenuItem;
    actMember: TdsdOpenForm;
    N81: TMenuItem;
    actWorkTimeKind: TdsdOpenForm;
    N82: TMenuItem;
    actSheetWorkTime: TdsdOpenForm;
    N83: TMenuItem;
    actReport_LiquidForm: TdsdOpenForm;
    miReport_LiquidForm: TMenuItem;
    actReportMovementIncomeForm: TdsdOpenForm;
    miReportMovementIncomeForm: TMenuItem;
    actReport_Wage: TdsdOpenForm;
    N86: TMenuItem;
    N87: TMenuItem;
    actGoodsAll: TdsdOpenForm;
    N88: TMenuItem;
    N89: TMenuItem;
    actGoodsAllRetail: TdsdOpenForm;
    actGoodsAllJuridical: TdsdOpenForm;
    N90: TMenuItem;
    N91: TMenuItem;
    actEmailSettings: TdsdOpenForm;
    N92: TMenuItem;
    N93: TMenuItem;
    actEmailTools: TdsdOpenForm;
    actEmailKind: TdsdOpenForm;
    N94: TMenuItem;
    N95: TMenuItem;
    actPriceOnDate: TdsdOpenForm;
    N96: TMenuItem;
    actReport_ProfitForm: TdsdOpenForm;
    miReport_ProfitForm: TMenuItem;
    actReport_PriceInterventionForm: TdsdOpenForm;
    miReport_PriceInterventionForm: TMenuItem;
    N40: TMenuItem;
    actReportMovementCheckFarmForm: TdsdOpenForm;
    miReportMovementCheckFarmForm: TMenuItem;
    actReportMovementIncomeFarmForm: TdsdOpenForm;
    N51: TMenuItem;
    actReport_PriceIntervention2: TdsdOpenForm;
    N59: TMenuItem;
    actChoiceGoodsFromRemains: TdsdOpenForm;
    N60: TMenuItem;
    actGoodsOnUnit_ForSite: TdsdOpenForm;
    N61: TMenuItem;
    actReportMovementCheckMiddleForm: TdsdOpenForm;
    N63: TMenuItem;
    actMaker: TdsdOpenForm;
    N64: TMenuItem;
    actPromo: TdsdOpenForm;
    N65: TMenuItem;
    actReport_RemainsOverGoods: TdsdOpenForm;
    miReport_RemainsOverGoods: TMenuItem;
    actUnitForFarmacyCash: TdsdOpenForm;
    FarmacyCash1: TMenuItem;
    actEmail: TdsdOpenForm;
    N71: TMenuItem;
    actOver: TdsdOpenForm;
    N84: TMenuItem;
    actRoleUnion: TdsdOpenForm;
    N85: TMenuItem;
    actColor: TdsdOpenForm;
    N97: TMenuItem;
    actOverSettings: TdsdOpenForm;
    miOverSettings: TMenuItem;
    actDiscountCard: TdsdOpenForm;
    actBarCode: TdsdOpenForm;
    actDiscountExternal: TdsdOpenForm;
    N99: TMenuItem;
    N100: TMenuItem;
    N101: TMenuItem;
    miDiscountExternal: TMenuItem;
    N103: TMenuItem;
    actConfirmedKind: TdsdOpenForm;
    N98: TMenuItem;
    actDiscountExternalTools: TdsdOpenForm;
    miDiscountExternalTools: TMenuItem;
    actPriceGroupSettingsTOP: TdsdOpenForm;
    N102: TMenuItem;
    actReport_MovementCheckUnLiquid: TdsdOpenForm;
    N104: TMenuItem;
    actReport_Payment_Plan: TdsdOpenForm;
    N105: TMenuItem;
    actReport_MovementCheckErrorForm: TdsdOpenForm;
    N106: TMenuItem;
    actOrderShedule: TdsdOpenForm;
    N107: TMenuItem;
    actReport_MovementIncome_Promo: TdsdOpenForm;
    N108: TMenuItem;
    actReport_MovementCheck_Promo: TdsdOpenForm;
    N109: TMenuItem;
    actReport_CheckPromo: TdsdOpenForm;
    N110: TMenuItem;
    N111: TMenuItem;
    actKindOutSP: TdsdOpenForm;
    N112: TMenuItem;
    actBrandSP: TdsdOpenForm;
    actIntenalSP: TdsdOpenForm;
    N113: TMenuItem;
    N114: TMenuItem;
    actGoodsSP: TdsdOpenForm;
    N115: TMenuItem;
    actReport_CheckSP: TdsdOpenForm;
    N117: TMenuItem;
    N118: TMenuItem;
    N119: TMenuItem;
    actPartnerMedical: TdsdOpenForm;
    N120: TMenuItem;
    actConditionsKeep: TdsdOpenForm;
    N121: TMenuItem;
    actReportPromoParams: TdsdOpenForm;
    N122: TMenuItem;
    actReport_MinPrice_onGoods: TdsdOpenForm;
    N123: TMenuItem;
    actReport_Badm: TdsdOpenForm;
    N126: TMenuItem;
    actUnit_byReportBadm: TdsdOpenForm;
    N125: TMenuItem;
    actMarginCategory_Cross: TdsdOpenForm;
    N127: TMenuItem;
    actMarginCategory_Total: TdsdOpenForm;
    actPromoUnit: TdsdOpenForm;
    N128: TMenuItem;
    actReport_MovementCheck_Cross: TdsdOpenForm;
    miReport_MovementCheck_Cross: TMenuItem;
    actReport_MovementCheckFarm_Cross: TdsdOpenForm;
    miReport_MovementCheckFarm_Cross: TMenuItem;
    actReport_SaleSP: TdsdOpenForm;
    N13031: TMenuItem;
    actMedicSP: TdsdOpenForm;
    actMemberSP: TdsdOpenForm;
    N41: TMenuItem;
    N129: TMenuItem;
    actReport_RemainsOverGoods_To: TdsdOpenForm;
    N130: TMenuItem;
    N131: TMenuItem;
    N132: TMenuItem;
    N133: TMenuItem;
    actInvoice: TdsdOpenForm;
    N70: TMenuItem;
    N134: TMenuItem;
    N135: TMenuItem;
    actReport_CheckPromoFarm: TdsdOpenForm;
    N136: TMenuItem;
    actReport_MovementPriceList_Cross: TdsdOpenForm;
    N137: TMenuItem;
    N138: TMenuItem;
    actDiscountExternalJuridical: TdsdOpenForm;
    miDiscountExternalJuridical: TMenuItem;
    actSPKind: TdsdOpenForm;
    N139: TMenuItem;
    actMemberIncomeCheck: TdsdOpenForm;
    N140: TMenuItem;
    actGoodsBarCodeLoad: TdsdOpenForm;
    N141: TMenuItem;
    actGoods_BarCode: TdsdOpenForm;
    N142: TMenuItem;
    actReportMovementCheckLight: TdsdOpenForm;
    N143: TMenuItem;
    actReport_GoodsRemainsLight: TdsdOpenForm;
    N144: TMenuItem;
    miExportSalesForSupp: TMenuItem;
    actProvinceCity: TdsdOpenForm;
    N145: TMenuItem;
    actReport_Check_Assortment: TdsdOpenForm;
    N146: TMenuItem;
    actReport_OverOrder: TdsdOpenForm;
    N147: TMenuItem;
    actReport_Check_Rating: TdsdOpenForm;
    N124: TMenuItem;
    actReportMovementCheckGrowthAndFalling: TdsdOpenForm;
    miReportMovementCheckGrowthAndFalling: TMenuItem;
    actUnit_Object: TdsdOpenForm;
    N149: TMenuItem;
    actArea: TdsdOpenForm;
    N150: TMenuItem;
    actJuridicalArea: TdsdOpenForm;
    N151: TMenuItem;
    actUnit_JuridicalArea: TdsdOpenForm;
    N152: TMenuItem;
    actReport_CheckMiddle_Detail: TdsdOpenForm;
    N153: TMenuItem;
    actReport_GoodsRemains_AnotherRetail: TdsdOpenForm;
    ID1: TMenuItem;
    actPersonalList: TdsdOpenForm;
    actExportSalesForSuppClick: TAction;
    actMarginCategory_Movement: TdsdOpenForm;
    N154: TMenuItem;
    N155: TMenuItem;
    actReport_Check_UKTZED: TdsdOpenForm;
    N156: TMenuItem;
    actPromoCode: TdsdOpenForm;
    N157: TMenuItem;
    N158: TMenuItem;
    N159: TMenuItem;
    actPromoCodeMovement: TdsdOpenForm;
    N160: TMenuItem;
    N161: TMenuItem;
    actFiscal: TdsdOpenForm;
    N162: TMenuItem;
    actReport_GoodsRemainsCurrent: TdsdOpenForm;
    miReport_GoodsRemainsCurrent: TMenuItem;
    actGoodsRetail: TdsdOpenForm;
    miGoodsRetail: TMenuItem;
    actGoods_NDS_diff: TdsdOpenForm;
    miGoods_NDS_diff: TMenuItem;
    N2: TMenuItem;
    actReportMovementCheckFLForm: TdsdOpenForm;
    miReportMovementCheckFLForm: TMenuItem;
    actReport_ImplementationPlanEmployee: TAction;
    N3: TMenuItem;
    N116: TMenuItem;
    actReport_ImplementationPlanEmployeeAll: TdsdOpenForm;
    N163: TMenuItem;
    actGoodsSPJournal: TdsdOpenForm;
    miGoodsSPJournal: TMenuItem;
    actReport_Liquidity: TdsdOpenForm;
    N164: TMenuItem;
    actPriceChangeOnDate: TdsdOpenForm;
    actPriceChange: TdsdOpenForm;
    N165: TMenuItem;
    miPriceChange: TMenuItem;
    miPriceChangeOnDate: TMenuItem;
    miRepriceChange: TMenuItem;
    actRepriceChangeJournal: TdsdOpenForm;
    miRepriceChangeJournal: TMenuItem;
    actReport_Check_PriceChange: TdsdOpenForm;
    miReport_Check_PriceChange: TMenuItem;
    actMarginCategoryJournal2: TdsdOpenForm;
    miMarginCategoryJournal2: TMenuItem;
    N166: TMenuItem;
    actReport_TestingUser: TdsdOpenForm;
    N167: TMenuItem;
    actListDiff: TdsdOpenForm;
    N168: TMenuItem;
    actPriceListLoad_Add: TdsdOpenForm;
    miPriceListLoad_Add: TMenuItem;
    N170: TMenuItem;
    actClientsByBank: TdsdOpenForm;
    N169: TMenuItem;
    actUnnamedEnterprises: TdsdOpenForm;
    N171: TMenuItem;
    actReport_IncomeSample: TdsdOpenForm;
    miReport_IncomeSample: TMenuItem;
    actReport_KPU: TdsdOpenForm;
    N172: TMenuItem;
    actReport_Check_GoodsPriceChange: TdsdOpenForm;
    miReport_Check_GoodsPriceChange: TMenuItem;
    actLog_CashRemains: TdsdOpenForm;
    GUID1: TMenuItem;
    actRepriceUnitSheduler: TdsdOpenForm;
    N173: TMenuItem;
    actCheckNoCashRegister: TdsdOpenForm;
    N174: TMenuItem;
    actReportUnLiquid_Movement: TdsdOpenForm;
    N175: TMenuItem;
    actCheckUnComplete: TdsdOpenForm;
    N176: TMenuItem;
    actEmployeeSchedule: TdsdOpenForm;
    N177: TMenuItem;
    actDiffKind: TdsdOpenForm;
    miDiffKind: TMenuItem;
    actUnit_MCS: TdsdOpenForm;
    miUnit_MCS: TMenuItem;
    actReport_Movement_ListDiff: TdsdOpenForm;
    miReport_Movement_ListDiff: TMenuItem;
    actRecalcMCSSheduler: TdsdOpenForm;
    N178: TMenuItem;
    actReturnInJournal: TdsdOpenForm;
    miReturnInJournal: TMenuItem;
    actGlobalConst: TdsdOpenForm;
    miGlobalConst: TMenuItem;
    actGoodsCategory: TdsdOpenForm;
    miGoodsCategory: TMenuItem;
    N179: TMenuItem;
    actReportRogersMovementCheck: TdsdOpenForm;
    actRepriceRogersJournal: TdsdOpenForm;
    N180: TMenuItem;
    N181: TMenuItem;
    actBankPOSTerminal: TdsdOpenForm;
    POS1: TMenuItem;
    actTaxUnit: TdsdOpenForm;
    miTaxUnit: TMenuItem;
    actUnitBankPOSTerminal: TdsdOpenForm;
    POS2: TMenuItem;
    actJackdawsChecks: TdsdOpenForm;
    actJackdawsChecks1: TMenuItem;
    actPUSH: TdsdOpenForm;
    actPUSH1: TMenuItem;
    actSendPartionDate: TdsdOpenForm;
    miSendPartionDate: TMenuItem;
    actGoodsInventory: TdsdOpenForm;
    N182: TMenuItem;
    actCreditLimitDistributor: TdsdOpenForm;
    N183: TMenuItem;
    actOrderInternalPromo: TdsdOpenForm;
    miOrderInternalPromo: TMenuItem;
    actPartionDateKind: TdsdOpenForm;
    N184: TMenuItem;
    actRetailCostCredit: TdsdOpenForm;
    miRetailCostCredit: TMenuItem;
    actReturnOutPharmacy: TdsdOpenForm;
    miReturnOutPharmacy: TMenuItem;
    actReport_GoodsPartionDate: TdsdOpenForm;
    miReport_GoodsPartionDate: TMenuItem;
    actReport_CheckPartionDate: TdsdOpenForm;
    miReport_CheckPartionDate: TMenuItem;
    actSendMenegerJournal: TdsdOpenForm;
    N185: TMenuItem;
    actReport_GoodsNotSalePast: TdsdOpenForm;
    actReportGoodsNotSalePast1: TMenuItem;
    acttReport_GoodsPartionDate_Promo: TdsdOpenForm;
    N186: TMenuItem;
    actReport_GoodsPartionDate5: TdsdOpenForm;
    N510: TMenuItem;
    actReport_Movement_Send_RemainsSun_express: TdsdOpenForm;
    miReport_Movement_Send_RemainsSun: TMenuItem;
    actMCS_Lite: TdsdOpenForm;
    miMCS_Lite: TMenuItem;
    actReport_PriceProtocol: TdsdOpenForm;
    miReport_PriceProtocol: TMenuItem;
    actDriver: TdsdOpenForm;
    N187: TMenuItem;
    actUnitLincDriver: TdsdOpenForm;
    N188: TMenuItem;
    actReport_BalanceGoodsSUN: TdsdOpenForm;
    N189: TMenuItem;
    actWages: TdsdOpenForm;
    N190: TMenuItem;
    actReport_CheckSendSUN_InOut: TdsdOpenForm;
    miReport_CheckSendSUN_InOut: TMenuItem;
    actPayrollType: TdsdOpenForm;
    N191: TMenuItem;
    actReport_CheckSUN: TdsdOpenForm;
    miReport_CheckSUN: TMenuItem;
    actGoodsAll_Tab: TdsdOpenForm;
    actGoodsAllRetail_Tab: TdsdOpenForm;
    miGoodsAll_Tab: TMenuItem;
    miGoodsAllRetail_Tab: TMenuItem;
    N192: TMenuItem;
    actReport_DiscountExternal: TdsdOpenForm;
    N193: TMenuItem;
    actGoodsMainTab_Error: TdsdOpenForm;
    miGoodsMainTab_Error: TMenuItem;
    actReport_Profitability: TdsdOpenForm;
    N194: TMenuItem;
    actLoyaltyJournal: TdsdOpenForm;
    N195: TMenuItem;
    actGoodsRetailTab_Error: TdsdOpenForm;
    miGoodsRetailTab_Error: TMenuItem;
    N196: TMenuItem;
    actReport_Send_RemainsSun_over: TdsdOpenForm;
    miReport_GoodsSendSUN_over: TMenuItem;
    actMarginCategory_All: TdsdOpenForm;
    miMarginCategory_All: TMenuItem;
    actGoodsReprice: TdsdOpenForm;
    miGoodsReprice: TMenuItem;
    DSGetInfo: TDataSource;
    CDSGetInfo: TClientDataSet;
    spGetInfo: TdsdStoredProc;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colText: TcxGridDBColumn;
    colData: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actRefresh: TdsdExecStoredProc;
    actCashSettings: TdsdOpenForm;
    N197: TMenuItem;
    actReport_GoodsPartionDate0: TdsdOpenForm;
    N198: TMenuItem;
    actReport_Movement_ReturnOut: TdsdOpenForm;
    miReport_Movement_ReturnOut: TMenuItem;
    N199: TMenuItem;
    N200: TMenuItem;
    actReport_IlliquidReductionPlanAll: TdsdOpenForm;
    N201: TMenuItem;
    miReprice_test: TMenuItem;
    N202: TMenuItem;
    N203: TMenuItem;
    actPercentageOverdueSUN: TdsdOpenForm;
    N204: TMenuItem;
    TimerPUSH: TTimer;
    spGet_PUSH_Farmacy: TdsdStoredProc;
    PUSHDS: TClientDataSet;
    actPermanentDiscount: TdsdOpenForm;
    N205: TMenuItem;
    actReport_PromoDoctors: TdsdOpenForm;
    actReport_PromoEntrances: TdsdOpenForm;
    N206: TMenuItem;
    N207: TMenuItem;
    actIlliquidUnitJournal: TdsdOpenForm;
    N208: TMenuItem;
    N209: TMenuItem;
    actLoyaltySaveMoneyJournal: TdsdOpenForm;
    N210: TMenuItem;
    actReport_IlliquidReductionPlanUser: TdsdOpenForm;
    N211: TMenuItem;
    N212: TMenuItem;
    actBuyer: TdsdOpenForm;
    N213: TMenuItem;
    actReport_StockTiming_RemainderForm: TdsdOpenForm;
    N214: TMenuItem;
    actReport_InventoryErrorRemains: TdsdOpenForm;
    N215: TMenuItem;
    actPlanIventory: TdsdOpenForm;
    miPlanIventory: TMenuItem;
    actReport_SendSUNLoss: TdsdOpenForm;
    actReport_SendSUNDelay: TdsdOpenForm;
    N216: TMenuItem;
    N217: TMenuItem;
    N218: TMenuItem;
    actReport_GoodsSendSUN: TdsdOpenForm;
    miReport_GoodsSendSUN: TMenuItem;
    actReport_SUNSaleDates: TdsdOpenForm;
    N219: TMenuItem;
    actTechnicalRediscount: TdsdOpenForm;
    N220: TMenuItem;
    actTechnicalRediscountCashier: TdsdOpenForm;
    N221: TMenuItem;
    actReport_SendSUN_SUNv2: TdsdOpenForm;
    miReport_SendSUN_SUNv2: TMenuItem;
    actReport_JuridicalRemains: TdsdOpenForm;
    miReport_JuridicalRemains: TMenuItem;
    actReport_Movement_Send_RemainsSunOut: TdsdOpenForm;
    N222: TMenuItem;
    actHelsiUser: TdsdOpenForm;
    N223: TMenuItem;
    actReport_JuridicalSales: TdsdOpenForm;
    N224: TMenuItem;
    miReport_JuridicalSales: TMenuItem;
    actReport_EntryGoodsMovement: TdsdOpenForm;
    N225: TMenuItem;
    actReport_GeneralMovementGoods: TdsdOpenForm;
    N226: TMenuItem;
    actReport_Movement_Send_RemainsSun: TdsdOpenForm;
    mmReport_Send_RemainsSun_express: TMenuItem;
    N228: TMenuItem;
    actReport_Movement_Send_RemainsSunOut_express: TdsdOpenForm;
    miReport_Send_RemainsSunOut_express: TMenuItem;
    actSeasonalityCoefficient: TdsdOpenForm;
    N227: TMenuItem;
    actReport_PharmacyPerformance: TdsdOpenForm;
    N229: TMenuItem;
    actSunExclusion: TdsdOpenForm;
    miSunExclusion: TMenuItem;
    N230: TMenuItem;
    actReport_SummSP: TdsdOpenForm;
    miReport_SummSP: TMenuItem;
    actReport_NomenclaturePeriod: TdsdOpenForm;
    N231: TMenuItem;
    actHardware: TdsdOpenForm;
    N232: TMenuItem;
    actReport_Movement_Send_RemainsSunOut_expressV2: TdsdOpenForm;
    miReport_Send_RemainsSunOut_expressV2: TMenuItem;
    actReport_Movement_Send_RemainsSun_pi: TdsdOpenForm;
    miReport_Movement_Send_RemainsSun_pi: TMenuItem;
    N233: TMenuItem;
    actLossFundJournal: TdsdOpenForm;
    N234: TMenuItem;
    actReport_IncomeSale_UseNDSKind: TdsdOpenForm;
    miReport_IncomeSale_UseNDSKind: TMenuItem;
    actReport_IncomeVATBalance: TdsdOpenForm;
    N235: TMenuItem;
    actProjectsImprovements: TdsdOpenForm;
    actProjectsImprovements1: TMenuItem;
    actReport_ImplementationPeriod: TdsdOpenForm;
    N236: TMenuItem;
    actUnitForOrderInternalPromo: TdsdOpenForm;
    miUnitForOrderInternalPromo: TMenuItem;
    actSearchRemainsVIP: TdsdOpenStaticForm;
    actSearchRemainsVIP1: TMenuItem;
    actSendMenegerVIPJournal: TdsdOpenForm;
    VIP1: TMenuItem;
    actReport_RemainsOverGoods_test: TdsdOpenForm;
    miReport_RemainsOverGoods_test: TMenuItem;
    actReport_Sun_Supplement: TdsdOpenForm;
    v11: TMenuItem;
    actSendPartionDateChangeJournal: TdsdOpenForm;
    N237: TMenuItem;
    actCheckSummCard: TdsdOpenForm;
    N238: TMenuItem;
    mmServiceFunctions: TMenuItem;
    actTReport_Check_NumberChecks: TdsdOpenForm;
    N239: TMenuItem;
    actHouseholdInventory: TdsdOpenForm;
    N240: TMenuItem;
    N241: TMenuItem;
    actIncomeHouseholdInventory: TdsdOpenForm;
    N242: TMenuItem;
    N243: TMenuItem;
    actTHouseholdInventoryRemains: TdsdOpenForm;
    N244: TMenuItem;
    N245: TMenuItem;
    actWriteOffHouseholdInventory: TdsdOpenForm;
    N246: TMenuItem;
    actReport_PercentageOccupancySUN: TdsdOpenForm;
    actReportPercentageOccupancySUN1: TMenuItem;
    actComputerAccessoriesRegister: TdsdOpenForm;
    N247: TMenuItem;
    actInventoryHouseholdInventory: TdsdOpenForm;
    N248: TMenuItem;
    actReport_Check_Count: TdsdOpenForm;
    miReport_Check_Count: TMenuItem;
    actReport_LeftSend: TdsdOpenForm;
    N249: TMenuItem;
    actPositionsUKTVEDonSUN: TdsdOpenForm;
    N250: TMenuItem;
    actDivisionParties: TdsdOpenForm;
    N251: TMenuItem;
    actJuridicalPriorities: TdsdOpenForm;
    N252: TMenuItem;
    actReport_CommentSendSUN: TdsdOpenForm;
    N253: TMenuItem;
    actLayoutJournal: TdsdOpenForm;
    miLayoutJournal: TMenuItem;
    actReport_ChangeCommentsSUN: TdsdOpenForm;
    N254: TMenuItem;
    N255: TMenuItem;
    actReport_ArrivalWithoutSales: TdsdOpenForm;
    actLoyaltyPresentJournal: TdsdOpenForm;
    N256: TMenuItem;
    actReport_ResortsByLot: TdsdOpenForm;
    N257: TMenuItem;
    actReport_TwoVendorBindings: TdsdOpenForm;
    N258: TMenuItem;
    N259: TMenuItem;
    actRelatedProduct: TdsdOpenForm;
    N260: TMenuItem;
    N261: TMenuItem;
    actReport_TestingUserAttempts: TdsdOpenForm;
    N262: TMenuItem;
    acTReport_SAUA: TdsdOpenForm;
    N263: TMenuItem;
    actDistributionPromo: TdsdOpenForm;
    N264: TMenuItem;
    actReport_PriceCheck: TdsdOpenForm;
    N265: TMenuItem;
    actReport_ClippedReprice_SaleForm: TdsdOpenForm;
    N266: TMenuItem;
    N267: TMenuItem;
    actReport_PromoDoctorsShevchenko9: TdsdOpenForm;
    N910: TMenuItem;
    miRepricePromo: TMenuItem;
    actCalculation_SAUA: TdsdOpenStaticForm;
    N268: TMenuItem;
    actReport_MovementCheckSite: TdsdOpenForm;
    N269: TMenuItem;
    actClearDefaultUnit: TdsdOpenForm;
    N270: TMenuItem;
    actReport_QuantityComparison: TdsdOpenForm;
    N271: TMenuItem;
    actReport_RemainsSun_UKTZED: TdsdOpenForm;
    N272: TMenuItem;
    actReport_GoodsRemainsUKTZED: TdsdOpenForm;
    N273: TMenuItem;
    actReport_SalesOfTermDrugs: TdsdOpenForm;
    N274: TMenuItem;
    actFinalSUAJournal: TdsdOpenForm;
    N275: TMenuItem;
    actReport_Movement_Send_RemainsSun_SUA: TdsdOpenForm;
    N276: TMenuItem;
    actInstructions: TdsdOpenForm;
    N277: TMenuItem;
    actPromoBonus: TdsdOpenForm;
    N278: TMenuItem;
    actReport_HammerTimeSUN: TdsdOpenForm;
    N279: TMenuItem;
    actReport_Check_PromoBonusLosses: TdsdOpenForm;
    N280: TMenuItem;
    actReport_Check_SP_ForDPSS: TdsdOpenForm;
    N281: TMenuItem;
    actDiscountExternalSupplier: TdsdOpenForm;
    N282: TMenuItem;
    actReport_Check_PromoBonusEstimate: TdsdOpenForm;
    N283: TMenuItem;
    actReport_Check_CorrectMarketing: TdsdOpenForm;
    N284: TMenuItem;
    actReport_PromoBonusDisco: TdsdOpenForm;
    N285: TMenuItem;
    actAccommodationLincGoods: TdsdOpenForm;
    N286: TMenuItem;
    actReport_KilledCodeRecovery: TdsdOpenForm;
    C1: TMenuItem;
    actGoodsDivisionLock: TdsdOpenForm;
    N288: TMenuItem;
    N289: TMenuItem;
    N290: TMenuItem;
    N291: TMenuItem;
    N292: TMenuItem;
    N293: TMenuItem;
    N294: TMenuItem;
    N295: TMenuItem;
    actRepriceUnit: TdsdOpenStaticForm;
    actRepriceÑhangeRetail: TdsdOpenStaticForm;
    actReport_Analysis_Remains_Selling: TdsdOpenStaticForm;
    actReport_IncomeConsumptionBalance: TdsdOpenStaticForm;
    actReport_SalesGoods_SUA: TdsdOpenForm;
    N296: TMenuItem;
    actTestingTuning: TdsdOpenForm;
    N297: TMenuItem;
    actReport_RepriceSite: TdsdOpenForm;
    N298: TMenuItem;
    actPriceSite: TdsdOpenForm;
    N287: TMenuItem;
    actRepriceSite: TdsdOpenForm;
    N299: TMenuItem;
    actReport_Movement_DynamicsOrdersEIC: TdsdOpenForm;
    N300: TMenuItem;
    actCheckoutTesting: TdsdOpenForm;
    GUID2: TMenuItem;
    actReport_Check_SetErasedUser: TdsdOpenForm;
    N301: TMenuItem;
    actTopicsTestingTuning: TdsdOpenForm;
    N302: TMenuItem;
    actReport_RemainsCovid_19: TdsdOpenForm;
    Covid191: TMenuItem;
    N303: TMenuItem;
    actTestingTuning_Manual: TdsdOpenForm;
    N304: TMenuItem;
    actTestingUser: TdsdOpenStaticForm;
    N305: TMenuItem;
    actReport_Movement_CheckWithPennies: TdsdOpenForm;
    N501: TMenuItem;
    actReport_Movement_CheckDeliverySite: TdsdOpenForm;
    N306: TMenuItem;
    actReport_Check_JackdawsSum: TdsdOpenForm;
    N308: TMenuItem;
    actGoodsSUN: TdsdOpenForm;
    N307: TMenuItem;
    actReport_ZReportLog: TdsdOpenForm;
    Z1: TMenuItem;
    actListDiffFormVIPSend: TdsdOpenForm;
    VIP2: TMenuItem;
    actCreateOrderFromMCSLayout: TdsdOpenForm;
    N309: TMenuItem;
    actReport_Top100GoodsSUN: TdsdOpenForm;
    N1001: TMenuItem;
    actReport_ZeroingInOrders: TdsdOpenForm;
    N310: TMenuItem;
    actReport_LayoutCheckRemains: TdsdOpenForm;
    N311: TMenuItem;
    spGet_MainForm_isTop: TdsdStoredProc;
    actReport_CheckZReport: TdsdOpenForm;
    Z2: TMenuItem;
    actMakerReport: TdsdOpenForm;
    N312: TMenuItem;
    N313: TMenuItem;
    actReport_PriceCorrectionSystem: TdsdOpenForm;
    actPayrollTypeVIP: TdsdOpenForm;
    N314: TMenuItem;
    actEmployeeScheduleVIP: TdsdOpenForm;
    VIP3: TMenuItem;
    actEmployeeScheduleUserVIP: TdsdOpenForm;
    N315: TMenuItem;
    actWagesVIP: TdsdOpenForm;
    VIP4: TMenuItem;
    actInsuranceCompanies: TdsdOpenForm;
    actMemberIC: TdsdOpenForm;
    N316: TMenuItem;
    N317: TMenuItem;
    N318: TMenuItem;
    actCorrectWagesPercentage: TdsdOpenForm;
    N319: TMenuItem;
    actMedicalProgramSP: TdsdOpenForm;
    N320: TMenuItem;
    actMedicalProgramSPLink: TdsdOpenForm;
    N321: TMenuItem;
    actBanCommentSend: TdsdOpenForm;
    N322: TMenuItem;
    actReport_TopListDiffGoods: TdsdOpenForm;
    N323: TMenuItem;
    actWagesVIP_User: TdsdOpenForm;
    N324: TMenuItem;
    actTelegramProtocol: TdsdOpenForm;
    elegram1: TMenuItem;
    actReport_MonitoringCollectionSUN: TdsdOpenForm;
    N325: TMenuItem;
    actReport_RelatedCodesSUN: TdsdOpenForm;
    N326: TMenuItem;
    actReport_InsuranceCompanies: TdsdOpenForm;
    N327: TMenuItem;
    actReport_SummaInsuranceCompanies: TdsdOpenForm;
    N328: TMenuItem;
    actSurchargeWages: TdsdOpenForm;
    N329: TMenuItem;
    actReport_TestingAttemptsUser: TdsdOpenForm;
    N330: TMenuItem;
    actReport_FinancialMonitoring: TdsdOpenForm;
    N331: TMenuItem;
    actPretensionJournal: TdsdOpenForm;
    N332: TMenuItem;
    actReport_Layout_NotLinkPriceList: TdsdOpenForm;
    N333: TMenuItem;
    actReport_Layout_OutOrder: TdsdOpenForm;
    N334: TMenuItem;
    actPickUpLogsAndDBF: TdsdOpenForm;
    N335: TMenuItem;
    actReport_PriceComparisonBIG3: TdsdOpenForm;
    C31: TMenuItem;
    actReport_Sun_Supplement_v2: TdsdOpenForm;
    v21: TMenuItem;
    actLayoutFileJournal: TdsdOpenForm;
    N336: TMenuItem;
    actReport_CommodityStock: TdsdOpenForm;
    N337: TMenuItem;
    actSupplierFailures: TdsdOpenForm;
    N338: TMenuItem;
    actExchangeRates: TdsdOpenForm;
    N339: TMenuItem;
    actCheckRed: TdsdOpenForm;
    N340: TMenuItem;
    actReport_RemainingInsulins: TdsdOpenForm;
    N341: TMenuItem;
    actReport_PaperRecipeSP: TdsdOpenForm;
    N342: TMenuItem;
    actReport_PaperRecipeSPInsulin: TdsdOpenForm;
    N343: TMenuItem;
    actReport_PaymentSum: TdsdOpenForm;
    N344: TMenuItem;
    actReport_LoginProtocol: TdsdOpenForm;
    N345: TMenuItem;
    acTReport_NotPaySumIncome: TdsdOpenForm;
    N346: TMenuItem;
    actGoodsSP_1303: TdsdOpenForm;
    N13032: TMenuItem;
    actNewUser: TdsdOpenForm;
    N148: TMenuItem;
    actReport_CheckUpdateNotMCS: TdsdOpenForm;
    N347: TMenuItem;
    N348: TMenuItem;
    actCompetitorMarkups: TdsdOpenForm;
    N349: TMenuItem;
    actReport_CompetitorMarkups: TdsdOpenForm;
    N350: TMenuItem;
    N351: TMenuItem;
    actGoodsWages: TdsdOpenForm;
    N352: TMenuItem;
    actGoodsSite: TdsdOpenForm;
    N353: TMenuItem;
    actGoodsCash: TdsdOpenForm;
    N354: TMenuItem;
    actGoodsSPRegistry_1303: TdsdOpenForm;
    N13033: TMenuItem;
    actReport_ImplementationPlanEmployeeUser: TdsdOpenForm;
    N355: TMenuItem;
    actGoodsSPSearch_1303Journal: TdsdOpenForm;
    N13034: TMenuItem;
    actReport_Check_SiteDelay: TdsdOpenForm;
    N356: TMenuItem;
    actReport_Check_OrderFine: TdsdOpenForm;
    N357: TMenuItem;
    actChoiceGoodsSPSearch_1303: TdsdOpenForm;
    N13035: TMenuItem;
    actChoiceGoodsFromRemains_1303: TdsdOpenForm;
    N13036: TMenuItem;
    actLoadingFarmacyCash: TdsdOpenStaticForm;
    FarmacyCash2: TMenuItem;
    actReport_IncomeDubly: TdsdOpenForm;
    N358: TMenuItem;
    actReport_Inventory_ProficitReturnOut: TdsdOpenForm;
    N359: TMenuItem;
    actReport_AnalysisBonusesIncome: TdsdOpenForm;
    N360: TMenuItem;
    actReport_RestTermGoods: TdsdOpenForm;
    N361: TMenuItem;
    actReport_Goods_LeftTheMarket: TdsdOpenForm;
    N362: TMenuItem;
    actUkraineAlarm: TdsdOpenForm;
    N363: TMenuItem;
    actReport_CheckMobile: TdsdOpenForm;
    N364: TMenuItem;
    actReport_JuridicalRemainsEnd: TdsdOpenForm;
    N365: TMenuItem;
    actReport_MovementSiteBonus: TdsdOpenForm;
    N366: TMenuItem;
    actFilesToCheckJournal: TdsdOpenForm;
    N367: TMenuItem;
    actSalePromoGoodsJournal: TdsdOpenForm;
    N368: TMenuItem;
    actInternetRepair: TdsdOpenForm;
    N369: TMenuItem;
    actUserCash: TdsdOpenForm;
    N370: TMenuItem;
    actCheckErrorInsertDate: TdsdOpenForm;
    N371: TMenuItem;
    actPartionDateWages: TdsdOpenForm;
    N372: TMenuItem;
    actReport_Check_TabletkiRecreate: TdsdOpenForm;
    N373: TMenuItem;
    procedure actSaveDataExecute(Sender: TObject);
    procedure actExportSalesForSuppClickExecute(Sender: TObject);
    procedure actReport_ImplementationPlanEmployeeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miReprice_testClick(Sender: TObject);
    procedure TimerPUSHTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N261Click(Sender: TObject);
    procedure miRepricePromoClick(Sender: TObject);
  private
    { Private declarations }
    FLoadPUSH: Integer;
    FNumberPUSH: Integer;
    FPUSHThread: TThread;
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

{$R *.dfm}

uses
  UploadUnloadData, Dialogs, Forms, SysUtils, CommonData, IdGlobal, RepriceUnit,  RepriceUnit_test,
  RepriceChangeRetail, ExportSalesForSupp, Report_Analysis_Remains_Selling, SearchByCaption,
  Report_ImplementationPlanEmployee, Report_IncomeConsumptionBalance, PUSHMessageFarmacy,
  RepricePromoUnit, Storage;

type
  TPUSHThread = class(TThread)
  private
  { Private declarations }
  protected
    procedure Execute; override;
  end;

{ TPUSHThread }

procedure TPUSHThread.Execute;
  var pXML, Data : String;
      StringStream: TStringStream;
begin
  {ñîçäàåì XML âûçîâà ïðîöåäóðû íà ñåðâåðå}
  pXML :=
    '<xml Session = "%s" >' +
      '<gpGet_PUSH_Farmacy OutputType="otDataSet">' +
      '<inNumberPUSH    DataType="ftInteger" Value="%s" />' +
      '</gpGet_PUSH_Farmacy>' +
    '</xml>';

  try
    Data := TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [gc_User.Session, IntToStr(MainFormInstance.FNumberPUSH)]), False, 4, False);
    //
    if Data <> '' then
    begin
      try
        StringStream := GetStringStream(String(Data));
        MainFormInstance.PUSHDS.LoadFromStream(StringStream);
      finally
        FreeAndNil(StringStream);
      end;
    end;
  except
  end;
  MainFormInstance.FPUSHThread := Nil;
  MainFormInstance.FLoadPUSH := 0;
end;


procedure TMainForm.actReport_ImplementationPlanEmployeeExecute(
  Sender: TObject);
begin
  with TReport_ImplementationPlanEmployeeForm.Create(Self) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actSaveDataExecute(Sender: TObject);
begin
  with TdmUnloadUploadData.Create(Self) do
     try
       UnloadData;
     finally
       Free;
     end;

  Application.ProcessMessages;
  ShowMessage('Âûãðóçèëè');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  FNumberPUSH := 0;
  try
    spGet_MainForm_isTop.Execute;
    if spGet_MainForm_isTop.ParamByName('isMainFormTop').Value then
    begin
      Top := 10;
      Left := 10
    end;
  finally
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  inherited;

  if (gc_User.Session = '3') or (gc_User.Session = '4183126') then
  begin
    cxGrid.Visible := True;
    actRefresh.Execute;
  end else
  begin
    cxGrid.Visible := False;
    actRefresh.Enabled := False;
    actRefresh.Timer.Enabled := False;
  end;

  FLoadPUSH := 16;
  TimerPUSH.Enabled := True;
end;

procedure TMainForm.actExportSalesForSuppClickExecute(Sender: TObject);
begin
  TExportSalesForSuppForm.Create(Self).Show;
end;

procedure TMainForm.miRepricePromoClick(Sender: TObject);
begin
  with TRepricePromoUnitForm.Create(Self) do
  try
     Show;
  finally
     //Free;
  end;
end;

procedure TMainForm.miReprice_testClick(Sender: TObject);
begin
  with TRepriceUnit_testForm.Create(Self) do
  try
     Show;
  finally
     //Free;
  end;
end;

procedure TMainForm.N261Click(Sender: TObject);
begin
  inherited;
  with TSearchByCaptionForm.Create(Self) do
  try
     Show;
  finally
     //Free;
  end;
end;

procedure TMainForm.TimerPUSHTimer(Sender: TObject);

  procedure Load_PUSH;
  begin
    if (FLoadPUSH > 15) and not Assigned(FPUSHThread) and not PUSHDS.Active then
    begin

      if not gc_User.Local then
      try
        Inc(FNumberPUSH);
        FPUSHThread:=TPUSHThread.Create(true);
        FPUSHThread.FreeOnTerminate:=true;
        FPUSHThread.Resume;

//        spGet_PUSH_Farmacy.ParamByName('inNumberPUSH').Value := FNumberPUSH;
//        spGet_PUSH_Farmacy.Execute;
        TimerPUSH.Interval := 10000;
      except
      end;
    end else Inc(FLoadPUSH);
  end;

begin
  TimerPUSH.Enabled := False;

  if FLoadPUSH >= 15 then TimerPUSH.Interval := 10000
  else TimerPUSH.Interval := 60 * 1000;

  try
    Load_PUSH;

    if PUSHDS.Active and (PUSHDS.RecordCount > 0) then
    begin
      PUSHDS.First;
      try
        TimerPUSH.Interval := 1000;
        if (Trim(PUSHDS.FieldByName('Text').AsString) <> '') OR (Trim(PUSHDS.FieldByName('FormName').AsString) <> '') then
        begin
          ShowPUSHMessageFarmacy(PUSHDS.FieldByName('Text').AsString,
                                 PUSHDS.FieldByName('FormName').AsString,
                                 PUSHDS.FieldByName('Button').AsString,
                                 PUSHDS.FieldByName('Params').AsString,
                                 PUSHDS.FieldByName('TypeParams').AsString,
                                 PUSHDS.FieldByName('ValueParams').AsString,
                                 PUSHDS.FieldByName('Beep').AsInteger,
                                 PUSHDS.FieldByName('SpecialLighting').AsBoolean,
                                 PUSHDS.FieldByName('TextColor').AsInteger,
                                 PUSHDS.FieldByName('Color').AsInteger,
                                 PUSHDS.FieldByName('Bold').AsBoolean,
                                 PUSHDS.FieldByName('GridData').AsString);
        end;
      finally
         PUSHDS.Delete;
      end;
    end;
  finally
    TimerPUSH.Enabled := True;
    if PUSHDS.IsEmpty and PUSHDS.Active then PUSHDS.Close;
  end;
end;

end.
