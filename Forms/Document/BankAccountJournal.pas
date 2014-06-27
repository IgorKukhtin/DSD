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
    colInfoMoney: TcxGridDBColumn;
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
    PrintHeaderCDS: TClientDataSet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    AccountCode: TcxGridDBColumn;
    AccountName_All: TcxGridDBColumn;
    ObjectCode_Direction: TcxGridDBColumn;
    ObjectName_Direction: TcxGridDBColumn;
    DescName_Direction: TcxGridDBColumn;
    ObjectCode_Destination: TcxGridDBColumn;
    ObjectName_Destination: TcxGridDBColumn;
    DescName_Destination: TcxGridDBColumn;
    JuridicalBasisName: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    AccountCode_inf: TcxGridDBColumn;
    AccountName_All_inf: TcxGridDBColumn;
    ProfitLossName_All_inf: TcxGridDBColumn;
    BusinessName_inf: TcxGridDBColumn;
    BranchName_inf: TcxGridDBColumn;
    UnitName_inf: TcxGridDBColumn;
    RouteName_inf: TcxGridDBColumn;
    OperPrice: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    SummIn: TcxGridDBColumn;
    SummOut: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
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
