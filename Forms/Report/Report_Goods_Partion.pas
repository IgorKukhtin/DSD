unit Report_Goods_Partion;

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
  TReport_Goods_PartionForm = class(TParentForm)
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
    Amount: TcxGridDBColumn;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    LocationName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    PartionGoodsName_1: TcxGridDBColumn;
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
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    dxBarStatic: TdxBarStatic;
    cxLabel7: TcxLabel;
    GuidesAccountGroup: TdsdGuides;
    FormParams: TdsdFormParams;
    spGetDescSets: TdsdStoredProc;
    SaleJournal: TdsdOpenForm;
    actIsInfoMoney: TdsdDataSetRefresh;
    bbGoodsKind: TdxBarControlContainerItem;
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
    actPrint_Loss: TdsdPrintAction;
    bbPrint_Loss: TdxBarButton;
    actPrint_Inventory: TdsdPrintAction;
    bbPrint_Inventory: TdxBarButton;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    OperDate_1: TcxGridDBColumn;
    MovementDescName_1: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_Goods_PartionForm);

end.
