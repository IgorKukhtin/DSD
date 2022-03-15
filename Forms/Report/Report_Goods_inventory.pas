unit Report_Goods_inventory;

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
  TReport_Goods_inventoryForm = class(TParentForm)
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
    DBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    LocationName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    CountEnd_calc: TcxGridDBColumn;
    CountIn_ProductionSeparate_un: TcxGridDBColumn;
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
    CountIn_Income: TcxGridDBColumn;
    CountOut_Loss_un: TcxGridDBColumn;
    CountOut_Sale: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    dxBarStatic: TdxBarStatic;
    cxLabel7: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    cxLabel2: TcxLabel;
    GuidesAccountGroup: TdsdGuides;
    FormParams: TdsdFormParams;
    spGetDescSets: TdsdStoredProc;
    SaleJournal: TdsdOpenForm;
    actIsInfoMoney: TdsdDataSetRefresh;
    bbGoodsKind: TdxBarControlContainerItem;
    bbPartionGoods: TdxBarControlContainerItem;
    bbAmount: TdxBarControlContainerItem;
    actPrint2: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    actPrint3: TdsdPrintAction;
    bbPrint3: TdxBarButton;
    CountOut_Loss: TcxGridDBColumn;
    CountOut_Sale_un: TcxGridDBColumn;
    CountOut_Send: TcxGridDBColumn;
    CountOut_ProductionSeparate: TcxGridDBColumn;
    CountIn_Income_un: TcxGridDBColumn;
    CountIn_ProductionSeparate: TcxGridDBColumn;
    CountIn_ProductionUnion: TcxGridDBColumn;
    CountIn_ProductionUnion_un: TcxGridDBColumn;
    CountIn_ReturnIn: TcxGridDBColumn;
    CountIn_ReturnIn_un: TcxGridDBColumn;
    CountIn_Loss: TcxGridDBColumn;
    CountIn_Loss_un: TcxGridDBColumn;
    CountIn_Send: TcxGridDBColumn;
    CountIn_Send_un: TcxGridDBColumn;
    CountOut_ProductionSeparate_un: TcxGridDBColumn;
    CountOut_ProductionUnion: TcxGridDBColumn;
    actPrint_Loss: TdsdPrintAction;
    bbPrint_Loss: TdxBarButton;
    actPrint_Inventory: TdsdPrintAction;
    bbPrint_Inventory: TdxBarButton;
    actPrintBarCode: TdsdPrintAction;
    bbPrintBarCode: TdxBarButton;
    actIsAllMO: TdsdDataSetRefresh;
    actIsAllAuto: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actPrint_MOAuto: TdsdPrintAction;
    bbPrint_MOAuto: TdxBarButton;
    actPrintCount: TdsdPrintAction;
    bbPrintCount: TdxBarButton;
    OperDate: TcxGridDBColumn;
    OperDate_byReport: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_Goods_inventoryForm);

end.
