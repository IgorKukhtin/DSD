unit Report_GoodsBalance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, ChoicePeriod, cxLabel, dxBarExtItems, cxCheckBox;

type
  TReport_GoodsBalanceForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spReport: TdsdStoredProc;
    CountStart: TcxGridDBColumn;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    CountEnd_calc: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    LocationName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    CountEnd: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    CountOut_calc: TcxGridDBColumn;
    PriceListStart: TcxGridDBColumn;
    GuidesGoodsGroup: TdsdGuides;
    GuidesLocation: TdsdGuides;
    edGoodsGroup: TcxButtonEdit;
    edUnitGroup: TcxButtonEdit;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    edGoods: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PriceListEnd: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    GuidesUnitGroup: TdsdGuides;
    cxLabel1: TcxLabel;
    GuidesGoods: TdsdGuides;
    edLocation: TcxButtonEdit;
    cxLabel4: TcxLabel;
    MeasureName: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    LocationDescName: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrintBy_Goods: TdxBarButton;
    CountIn_calc: TcxGridDBColumn;
    CountOut: TcxGridDBColumn;
    CountIn: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    dxBarStatic: TdxBarStatic;
    cxLabel7: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    cxLabel2: TcxLabel;
    GuidesAccountGroup: TdsdGuides;
    cbInfoMoney: TcxCheckBox;
    FormParams: TdsdFormParams;
    spGetDescSets: TdsdStoredProc;
    SaleJournal: TdsdOpenForm;
    actIsInfoMoney: TdsdDataSetRefresh;
    cbGoodsKind: TcxCheckBox;
    bbGoodsKind: TdxBarControlContainerItem;
    cbPartionGoods: TcxCheckBox;
    cbAmount: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    bbAmount: TdxBarControlContainerItem;
    actPrint2: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    actPrint3: TdsdPrintAction;
    bbPrint3: TdxBarButton;
    PartionGoodsName: TcxGridDBColumn;
    ColorB_GreenL: TcxGridDBColumn;
    ColorB_Yelow: TcxGridDBColumn;
    CountReal: TcxGridDBColumn;
    ColorB_Cyan: TcxGridDBColumn;
    CountIn_sh: TcxGridDBColumn;
    CountIn_Weight: TcxGridDBColumn;
    CountOut_sh: TcxGridDBColumn;
    CountOut_Weight: TcxGridDBColumn;
    CountIn_sh_calc: TcxGridDBColumn;
    CountIn_Weight_calc: TcxGridDBColumn;
    CountOut_sh_calc: TcxGridDBColumn;
    CountOut_Weight_calc: TcxGridDBColumn;
    CountEnd_sh_calc: TcxGridDBColumn;
    CountEnd_Weight_calc: TcxGridDBColumn;
    CountReal_sh: TcxGridDBColumn;
    CountReal_Weight: TcxGridDBColumn;
    CountStart_sh: TcxGridDBColumn;
    CountStart_Weight: TcxGridDBColumn;
    CountEnd_sh: TcxGridDBColumn;
    CountEnd_Weight: TcxGridDBColumn;
    isReprice: TcxGridDBColumn;
    isPriceStart_diff: TcxGridDBColumn;
    isPriceEnd_diff: TcxGridDBColumn;
    Count_byCount: TcxGridDBColumn;
    Count_onCount: TcxGridDBColumn;
    CountStart_byCount: TcxGridDBColumn;
    CountEnd_byCount: TcxGridDBColumn;
    Weight_byCount: TcxGridDBColumn;
    PriceReal: TcxGridDBColumn;
    PriceStart: TcxGridDBColumn;
    PriceEnd: TcxGridDBColumn;
    SummReal: TcxGridDBColumn;
    SummIn: TcxGridDBColumn;
    SummOut: TcxGridDBColumn;
    PriceIn: TcxGridDBColumn;
    PriceOut: TcxGridDBColumn;
    SummPriceListStart: TcxGridDBColumn;
    SummPriceListEnd: TcxGridDBColumn;
    CountLoss_sh: TcxGridDBColumn;
    CountLoss_Weight: TcxGridDBColumn;
    SummLoss: TcxGridDBColumn;
    PriceLoss: TcxGridDBColumn;
    CountInventory_sh: TcxGridDBColumn;
    CountInventory_Weight: TcxGridDBColumn;
    SummInventory: TcxGridDBColumn;
    PriceInventory: TcxGridDBColumn;
    SummInventory_RePrice: TcxGridDBColumn;
    CountIn_Weight_gp: TcxGridDBColumn;
    CountIn_Weight_end_gp: TcxGridDBColumn;
    CountOut_norm_pf: TcxGridDBColumn;
    CountIn_Weight_norm_gp: TcxGridDBColumn;
    CountOut_byPF: TcxGridDBColumn;
    isPartionClose_calc: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    TermProduction: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    actPrint_Loss: TdsdPrintAction;
    bbPrint_Loss: TdxBarButton;
    TaxExit_norm: TcxGridDBColumn;
    TaxExit_norm_real: TcxGridDBColumn;
    TaxExit_real: TcxGridDBColumn;
    CuterCount: TcxGridDBColumn;
    CountIn_byPF: TcxGridDBColumn;
    Value_receipt: TcxGridDBColumn;
    CuterCount_receipt: TcxGridDBColumn;
    actPrint_Inventory: TdsdPrintAction;
    bbPrint_Inventory: TdxBarButton;
    CountTotalIn_Weight: TcxGridDBColumn;
    SummTotalIn: TcxGridDBColumn;
    AssetToName: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    InfoMoneyName_all_Detail: TcxGridDBColumn;
    actPrintBarCode: TdsdPrintAction;
    bbPrintBarCode: TdxBarButton;
    actIsAllMO: TdsdDataSetRefresh;
    actIsAllAuto: TdsdDataSetRefresh;
    cbAllMO: TcxCheckBox;
    cbAllAuto: TcxCheckBox;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    UnitName_to: TcxGridDBColumn;
    DriverName: TcxGridDBColumn;
    actPrint_MOAuto: TdsdPrintAction;
    bbPrint_MOAuto: TdxBarButton;
    actPrintCount: TdsdPrintAction;
    bbPrintCount: TdxBarButton;
    PartionCellCode: TcxGridDBColumn;
    PartionCellName: TcxGridDBColumn;
    cbPartionCell: TcxCheckBox;
    cbOperDate_Partion: TcxCheckBox;
    actisOperDate_Partion: TdsdDataSetRefresh;
    actisPartionCell: TdsdDataSetRefresh;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_GoodsBalanceForm);

end.
