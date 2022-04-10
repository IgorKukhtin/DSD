unit GoodsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxButtonEdit, dsdAddOn, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCalendar, dxSkinsdxBarPainter, cxStyles, cxVGrid, cxDBVGrid,
  cxInplaceContainer, dxBar, Vcl.ExtCtrls, dxBarExtItems, cxClasses, Document,
  cxImage, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxSplitter;

type
  TGoodsEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    ���: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesMeasure: TdsdGuides;
    edRefer: TcxLabel;
    ceRefer: TcxCurrencyEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceParentGroup: TcxButtonEdit;
    ceMeasure: TcxButtonEdit;
    edProdColor: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesProdColor: TdsdGuides;
    ceInfoMoney: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesInfoMoney: TdsdGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel7: TcxLabel;
    edGoodsSize: TcxButtonEdit;
    GuidesGoodsSize: TdsdGuides;
    cxLabel8: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    GuidesGoodsGroup: TdsdGuides;
    cxLabel9: TcxLabel;
    edGoodsTag: TcxButtonEdit;
    GuidesGoodsTag: TdsdGuides;
    cxLabel10: TcxLabel;
    ceDiscountParner: TcxButtonEdit;
    GuidesDiscountPartner: TdsdGuides;
    edGoodsType: TcxButtonEdit;
    cxLabel11: TcxLabel;
    GuidesGoodsType: TdsdGuides;
    cxLabel12: TcxLabel;
    edPartnerDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    ceMin: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    edArticle: TcxTextEdit;
    edArticleVergl: TcxTextEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    edEAN: TcxTextEdit;
    cxLabel21: TcxLabel;
    edASIN: TcxTextEdit;
    cxLabel22: TcxLabel;
    edMatchCode: TcxTextEdit;
    cxLabel23: TcxLabel;
    edFeeNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    edEKPrice: TcxCurrencyEdit;
    edEmpfPrice: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edComment: TcxTextEdit;
    ceisArc: TcxCheckBox;
    GuidesTaxKind: TdsdGuides;
    edTaxKind: TcxButtonEdit;
    spInsertDocument: TdsdStoredProc;
    spDocumentSelect: TdsdStoredProc;
    DocumentDS: TDataSource;
    DocumentCDS: TClientDataSet;
    spDeleteDocument: TdsdStoredProc;
    spGetDocument: TdsdStoredProc;
    Document: TDocument;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel: TPanel;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    colFileName: TcxDBEditorRow;
    dxBarDockControl1: TdxBarDockControl;
    dxBarDockControl3: TdxBarDockControl;
    cxDBVerticalGrid1: TcxDBVerticalGrid;
    cxDBEditorRow1: TcxDBEditorRow;
    PhotoCDS: TClientDataSet;
    PhotoDS: TDataSource;
    Photo: TDocument;
    spGetPhoto: TdsdStoredProc;
    spDeletePhoto: TdsdStoredProc;
    spPhotoSelect: TdsdStoredProc;
    spInsertPhoto: TdsdStoredProc;
    ActionList1: TActionList;
    actRefresh: TdsdDataSetRefresh;
    FormClose: TdsdFormClose;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
    actInsertDocument: TdsdExecStoredProc;
    DocumentRefresh: TdsdDataSetRefresh;
    DocumentOpenAction: TDocumentOpenAction;
    MultiActionInsertDocument: TMultiAction;
    spInserUpdateGoods: TdsdExecStoredProc;
    actDeleteDocument: TdsdExecStoredProc;
    BarManager: TdxBarManager;
    BarManagerBar1: TdxBar;
    BarManagerBar2: TdxBar;
    bbAddDocument: TdxBarButton;
    bbRefreshDoc: TdxBarButton;
    bbStatic: TdxBarStatic;
    bbOpenDocument: TdxBarButton;
    bbInsertCondition: TdxBarButton;
    bbPhotoRefresh: TdxBarButton;
    bbSetErasedContractCondition: TdxBarButton;
    bbPhotoOpenAction: TdxBarButton;
    bbDeleteDocument: TdxBarButton;
    PhotoRefresh: TdsdDataSetRefresh;
    PhotoOpenAction: TDocumentOpenAction;
    MultiActionInsertPhoto: TMultiAction;
    actInsertPhoto: TdsdExecStoredProc;
    actDeletePhoto: TdsdExecStoredProc;
    PanelPhoto: TPanel;
    Image3: TcxImage;
    Image2: TcxImage;
    Image1: TcxImage;
    spGetPhoto_panel: TdsdStoredProc;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    DBViewAddOn: TdsdDBViewAddOn;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxLabel24: TcxLabel;
    edEngine: TcxButtonEdit;
    GuidesProdEngine: TdsdGuides;
    dsdDBViewAddOnDoc: TdsdDBViewAddOn;
    Panel1: TPanel;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    DocTagName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ClientDataSetDoc: TClientDataSet;
    DataSourceDoc: TDataSource;
    spDocumentSelect2: TdsdStoredProc;
    spUpdate_GoodsDocument: TdsdStoredProc;
    dsdUpdateDataSetDoc: TdsdUpdateDataSet;
    cxRightSplitter: TcxSplitter;
    OpenChoiceFormDocTag: TOpenChoiceForm;
    InsertRecordDoc: TInsertRecord;
    bb: TdxBarButton;
    cxLabel288: TcxLabel;
    ceFeet: TcxCurrencyEdit;
    ceMetres: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsEditForm);

end.
