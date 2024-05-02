unit ProdOptions;

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
  cxCurrencyEdit, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxLabel, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar;

type
  TProdOptionsForm = class(TParentForm)
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
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actChoiceGuides: TdsdChoiceGuides;
    DBViewAddOn: TdsdDBViewAddOn;
    actProtocol: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Comment: TcxGridDBColumn;
    spUnErased: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxLabel6: TcxLabel;
    edProdModel: TcxButtonEdit;
    GuidesProdModel: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbModel: TdxBarControlContainerItem;
    FormParams: TdsdFormParams;
    RefreshDispatcher: TRefreshDispatcher;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    actChoiceFormGoods: TOpenChoiceForm;
    actChoiceFormModel: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    SalePrice: TcxGridDBColumn;
    SalePriceWVAT: TcxGridDBColumn;
    MaterialOptionsName: TcxGridDBColumn;
    Id_Site: TcxGridDBColumn;
    CodeVergl: TcxGridDBColumn;
    ProdColorPatternName: TcxGridDBColumn;
    actChoiceFormProdColorPattern: TOpenChoiceForm;
    NPP: TcxGridDBColumn;
    NPP_pcp: TcxGridDBColumn;
    actChoiceFormProdColor_goods: TOpenChoiceForm;
    actChoiceFormProdOptions_Òomment: TOpenChoiceForm;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    Panel_btn: TPanel;
    btnInsert: TcxButton;
    btnUpdate: TcxButton;
    btnChoiceGuides: TcxButton;
    btnSetErased: TcxButton;
    btnFormClose: TcxButton;
    actFormClose: TdsdFormClose;
    actSetNull_GuidesModel: TdsdSetDefaultParams;
    btnSetNull_GuidesClient: TcxButton;
    btnClientChoiceForm: TcxButton;
    actModelChoiceForm: TOpenChoiceForm;
    Panel2: TPanel;
    cxLabel3: TcxLabel;
    edOperDate: TcxDateEdit;
    cbis—hangePrice: TcxCheckBox;
    actPriceListGoods: TdsdOpenForm;
    bbPriceListGoods: TdxBarButton;
    cxLabel1: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
    cxLabel2: TcxLabel;
    edLanguage1: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edLanguage2: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edLanguage3: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edLanguage4: TcxButtonEdit;
    GuidesLanguage4: TdsdGuides;
    GuidesLanguage3: TdsdGuides;
    GuidesLanguage2: TdsdGuides;
    GuidesLanguage1: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProdOptionsForm);

end.
