
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
    actCashTree: TdsdOpenForm;
    miCashTree: TMenuItem;
    actCommentMoveMoney: TdsdOpenForm;
    actCommentInfoMoney: TdsdOpenForm;
    miCommentInfoMoney: TMenuItem;
    miCommentMoveMoney: TMenuItem;
    N2: TMenuItem;
    actInfoMoneyDetail: TdsdOpenForm;
    miInfoMoneyDetail: TMenuItem;
    actInfoMoneyTree: TdsdOpenForm;
    N4: TMenuItem;
    miInfoMoney: TMenuItem;
    miInfoMoneyTree: TMenuItem;
    actServiceItem: TdsdOpenForm;
    miServiceItem: TMenuItem;
    actServiceJournal: TdsdOpenForm;
    miServiceJournal: TMenuItem;
    actCashJournal_in: TdsdOpenForm;
    actCashJournal_out: TdsdOpenForm;
    miCashJournal_out: TMenuItem;
    miCashJournal_in: TMenuItem;
    N5: TMenuItem;
    actCashChildJournal_in: TdsdOpenForm;
    actCashChildJournal_out: TdsdOpenForm;
    miCashChildJournal_in: TMenuItem;
    miCashChildJournal_out: TMenuItem;
    N6: TMenuItem;
    actCashSendJournal: TdsdOpenForm;
    miCashSendJournal: TMenuItem;
    N7: TMenuItem;
    actReport_UnitRent: TdsdOpenForm;
    miReport_UnitRent: TMenuItem;
    actReport_UnitBalance: TdsdOpenForm;
    miReport_UnitBalance: TMenuItem;
    actReport_CashBalance: TdsdOpenForm;
    N9: TMenuItem;
    actCurrencyJournal: TdsdOpenForm;
    miCurrencyJournal: TMenuItem;
    N10: TMenuItem;
    actServiceItemJournal: TdsdOpenForm;
    miServiceItemJournal: TMenuItem;
    actServiceItemUpdate: TdsdOpenForm;
    miServiceItemUpdate: TMenuItem;
    actServiceItemAddJournal: TdsdOpenForm;
    miServiceItemAddJournal: TMenuItem;
    actServiceItemAddUpdate: TdsdOpenForm;
    miServiceItemAddUpdate: TMenuItem;
    N3: TMenuItem;
    N8: TMenuItem;
    actReport_UnitRent_service: TdsdOpenForm;
    miReport_UnitRent_service: TMenuItem;
    N11: TMenuItem;
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
