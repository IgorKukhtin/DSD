unit ProdColorPatternGoodsEdit;

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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack,
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
  cxButtonEdit, cxCurrencyEdit, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxLabel, Vcl.ExtCtrls;

type
  TProdColorPatternGoodsEditForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    spErased: TdsdStoredProc;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actChoiceGuides: TdsdChoiceGuides;
    DBViewAddOn: TdsdDBViewAddOn;
    actProtocol: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    spUnErased: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdate: TdsdStoredProc;
    actChoiceFormGoods: TOpenChoiceForm;
    cxLabel6: TcxLabel;
    GuidesColorPattern: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    FormParams: TdsdFormParams;
    RefreshDispatcher: TRefreshDispatcher;
    actShowAll: TBooleanStoredProcAction;
    bbactShowAll: TdxBarButton;
    actChoiceFormOption: TOpenChoiceForm;
    actChoiceFormProdColor_goods: TOpenChoiceForm;
    Panel2: TPanel;
    edSearchArticle: TcxTextEdit;
    lbSearchArticle: TcxLabel;
    lbSearchCode: TcxLabel;
    lbSearchName: TcxLabel;
    edSearchCode: TcxTextEdit;
    edSearchName: TcxTextEdit;
    cxLabel4: TcxLabel;
    FieldFilter_Name: TdsdFieldFilter;
    FieldFilter_Code: TdsdFieldFilter;
    FieldFilter_Article: TdsdFieldFilter;
    edUserCode: TcxTextEdit;
    cxLabel1: TcxLabel;
    edName: TcxTextEdit;
    cxLabel2: TcxLabel;
    edColorPattern: TcxButtonEdit;
    cxLabel12: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    edArticle: TcxTextEdit;
    cxLabel18: TcxLabel;
    Panel1: TPanel;
    spInsertUpdate_Child1: TdsdStoredProc;
    dsdChoiceGuides: TdsdChoiceGuides;
    actChoiceFormReceiptLevel_ch1: TOpenChoiceForm;
    actChoiceFormMaterialOptions_1: TOpenChoiceForm;
    actChoiceFormGoods_1: TOpenChoiceForm;
    actChoiceFormGoodsChild_1: TOpenChoiceForm;
    actInsertRecordGoods: TInsertRecord;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProdColorPatternGoodsEditForm);

end.
