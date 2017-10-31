unit Report_Check_Assortment;

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
  ExternalLoad;

type
  TReport_Check_AssortmentForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    rdUnit: TRefreshDispatcher;
    GuidesUnit: TdsdGuides;
    dxBarButton1: TdxBarButton;
    GoodsId: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    SummaSale: TcxGridDBColumn;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    GoodsGroupName: TcxGridDBColumn;
    NDSKindName: TcxGridDBColumn;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    UnitName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actRefreshJuridical: TdsdDataSetRefresh;
    cbList: TcxCheckBox;
    actRefreshList: TdsdDataSetRefresh;
    CountUnit: TcxGridDBColumn;
    MCSNotRecalc: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    cbisMCSAuto: TcxCheckBox;
    cxLabel8: TcxLabel;
    ceDays: TcxCurrencyEdit;
    MCS_Value: TcxGridDBColumn;
    spUpdate_Price_MCS: TdsdStoredProc;
    actUpdate_Price_MCS: TdsdExecStoredProc;
    macUpdate_Price_MCS_list: TMultiAction;
    macUpdate_Price_MCS: TMultiAction;
    bbUpdate_Price_MCS: TdxBarButton;
    cxLabel5: TcxLabel;
    spInsert_MCS_byReport: TdsdStoredProc;
    actInsert_MCS: TdsdExecStoredProc;
    macInsert_MCS_List: TMultiAction;
    macInsert_MCS: TMultiAction;
    bbInsert_MCS: TdxBarButton;
    HeaderChanger: THeaderChanger;
    ceMCSValue: TcxCurrencyEdit;
    bbStartLoad: TdxBarButton;
    FormParams: TdsdFormParams;
    spGetImportSetting_MCS: TdsdStoredProc;
    actGetImportSetting_MCS: TdsdExecStoredProc;
    actDoLoadMCS: TExecuteImportSettingsAction;
    actStartLoadMCS: TMultiAction;
    spGetImportSetting_MCSExcel: TdsdStoredProc;
    actGetImportSetting_MCSExcel: TdsdExecStoredProc;
    actDoLoadMCSExcel: TExecuteImportSettingsAction;
    macStartLoadMCSExcel: TMultiAction;
    bbStartLoadMCSExcel: TdxBarButton;
    spDeleteDataExcel: TdsdStoredProc;
    actDeleteDataExcel: TdsdExecStoredProc;
    macDeleteDataExcel: TMultiAction;
    bbbdxBarButton2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Check_AssortmentForm: TReport_Check_AssortmentForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Check_AssortmentForm)
end.
