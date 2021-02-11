unit ProdColorPatternEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dsdGuides, cxMaskEdit, cxButtonEdit, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB, cxDBData,
  dxSkinsdxBarPainter, dxBarExtItems, dxBar, cxClasses, Document,
  Datasnap.DBClient, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxImage, cxVGrid, cxDBVGrid,
  cxInplaceContainer, Vcl.ExtCtrls;

type
  TProdColorPatternEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actDataSetRefresh: TdsdDataSetRefresh;
    actInsertUpdateGuides: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel4: TcxLabel;
    edProdOptions: TcxButtonEdit;
    GuidesProdColorGroup: TdsdGuides;
    cxLabel5: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GuidesColorPattern: TdsdGuides;
    edColorPattern: TcxButtonEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    GuidesProdOptions: TdsdGuides;
    Panel: TPanel;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    colFileName: TcxDBEditorRow;
    dxBarDockControl3: TdxBarDockControl;
    PanelPhoto: TPanel;
    Image3: TcxImage;
    Image2: TcxImage;
    Image1: TcxImage;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
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
    actInsertPhoto: TdsdExecStoredProc;
    PhotoRefresh: TdsdDataSetRefresh;
    DocumentRefresh: TdsdDataSetRefresh;
    PhotoOpenAction: TDocumentOpenAction;
    DocumentOpenAction: TDocumentOpenAction;
    MultiActionInsertPhoto: TMultiAction;
    actDeletePhoto: TdsdExecStoredProc;
    spInserUpdateProdColorPattern: TdsdExecStoredProc;
    BarManager: TdxBarManager;
    BarManagerBar1: TdxBar;
    bbAddDocument: TdxBarButton;
    bbRefreshDoc: TdxBarButton;
    bbStatic: TdxBarStatic;
    bbOpenDocument: TdxBarButton;
    bbInsertCondition: TdxBarButton;
    bbPhotoRefresh: TdxBarButton;
    bbSetErasedContractCondition: TdxBarButton;
    bbPhotoOpenAction: TdxBarButton;
    bbDeleteDocument: TdxBarButton;
    spGetPhoto_panel: TdsdStoredProc;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    DBViewAddOn: TdsdDBViewAddOn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProdColorPatternEditForm);

end.
