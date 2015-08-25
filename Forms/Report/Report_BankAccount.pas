unit Report_BankAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxImageComboBox;

type
  TReport_BankAccountForm = class(TAncestorReportForm)
    colAccountName: TcxGridDBColumn;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    StartAmount: TcxGridDBColumn;
    EndAmount: TcxGridDBColumn;
    StartAmount_Currency: TcxGridDBColumn;
    EndAmount_Currency: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    bbPrint: TdxBarButton;
    colInfoMoneyCode: TcxGridDBColumn;
    colDebetSumm: TcxGridDBColumn;
    colKreditSumm: TcxGridDBColumn;
    colDebetSumm_Currency: TcxGridDBColumn;
    colKreditSumm_Currency: TcxGridDBColumn;
    spGetDescSets: TdsdStoredProc;
    FormParams: TdsdFormParams;
    MoneyPlaceName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edAccount: TcxButtonEdit;
    AccountGuides: TdsdGuides;
    BankName: TcxGridDBColumn;
    ceBankAccount: TcxButtonEdit;
    cxLabel4: TcxLabel;
    BankAccountGuides: TdsdGuides;
    ContractInvNumber: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    StartAmountD: TcxGridDBColumn;
    StartAmountK: TcxGridDBColumn;
    EndAmountD: TcxGridDBColumn;
    EndAmountK: TcxGridDBColumn;
    StartAmountD_Currency: TcxGridDBColumn;
    StartAmountK_Currency: TcxGridDBColumn;
    EndAmountD_Currency: TcxGridDBColumn;
    EndAmountK_Currency: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edCurrency: TcxButtonEdit;
    CurrencyGuides: TdsdGuides;
    CurrencyName: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    Summ_Currency: TcxGridDBColumn;
    CurrencyName_BankAccount: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    ProfitLossGroupCode: TcxGridDBColumn;
    ProfitLossGroupName: TcxGridDBColumn;
    ProfitLossDirectionCode: TcxGridDBColumn;
    ProfitLossDirectionName: TcxGridDBColumn;
    actPrint_byElements: TdsdPrintAction;
    actPrint_byElements_byComments: TdsdPrintAction;
    bbPrint_byElements: TdxBarButton;
    bbPrint_byElements_byComments: TdxBarButton;
    CashName: TcxGridDBColumn;
    GroupId: TcxGridDBColumn;
    GroupName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_BankAccountForm)

end.
