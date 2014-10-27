unit TransferDebtIn;

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
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxImageComboBox;

type
  TTransferDebtInForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContractFrom: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edPaidKindFrom: TcxButtonEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    PaidKindFromGuides: TdsdGuides;
    ContractFromGuides: TdsdGuides;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colChangePercentAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    spGetReportName: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTaxCorrective_Client: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTaxCorrective: TdxBarButton;
    bbPrintTaxCorrective_Us: TdxBarButton;
    colMeasureName: TcxGridDBColumn;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel10: TcxLabel;
    edPaidKindTo: TcxButtonEdit;
    PaidKindToGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edContractTo: TcxButtonEdit;
    ContractToGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    edPartner: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesPartner: TdsdGuides;
    mactPrint: TMultiAction;
    actSPPrintProcName: TdsdExecStoredProc;
    cxLabel13: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    bbCorrective: TdxBarButton;
    spCorrective: TdsdStoredProc;
    spTaxCorrective: TdsdStoredProc;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    cxLabel14: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    edIsChecked: TcxCheckBox;
    TaxCorrectiveCDS: TClientDataSet;
    TaxCorrectiveDS: TDataSource;
    spSelectTaxCorrective: TdsdStoredProc;
    spMovementSetErasedTaxCorrective: TdsdStoredProc;
    spMovementCompleteTaxCorrective: TdsdStoredProc;
    spMovementUnCompleteTaxCorrective: TdsdStoredProc;
    gpUpdateTaxCorrective: TdsdStoredProc;
    actUnCompleteTaxCorrective: TdsdChangeMovementStatus;
    actSetErasedTaxCorrective: TdsdChangeMovementStatus;
    actCompleteTaxCorrective: TdsdChangeMovementStatus;
    bbCompleteTaxCorrective: TdxBarButton;
    bbSetErasedTaxCorrective: TdxBarButton;
    bbUnCompleteTaxCorrective: TdxBarButton;
    actTaxJournalChoice: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTransferDebtInForm);

end.
