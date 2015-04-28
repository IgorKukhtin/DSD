unit BankAccountJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, ClientBankLoad, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns;

type
  TBankAccountJournalForm = class(TAncestorJournalForm)
    colBankName: TcxGridDBColumn;
    colBankAccount: TcxGridDBColumn;
    colJuridical: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colContract: TcxGridDBColumn;
    colDebet: TcxGridDBColumn;
    colKredit: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    colInvNumber_Parent: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    clOKPO_Parent: TcxGridDBColumn;
    colPartnerBankName: TcxGridDBColumn;
    colPartnerBankMFO: TcxGridDBColumn;
    colPartnerBankAccount: TcxGridDBColumn;
    actInsertProfitLossService: TdsdInsertUpdateAction;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    colInfoMoneyName_all: TcxGridDBColumn;
    colAmountCurrency: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    ParValue: TcxGridDBColumn;
    CurrencyPartnerValue: TcxGridDBColumn;
    ParPartnerValue: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    clJuridicalName: TcxGridDBColumn;
    clMFO: TcxGridDBColumn;
    clBankSInvNumber_Parent: TcxGridDBColumn;
    spUpdate_isCopy: TdsdStoredProc;
    actIsCopy: TdsdExecStoredProc;
    bbisCopy: TdxBarButton;
    clisCopy: TcxGridDBColumn;
    mactInsertProfitLossService: TMultiAction;
    actIsCopyTrue: TdsdExecStoredProc;
    actMasterPost: TDataSetPost;
    mactIsCopy: TMultiAction;
    colUnitCode: TcxGridDBColumn;
    OKPO_BankAccount: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountJournalForm);

end.
