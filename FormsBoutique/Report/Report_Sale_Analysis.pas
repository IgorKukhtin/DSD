unit Report_Sale_Analysis;

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
  cxSplitter, Vcl.StdCtrls, cxRadioGroup;

type
  TReport_Sale_AnalysisForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    dxBarButton1: TdxBarButton;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    UnitName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshSize: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    cxLabel4: TcxLabel;
    edBrand: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPartner: TcxButtonEdit;
    actRefreshPartner: TdsdDataSetRefresh;
    GuidesBrand: TdsdGuides;
    GuidesPartner: TdsdGuides;
    actRefreshMovement: TdsdDataSetRefresh;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actOpenReportTo: TdsdOpenForm;
    bbOpenReportTo: TdxBarButton;
    cxLabel7: TcxLabel;
    edPeriod: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    GuidesPeriod: TdsdGuides;
    edStartYear: TcxButtonEdit;
    edEndYear: TcxButtonEdit;
    GuidesEndYear: TdsdGuides;
    actRefreshClient: TdsdDataSetRefresh;
    GuidesStartYear: TdsdGuides;
    actPrint: TdsdPrintAction;
    actPrintIn: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintin: TdxBarButton;
    cbPeriodAll: TcxCheckBox;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ClientDataSet2: TClientDataSet;
    DataSource2: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    cxSplitter1: TcxSplitter;
    cxSale_SummCost_diff: TcxGridDBColumn;
    cbUnit: TcxCheckBox;
    edPresent1: TcxCurrencyEdit;
    edPresent2: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    cxLabel11: TcxLabel;
    Color_Calc: TcxGridDBColumn;
    cxColor_Calc: TcxGridDBColumn;
    chColor_Calc: TcxGridDBColumn;
    dsdDBViewAddOn3: TdsdDBViewAddOn;
    cbIsAmount: TcxCheckBox;
    cbIsSumm: TcxCheckBox;
    cbIsProf: TcxCheckBox;
    cxLabel10: TcxLabel;
    cxLabel12: TcxLabel;
    edPresent1_Summ: TcxCurrencyEdit;
    edPresent2_Summ: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    edPresent1_Prof: TcxCurrencyEdit;
    edPresent2_Prof: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Sale_AnalysisForm: TReport_Sale_AnalysisForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Sale_AnalysisForm)
end.
