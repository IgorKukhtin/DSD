unit TransferDebtInJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TTransferDebtInJournalForm = class(TAncestorJournalForm)
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrint: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    spGetReportName: TdsdStoredProc;
    spSelectPrint: TdsdStoredProc;
    actSPPrintProcName: TdsdExecStoredProc;
    actPrint: TdsdPrintAction;
    mactPrint: TMultiAction;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    spCorrective: TdsdStoredProc;
    spTaxCorrective: TdsdStoredProc;
    bbTaxCorrective: TdxBarButton;
    bbCorrective: TdxBarButton;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    bbPrintTaxCorrective_Client: TdxBarButton;
    bbPrintTaxCorrective_Us: TdxBarButton;
    colInvNumberPartner: TcxGridDBColumn;
    spChecked: TdsdStoredProc;
    clChecked: TcxGridDBColumn;
    actChecked: TdsdExecStoredProc;
    bbspChecked: TdxBarButton;
    colInvNumberMark: TcxGridDBColumn;
    actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction;
    bbPrint_Return_By_TaxCorrective: TdxBarButton;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    colContractFromCode: TcxGridDBColumn;
    colContractToCode: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTransferDebtInJournalForm);
end.
