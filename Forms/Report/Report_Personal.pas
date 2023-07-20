unit Report_Personal;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_PersonalForm = class(TAncestorReportForm)
    AccountName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    StartAmount: TcxGridDBColumn;
    EndAmount: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    dsdPrintAction: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel3: TcxLabel;
    ceInfoMoneyGroup: TcxButtonEdit;
    GuidesInfoMoneyGroup: TdsdGuides;
    GuidesInfoMoneyDestination: TdsdGuides;
    ceInfoMoneyDestination: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesInfoMoney: TdsdGuides;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    InfoMoneyCode: TcxGridDBColumn;
    DebetSumm: TcxGridDBColumn;
    KreditSumm: TcxGridDBColumn;
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
    SaleRealJournal: TdsdOpenForm;
    ReturnInRealJournal: TdsdOpenForm;
    TransferDebtJournal: TdsdOpenForm;
    dsdPrintRealAction: TdsdPrintAction;
    bbPrintReal: TdxBarButton;
    ceBranch: TcxButtonEdit;
    cxLabel7: TcxLabel;
    GuidesBranch: TdsdGuides;
    BranchName: TcxGridDBColumn;
    ServiceDate: TcxGridDBColumn;
    cbServiceDate: TcxCheckBox;
    deServiceDate: TcxDateEdit;
    StartAmountD: TcxGridDBColumn;
    StartAmountK: TcxGridDBColumn;
    EndAmountD: TcxGridDBColumn;
    EndAmountK: TcxGridDBColumn;
    MoneySumm: TcxGridDBColumn;
    ServiceSumm: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PositionCode: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    PersonalServiceListCode: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    IncomeSumm: TcxGridDBColumn;
    SummTransportAdd: TcxGridDBColumn;
    SummTransportAddLong: TcxGridDBColumn;
    SummTransportTaxi: TcxGridDBColumn;
    SummPhone: TcxGridDBColumn;
    SummNalog: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    cePersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    cxLabel9: TcxLabel;
    cePersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    MoneySummCard: TcxGridDBColumn;
    MoneySummCardSecond: TcxGridDBColumn;
    MoneySummCash: TcxGridDBColumn;
    SummNalogRet: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    SummHoliday_inf: TcxGridDBColumn;
    cbMember: TcxCheckBox;
    actRefMember: TdsdDataSetRefresh;
    actOpenReportForm_MoneySumm: TdsdOpenForm;
    bbOpenReportForm_MoneySumm: TdxBarButton;
    actOpenReportForm_ServiceSumm: TdsdOpenForm;
    bbOpenReportForm_ServiceSumm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_PersonalForm)

end.
