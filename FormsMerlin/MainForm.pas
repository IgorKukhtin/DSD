
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
    actForms: TdsdOpenForm;
    miForms: TMenuItem;
    actCurrency: TdsdOpenForm;
    miCurrency: TMenuItem;
    actMember: TdsdOpenForm;
    miMember: TMenuItem;
    actUnitTree: TdsdOpenForm;
    miUnit: TMenuItem;
    miPosition: TMenuItem;
    miPersonal: TMenuItem;
    miMovement: TMenuItem;
    miPriceList: TMenuItem;
    miHistory: TMenuItem;
    actCash: TdsdOpenForm;
    miCash: TMenuItem;
    actBank: TdsdOpenForm;
    miBank: TMenuItem;
    actBankAccount: TdsdOpenForm;
    miBankAccount: TMenuItem;
    miReport: TMenuItem;
    miLine83: TMenuItem;
    miLine84: TMenuItem;
    miImportType: TMenuItem;
    miImportSettings: TMenuItem;
    actLanguage: TdsdOpenForm;
    actTranslateWord: TdsdOpenForm;
    actProdColorKind: TdsdOpenForm;
    actTranslateMessage: TdsdOpenForm;
    actTaxKindEdit: TdsdOpenForm;
    actReport_Goods: TdsdOpenForm;
    actDocTag: TdsdOpenForm;
    actUnit: TdsdOpenForm;
    N1: TMenuItem;
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
