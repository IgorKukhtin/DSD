unit Report_MovementCheck_UnLiquid;

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
  dxSkinsdxBarPainter, cxCheckBox, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_MovementCheck_UnLiquidForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    rdUnit: TRefreshDispatcher;
    GuidesUnit: TdsdGuides;
    dxBarButton1: TdxBarButton;
    GoodsId: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Price_Sale: TcxGridDBColumn;
    Summa_Sale: TcxGridDBColumn;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    GoodsGroupName: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    actRefreshReserve: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actRefreshJuridical: TdsdDataSetRefresh;
    MinExpirationDate: TcxGridDBColumn;
    OperDate_LastIncome: TcxGridDBColumn;
    Amount_LastIncome: TcxGridDBColumn;
    Price_Remains: TcxGridDBColumn;
    Summa_Remains: TcxGridDBColumn;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    UnitName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    isSaleAnother: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    DataSourceDocs: TDataSource;
    DataSetDocs: TClientDataSet;
    spSend: TdsdStoredProc;
    actSend: TdsdExecStoredProc;
    macSend: TMultiAction;
    bbmacSend: TdxBarButton;
    cbList: TcxCheckBox;
    actRefreshList: TdsdDataSetRefresh;
    spReportUnLiquid_mov: TdsdStoredProc;
    actReportUnLiquid_mov: TdsdExecStoredProc;
    macReportUnLiquid_mov: TMultiAction;
    bbReportUnLiquid_mov: TdxBarButton;
    cbReserve: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_MovementCheck_UnLiquidForm: TReport_MovementCheck_UnLiquidForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_MovementCheck_UnLiquidForm)
end.
