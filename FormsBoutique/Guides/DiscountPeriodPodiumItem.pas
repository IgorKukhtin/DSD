unit DiscountPeriodPodiumItem;

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
  TDiscountPeriodPodiumItemForm = class(TParentForm)
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
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    edShowDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    edOperDate: TcxDateEdit;
    EndDate: TcxGridDBColumn;
    ValueDiscount: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    actDiscountPeriodGoods: TdsdOpenForm;
    bbPriceListGoodsItem: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    RefreshDispatcher: TRefreshDispatcher;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    GoodsIsErased: TcxGridDBColumn;
    actProtocol: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    ObjectId: TcxGridDBColumn;
    bbPriceListTaxDialog: TdxBarButton;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    spSelect_Print: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    PrintItemsCDS: TClientDataSet;
    bbPrint: TdxBarButton;
    edPersent: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    spInsertUpdateList: TdsdStoredProc;
    spUpdatePersent: TdsdExecStoredProc;
    macUpdatePersent: TMultiAction;
    macUpdateAll: TMultiAction;
    ExecuteDialog: TExecuteDialog;
    cxLabel5: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    cxLabel6: TcxLabel;
    edPeriod: TcxButtonEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    GuidesPeriod: TdsdGuides;
    bbExecuteDialog: TdxBarButton;
    edStartYear: TcxButtonEdit;
    GuidesStartYear: TdsdGuides;
    edEndYear: TcxButtonEdit;
    GuidesEndYear: TdsdGuides;
    spGet_Current_Date: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    InvNumber_Partion: TcxGridDBColumn;
    ExecuteDialogPersent: TExecuteDialog;
    FormParams: TdsdFormParams;
    cbSize: TcxCheckBox;
    cxLabel9: TcxLabel;
    edPersentNext: TcxCurrencyEdit;
    ExecuteDialogPersentNext: TExecuteDialog;
    spInsertUpdateListNext: TdsdStoredProc;
    macUpdateAllNext: TMultiAction;
    macUpdatePersentNext: TMultiAction;
    spUpdatePersentNext: TdsdExecStoredProc;
    bbUpdateAllNext: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TDiscountPeriodPodiumItemForm);

end.
