unit GoodsMainTab_Error;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, cxContainer, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, dsdGuides, cxSplitter, Vcl.DBActns, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.ExtCtrls, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TGoodsMainTab_ErrorForm = class(TAncestorGuidesForm)
    cxGridGChild1: TcxGrid;
    cxGridDBTableViewChild1: TcxGridDBTableView;
    cxGridLevelChild1: TcxGridLevel;
    ChildCDS_1: TClientDataSet;
    ChildDS_1: TDataSource;
    DBViewAddOnChild1: TdsdDBViewAddOn;
    actGoodsLinkRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    DataSetDelete: TDataSetDelete;
    dsdStoredProc1: TdsdStoredProc;
    dsdExecStoredProc1: TdsdExecStoredProc;
    mactListDelete: TMultiAction;
    N8: TMenuItem;
    N9: TMenuItem;
    isNotMarion_1: TcxGridDBColumn;
    isNOT_1: TcxGridDBColumn;
    ReferCode_1: TcxGridDBColumn;
    ReferPrice_1: TcxGridDBColumn;
    NameUkr_1: TcxGridDBColumn;
    Protocol2OpenForm: TdsdOpenForm;
    Protocol3OpenForm: TdsdOpenForm;
    bbProtocol2OpenForm: TdxBarButton;
    bbProtocol3OpenForm: TdxBarButton;
    MorionCode_1: TcxGridDBColumn;
    LastPrice_2: TcxGridDBColumn;
    LastPriceOld_2: TcxGridDBColumn;
    CodeUKTZED: TcxGridDBColumn;
    Analog_2: TcxGridDBColumn;
    Thumb_2: TcxGridDBColumn;
    AppointmentName_2: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter: TcxSplitter;
    Color_Code: TcxGridDBColumn;
    Color_Name: TcxGridDBColumn;
    Color_MorionCode: TcxGridDBColumn;
    Color_isErased: TcxGridDBColumn;
    Color_isClose: TcxGridDBColumn;
    Color_isNotUploadSites: TcxGridDBColumn;
    Color_isDoesNotShare: TcxGridDBColumn;
    Color_isAllowDivision: TcxGridDBColumn;
    Color_isNotTransferTime: TcxGridDBColumn;
    Color_isNotMarion: TcxGridDBColumn;
    Color_isNOT: TcxGridDBColumn;
    Color_GoodsGroupId: TcxGridDBColumn;
    Color_MeasureId: TcxGridDBColumn;
    Color_NDSKindId: TcxGridDBColumn;
    Color_Exchange: TcxGridDBColumn;
    Color_ConditionsKeepId: TcxGridDBColumn;
    Color_GoodsGroupPromoID: TcxGridDBColumn;
    Color_ReferCode: TcxGridDBColumn;
    Color_ReferPrice: TcxGridDBColumn;
    Color_CountPrice: TcxGridDBColumn;
    Color_LastPrice: TcxGridDBColumn;
    Color_MakerName: TcxGridDBColumn;
    Color_NameUkr: TcxGridDBColumn;
    Color_CodeUKTZED: TcxGridDBColumn;
    Color_Analog: TcxGridDBColumn;
    Color_isPublished: TcxGridDBColumn;
    Color_SiteKey: TcxGridDBColumn;
    Color_Foto: TcxGridDBColumn;
    Color_Thumb: TcxGridDBColumn;
    Color_AppointmentId: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsMainTab_ErrorForm);

end.
