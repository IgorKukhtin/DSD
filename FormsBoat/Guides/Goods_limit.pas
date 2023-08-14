unit Goods_limit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dxSkinsdxBarPainter,
  dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxButtonEdit,
  cxCurrencyEdit, ExternalLoad, cxContainer, cxImage, Vcl.ExtCtrls, cxTextEdit,
  cxLabel;

type
  TGoods_limitForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    TaxKind_Value: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel1: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    DBViewAddOn: TdsdDBViewAddOn;
    UnitName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    DiscountPartnerName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    IsArc: TcxGridDBColumn;
    GoodsTypeName: TcxGridDBColumn;
    GoodsTagName: TcxGridDBColumn;
    EAN: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    TaxKindName: TcxGridDBColumn;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    actUpdateisPartionCount: TdsdExecStoredProc;
    actUpdateisPartionSumm: TdsdExecStoredProc;
    PartnerDate: TcxGridDBColumn;
    actDatePeriodDialog: TExecuteDialog;
    actUpdateGoods_In: TdsdExecStoredProc;
    macUpdateGoods_In: TMultiAction;
    bbUpdateGoods_In: TdxBarButton;
    FormParams: TdsdFormParams;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceAsset: TOpenChoiceForm;
    GoodsSizeName: TcxGridDBColumn;
    EmpfPrice: TcxGridDBColumn;
    EKPrice: TcxGridDBColumn;
    actUpdate_WeightTare: TdsdExecStoredProc;
    macUpdate_WeightTare: TMultiAction;
    macUpdate_WeightTareList: TMultiAction;
    ExecuteDialogWeightTare: TExecuteDialog;
    actGetImportSetting_Goods_Price: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    spUnErased: TdsdStoredProc;
    spErased: TdsdStoredProc;
    isDoc: TcxGridDBColumn;
    isPhoto: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    edSearchArticle: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    Article_all: TcxGridDBColumn;
    bbSearchArticle: TdxBarControlContainerItem;
    bbSearchArticleLabel: TdxBarControlContainerItem;
    lbSearchArticle: TcxLabel;
    actSetFocused: TdsdSetFocusedAction;
    InvNumber_pl: TcxGridDBColumn;
    Comment_pl: TcxGridDBColumn;
    myCount_pl: TcxGridDBColumn;
    GoodsArticle: TcxGridDBColumn;
    Metres: TcxGridDBColumn;
    Feet: TcxGridDBColumn;
    bbSearchCodeLabel: TdxBarControlContainerItem;
    bbSearchCode: TdxBarControlContainerItem;
    lbSearchCode: TcxLabel;
    lbSearchName: TcxLabel;
    edSearchCode: TcxTextEdit;
    edSearchName: TcxTextEdit;
    bbSearchNameLabel: TdxBarControlContainerItem;
    bbSearchName: TdxBarControlContainerItem;
    isReceiptGoods_group: TcxGridDBColumn;
    isReceiptGoods: TcxGridDBColumn;
    isProdOptions: TcxGridDBColumn;
    ModelName_calc: TcxGridDBColumn;
    Name_all: TcxGridDBColumn;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}
initialization
  RegisterClass(TGoods_limitForm);
end.
