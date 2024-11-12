unit Inventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Vcl.StdCtrls, dsdCommon;

type
  TInventoryForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    Count: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    AssetName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    StorageName: TcxGridDBColumn;
    actUnitChoice: TOpenChoiceForm;
    actStorageChoice: TOpenChoiceForm;
    actAssetChoice: TOpenChoiceForm;
    PartionGoodsDate: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    spInsertUpdateMIAmount: TdsdStoredProc;
    actInsertUpdateMIAmount: TdsdExecStoredProc;
    bbInsertUpdateMIAmount: TdxBarButton;
    actPrint1: TdsdPrintAction;
    mactUpdate_Summ: TMultiAction;
    spUpdateMIMaster_Summ: TdsdStoredProc;
    actUpdate_Summ: TdsdExecStoredProc;
    bbUpdate_Summ: TdxBarButton;
    mactUpdate_SummAll: TMultiAction;
    GoodsKindName_Complete: TcxGridDBColumn;
    actGoodsKindCompleteChoiceMaster: TOpenChoiceForm;
    ContainerId: TcxGridDBColumn;
    actSendOpenForm: TOpenChoiceForm;
    bbInsert_bySend: TdxBarButton;
    spInsert_MI_Inventory_bySend: TdsdStoredProc;
    actInsert_bySend: TdsdExecStoredProc;
    macInsert_bySend: TMultiAction;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    actPrintStickerTermo: TdsdPrintAction;
    bbPrintStickerTermo: TdxBarButton;
    cxLabel5: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    cbisGoodsGroupIn: TcxCheckBox;
    cbisGoodsGroupExc: TcxCheckBox;
    actRefreshGet: TdsdDataSetRefresh;
    HeaderChanger: THeaderChanger;
    spDelete_MI_Inventory_bySend: TdsdStoredProc;
    macDelete_bySend: TMultiAction;
    actDelete_bySend: TdsdExecStoredProc;
    bbDelete_bySend: TdxBarButton;
    actPartionGoodsChoiceForm: TOpenChoiceForm;
    spUpdate_PartionGoods: TdsdStoredProc;
    actUpdate_PartionGoods: TdsdExecStoredProc;
    macUpdate_PartionGoods: TMultiAction;
    bbUpdate_PartionGoods: TdxBarButton;
    actInsert_bySeparate: TdsdExecStoredProc;
    spInsert_MI_Inventory_bySeparate: TdsdStoredProc;
    macInsert_bySeparate: TMultiAction;
    actSeparateOpenForm: TOpenChoiceForm;
    spDelete_MI_Inventory_bySeparate: TdsdStoredProc;
    actDelete_bySeparate: TdsdExecStoredProc;
    macDelete_bySeparate: TMultiAction;
    bbInsert_bySeparate: TdxBarButton;
    bbDelete_bySeparate: TdxBarButton;
    actPrintStickerGrid: TdsdPrintAction;
    bbPrintStickerGrid: TdxBarButton;
    IdBarCode: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    spInsert_MI_Inventory_bySale: TdsdStoredProc;
    spDelete_MI_Inventory_bySale: TdsdStoredProc;
    actSaleOpenForm: TOpenChoiceForm;
    macDelete_bySale: TMultiAction;
    actDelete_bySale: TdsdExecStoredProc;
    macInsert_bySale: TMultiAction;
    actInsert_bySale: TdsdExecStoredProc;
    bbInsert_bySale: TdxBarButton;
    bbDelete_bySale: TdxBarButton;
    cbList: TcxCheckBox;
    cxLabel18: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
    actPartionGoodsAssetChoiceForm: TOpenChoiceForm;
    actInsertRecordAsset: TInsertRecord;
    macInsertRecordAsset: TMultiAction;
    bbInsertRecordAsset: TdxBarButton;
    bbPartionGoodsAssetChoiceForm: TdxBarButton;
    actPartionModelForm: TOpenChoiceForm;
    actSendOnPriceOpenForm: TOpenChoiceForm;
    actInsert_bySendOnPrice: TdsdExecStoredProc;
    macInsert_bySendOnPrice: TMultiAction;
    bbInsert_bySendOnPrice: TdxBarButton;
    actDelete_bySendOnPrice: TdsdExecStoredProc;
    macDelete_bySendOnPrice: TMultiAction;
    bbDelete_bySendOnPrice: TdxBarButton;
    cxTabSheet_PartionCell: TcxTabSheet;
    cxGrid_PartionCell: TcxGrid;
    cxGridDBTableView_PartionCell: TcxGridDBTableView;
    GoodsGroupNameFull_ch4: TcxGridDBColumn;
    GoodsCode_ch4: TcxGridDBColumn;
    GoodsName_ch4: TcxGridDBColumn;
    GoodsKindName_ch4GoodsKindName: TcxGridDBColumn;
    MeasureName_ch4: TcxGridDBColumn;
    PartionGoodsDate_ch4: TcxGridDBColumn;
    Amount_ch4: TcxGridDBColumn;
    PartionCellName_1_ch4: TcxGridDBColumn;
    isPartionCell_Close_1_ch4: TcxGridDBColumn;
    cxGridLevel_PartionCell: TcxGridLevel;
    PartionCellCDS: TClientDataSet;
    PartionCellDS: TDataSource;
    DBViewAddOn_PartionCell: TdsdDBViewAddOn;
    spSelect_MI_PartionCell: TdsdStoredProc;
    spInsertUpdateMIPartionCell: TdsdStoredProc;
    acrRefreshPartionCell: TdsdDataSetRefresh;
    actUpdatePartionCellDS: TdsdUpdateDataSet;
    PartionCellCode_1: TcxGridDBColumn;
    PartionCellName_1: TcxGridDBColumn;
    actGoodsChoiceFormPC: TOpenChoiceForm;
    actGoodsKindChoicePC: TOpenChoiceForm;
    actOpenPartionCellForm1: TOpenChoiceForm;
    spErasedMIPC: TdsdStoredProc;
    spUnErasedMIPC: TdsdStoredProc;
    actMISetErasedPC: TdsdUpdateErased;
    actMISetUnErasedPc: TdsdUpdateErased;
    bbMISetErasedPC: TdxBarButton;
    bbMISetUnErasedPc: TdxBarButton;
    isErased_ch4: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInventoryForm);

end.
