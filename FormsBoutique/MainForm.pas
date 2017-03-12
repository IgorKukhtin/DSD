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
    N6: TMenuItem;
    miRole: TMenuItem;
    miImportExportLink: TMenuItem;
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
    actKassa: TdsdOpenForm;
    N13: TMenuItem;
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
