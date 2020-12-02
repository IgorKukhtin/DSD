
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
    actCountry: TdsdOpenForm;
    miCountryBrand: TMenuItem;
    actBrand: TdsdOpenForm;
    actGoodsSize: TdsdOpenForm;
    miGoodsSize: TMenuItem;
    actGoodsGroup: TdsdOpenForm;
    miGoodsGroup: TMenuItem;
    actCurrency: TdsdOpenForm;
    miCurrency: TMenuItem;
    actMember: TdsdOpenForm;
    miMember: TMenuItem;
    actPartner: TdsdOpenForm;
    miPartner: TMenuItem;
    actUnit: TdsdOpenForm;
    miUnit: TMenuItem;
    actClient: TdsdOpenForm;
    miClient: TMenuItem;
    actGoods: TdsdOpenForm;
    miGoods: TMenuItem;
    actGoodsTree: TdsdOpenForm;
    miGoodsTree: TMenuItem;
    actPartionGoods: TdsdOpenForm;
    miPartionGoods: TMenuItem;
    actPosition: TdsdOpenForm;
    miPosition: TMenuItem;
    actPersonal: TdsdOpenForm;
    miPersonal: TMenuItem;
    actIncome: TdsdOpenForm;
    miMovement: TMenuItem;
    miIncome: TMenuItem;
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
    actDiscountItem: TdsdOpenForm;
    miDiscountItem: TMenuItem;
    actInventory: TdsdOpenForm;
    miInventory: TMenuItem;
    actCash: TdsdOpenForm;
    miCash: TMenuItem;
    actBank: TdsdOpenForm;
    miBank: TMenuItem;
    actSale: TdsdOpenForm;
    miSale: TMenuItem;
    actBankAccount: TdsdOpenForm;
    miBankAccount: TMenuItem;
    miBankAccountJournal: TMenuItem;
    actReport_Income: TdsdOpenForm;
    miReport: TMenuItem;
    miReport_Income: TMenuItem;
    actReport_Send: TdsdOpenForm;
    miReport_Send: TMenuItem;
    actReport_Loss: TdsdOpenForm;
    miReport_MovementLoss: TMenuItem;
    actReport_Balance: TdsdOpenForm;
    actReport_ProfitLoss: TdsdOpenForm;
    actReport_Cash: TdsdOpenForm;
    miFinance: TMenuItem;
    miLine13: TMenuItem;
    miLine31: TMenuItem;
    miReport_Basis: TMenuItem;
    miReport_Balance: TMenuItem;
    miReport_Finance: TMenuItem;
    miReport_Cash: TMenuItem;
    miReport_ProfitLoss: TMenuItem;
    miLine81: TMenuItem;
    miLine82: TMenuItem;
    miLine83: TMenuItem;
    miLine84: TMenuItem;
    actReport_Remains_curr: TdsdOpenForm;
    miLine51: TMenuItem;
    miReport_Remains_curr_prod: TMenuItem;
    miReport_GoodsCode: TMenuItem;
    actReport_Account: TdsdOpenForm;
    miReport_ProductionOLAP: TMenuItem;
    miLine61: TMenuItem;
    actReport_MotionByClient: TdsdOpenForm;
    miReport_MotionByPartner: TMenuItem;
    miProduction: TMenuItem;
    actReport_CollationByClient: TdsdOpenForm;
    miReport_CollationByPartner: TMenuItem;
    miReport_SaleOLAP: TMenuItem;
    actReport_SaleOLAP: TdsdOpenForm;
    miReport_Unit: TMenuItem;
    miLine12: TMenuItem;
    miLine41: TMenuItem;
    miLine71: TMenuItem;
    actReport_Sale: TdsdOpenForm;
    miReport_Sale: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    actReport_GoodsCode: TdsdOpenForm;
    miReport_SaleOLAP_Analysis: TMenuItem;
    actCashJournal: TdsdOpenForm;
    miCashJournal: TMenuItem;
    N4: TMenuItem;
    miReport_Sale_Analysis: TMenuItem;
    N6: TMenuItem;
    actReport_ProfitLossPeriod: TdsdOpenForm;
    miReport_ProfitLossPeriod: TMenuItem;
    N7: TMenuItem;
    miImportType: TMenuItem;
    miImportSettings: TMenuItem;
    N10: TMenuItem;
    actReport_Remains_onDate: TdsdOpenForm;
    actReport_Remains_onDate_prod: TMenuItem;
    actBankAccountJournal: TdsdOpenForm;
    miLine11: TMenuItem;
    actOrderClient: TdsdOpenForm;
    actOrderPartner: TdsdOpenForm;
    actOrderProduction: TdsdOpenForm;
    miOrderPartner: TMenuItem;
    miOrderClient: TMenuItem;
    miOrderProduction: TMenuItem;
    actProductionUnion: TdsdOpenForm;
    miProductionUnion: TMenuItem;
    actReport_ProductionOLAP: TdsdOpenForm;
    N3: TMenuItem;
    miReport_Remains_curr: TMenuItem;
    miReport_Remains_onDate: TMenuItem;
    actLanguage: TdsdOpenForm;
    actTranslateWord: TdsdOpenForm;
    miLanguage: TMenuItem;
    miTranslateWord: TMenuItem;
    miBoat: TMenuItem;
    miLine21_: TMenuItem;
    miProdColorItems: TMenuItem;
    miLine32_: TMenuItem;
    miProdOptions: TMenuItem;
    miProdOptItems: TMenuItem;
    miReceipt: TMenuItem;
    actProduct: TdsdOpenForm;
    actProdColorGroup: TdsdOpenForm;
    actProdColor: TdsdOpenForm;
    actProdColorItems: TdsdOpenForm;
    actProdOptions: TdsdOpenForm;
    actProdOptItems: TdsdOpenForm;
    actProdModel: TdsdOpenForm;
    actProdGroup: TdsdOpenForm;
    actProdEngine: TdsdOpenForm;
    actReceipt: TdsdOpenForm;
    miProduct: TMenuItem;
    miProdGroup: TMenuItem;
    miLine31_: TMenuItem;
    miProdColorGroup: TMenuItem;
    miProdColor: TMenuItem;
    miBrand: TMenuItem;
    miProdModel: TMenuItem;
    miProdEngine: TMenuItem;
    actProdColorPattern: TdsdOpenForm;
    actProdOptPattern: TdsdOpenForm;
    miProdColorPattern: TMenuItem;
    miProdOptPattern: TMenuItem;
    actPLZ: TdsdOpenForm;
    miPLZ: TMenuItem;
    actModelEtiketen: TdsdOpenForm;
    miModelEtiketen: TMenuItem;
    N5: TMenuItem;
    actReceiptProdModel: TdsdOpenForm;
    miReceiptProdModel: TMenuItem;
    N8: TMenuItem;
    actReceiptGoods: TdsdOpenForm;
    miReceiptGoods: TMenuItem;
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
