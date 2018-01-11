
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
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    miUser: TMenuItem;
    miRole: TMenuItem;
    N20: TMenuItem;
    miAccountGroup: TMenuItem;
    miAccountDirection: TMenuItem;
    miAccount: TMenuItem;
    N24: TMenuItem;
    miInfoMoneyGroup: TMenuItem;
    miInfoMoneyDestination: TMenuItem;
    miInfoMoney: TMenuItem;
    N28: TMenuItem;
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
    N44: TMenuItem;
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
    miSale: TMenuItem;
    actBankAccount: TdsdOpenForm;
    N57: TMenuItem;
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
    N49: TMenuItem;
    miLine11: TMenuItem;
    miLine31: TMenuItem;
    N45: TMenuItem;
    miReport_Balance: TMenuItem;
    N46: TMenuItem;
    miReport_Cash: TMenuItem;
    miReport_ProfitLoss: TMenuItem;
    miGoodsAll: TMenuItem;
    miLine711: TMenuItem;
    miLine71: TMenuItem;
    miLine72: TMenuItem;
    miLine73: TMenuItem;
    miLine74: TMenuItem;
    actReport_Goods_RemainsCurrent: TdsdOpenForm;
    N6: TMenuItem;
    miReport_Goods_RemainsCurrent: TMenuItem;
    actReport_Goods: TdsdOpenForm;
    miReport_Goods: TMenuItem;
    miReport_GoodsMI_Account: TMenuItem;
    actReport_GoodsMI_Account: TdsdOpenForm;
    actReport_SaleReturnIn: TdsdOpenForm;
    miReport_SaleReturnIn: TMenuItem;
    actReport_PartnerDebt: TdsdOpenForm;
    miReport_PartnerDebt: TMenuItem;
    N58: TMenuItem;
    actGoodsAccount_ReturnIn: TdsdOpenForm;
    miGoodsAccount_ReturnIn: TMenuItem;
    actGoodsPrint: TdsdOpenForm;
    miGoodsPrint: TMenuItem;
    actReport_MotionByPartner: TdsdOpenForm;
    miReport_MotionByPartner: TMenuItem;
    actSaleMovement: TdsdOpenForm;
    actReturnInMovement: TdsdOpenForm;
    actGoodsAccountMovement: TdsdOpenForm;
    miGoodsAccountMovement: TMenuItem;
    miReturnInMovement: TMenuItem;
    miSaleMovement: TMenuItem;
    actReport_GoodsAccount_TotalError: TdsdOpenForm;
    miTotalError: TMenuItem;
    N4: TMenuItem;
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
    N1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation
uses // UploadUnloadData,
 Dialogs, Forms, SysUtils, IdGlobal
// , RepriceUnit
 ;
{$R *.dfm}

end.
