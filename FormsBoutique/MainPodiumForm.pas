
unit MainPodiumForm;

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
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    miUser: TMenuItem;
    miRole: TMenuItem;
    miGuide_Basis: TMenuItem;
    miAccountGroup: TMenuItem;
    miAccountDirection: TMenuItem;
    miAccount: TMenuItem;
    miLine8001: TMenuItem;
    miInfoMoneyGroup: TMenuItem;
    miInfoMoneyDestination: TMenuItem;
    miInfoMoney: TMenuItem;
    miLine8002: TMenuItem;
    miProfitLossGroup: TMenuItem;
    miProfitLossDirection: TMenuItem;
    miProfitLoss: TMenuItem;
    actForms: TdsdOpenForm;
    miForms: TMenuItem;
    actMeasure: TdsdOpenForm;
    miMeasure: TMenuItem;
    actCompositionGroup: TdsdOpenForm;
    miCompositionGroup: TMenuItem;
    actComposition: TdsdOpenForm;
    miComposition: TMenuItem;
    actCountryBrand: TdsdOpenForm;
    miCountryBrand: TMenuItem;
    actBrand: TdsdOpenForm;
    miBrand: TMenuItem;
    actFabrika: TdsdOpenForm;
    miFabrika: TMenuItem;
    actGoodsInfo: TdsdOpenForm;
    miGoodsInfo: TMenuItem;
    actGoodsSize: TdsdOpenForm;
    miGoodsSize: TMenuItem;
    actGoodsGroup: TdsdOpenForm;
    miGoodsGroup: TMenuItem;
    actCurrency: TdsdOpenForm;
    miCurrency: TMenuItem;
    actMember: TdsdOpenForm;
    miMember: TMenuItem;
    actPeriod: TdsdOpenForm;
    miPeriod: TMenuItem;
    actLineFabrica: TdsdOpenForm;
    miLineFabrica: TMenuItem;
    actDiscount: TdsdOpenForm;
    miDiscount: TMenuItem;
    actDiscountTools: TdsdOpenForm;
    miDiscountTools: TMenuItem;
    actPartner: TdsdOpenForm;
    miPartner: TMenuItem;
    actJuridicalGroup: TdsdOpenForm;
    miJuridicalGroup: TMenuItem;
    actJuridical: TdsdOpenForm;
    miJuridical: TMenuItem;
    actUnit: TdsdOpenForm;
    miUnit: TMenuItem;
    actCity: TdsdOpenForm;
    miCity: TMenuItem;
    actClient: TdsdOpenForm;
    miClient: TMenuItem;
    actLabel: TdsdOpenForm;
    miLabel: TMenuItem;
    actGoods: TdsdOpenForm;
    miGoods: TMenuItem;
    actGoodsTree: TdsdOpenForm;
    mioodsTree: TMenuItem;
    catGoodsItem: TdsdOpenForm;
    miGoodsItem: TMenuItem;
    actPartionGoods: TdsdOpenForm;
    miPartionGoods: TMenuItem;
    actPosition: TdsdOpenForm;
    miPosition: TMenuItem;
    actPersonal: TdsdOpenForm;
    miPersonal: TMenuItem;
    actIncome: TdsdOpenForm;
    miMovement: TMenuItem;
    miIncome: TMenuItem;
    actReturnOut: TdsdOpenForm;
    miReturnOut: TMenuItem;
    actSend: TdsdOpenForm;
    actLoss: TdsdOpenForm;
    miSend: TMenuItem;
    miLoss: TMenuItem;
    actCurrencyMovement: TdsdOpenForm;
    miCurrencyMovement: TMenuItem;
    miLine21: TMenuItem;
    actPriceList: TdsdOpenForm;
    miPriceList: TMenuItem;
    actPriceListItem: TdsdOpenForm;
    miHistory: TMenuItem;
    miPriceListItem: TMenuItem;
    actDiscountPeriodItem: TdsdOpenForm;
    miDiscountPeriodItem: TMenuItem;
    actInventory: TdsdOpenForm;
    miInventory: TMenuItem;
    actCash: TdsdOpenForm;
    miCash: TMenuItem;
    actBank: TdsdOpenForm;
    miBank: TMenuItem;
    actSale: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    miBankAccount: TMenuItem;
    actReturnIn: TdsdOpenForm;
    miReturnIn: TMenuItem;
    actGoodsAccount: TdsdOpenForm;
    miGoodsAccount: TMenuItem;
    actReport_MovementIncome: TdsdOpenForm;
    miReport: TMenuItem;
    miReport_MovementIncome: TMenuItem;
    actReport_MovementReturnOut: TdsdOpenForm;
    miReport_MovementReturnOut: TMenuItem;
    actReport_MovementSend: TdsdOpenForm;
    miReport_MovementSend: TMenuItem;
    actReport_MovementLoss: TdsdOpenForm;
    miReport_MovementLoss: TMenuItem;
    actReport_Balance: TdsdOpenForm;
    actReport_ProfitLoss: TdsdOpenForm;
    actReport_Cash: TdsdOpenForm;
    miFinance: TMenuItem;
    miLine12: TMenuItem;
    miLine31: TMenuItem;
    miReport_Basis: TMenuItem;
    miReport_Balance: TMenuItem;
    miReport_Finance: TMenuItem;
    miReport_Cash: TMenuItem;
    miReport_ProfitLoss: TMenuItem;
    miGoodsAll: TMenuItem;
    miLine711: TMenuItem;
    miLine81: TMenuItem;
    miLine82: TMenuItem;
    miLine83: TMenuItem;
    miLine84: TMenuItem;
    actReport_Goods_RemainsCurrentPodium: TdsdOpenForm;
    miLine51: TMenuItem;
    miReport_Goods_RemainsCurrent: TMenuItem;
    actReport_Goods: TdsdOpenForm;
    miReport_GoodsCode: TMenuItem;
    miReport_GoodsMI_Account: TMenuItem;
    actReport_GoodsMI_AccountPodium: TdsdOpenForm;
    actReport_SaleReturnInPodium: TdsdOpenForm;
    miReport_SaleReturnIn: TMenuItem;
    actReport_ClientDebtPodium: TdsdOpenForm;
    miReport_PartnerDebt: TMenuItem;
    miLine61: TMenuItem;
    actGoodsAccount_ReturnIn: TdsdOpenForm;
    miGoodsAccount_ReturnIn: TMenuItem;
    actGoodsPrint: TdsdOpenForm;
    miGoodsPrint: TMenuItem;
    actReport_MotionByClient: TdsdOpenForm;
    miReport_MotionByPartner: TMenuItem;
    actSaleMovement: TdsdOpenForm;
    actReturnInMovement: TdsdOpenForm;
    actGoodsAccountMovement: TdsdOpenForm;
    miGoodsAccountMovement: TMenuItem;
    miReturnInMovement: TMenuItem;
    miSaleMovement: TMenuItem;
    actReport_GoodsAccount_TotalError: TdsdOpenForm;
    miTotalError: TMenuItem;
    miGoodsAccount_TotalError: TMenuItem;
    actReport_ReturnIn_TotalError: TdsdOpenForm;
    miReturnIn_TotalError: TMenuItem;
    actReport_Sale_TotalError: TdsdOpenForm;
    miSale_TotalError: TMenuItem;
    actReport_Client_TotalError: TdsdOpenForm;
    miObject_Client_TotalError: TMenuItem;
    actReport_Client_LastError: TdsdOpenForm;
    miObject_Client_LastError: TMenuItem;
    actReport_Sale_ContainerError: TdsdOpenForm;
    miReport_Sale_ContainerError: TMenuItem;
    actReport_CollationByClientPodium: TdsdOpenForm;
    miReport_CollationByPartner: TMenuItem;
    miReport_SaleOLAP: TMenuItem;
    actReport_SaleOLAP: TdsdOpenForm;
    miReport_Unit: TMenuItem;
    miLine11: TMenuItem;
    miLine41: TMenuItem;
    miLine42: TMenuItem;
    miLine71: TMenuItem;
    actReport_Sale: TdsdOpenForm;
    miReport_Sale: TMenuItem;
    actReport_ReturnIn: TdsdOpenForm;
    miReport_ReturnIn: TMenuItem;
    actReport_OH_DiscountPeriod: TdsdOpenForm;
    miReport_OH_DiscountPeriod: TMenuItem;
    actDiscountPeriod: TdsdOpenForm;
    miDiscountPeriod: TMenuItem;
    actIncomeKoeff: TdsdOpenForm;
    miIncomeKoeff: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    actClientSMS: TdsdOpenForm;
    miClientSMS: TMenuItem;
    actReport_GoodsCode: TdsdOpenForm;
    actReport_SaleOLAP_Analysis: TdsdOpenForm;
    miReport_SaleOLAP_Analysis: TMenuItem;
    actCashJournal: TdsdOpenForm;
    miCashJournal: TMenuItem;
    N4: TMenuItem;
    actReport_Sale_Analysis: TdsdOpenForm;
    miReport_Sale_Analysis: TMenuItem;
    N6: TMenuItem;
    actReport_Sale_AnalysisAll: TdsdOpenForm;
    miReport_Sale_AnalysisAll: TMenuItem;
    actReport_ProfitLossPeriod: TdsdOpenForm;
    miReport_ProfitLossPeriod: TMenuItem;
    actProfitLossDemo: TdsdOpenForm;
    miProfitLossDemo: TMenuItem;
    actReport_ProfitDemo: TdsdOpenForm;
    miReport_ProfitDemo: TMenuItem;
    N7: TMenuItem;
    actReport_ProfitDemoPeriod: TdsdOpenForm;
    miReport_ProfitDemoPeriod: TMenuItem;
    miImportType: TMenuItem;
    miImportSettings: TMenuItem;
    N10: TMenuItem;
    actSalePodium: TdsdOpenForm;
    miSalePodium: TMenuItem;
    actReport_MotionOLAP: TdsdOpenForm;
    miReport_MotionOLAP: TMenuItem;
    actPriceListItem_Currency: TdsdOpenForm;
    miPriceListItem_Currency: TMenuItem;
    actGoodsTag: TdsdOpenForm;
    miGoodsTag: TMenuItem;
    actReport_Goods_RemainsCurrent_onDate: TdsdOpenForm;
    miReport_Goods_RemainsCurrent_onDate: TMenuItem;
    N3: TMenuItem;
    actReturnInPodium: TdsdOpenForm;
    actGoodsAccountPodium: TdsdOpenForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses Dialogs, Forms, SysUtils, IdGlobal
 ;
{$R *.dfm}

end.
