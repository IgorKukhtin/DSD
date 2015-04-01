unit Tax;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels,  cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  MeDOC, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter;

type
  TTaxForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    DocumentTaxKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    edDateRegistered: TcxDateEdit;
    cxLabel10: TcxLabel;
    edIsChecked: TcxCheckBox;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    cxLabel12: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    spGetReportName: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    mactPrint_Tax: TMultiAction;
    actPrintTax: TdsdPrintAction;
    spGetReporNameTax: TdsdStoredProc;
    actSPPrintTaxProcName: TdsdExecStoredProc;
    PrintItemsCDS: TClientDataSet;
    edIsDocument: TcxCheckBox;
    edIsRegistered: TcxCheckBox;
    HeaderSaver2: THeaderSaver;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    spSelectTax_Client: TdsdStoredProc;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    bbPrint_Us: TdxBarButton;
    edPartner: TcxButtonEdit;
    cxLabel5: TcxLabel;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel8: TcxLabel;
    edInvNumberBranch: TcxTextEdit;
    spTax: TdsdStoredProc;
    GuidesPartner: TdsdGuides;
    bbMeDoc: TdxBarButton;
    spUpdateIsMedoc: TdsdStoredProc;
    actUpdateIsMedoc: TdsdExecStoredProc;
    actInsertMaskDoc: TdsdInsertUpdateAction;
    actInsertMaskMulti: TMultiAction;
    bb: TdxBarButton;
    clGoodsGroupNameFull: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxForm: TTaxForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTaxForm);

end.
