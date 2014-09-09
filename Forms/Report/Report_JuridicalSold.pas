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
    colJuridicalName: TcxGridDBColumn;
    colContractNumber: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colAccountName: TcxGridDBColumn;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colStartAmount_A: TcxGridDBColumn;
    colSaleSumm: TcxGridDBColumn;
    colMoneySumm: TcxGridDBColumn;
    colServiceSumm: TcxGridDBColumn;
    colOtherSumm: TcxGridDBColumn;
    colEndAmount_A: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
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
    colInfoMoneyCode: TcxGridDBColumn;
    colStartAmount_P: TcxGridDBColumn;
    colStartAmountD: TcxGridDBColumn;
    colStartAmountK: TcxGridDBColumn;
    colIncomeSumm: TcxGridDBColumn;
    colReturnOutSumm: TcxGridDBColumn;
    colReturnInSumm: TcxGridDBColumn;
    colSendDebtSumm: TcxGridDBColumn;
    colEndAmount_P: TcxGridDBColumn;
    colEndAmount_D: TcxGridDBColumn;
    colEndAmount_K: TcxGridDBColumn;
    colDebetSumm: TcxGridDBColumn;
    colKreditSumm: TcxGridDBColumn;
    colContractCode: TcxGridDBColumn;
    colJuridicalCode: TcxGridDBColumn;
    colOKPO: TcxGridDBColumn;
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
    colAreaName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    clJuridicalGroupName: TcxGridDBColumn;
    clPartnerCode: TcxGridDBColumn;
    clPartnerName: TcxGridDBColumn;
    colSaleRealSumm: TcxGridDBColumn;
    colReturnInRealSumm: TcxGridDBColumn;
    colTransferDebtSumm: TcxGridDBColumn;
    SaleRealJournal: TdsdOpenForm;
    ReturnInRealJournal: TdsdOpenForm;
    TransferDebtJournal: TdsdOpenForm;
    dsdPrintRealAction: TdsdPrintAction;
    bbPrintReal: TdxBarButton;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
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
