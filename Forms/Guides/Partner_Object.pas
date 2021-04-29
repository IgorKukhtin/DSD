unit Partner_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinsdxBarPainter, dxBarExtItems,
  dsdAddOn, cxCheckBox, dxSkinscxPCPainter, cxButtonEdit, cxContainer,
  cxTextEdit, dsdGuides, cxLabel, cxCurrencyEdit;

type
  TPartner_ObjectForm = class(TParentForm)
    DataSource: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    Name: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Address: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    PriceListName: TcxGridDBColumn;
    PriceListPromoName: TcxGridDBColumn;
    StartPromo: TcxGridDBColumn;
    EndPromo: TcxGridDBColumn;
    PriceListName_Prior: TcxGridDBColumn;
    PriceListName_30103: TcxGridDBColumn;
    PriceListName_30201: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    JuridicalGuides: TdsdGuides;
    edJuridical: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    GLNCode: TcxGridDBColumn;
    GLNCodeJuridical: TcxGridDBColumn;
    GLNCodeRetail: TcxGridDBColumn;
    GLNCodeCorporate: TcxGridDBColumn;
    DocumentDayCount: TcxGridDBColumn;
    PrepareDayCount: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    actShowCurPartnerOnMap: TdsdPartnerMapAction;
    bbShowCurPartnerOnMap: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartner_ObjectForm);

end.
