unit Inventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxImageComboBox, cxSplitter, Vcl.StdCtrls;

type
  TInventoryForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    GuidesUnit: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    IsErased: TcxGridDBColumn;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    actUnCompleteMovement: TChangeGuidesStatus;
    actCompleteMovement: TChangeGuidesStatus;
    actDeleteMovement: TChangeGuidesStatus;
    MeasureName: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    actMIProtocol: TdsdOpenForm;
    bbMIProtocol: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    spInsertMaskMIMaster: TdsdStoredProc;
    bbInsertRecord: TdxBarButton;
    actRefreshMI: TdsdDataSetRefresh;
    PartionId: TcxGridDBColumn;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel11: TcxLabel;
    ceStatus: TcxButtonEdit;
    actInsertRecord_partion: TInsertRecord;
    actPartionGoodsChoice: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    spUpdate_MI_Inventory_AmountRemains: TdsdStoredProc;
    bb: TdxBarButton;
    Comment: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
   cxSplitter1: TcxSplitter;
    dsdDBViewAddOn0: TdsdDBViewAddOn;
    actGoodsItem1: TdsdInsertUpdateAction;
    actGoodsChoiceForm: TOpenChoiceForm;
    EAN: TcxGridDBColumn;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actInsertRecord_goods: TInsertRecord;
    bbInsertRecord_goods: TdxBarButton;
    edPartNumber: TcxTextEdit;
    cxLabel4: TcxLabel;
    edBarCode2: TcxTextEdit;
    cxLabel5: TcxLabel;
    edAmount: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    EnterMoveNext2: TEnterMoveNext;
    actGoodsItem2: TdsdInsertUpdateAction;
    spGet_dop1: TdsdStoredProc;
    spGet_dop2: TdsdStoredProc;
    spGet_dop3: TdsdStoredProc;
    cxLabel6: TcxLabel;
    edBarCode1: TcxTextEdit;
    cxLabel7: TcxLabel;
    edBarCode3: TcxTextEdit;
    actGoodsItem3: TdsdInsertUpdateAction;
    EnterMoveNext1: TEnterMoveNext;
    EnterMoveNext3: TEnterMoveNext;
    spBarcode_null: TdsdStoredProc;
    macGoodsItem1: TMultiAction;
    macGoodsItem3: TMultiAction;
    macGoodsItem2: TMultiAction;
    Panel1: TPanel;
    cxLabel8: TcxLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    Ord: TcxGridDBColumn;
    actAdd: TdsdInsertUpdateAction;
    mactAdd: TMultiAction;
    actGoodsItemGet1: TdsdExecStoredProc;
    actGoodsItemGet3: TdsdExecStoredProc;
    actGoodsItemGet2: TdsdExecStoredProc;
    cbList: TcxCheckBox;
    AmountDiff: TcxGridDBColumn;
    AmountRemains_curr: TcxGridDBColumn;
    OperDate_protocol: TcxGridDBColumn;
    UserName_protocol: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    lbSearchArticle: TcxLabel;
    edSearchArticle: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    actChoiceGuides: TdsdChoiceGuides;
    Article_all: TcxGridDBColumn;
    bbedSearchArticle: TdxBarControlContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    spSelectPrintStickerOne: TdsdStoredProc;
    actPrintStickerOne: TdsdPrintAction;
    bbPrintStickerOne: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInventoryForm);

end.
