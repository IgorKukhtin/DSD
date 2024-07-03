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
  cxImageComboBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TReport_BankAccountForm = class(TAncestorReportForm)
    AccountName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    StartAmount: TcxGridDBColumn;
    EndAmount: TcxGridDBColumn;
    StartAmount_Currency: TcxGridDBColumn;
    EndAmount_Currency: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    bbPrint: TdxBarButton;
    InfoMoneyCode: TcxGridDBColumn;
    DebetSumm: TcxGridDBColumn;
    KreditSumm: TcxGridDBColumn;
    DebetSumm_Currency: TcxGridDBColumn;
    KreditSumm_Currency: TcxGridDBColumn;
    spGetDescSets: TdsdStoredProc;
    FormParams: TdsdFormParams;
    MoneyPlaceName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    BankName: TcxGridDBColumn;
    ceBankAccount: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesBankAccount: TdsdGuides;
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
    GuidesCurrency: TdsdGuides;
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
    Summ_pl: TcxGridDBColumn;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    GuidesJuridicalBasis: TdsdGuides;
    spGet_UseJuridicalBankAccount: TdsdStoredProc;
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
//actPrint_byElements_byComments - cashname;GroupId;InfoMoneyName_all;MoneyPlaceName;Comment
