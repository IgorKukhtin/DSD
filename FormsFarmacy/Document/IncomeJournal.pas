unit IncomeJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCurrencyEdit, dsdAction, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, ExternalSave,
  dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns;

type
  TIncomeJournalForm = class(TAncestorJournalForm)
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    colTotalSumm: TcxGridDBColumn;
    ADOQueryAction1: TADOQueryAction;
    actGetDataForSend: TdsdExecStoredProc;
    mactSendOneDoc: TMultiAction;
    MultiAction2: TMultiAction;
    bbSendData: TdxBarButton;
    spGetDataForSend: TdsdStoredProc;
    colTotalSummMVAT: TcxGridDBColumn;
    colNDSKindName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colPaymentDate: TcxGridDBColumn;
    colPaySumm: TcxGridDBColumn;
    mactSendOneDocNEW: TMultiAction;
    actGetDataForSendNew: TdsdExecStoredProc;
    spGetDataForSendNew: TdsdStoredProc;
    bbNewSend: TdxBarButton;
    colSaleSumm: TcxGridDBColumn;
    colInvNumberBranch: TcxGridDBColumn;
    colBranchDate: TcxGridDBColumn;
    colChecked: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colPayColor: TcxGridDBColumn;
    colDateLastPay: TcxGridDBColumn;
    spUpdateIncome_PartnerData: TdsdStoredProc;
    mactEditPartnerData: TMultiAction;
    actPartnerDataDialod: TExecuteDialog;
    actUpdateIncome_PartnerData: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    DataSetPost1: TDataSetPost;
    spisDocument: TdsdStoredProc;
    actisDocument: TdsdExecStoredProc;
    bbisDocument: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    FromOKPO: TcxGridDBColumn;
    PaymentDays: TcxGridDBColumn;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    actPrintSticker_notPrice: TdsdPrintAction;
    bbPrintSticker_notPrice: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TIncomeJournalForm);
end.
