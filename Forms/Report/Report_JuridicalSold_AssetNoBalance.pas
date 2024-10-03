unit Report_JuridicalSold_AssetNoBalance;

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
  cxImageComboBox, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_JuridicalSold_AssetNoBalanceForm = class(TAncestorReportForm)
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
    GuidesPaidKind: TdsdGuides;
    JuridicalGroupName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    SaleRealSumm: TcxGridDBColumn;
    ReturnInRealSumm: TcxGridDBColumn;
    TransferDebtSumm: TcxGridDBColumn;
    SaleRealJournal: TdsdOpenForm;
    ReturnInRealJournal: TdsdOpenForm;
    TransferDebtJournal: TdsdOpenForm;
    actPrintSale: TdsdPrintAction;
    bbPrintSale: TdxBarButton;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    actPrintSalePartner: TdsdPrintAction;
    bbPrintSalePartner: TdxBarButton;
    cxLabel9: TcxLabel;
    edJuridicalGroup: TcxButtonEdit;
    PersonalTradeName: TcxGridDBColumn;
    GuidesJuridicalGroup: TdsdGuides;
    ContractConditionKindName: TcxGridDBColumn;
    ContractConditionValue: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
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
    PersonalTradeName_Partner: TcxGridDBColumn;
    AreaName_Partner: TcxGridDBColumn;
    JuridicalPartnerlName: TcxGridDBColumn;
    actPrintIncome: TdsdPrintAction;
    actPrintIncomePartner: TdsdPrintAction;
    bbPrintIncome: TdxBarButton;
    bbPrintIncomePartner: TdxBarButton;
    PartionMovementName: TcxGridDBColumn;
    PaymentDate: TcxGridDBColumn;
    SaleRealSumm_total: TcxGridDBColumn;
    ReturnInRealSumm_total: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cbPartionMovement: TcxCheckBox;
    ContractJuridicalDocCode: TcxGridDBColumn;
    ContractJuridicalDocName: TcxGridDBColumn;
    actPrintIncomePartnerService: TdsdPrintAction;
    bbPrintIncomePartnerService: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    spSavePrintObject: TdsdStoredProc;
    actSPSaveObject: TdsdExecStoredProc;
    spJuridicalBalance: TdsdStoredProc;
    actPrintReportCollation11: TdsdPrintAction;
    macPrintReportCollation: TMultiAction;
    bbPrintReportCollation: TdxBarButton;
    spReport_JuridicalCollation: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actReport_JuridicalCollation: TdsdExecStoredProc;
    actJuridicalBalance: TdsdExecStoredProc;
    actPrintReportCollation: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_JuridicalSold_AssetNoBalanceForm)

end.
