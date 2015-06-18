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
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel3: TcxLabel;
    edInfoMoneyGroup: TcxButtonEdit;
    GuidesInfoMoneyGroup: TdsdGuides;
    GuidesInfoMoneyDestination: TdsdGuides;
    edInfoMoneyDestination: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesInfoMoney: TdsdGuides;
    edInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
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
    GuidesPaidKind: TdsdGuides;
    clJuridicalGroupName: TcxGridDBColumn;
    clPartnerCode: TcxGridDBColumn;
    clPartnerName: TcxGridDBColumn;
    colSaleRealSumm: TcxGridDBColumn;
    colReturnInRealSumm: TcxGridDBColumn;
    colTransferDebtSumm: TcxGridDBColumn;
    SaleRealJournal: TdsdOpenForm;
    ReturnInRealJournal: TdsdOpenForm;
    TransferDebtJournal: TdsdOpenForm;
    actPrintSale: TdsdPrintAction;
    bbPrintSale: TdxBarButton;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    actPrintSalePartner: TdsdPrintAction;
    bbPrintSalePartner: TdxBarButton;
    cxLabel9: TcxLabel;
    edJuridicalGroup: TcxButtonEdit;
    clPersonalTradeName: TcxGridDBColumn;
    GuidesJuridicalGroup: TdsdGuides;
    colContractConditionKindName: TcxGridDBColumn;
    colContractConditionValue: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
    InfoMoneyName_all: TcxGridDBColumn;
    SaleSumm_10300: TcxGridDBColumn;
    ReturnInSumm_10300: TcxGridDBColumn;
    colPriceCorrectiveSumm: TcxGridDBColumn;
    colServiceRealSumm: TcxGridDBColumn;
    PriceCorrectiveJournal: TdsdOpenForm;
    ServiceRealJournal: TdsdOpenForm;
    colChangeCurrencySumm: TcxGridDBColumn;
    CurrencyJournal: TdsdOpenForm;
    clRetailName: TcxGridDBColumn;
    clRetailReportName: TcxGridDBColumn;
    clContractTagGroupName: TcxGridDBColumn;
    colPersonalTradeName_Partner: TcxGridDBColumn;
    colAreaName_Partner: TcxGridDBColumn;
    JuridicalPartnerlName: TcxGridDBColumn;
    actPrintIncome: TdsdPrintAction;
    actPrintIncomePartner: TdsdPrintAction;
    bbPrintIncome: TdxBarButton;
    bbPrintIncomePartner: TdxBarButton;
    clPartionMovementName: TcxGridDBColumn;
    clPaymentDate: TcxGridDBColumn;
    SaleRealSumm_total: TcxGridDBColumn;
    ReturnInRealSumm_total: TcxGridDBColumn;
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
