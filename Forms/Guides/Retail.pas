unit Retail;

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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxButtonEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCurrencyEdit;

type
  TRetailForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    spErasedUnErased: TdsdStoredProc;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actInsert: TdsdInsertUpdateAction;
    GLNCode: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    spUpdateGLNCode: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    GLNCodeCorporate: TcxGridDBColumn;
    actChoiceGoodsProperty: TOpenChoiceForm;
    OperDateOrder: TcxGridDBColumn;
    PersonalMarketingName: TcxGridDBColumn;
    actChoicePersonalMarketing: TOpenChoiceForm;
    actChoicePersonalTrade: TOpenChoiceForm;
    ClientKindName: TcxGridDBColumn;
    spUpdate_ClientKind_Retail: TdsdStoredProc;
    spUpdate_ClientKind_Null: TdsdStoredProc;
    actUpdate_ClientKind_Retail: TdsdExecStoredProc;
    actUpdate_ClientKind_Null: TdsdExecStoredProc;
    macUpdate_ClientKind_Null_List: TMultiAction;
    macUpdate_ClientKind_Null: TMultiAction;
    macUpdate_ClientKind_Retail_list: TMultiAction;
    macUpdate_ClientKind_Retai: TMultiAction;
    bbUpdate_ClientKind_Retai: TdxBarButton;
    bbUpdate_ClientKind_Null: TdxBarButton;
    spUpdate_IsOrderMin: TdsdStoredProc;
    actUpdate_IsOrderMin: TdsdExecStoredProc;
    bbUpdate_IsOrderMin: TdxBarButton;
    spUpdate_isWMS: TdsdStoredProc;
    actUpdate_isWMS: TdsdExecStoredProc;
    bbUpdate_isWMS: TdxBarButton;
    RoundWeight: TcxGridDBColumn;
    spUpdate_StickerHeader: TdsdStoredProc;
    macUpdate_StickerHeader: TMultiAction;
    actOpenChoiceStickerHeader: TOpenChoiceForm;
    actUpdate_StickerHeader: TdsdExecStoredProc;
    bbUpdate_StickerHeader: TdxBarButton;
    StickerHeaderName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRetailForm);

end.
