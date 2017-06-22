unit Report_JuridicalSold;

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
  TReport_JuridicalSoldForm = class(TAncestorReportForm)
    JuridicalName: TcxGridDBColumn;
    ContractNumber: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AccountName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    StartAmount_A: TcxGridDBColumn;
    SaleSumm: TcxGridDBColumn;
    MoneySumm: TcxGridDBColumn;
    ServiceSumm: TcxGridDBColumn;
    OtherSumm: TcxGridDBColumn;
    EndAmount_A: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    dsdPrintAction: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel3: TcxLabel;
    ceInfoMoneyGroup: TcxButtonEdit;
    InfoMoneyGroupGuides: TdsdGuides;
    InfoMoneyDestinationGuides: TdsdGuides;
    ceInfoMoneyDestination: TcxButtonEdit;
    cxLabel4: TcxLabel;
    InfoMoneyGuides: TdsdGuides;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edAccount: TcxButtonEdit;
    AccountGuides: TdsdGuides;
    InfoMoneyCode: TcxGridDBColumn;
    StartAmount_P: TcxGridDBColumn;
    StartAmountD: TcxGridDBColumn;
    StartAmountK: TcxGridDBColumn;
    IncomeSumm: TcxGridDBColumn;
    ReturnOutSumm: TcxGridDBColumn;
    ReturnInSumm: TcxGridDBColumn;
    SendDebtSumm: TcxGridDBColumn;
    EndAmount_P: TcxGridDBColumn;
    EndAmount_D: TcxGridDBColumn;
    EndAmount_K: TcxGridDBColumn;
    DebetSumm: TcxGridDBColumn;
    KreditSumm: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    SaleJournal: TdsdOpenForm;
    ReturnInJournal: TdsdOpenForm;
    IncomeJournal: TdsdOpenForm;
    ReturnOutJournal: TdsdOpenForm;
    MoneyJournal: TdsdOpenForm;
    ServiceJournal: TdsdOpenForm;
    SendDebtJournal: TdsdOpenForm;
    OtherJournal: TdsdOpenForm;
    spGetDescSets: TdsdStoredProc;
    FormParams: TdsdFormParams;
    AreaName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    JuridicalGroupName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    SaleRealSumm: TcxGridDBColumn;
    ReturnInRealSumm: TcxGridDBColumn;
    TransferDebtSumm: TcxGridDBColumn;
    SaleRealJournal: TdsdOpenForm;
    ReturnInRealJournal: TdsdOpenForm;
    TransferDebtJournal: TdsdOpenForm;
    dsdPrintRealAction: TdsdPrintAction;
    bbPrintReal: TdxBarButton;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    dsdPrintReal_byJuridicalPersonal: TdsdPrintAction;
    bbPrintReal_byJuridicalPersonal: TdxBarButton;
    cxLabel9: TcxLabel;
    edJuridicalGroup: TcxButtonEdit;
    PersonalTradeName: TcxGridDBColumn;
    JuridicalGroupGuides: TdsdGuides;
    ContractConditionKindName: TcxGridDBColumn;
    ContractConditionValue: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edCurrency: TcxButtonEdit;
    CurrencyGuides: TdsdGuides;
    InfoMoneyName_all: TcxGridDBColumn;
    SaleSumm_10300: TcxGridDBColumn;
    ReturnInSumm_10300: TcxGridDBColumn;
    PriceCorrectiveSumm: TcxGridDBColumn;
    ServiceRealSumm: TcxGridDBColumn;
    PriceCorrectiveJournal: TdsdOpenForm;
    ServiceRealJournal: TdsdOpenForm;
    ChangeCurrencySumm: TcxGridDBColumn;
    CurrencyJournal: TdsdOpenForm;
    RetailName: TcxGridDBColumn;
    RetailReportName: TcxGridDBColumn;
    ContractTagGroupName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_JuridicalSoldForm)

end.
