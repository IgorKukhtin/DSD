unit Report_SaleOLAP_Analysis;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxSplitter;

type
  TReport_SaleOLAP_AnalysisForm = class(TAncestorReportForm)
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel8: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    FormParams: TdsdFormParams;
    cbSumm_branch: TcxCheckBox;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    actRefreshIsGoodsSize: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    actRefreshIsPeriod: TdsdDataSetRefresh;
    SizeName1: TcxGridDBColumn;
    actReport_CollationByPartner: TdsdOpenForm;
    bbReport_CollationByPartner: TdxBarButton;
    cxLabel4: TcxLabel;
    edPartner: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edBrand: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPeriod: TcxButtonEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    edStartYear: TcxButtonEdit;
    edEndYear: TcxButtonEdit;
    cbMark: TcxCheckBox;
    GuidesPartner: TdsdGuides;
    GuidesPeriod: TdsdGuides;
    GuidesBrand: TdsdGuides;
    GuidesEndYear: TdsdGuides;
    GuidesStartYear: TdsdGuides;
    Persent_Sale: TcxGridDBColumn;
    Color_Grey: TcxGridDBColumn;
    cbPeriodAll: TcxCheckBox;
    cbYear: TcxCheckBox;
    Ord1: TcxGridDBColumn;
    actPrintGroup: TdsdPrintAction;
    actPrintLine: TdsdPrintAction;
    bbPrintGroup: TdxBarButton;
    bbPrintLine: TdxBarButton;
    actPrintBrand: TdsdPrintAction;
    bbPrintBrand: TdxBarButton;
    cxLabel9: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_SaleOLAP_AnalysisForm);

end.
