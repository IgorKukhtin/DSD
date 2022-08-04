unit ReturnOutJournal;

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
  TReturnOutJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    TotalSumm: TcxGridDBColumn;
    ADOQueryAction1: TADOQueryAction;
    actGetDataForSend: TdsdExecStoredProc;
    mactSendOneDoc: TMultiAction;
    MultiAction2: TMultiAction;
    bbSendData: TdxBarButton;
    spGetDataForSend: TdsdStoredProc;
    TotalSummMVAT: TcxGridDBColumn;
    NDSKindName: TcxGridDBColumn;
    mactInsert: TMultiAction;
    actReturnOutMovementInsert: TdsdExecStoredProc;
    spInsertMovement: TdsdStoredProc;
    actChoiceIncomeMovement: TOpenChoiceForm;
    JuridicalName: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    IncomeOperDate: TcxGridDBColumn;
    IncomeInvNumber: TcxGridDBColumn;
    ReturnTypeName: TcxGridDBColumn;
    mactEditPartnerData: TMultiAction;
    actPartnerDataDialog: TExecuteDialog;
    actUpdateReturnOut_PartnerData: TdsdExecStoredProc;
    spUpdateReturnOut_PartnerData: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    DataSetPost1: TDataSetPost;
    ExecuteDialog: TExecuteDialog;
    AdjustingOurDate: TcxGridDBColumn;
    actPrintTTN: TdsdPrintAction;
    BranchUser: TcxGridDBColumn;
    actPUSHMessage: TdsdShowPUSHMessage;
    spPUSHInfo: TdsdStoredProc;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    isDeferred: TcxGridDBColumn;
    actPrintOptima: TdsdPrintAction;
    bbPrintOptima: TdxBarButton;
    actPrintFilter: TdsdPrintAction;
    macPrintFilter: TMultiAction;
    actDirectoryDialog: TFileDialogAction;
    bbPrintFilter: TdxBarButton;
    macPrintFilterXLS: TMultiAction;
    actPrintFilterXLS: TdsdPrintAction;
    bbPrintFilterXLS: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReturnOutJournalForm);
end.
