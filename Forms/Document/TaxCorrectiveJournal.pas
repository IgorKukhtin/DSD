unit TaxCorrectiveJournal;

interface

uses
  DataModul, Winapi.Windows, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, MeDOC, dsdAction, cxCheckBox, dsdDB, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxPC,
  Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, EDI;

type
  TTaxCorrectiveJournalForm = class(TAncestorJournalForm)
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
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colOKPO_From: TcxGridDBColumn;
    colInvNumber_Master: TcxGridDBColumn;
    colInvNumberPartner_Child: TcxGridDBColumn;
    colDocument: TcxGridDBColumn;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrintTaxCorrective_Us: TdxBarButton;
    bbPrintTaxCorrective_Client: TdxBarButton;
    colIsError: TcxGridDBColumn;
    colRegistered: TcxGridDBColumn;
    colOperDate_Child: TcxGridDBColumn;
    colInvNumberPartner_Master: TcxGridDBColumn;
    spSelectPrintTaxCorrective_Reest: TdsdStoredProc;
    actPrint_TaxCorrective_Reestr: TdsdPrintAction;
    bbPrintTaxCorrective_Reestr: TdxBarButton;
    colInvNumberBranch: TcxGridDBColumn;
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    bbMeDoc: TdxBarButton;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbactChecked: TdxBarButton;
    colIsEDI: TcxGridDBColumn;
    colIsElectron: TcxGridDBColumn;
    spElectron: TdsdStoredProc;
    actElectron: TdsdExecStoredProc;
    bbElectron: TdxBarButton;
    actDocument: TdsdExecStoredProc;
    spDocument: TdsdStoredProc;
    bbDocument: TdxBarButton;
    colContractCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    spUpdateIsMedoc: TdsdStoredProc;
    MedocCorrectiveActionList: TMedocCorrectiveAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxCorrectiveJournalForm: TTaxCorrectiveJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTaxCorrectiveJournalForm);
end.
