unit Report_FulfillmentPlanMobileAppAntiTOP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridBandedTableView, cxGridDBBandedTableView, cxDBEdit;

type
  TReport_FulfillmentPlanMobileAppAntiTOPForm = class(TAncestorReportForm)
    rdUnit: TRefreshDispatcher;
    dxBarButton1: TdxBarButton;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actRefreshJuridical: TdsdDataSetRefresh;
    bbMoneyBoxSun: TdxBarButton;
    UnitName: TcxGridDBColumn;
    ProcPlan: TcxGridDBColumn;
    ProcFact: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    PenaltiMobApp: TcxGridDBColumn;
    QuantityMobile: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    FormParams: TdsdFormParams;
    bbUpdate_ShowPlanMobileAppUser: TdxBarButton;
    CountShortage: TcxGridDBColumn;
    AntiTOPMP_Place: TcxGridDBColumn;
    Color_Calc: TcxGridDBColumn;
    isBold: TcxGridDBColumn;
    CountMobileAll: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_FulfillmentPlanMobileAppAntiTOPForm: TReport_FulfillmentPlanMobileAppAntiTOPForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_FulfillmentPlanMobileAppAntiTOPForm)
end.
