unit Report_DefermentPaymentMovement;

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
  TReport_DefermentPaymentMovementForm = class(TAncestorReportForm)
    JuridicalName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    DebetRemains: TcxGridDBColumn;
    SaleSumm: TcxGridDBColumn;
    DefermentPaymentRemains: TcxGridDBColumn;
    SaleSumm_month: TcxGridDBColumn;
    DebtRemains_month: TcxGridDBColumn;
    DefermentPaymentRemains_month: TcxGridDBColumn;
    AccountName: TcxGridDBColumn;
    Condition: TcxGridDBColumn;
    edAccount: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesAccount: TdsdGuides;
    bbReportOneWeek: TdxBarButton;
    FormParams: TdsdFormParams;
    bbTwoWeek: TdxBarButton;
    bbThreeWeek: TdxBarButton;
    bbFourWeek: TdxBarButton;
    bbOther: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPribt: TdxBarButton;
    ContractCode: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    MonthDate: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    bbSale: TdxBarButton;
    cxLabel6: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesedRetail: TdsdGuides;
    PartnerCode: TcxGridDBColumn;
    bbPrint_byJuridical: TdxBarButton;
    cxLabel9: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    RetailName: TcxGridDBColumn;
    ContractTagGroupName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbUpdate_LastPayment: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_DefermentPaymentMovementForm);


end.
