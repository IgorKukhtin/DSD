unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, dxSkinsdxBarPainter;

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
    dsdOpenForm2: TdsdOpenForm;
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
    N41: TMenuItem;
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
    N70: TMenuItem;
    procedure actSaveDataExecute(Sender: TObject);
    procedure miRepriceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses UploadUnloadData, Dialogs, Forms, SysUtils, IdGlobal, RepriceUnit;
{$R *.dfm}

procedure TMainForm.actSaveDataExecute(Sender: TObject);
begin
  with TdmUnloadUploadData.Create(nil) do
     try
       UnloadData;
     finally
       Free;
     end;

  Application.ProcessMessages;
  ShowMessage('���������');
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

end.
