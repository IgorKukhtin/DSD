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
  cxCheckBox, cxSplitter, cxImageComboBox, dxSkinBlack, dxSkinBlue,
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
    UnitName: TcxGridDBColumn;
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
    PriceFrom: TcxGridDBColumn;
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
    cxLabel8: TcxLabel;
    cbTerm: TcxCheckBox;
    edTerm: TcxCurrencyEdit;
    actRefreshReserve: TdsdDataSetRefresh;
    cbReserve: TcxCheckBox;
    cbIncome: TcxCheckBox;
    edDayIncome: TcxCurrencyEdit;
    actRefreshIncome: TdsdDataSetRefresh;
    cbSummSend: TcxCheckBox;
    edSummSend: TcxCurrencyEdit;
    isChoice: TcxGridDBColumn;
    cbMCS_0: TcxCheckBox;
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
