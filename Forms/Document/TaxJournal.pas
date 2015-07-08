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
    actGetReporNameTax: TdsdExecStoredProc;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    colInvNumber_Master: TcxGridDBColumn;
    colIsError: TcxGridDBColumn;
    colInvNumberBranch: TcxGridDBColumn;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    spTax: TdsdStoredProc;
    MedocAction: TMedocAction;
    bbMeDoc: TdxBarButton;
    mactMeDoc: TMultiAction;
    actSelectTax_Medoc: TdsdExecStoredProc;
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
    actSelectTax_Medoc_list: TdsdExecStoredProc;
    colIsMedoc: TcxGridDBColumn;
    spUpdateIsMedoc: TdsdStoredProc;
    MedocListAction: TMedocAction;
    actUpdateIsMedoc: TdsdExecStoredProc;
    actInsertMaskMulti: TMultiAction;
    actMedocFalse: TdsdExecStoredProc;
    spMedoc_False: TdsdStoredProc;
    bbMedocFalse: TdxBarButton;
    colRegisteredNumber: TcxGridDBColumn;
    cxTextEdit1: TcxTextEdit;
    edLoadData: TcxDateEdit;
    spGetInfo: TdsdStoredProc;
    spSelectTax_Medoc: TdsdStoredProc;
    edPeriod: TcxDateEdit;
    cxTextEdit2: TcxTextEdit;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Comment: TcxGridDBColumn;
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
