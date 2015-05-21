unit Juridical;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  dxSkinsdxBarPainter, dsdDB, Datasnap.DBClient, dsdAddOn, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxSplitter, cxButtonEdit;

type
  TJuridicalForm = class(TParentForm)
    cxSplitter: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ceCode: TcxGridDBColumn;
    ceName: TcxGridDBColumn;
    ceIsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    GridDS: TDataSource;
    MasterCDS: TClientDataSet;
    GridStoredProc: TdsdStoredProc;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    clInfoMoneyGroupCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationCode: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clGLNCode: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    clIsCorporate: TcxGridDBColumn;
    clJuridicalGroupName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    clPriceListName: TcxGridDBColumn;
    actChoicePriceListForm: TOpenChoiceForm;
    actChoicePriceListPromoForm: TOpenChoiceForm;
    clPriceListPromoName: TcxGridDBColumn;
    clStartPromo: TcxGridDBColumn;
    clEndPromo: TcxGridDBColumn;
    clGoodsPropertyName: TcxGridDBColumn;
    clRetailReportName: TcxGridDBColumn;
    actChoiceRetailReportForm: TOpenChoiceForm;
    actChoiceJuridicalGroup: TOpenChoiceForm;
    clRetailName: TcxGridDBColumn;
    actChoiceRetailForm: TOpenChoiceForm;
    InfoMoneyName_all: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    clisTaxSummary: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TJuridicalForm);
end.
