unit TaxJournal;

interface

uses
  DataModul, Winapi.Windows, AncestorJournal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxImageComboBox,
  cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdGuides,
  dsdAction, cxButtonEdit, cxCheckBox, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxPC,
  Vcl.Controls, MeDOC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, EDI;

type
  TTaxJournalForm = class(TAncestorJournalForm)
    colDateRegistered: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colVATPercent: TcxGridDBColumn;
    colTotalSummVAT: TcxGridDBColumn;
    colTotalSummMVAT: TcxGridDBColumn;
    colTotalSummPVAT: TcxGridDBColumn;
    colTaxKindName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colChecked: TcxGridDBColumn;
    edIsRegisterDate: TcxCheckBox;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colInvNumberPartner: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colDocument: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectTax_Client: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    spGetReporNameTax: TdsdStoredProc;
    actSPPrintTaxProcName: TdsdExecStoredProc;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    colInvNumber_Master: TcxGridDBColumn;
    colIsError: TcxGridDBColumn;
    colRegistered: TcxGridDBColumn;
    colInvNumberBranch: TcxGridDBColumn;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    spTax: TdsdStoredProc;
    MedocAction: TMedocAction;
    bbMeDoc: TdxBarButton;
    mactMeDoc: TMultiAction;
    actMedocProcedure: TdsdExecStoredProc;
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
    colIsEDI: TcxGridDBColumn;
    colIsElectron: TcxGridDBColumn;
    actElectron: TdsdExecStoredProc;
    spElectron: TdsdStoredProc;
    bbElectron: TdxBarButton;
    spDocument: TdsdStoredProc;
    actDocument: TdsdExecStoredProc;
    bbDocument: TdxBarButton;
    colContractCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    EDI: TEDI;
    spGetDirectoryName: TdsdStoredProc;
    mactMedocDECLAR: TMultiAction;
    bbSaveDeclarForMedoc: TdxBarButton;
    actGetDirectory: TdsdExecStoredProc;
    mactMEDOCList: TMultiAction;
    EDIAction: TEDIAction;
    spTaxPrint: TdsdExecStoredProc;
    colIsMedoc: TcxGridDBColumn;
    spUpdateIsMedoc: TdsdStoredProc;
    MedocListAction: TMedocAction;
    actUpdateIsMedoc: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TTaxJournalForm);
end.
