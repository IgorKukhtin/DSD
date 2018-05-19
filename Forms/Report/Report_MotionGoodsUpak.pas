unit Report_MotionGoodsUpak;

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
  TReport_MotionGoodsUpakForm = class(TParentForm)
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
    CountIncome: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    LocationName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoodsName: TcxGridDBColumn;
    AssetToCode: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    SummIncome: TcxGridDBColumn;
    CountEnd: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    CountSendIn: TcxGridDBColumn;
    SummSendIn: TcxGridDBColumn;
    CountSendOut: TcxGridDBColumn;
    SummSendOut: TcxGridDBColumn;
    CountSale: TcxGridDBColumn;
    SummSale: TcxGridDBColumn;
    CountReturnOut: TcxGridDBColumn;
    SummReturnOut: TcxGridDBColumn;
    CountReturnIn: TcxGridDBColumn;
    SummReturnIn: TcxGridDBColumn;
    CountLoss: TcxGridDBColumn;
    SummLoss: TcxGridDBColumn;
    CountInventory: TcxGridDBColumn;
    SummInventory: TcxGridDBColumn;
    PriceStart: TcxGridDBColumn;
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
    PriceIncome: TcxGridDBColumn;
    PriceSendIn: TcxGridDBColumn;
    PriceSendOut: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    PriceReturnOut: TcxGridDBColumn;
    PriceReturnIn: TcxGridDBColumn;
    PriceLoss: TcxGridDBColumn;
    PriceInventory: TcxGridDBColumn;
    PriceEnd: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    GuidesUnitGroup: TdsdGuides;
    cxLabel1: TcxLabel;
    GuidesGoods: TdsdGuides;
    edLocation: TcxButtonEdit;
    cxLabel4: TcxLabel;
    MeasureName: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    LocationDescName: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    CarCode: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PriceSendOnPriceIn: TcxGridDBColumn;
    PriceSendOnPriceOut: TcxGridDBColumn;
    CountSendOnPriceIn: TcxGridDBColumn;
    SummSendOnPriceIn: TcxGridDBColumn;
    CountSendOnPriceOut: TcxGridDBColumn;
    SummSendOnPriceOut: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrintBy_Goods: TdxBarButton;
    SummProductionIn: TcxGridDBColumn;
    CountProductionIn: TcxGridDBColumn;
    PriceProductionIn: TcxGridDBColumn;
    CountProductionOut: TcxGridDBColumn;
    PriceProductionOut: TcxGridDBColumn;
    SummProductionOut: TcxGridDBColumn;
    CountTotalIn: TcxGridDBColumn;
    CountTotalOut: TcxGridDBColumn;
    SummTotalIn: TcxGridDBColumn;
    SummTotalOut: TcxGridDBColumn;
    PriceTotalIn: TcxGridDBColumn;
    PriceTotalOut: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    dxBarStatic: TdxBarStatic;
    cxLabel7: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    cxLabel2: TcxLabel;
    GuidesAccountGroup: TdsdGuides;
    cbInfoMoney: TcxCheckBox;
    InfoMoneyName_all_Detail: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    ContainerId_Summ: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    SummSale_10500: TcxGridDBColumn;
    SummSale_40208: TcxGridDBColumn;
    SummReturnIn_40208: TcxGridDBColumn;
    SummInventory_RePrice: TcxGridDBColumn;
    CountSale_10500: TcxGridDBColumn;
    CountSale_40208: TcxGridDBColumn;
    CountReturnIn_40208: TcxGridDBColumn;

    CountStart_Weight: TcxGridDBColumn;
    CountEnd_Weight: TcxGridDBColumn;
    CountIncome_Weight: TcxGridDBColumn;
    CountReturnOut_Weight: TcxGridDBColumn;
    CountSendIn_Weight: TcxGridDBColumn;
    CountSendOut_Weight: TcxGridDBColumn;
    CountSendOnPriceIn_Weight: TcxGridDBColumn;
    CountSendOnPriceOut_Weight: TcxGridDBColumn;
    CountSale_Weight: TcxGridDBColumn;
    CountSale_10500_Weight: TcxGridDBColumn;
    CountSale_40208_Weight: TcxGridDBColumn;
    CountReturnIn_Weight: TcxGridDBColumn;
    CountReturnIn_40208_Weight: TcxGridDBColumn;
    CountProductionIn_Weight: TcxGridDBColumn;
    CountProductionOut_Weight: TcxGridDBColumn;
    CountLoss_Weight: TcxGridDBColumn;
    CountInventory_Weight: TcxGridDBColumn;
    CountTotalIn_Weight: TcxGridDBColumn;
    CountTotalOut_Weight: TcxGridDBColumn;
    spGetDescSets: TdsdStoredProc;
    SaleJournal: TdsdOpenForm;
    LineNum: TcxGridDBColumn;
    actIsInfoMoney: TdsdDataSetRefresh;
    cbGoodsKind: TcxCheckBox;
    bbGoodsKind: TdxBarControlContainerItem;
    cbPartionGoods: TcxCheckBox;
    cbAmount: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    bbAmount: TdxBarControlContainerItem;
    actPrint_GP: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    actPrint_Remains: TdsdPrintAction;
    bbPrint3: TdxBarButton;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edUnitGroup_by: TcxButtonEdit;
    edLocation_by: TcxButtonEdit;
    GuidesUnitGroup_by: TdsdGuides;
    GuidesLocation_by: TdsdGuides;
    PriceListStart: TcxGridDBColumn;
    PriceListEnd: TcxGridDBColumn;
    CountEnd_calc: TcxGridDBColumn;
    SummEnd_calc: TcxGridDBColumn;
    CountProductionIn_by: TcxGridDBColumn;
    SummProductionIn_by: TcxGridDBColumn;
    CountIn_by1: TcxGridDBColumn;
    SummIn_by1: TcxGridDBColumn;
    CountOtherIn_by: TcxGridDBColumn;
    SummOtherIn_by: TcxGridDBColumn;
    CountOut_by1: TcxGridDBColumn;
    SummOut_by1: TcxGridDBColumn;
    CountOtherOut_by: TcxGridDBColumn;
    SummOtherOut_by: TcxGridDBColumn;
    CountEnd_calc_Weight: TcxGridDBColumn;
    CountProductionIn_by_Weight: TcxGridDBColumn;
    CountIn_by1_Weight: TcxGridDBColumn;
    CountOtherIn_by_Weight: TcxGridDBColumn;
    CountOut_by1_Weight: TcxGridDBColumn;
    CountOtherOut_by_Weight: TcxGridDBColumn;
    CountIn_by2: TcxGridDBColumn;
    CountIn_by2_Weight: TcxGridDBColumn;
    SummIn_by2: TcxGridDBColumn;
    CountOut_by2: TcxGridDBColumn;
    CountOut_by2_Weight: TcxGridDBColumn;
    SummOut_by2: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    AssetToName: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_MotionGoodsUpakForm);

end.
