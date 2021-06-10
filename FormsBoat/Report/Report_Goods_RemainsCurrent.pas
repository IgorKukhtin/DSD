unit Report_Goods_RemainsCurrent;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, cxDBLabel,
  dsdInternetAction;

type
  TReport_Goods_RemainsCurrentForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    dxBarButton1: TdxBarButton;
    actRefreshStart: TdsdDataSetRefresh;
    UnitName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshIsSize: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    cbPartion: TcxCheckBox;
    cbPartner: TcxCheckBox;
    actRefreshIsPartner: TdsdDataSetRefresh;
    CountForPrice: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    GuidesGoodsPrint: TdsdGuides;
    spInsertUpdate_GoodsPrint: TdsdStoredProc;
    mactGoodsPrintList_Rem: TMultiAction;
    FormParams: TdsdFormParams;
    actUpdateDataSet: TdsdUpdateDataSet;
    bbGoodsPrintList: TdxBarButton;
    spUpdate_FloatValue_DS: TdsdStoredProc;
    actUpdate_FloatValue_DS: TdsdExecStoredProc;
    spDelete_Object_GoodsPrint: TdsdStoredProc;
    actDeleteGoodsPrint: TdsdExecStoredProc;
    bbDeleteGoodsPrint: TdxBarButton;
    spGet_User_curr: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrintSticker: TdsdStoredProc;
    mactGoodsPrintList_Print: TMultiAction;
    bbGoodsPrintList_Print: TdxBarButton;
    UnitName_in: TcxGridDBColumn;
    Amount_in: TcxGridDBColumn;
    actRefreshIsPeriodYear: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrintIn: TdsdPrintAction;
    bbPrintIn: TdxBarButton;
    PanelNameFull: TPanel;
    DBLabelNameFull: TcxDBLabel;
    PriceTax: TcxGridDBColumn;
    actGet_User_curr: TdsdExecStoredProc;
    macAddGoodsPrintList_Rem: TMultiAction;
    actPriceListGoods: TdsdOpenForm;
    bbPriceListGoods: TdxBarButton;
    actDeleteGoodsPrintList: TdsdExecStoredProc;
    spGet_GoodsPrint_Null: TdsdStoredProc;
    actGet_GoodsPrint_Null: TdsdExecStoredProc;
    spGet_PrinterByUser: TdsdStoredProc;
    actGet_PrinterByUser: TdsdExecStoredProc;
    macPrintSticker: TMultiAction;
    cbRemains: TcxCheckBox;
    spUpdate_Goods_isOlapNo: TdsdExecStoredProc;
    spUpdate_Goods_isOlapYes: TdsdExecStoredProc;
    macUpdate_Goods_isOlapNo: TMultiAction;
    macUpdate_Goods_isOlapYes: TMultiAction;
    spUpdate_Goods_isOlap_Yes: TdsdStoredProc;
    spUpdate_Goods_isOlap_No: TdsdStoredProc;
    macUpdate_Goods_isOlapYes_list: TMultiAction;
    macUpdate_Goods_isOlapNo_list: TMultiAction;
    bbGoods_isOlapNo_list: TdxBarButton;
    bbGoods_isOlapYes_list: TdxBarButton;
    spUpdate_Part_isOlap_Yes: TdsdStoredProc;
    spUpdate_Part_isOlap_No: TdsdStoredProc;
    spUpdate_Part_isOlapYes: TdsdExecStoredProc;
    macUpdate_Part_isOlapYes: TMultiAction;
    macUpdate_Part_isOlapYes_list: TMultiAction;
    macUpdate_Part_isOlapNo_list: TMultiAction;
    macUpdate_Part_isOlapNo: TMultiAction;
    spUpdate_Part_isOlapNo: TdsdExecStoredProc;
    spDelete_Object_PartionGoods_ReportOLAP: TdsdStoredProc;
    bbPart_isOlapYes_list: TdxBarButton;
    bbPart_isOlapNo_list: TdxBarButton;
    actDelete_PartionGoods_ReportOLAP: TdsdExecStoredProc;
    bbDelete_PartionGoods_ReportOLAP: TdxBarButton;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    spGet_Export_FileName: TdsdStoredProc;
    spSelect_Export: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    actExport: TMultiAction;
    bbExport: TdxBarButton;
    actPrintSticker_fp: TdsdPrintAction;
    macPrintSticker_fp: TMultiAction;
    bbPrintSticker_fp: TdxBarButton;
    mactGoodsPrintList_Print_fp: TMultiAction;
    bbGoodsPrintList_Print_fp: TdxBarButton;
    spGet_Export_FileName2: TdsdStoredProc;
    actPrint_Curr: TdsdPrintAction;
    bbPrint_Curr: TdxBarButton;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
    spGet_Export_Email: TdsdStoredProc;
    actGet_Export_Email: TdsdExecStoredProc;
    edGoodsGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesGoodsGroup: TdsdGuides;
    MovementItemId: TcxGridDBColumn;
    cbPartNumber: TcxCheckBox;
    CostSumm_Remains: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Goods_RemainsCurrentForm: TReport_Goods_RemainsCurrentForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Goods_RemainsCurrentForm)
end.
