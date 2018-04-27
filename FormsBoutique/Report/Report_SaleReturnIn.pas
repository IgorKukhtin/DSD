unit Report_SaleReturnIn;

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
  cxImageComboBox, cxDBLabel;

type
  TReport_SaleReturnInForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    dxBarButton1: TdxBarButton;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ClientName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshSize: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    actRefreshPartner: TdsdDataSetRefresh;
    actRefreshMovement: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    spGet_Unit: TdsdStoredProc;
    StatusCode: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    bbComplete: TdxBarButton;
    bbSetErased: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    actSetErased: TdsdExecStoredProc;
    spMovementSetErased: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actPrintCheck: TdsdPrintAction;
    bbPrintCheck: TdxBarButton;
    spSelectPrint: TdsdStoredProc;
    spSelectPrint_Check: TdsdStoredProc;
    spGetReporName: TdsdStoredProc;
    actGetReportName: TdsdExecStoredProc;
    mactPrint_Check: TMultiAction;
    FormParams: TdsdFormParams;
    spGet_Printer: TdsdStoredProc;
    actGet_Printer: TdsdExecStoredProc;
    PanelNameFull: TPanel;
    DBLabelNameFull: TcxDBLabel;
    PartnerName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    spGet_PrinterNull: TdsdStoredProc;
    actGet_PrinterNull: TdsdExecStoredProc;
    mactPrint: TMultiAction;
    BarCode_item: TcxGridDBColumn;
    actPrint_BarCode: TdsdPrintAction;
    macPrint_BarCode: TMultiAction;
    spPrint_Barcode: TdsdStoredProc;
    dsdStoredProc1: TdsdStoredProc;
    dsdPrintAction1: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_SaleReturnInForm: TReport_SaleReturnInForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_SaleReturnInForm)
end.
