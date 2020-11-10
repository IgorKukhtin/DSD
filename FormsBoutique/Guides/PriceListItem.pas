unit PriceListItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  Vcl.ExtCtrls, cxPC, dxDockControl, dxDockPanel, cxContainer, dsdGuides,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar, cxCurrencyEdit;

type
  TPriceListItemForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsName: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
    edShowDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    edOperDate: TcxDateEdit;
    EndDate: TcxGridDBColumn;
    ValuePrice: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    actPriceListGoods: TdsdOpenForm;
    bbPriceListGoodsItem: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    isErased: TcxGridDBColumn;
    actProtocol: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    ObjectId: TcxGridDBColumn;
    actPriceListTaxDialoglOpenForm: TdsdOpenForm;
    bbPriceListTaxDialog: TdxBarButton;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    dsdStoredProcPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    PrintItemsCDS: TClientDataSet;
    bbPrint: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel5: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    cxLabel6: TcxLabel;
    edPeriod: TcxButtonEdit;
    GuidesPeriod: TdsdGuides;
    cxLabel7: TcxLabel;
    edStartYear: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edEndYear: TcxButtonEdit;
    GuidesStartYear: TdsdGuides;
    GuidesEndYear: TdsdGuides;
    spInsertUpdate_Price: TdsdStoredProc;
    actInsertUpdate_Price: TdsdExecStoredProc;
    macInsertUpdate_Price_List: TMultiAction;
    cxLabel9: TcxLabel;
    edPriceTax: TcxCurrencyEdit;
    macInsertUpdate_Price: TMultiAction;
    bbInsertUpdate_Price: TdxBarButton;
    spGet_Current_Date: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialogPriceTax: TExecuteDialog;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    spSelectPrintSticker: TdsdStoredProc;
    spGet_PrinterByUser: TdsdStoredProc;
    actGet_PrinterByUser: TdsdExecStoredProc;
    FormParams: TdsdFormParams;
    actPrintSticker_fp: TdsdPrintAction;
    macPrintSticker_fp: TMultiAction;
    bbPrintSticker_fp: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListItemForm);

end.
