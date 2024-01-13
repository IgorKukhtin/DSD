unit BankAccountPdfEdit;

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
  TBankAccountPdfEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel: TPanel;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    colFileName: TcxDBEditorRow;
    dxBarDockControl3: TdxBarDockControl;
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
    dsdUpdateDataSetDoc: TdsdUpdateDataSet;
    OpenChoiceFormDocTag: TOpenChoiceForm;
    InsertRecordDoc: TInsertRecord;
    bb: TdxBarButton;
    Код: TcxLabel;
    cxLabel2: TcxLabel;
    ceOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel6: TcxLabel;
    ceObject: TcxButtonEdit;
    GuidesObject: TdsdGuides;
    edInvNumber: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountPdfEditForm);

end.
