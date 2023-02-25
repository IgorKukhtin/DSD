unit MobilePartner_Object;

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
  cxTextEdit, dsdGuides, cxLabel, cxCurrencyEdit, Vcl.ExtCtrls, cxImageComboBox;

type
  TMobilePartner_ObjectForm = class(TParentForm)
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
    ContractName: TcxGridDBColumn;
    PriceListName: TcxGridDBColumn;
    PriceListName_ret: TcxGridDBColumn;
    DebtSum: TcxGridDBColumn;
    OverSum: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    GPSN: TcxGridDBColumn;
    GPSE: TcxGridDBColumn;
    PrepareDayCount: TcxGridDBColumn;
    isSync: TcxGridDBColumn;
    OverDays: TcxGridDBColumn;
    Schedule: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    cxLabel3: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    spGet_PersonalTrade: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ContractCode: TcxGridDBColumn;
    spUpdate_Partner_Schedule: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    spUpdate_Partner_Delivery: TdsdStoredProc;
    Panel: TPanel;
    edRetail: TcxButtonEdit;
    cxLabel1: TcxLabel;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    GuidesRoute: TdsdGuides;
    JuridicalGuides: TdsdGuides;
    spCheck: TdsdStoredProc;
    actShowCurPartnerOnMap: TdsdPartnerMapAction;
    actShowAllPartnerOnMap: TdsdPartnerMapAction;
    actCheckShowAllPartnerOnMap: TdsdExecStoredProc;
    mactShowAllPartnerOnMap: TMultiAction;
    bbShowCurPartnerOnMap: TdxBarButton;
    bbShowAllPartnerOnMap: TdxBarButton;
    PartnerTagName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    GuidesFiller: TGuidesFiller;
    ExecuteDialog: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMobilePartner_ObjectForm);

end.
