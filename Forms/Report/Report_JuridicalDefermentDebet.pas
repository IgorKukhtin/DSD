unit Report_JuridicalDefermentDebet;

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
  cxCurrencyEdit, dsdGuides, cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, frxClass, frxDBSet, cxImageComboBox,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TReport_JuridicalDefermentDebetForm = class(TAncestorReportForm)
    JuridicalName: TcxGridDBColumn;
    ContractNumber: TcxGridDBColumn;
    KreditRemains: TcxGridDBColumn;
    DebetRemains: TcxGridDBColumn;
    SaleSumm: TcxGridDBColumn;
    SaleSumm1: TcxGridDBColumn;
    SaleSumm2: TcxGridDBColumn;
    SaleSumm3: TcxGridDBColumn;
    SaleSumm4: TcxGridDBColumn;
    SaleSumm5: TcxGridDBColumn;
    AccountName: TcxGridDBColumn;
    Condition: TcxGridDBColumn;
    edAccount: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesAccount: TdsdGuides;
    actPrintOneWeek: TdsdPrintAction;
    actPrintTwoWeek: TdsdPrintAction;
    actPrintThreeWeek: TdsdPrintAction;
    actPrintFourWeek: TdsdPrintAction;
    spReport: TdsdStoredProc;
    cdsReport: TClientDataSet;
    bbReportOneWeek: TdxBarButton;
    FormParams: TdsdFormParams;
    bbTwoWeek: TdxBarButton;
    bbThreeWeek: TdxBarButton;
    bbFourWeek: TdxBarButton;
    bbOther: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPribt: TdxBarButton;
    OKPO: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    actPrintSale: TdsdPrintAction;
    spReport_JuridicalSaleDocument: TdsdStoredProc;
    bbSale: TdxBarButton;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    StartContractDate: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    actPrint_byJuridical: TdsdPrintAction;
    bbPrint_byJuridical: TdxBarButton;
    cxLabel9: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridicalGroup: TcxButtonEdit;
    GuidesJuridicalGroup: TdsdGuides;
    RetailName_main: TcxGridDBColumn;
    ContractTagGroupName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalTradeName_Partner: TcxGridDBColumn;
    AreaName_Partner: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ContractJuridicalDocCode: TcxGridDBColumn;
    ContractJuridicalDocName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_JuridicalDefermentDebetForm);


end.
