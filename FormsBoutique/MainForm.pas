
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
    actForms: TdsdOpenForm;
    N74: TMenuItem;
    actMeasure: TdsdOpenForm;
    N1: TMenuItem;
    actCompositionGroup: TdsdOpenForm;
    N4: TMenuItem;
    actComposition: TdsdOpenForm;
    N5: TMenuItem;
    actCountryBrand: TdsdOpenForm;
    N7: TMenuItem;
    actBrand: TdsdOpenForm;
    N8: TMenuItem;
    actFabrika: TdsdOpenForm;
    N9: TMenuItem;
    actGoodsInfo: TdsdOpenForm;
    N10: TMenuItem;
    actGoodsSize: TdsdOpenForm;
    N11: TMenuItem;
    actGoodsGroup: TdsdOpenForm;
    N12: TMenuItem;
    actCurrency: TdsdOpenForm;
    N14: TMenuItem;
    actMember: TdsdOpenForm;
    N15: TMenuItem;
    actPeriod: TdsdOpenForm;
    N16: TMenuItem;
    actLineFabrica: TdsdOpenForm;
    N17: TMenuItem;
    actDiscount: TdsdOpenForm;
    N18: TMenuItem;
    actDiscountTools: TdsdOpenForm;
    N19: TMenuItem;
    actPartner: TdsdOpenForm;
    c1: TMenuItem;
    actJuridicalGroup: TdsdOpenForm;
    N32: TMenuItem;
    actJuridical: TdsdOpenForm;
    N33: TMenuItem;
    actUnit: TdsdOpenForm;
    N34: TMenuItem;
    actCity: TdsdOpenForm;
    N35: TMenuItem;
    actClient: TdsdOpenForm;
    N36: TMenuItem;
    actLabel: TdsdOpenForm;
    N37: TMenuItem;
    actGoods: TdsdOpenForm;
    N38: TMenuItem;
    actGoodsTree: TdsdOpenForm;
    N39: TMenuItem;
    catGoodsItem: TdsdOpenForm;
    N40: TMenuItem;
    actPartionGoods: TdsdOpenForm;
    N41: TMenuItem;
    actPosition: TdsdOpenForm;
    N42: TMenuItem;
    actPersonal: TdsdOpenForm;
    N43: TMenuItem;
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
    N51: TMenuItem;
    actPriceListItem: TdsdOpenForm;
    miHistory: TMenuItem;
    N52: TMenuItem;
    actDiscountPeriodItem: TdsdOpenForm;
    N53: TMenuItem;
    actInventory: TdsdOpenForm;
    miInventory: TMenuItem;
    actCash: TdsdOpenForm;
    N13: TMenuItem;
    actBank: TdsdOpenForm;
    N55: TMenuItem;
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
    N60: TMenuItem;
    actReport_MovementReturnOut: TdsdOpenForm;
    N61: TMenuItem;
    actReport_MovementSend: TdsdOpenForm;
    N62: TMenuItem;
    actReport_MovementLoss: TdsdOpenForm;
    N63: TMenuItem;
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
    N47: TMenuItem;
    actReport_Goods: TdsdOpenForm;
    N48: TMenuItem;
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
