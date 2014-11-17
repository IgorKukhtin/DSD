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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TBankAccountJournalForm = class(TAncestorJournalForm)
    colBankName: TcxGridDBColumn;
    colBankAccount: TcxGridDBColumn;
    colJuridical: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colUnit: TcxGridDBColumn;
    colContract: TcxGridDBColumn;
    colDebet: TcxGridDBColumn;
    colKredit: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    colInvNumber_Parent: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
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
