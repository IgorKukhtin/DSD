unit Report_RemainsOverGoods;

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
  cxButtonEdit, dsdGuides, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCheckBox, cxSplitter, cxImageComboBox;

type
  TReport_RemainsOverGoodsForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    actOpenPartionReport: TdsdOpenForm;
    bbGoodsPartyReport: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel3: TcxLabel;
    edPeriod: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edDay: TcxCurrencyEdit;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chPrice: TcxGridDBColumn;
    chMCSValue: TcxGridDBColumn;
    chRemainsStart: TcxGridDBColumn;
    chSummaRemainsStart: TcxGridDBColumn;
    chRemainsMCS_from: TcxGridDBColumn;
    chSummaRemainsMCS_from: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    chUnitName: TcxGridDBColumn;
    chStartDate: TcxGridDBColumn;
    chEndDate: TcxGridDBColumn;
    SummaMCSValue: TcxGridDBColumn;
    MCSValue_Child: TcxGridDBColumn;
    SummaMCSValue_Child: TcxGridDBColumn;
    RemainsMCS_result: TcxGridDBColumn;
    SummaRemainsMCS_result: TcxGridDBColumn;
    chSummaMCSValue: TcxGridDBColumn;
    chRemainsMCS_result: TcxGridDBColumn;
    chSummaRemainsMCS_result: TcxGridDBColumn;
    spSend: TdsdStoredProc;
    actSend: TdsdExecStoredProc;
    macSend: TMultiAction;
    bbSend: TdxBarButton;
    cxSplitterChild: TcxSplitter;
    DataSetDocs: TClientDataSet;
    DataSourceDocs: TDataSource;
    spSendChild: TdsdStoredProc;
    macSendChild: TMultiAction;
    actSendChild: TdsdExecStoredProc;
    bbSendChild: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    spSetErased_Over: TdsdStoredProc;
    actSetErased_Over: TdsdExecStoredProc;
    spOver: TdsdStoredProc;
    macOver: TMultiAction;
    actOver: TdsdExecStoredProc;
    macOverAll: TMultiAction;
    bbmacOverAll: TdxBarButton;
    spOverChild: TdsdStoredProc;
    actOverChild: TdsdExecStoredProc;
    macOverChild: TMultiAction;
    spInsertUpdateMIMaster: TdsdStoredProc;
    spInsertUpdateMIChild: TdsdStoredProc;
    actUpdateMainDS: TdsdUpdateDataSet;
    actUpdateChildDS: TdsdUpdateDataSet;
    spSendOver: TdsdStoredProc;
    actSendOver: TdsdExecStoredProc;
    macSendOver: TMultiAction;
    bbSendOver: TdxBarButton;
    chGoodsCode: TcxGridDBColumn;
    chPriceFrom: TcxGridDBColumn;
    TotalCDS: TClientDataSet;
    TotalDS: TDataSource;
    DBViewAddOnTotal: TdsdDBViewAddOn;
    actOpenUnitForm: TdsdOpenForm;
    bbOpenUnitForm: TdxBarButton;
    AmountSend: TcxGridDBColumn;
    chAmountSend: TcxGridDBColumn;
    dsdGridToExcelTotal: TdsdGridToExcel;
    bb: TdxBarButton;
    cbInMCS: TcxCheckBox;
    cbMCS: TcxCheckBox;
    cxLabel6: TcxLabel;
    cbisRecal: TcxCheckBox;
    cxLabel7: TcxLabel;
    cbAssortment: TcxCheckBox;
    edAssortment: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_RemainsOverGoodsForm);

end.
