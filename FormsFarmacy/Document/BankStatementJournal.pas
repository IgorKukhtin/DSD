unit BankStatementJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, DataModul, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, ClientBankLoad, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, ExternalLoad;

type
  TBankStatementJournalForm = class(TAncestorJournalForm)
    BankName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    BankPrivatLoad: TClientBankLoadAction;
    BankUkrEximLoad: TClientBankLoadAction;
    BankVostokLoad: TClientBankLoadAction;
    BankFidoLoad: TClientBankLoadAction;
    bbBankPrivat: TdxBarButton;
    bbBankVostok: TdxBarButton;
    bbBankForum: TdxBarButton;
    bbBankErnst: TdxBarButton;
    BankPrivat: TMultiAction;
    BankUkrExim: TMultiAction;
    BankVostok: TMultiAction;
    BankFido: TMultiAction;
    Amount: TcxGridDBColumn;
    Debet: TcxGridDBColumn;
    Kredit: TcxGridDBColumn;
    BankOTPLoad: TClientBankLoadAction;
    BankOTP: TMultiAction;
    bbOTPLoad: TdxBarButton;
    bbPireus: TdxBarButton;
    BankPireus: TMultiAction;
    BankPireusLoad: TClientBankLoadAction;
    BankPireusDBF: TMultiAction;
    BankPireusDBFLoad: TClientBankLoadAction;
    bbPireusDBFLoad: TdxBarButton;
    BankMarfinLoad: TClientBankLoadAction;
    BankMarfin: TMultiAction;
    bbMarfinLoad: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankStatementJournalForm);

end.
