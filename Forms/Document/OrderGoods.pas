unit OrderGoods;

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
  cxSplitter, ChoicePeriod;

type
  TOrderGoodsForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edOrderPeriodKind: TcxButtonEdit;
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesOrderPeriodKind: TdsdGuides;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actUnitChoiceForm: TOpenChoiceForm;
    actStorageChoiceForm: TOpenChoiceForm;
    actPartionGoodsChoiceForm: TOpenChoiceForm;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    actGoodsKindCompleteChoice: TOpenChoiceForm;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    actPrintNoGroup: TdsdPrintAction;
    bbPrintNoGroup: TdxBarButton;
    cxLabel8: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    edInsertName: TcxButtonEdit;
    cxLabel27: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
    actPrintSaleOrder: TdsdPrintAction;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    bbPrintSaleOrderTax: TdxBarButton;
    actPersonalGroupChoiceForm: TOpenChoiceForm;
    bbPersonalGroupChoiceForm: TdxBarButton;
    actUpdatePersonalGroup: TdsdExecStoredProc;
    macUpdatePersonalGroup: TMultiAction;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    ChildGoodsKindName: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildIsErased: TcxGridDBColumn;
    cxGridLevelChild: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    PopupMenuChild: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    N4: TMenuItem;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    spSelect_Child: TdsdStoredProc;
    cxLabel5: TcxLabel;
    edMonth: TcxTextEdit;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    DSDetailMaster: TDataSource;
    CDSDetailMaster: TClientDataSet;
    dsdDBViewAddOnDetailMaster: TdsdDBViewAddOn;
    DSDetailChild: TDataSource;
    CDSDetailChild: TClientDataSet;
    dsdDBViewAddOnDetailChild: TdsdDBViewAddOn;
    cxGridDetailMaster: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    GoodsGroupNameFull_ch2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    AmountForecastOrder_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    AmountForecastPromo_ch2: TcxGridDBColumn;
    AmountForecastOrderPromo_ch2: TcxGridDBColumn;
    GoodsKindName_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridDetailChild: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    GoodsGroupNameFull_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    MeasureName_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    GoodsKindName_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    spSelectDetailMaster: TdsdStoredProc;
    spSelectDetailChild: TdsdStoredProc;
    spGet_OrderGoodsDetail: TdsdStoredProc;
    cxLabel6: TcxLabel;
    edOperDateStart: TcxDateEdit;
    edOperDateEnd: TcxDateEdit;
    cxLabel9: TcxLabel;
    spInsert_MI_OrderGoodsDetail_Master: TdsdStoredProc;
    actInsert_OrderGoodsDetail_Master: TdsdExecStoredProc;
    matInsert_OrderGoodsDetail_Master: TMultiAction;
    bbInsert_OrderGoodsDetail_Master: TdxBarButton;
    actRefresh_Detail_Master: TdsdDataSetRefresh;
    PeriodChoice: TPeriodChoice;
    dsdGridToExceDetailMaster: TdsdGridToExcel;
    bbGridToExceDetailMaster: TdxBarButton;
    ReceiptName_ch2: TcxGridDBColumn;
    ReceiptBasisName_ch2: TcxGridDBColumn;
    isMain_ch2: TcxGridDBColumn;
    isMain_Basis_ch2: TcxGridDBColumn;
    ReceiptCode_ch2: TcxGridDBColumn;
    ReceiptCode_str_ch2: TcxGridDBColumn;
    ReceiptBasisCode_ch2: TcxGridDBColumn;
    ReceiptBasisCode_str_ch2: TcxGridDBColumn;
    GoodsGroupNameFull_parent: TcxGridDBColumn;
    MeasureName_parent_ch3: TcxGridDBColumn;
    GoodsKindName_parent_ch3: TcxGridDBColumn;
    actShowAll_DetailChild: TBooleanStoredProcAction;
    bbShowAll_DetailChild: TdxBarButton;
    DetailChildProtocolOpenForm: TdsdOpenForm;
    DetailMasterProtocolOpenForm: TdsdOpenForm;
    bbDetailMasterProtocolOpen: TdxBarButton;
    bbDetailChildProtocolOpen: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderGoodsForm);

end.
