unit Report_Sale;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_SaleForm = class(TAncestorReportForm)
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
    cbPartion: TcxCheckBox;
    cbSize: TcxCheckBox;
    cxLabel4: TcxLabel;
    edBrand: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPartner: TcxButtonEdit;
    cbPartner: TcxCheckBox;
    actRefreshPartner: TdsdDataSetRefresh;
    GuidesBrand: TdsdGuides;
    GuidesPartner: TdsdGuides;
    actRefreshMovement: TdsdDataSetRefresh;
    cbMovement: TcxCheckBox;
    cxLabel6: TcxLabel;
    edClient: TcxButtonEdit;
    GuidesClient: TdsdGuides;
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
    cbClient: TcxCheckBox;
    actRefreshClient: TdsdDataSetRefresh;
    GuidesStartYear: TdsdGuides;
    actPrint: TdsdPrintAction;
    actPrintIn: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintin: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_SaleForm: TReport_SaleForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_SaleForm)
end.
