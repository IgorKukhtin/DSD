unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, frxBarcode, dxSkinsdxBarPainter;

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
    N148: TMenuItem;
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
    miFiscal: TMenuItem;
    N162: TMenuItem;
    actReport_GoodsRemainsCurrent: TdsdOpenForm;
    miReport_GoodsRemainsCurrent: TMenuItem;
    actGoodsRetail: TdsdOpenForm;
    miGoodsRetail: TMenuItem;
    actGoods_NDS_diff: TdsdOpenForm;
    miGoods_NDS_diff: TMenuItem;
    N2: TMenuItem;
    actReport_Analysis_Remains_Selling: TAction;
    actReportMovementCheckFLForm: TdsdOpenForm;
    miReportMovementCheckFLForm: TMenuItem;
    actReport_ImplementationPlanEmployee: TAction;
    N3: TMenuItem;
    actReport_IncomeConsumptionBalance: TAction;
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
    procedure actSaveDataExecute(Sender: TObject);

    procedure miRepriceClick(Sender: TObject);
    procedure actExportSalesForSuppClickExecute(Sender: TObject);
    procedure actReport_Analysis_Remains_SellingExecute(Sender: TObject);
    procedure actReport_ImplementationPlanEmployeeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actReport_IncomeConsumptionBalanceExecute(Sender: TObject);
    procedure miRepriceChangeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

{$R *.dfm}

uses
  UploadUnloadData, Dialogs, Forms, SysUtils, IdGlobal, RepriceUnit, RepriceChangeRetail, ExportSalesForSupp,
  Report_Analysis_Remains_Selling, Report_ImplementationPlanEmployee,
  Report_IncomeConsumptionBalance;


procedure TMainForm.actReport_Analysis_Remains_SellingExecute(Sender: TObject);
begin
  with TReport_Analysis_Remains_SellingForm.Create(nil) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actReport_ImplementationPlanEmployeeExecute(
  Sender: TObject);
begin
  with TReport_ImplementationPlanEmployeeForm.Create(nil) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actReport_IncomeConsumptionBalanceExecute(Sender: TObject);
begin
  inherited;
  with TReport_IncomeConsumptionBalanceForm.Create(nil) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actSaveDataExecute(Sender: TObject);
begin
  with TdmUnloadUploadData.Create(nil) do
     try
       UnloadData;
     finally
       Free;
     end;

  Application.ProcessMessages;
  ShowMessage('Âûãðóçèëè');
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  inherited;

  actReport_Analysis_Remains_Selling.Visible := actReport_CheckPromo.Visible;
  actReport_IncomeConsumptionBalance.Visible := actReport_CheckPromo.Visible;
end;

procedure TMainForm.actExportSalesForSuppClickExecute(Sender: TObject);
begin
  TExportSalesForSuppForm.Create(Self).Show;
end;

procedure TMainForm.miRepriceClick(Sender: TObject);
begin
  with TRepriceUnitForm.Create(nil) do
  try
     Show;
  finally
     //Free;
  end;
end;

procedure TMainForm.miRepriceChangeClick(Sender: TObject);
begin
  with TRepriceÑhangeRetailForm.Create(nil) do
  try
     Show;
  finally
     //Free;
  end;
end;

end.
