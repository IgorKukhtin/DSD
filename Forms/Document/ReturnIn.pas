unit ReturnIn;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet;

type
  TReturnInForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edTo: TcxButtonEdit;
    edFrom: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesTo: TdsdGuides;
    GuidesFrom: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    edIsChecked: TcxCheckBox;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    colHeadCount: TcxGridDBColumn;
    colAssetName: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    N2: TMenuItem;
    N3: TMenuItem;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    spGetReportName: TdsdStoredProc;
    actSPPrintProcName: TdsdExecStoredProc;
    mactPrint: TMultiAction;
    PrintItemsCDS: TClientDataSet;
    edDocumentTaxKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    DocumentTaxKindGuides: TdsdGuides;
    edPriceList: TcxButtonEdit;
    cxLabel11: TcxLabel;
    GuidesPricelist: TdsdGuides;
    spTaxCorrectiv: TdsdStoredProc;
    actTaxCorrective: TdsdExecStoredProc;
    bbTaxCorrective: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    cxLabel12: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    colMeasureName: TcxGridDBColumn;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    bbPrintTaxCorrective_Us: TdxBarButton;
    bbPrintTaxCorrective_Client: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnInForm: TReturnInForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnInForm);

end.
