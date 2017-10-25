unit Sticker_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, DataModul, ParentForm,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxButtonEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, ChoicePeriod, dsdDB, dsdAction, System.Classes, Vcl.ActnList,
  dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient,
  cxCheckBox, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, Vcl.Controls, cxGrid, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, Vcl.ExtCtrls,
  cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TSticker_ObjectForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Comment: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    JuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    JuridicalCode: TcxGridDBColumn;
    Info: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    StickerGroupName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    clCode: TcxGridDBColumn;
    StickerNormName: TcxGridDBColumn;
    StickerTypeName: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    StickerSortName: TcxGridDBColumn;
    StickerFileName: TcxGridDBColumn;
    bbRecordCP: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    bbProtocolOpenFormPartner: TdxBarButton;
    Value1: TcxGridDBColumn;
    spUpdateVat: TdsdStoredProc;
    StickerTagName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    FormParams: TdsdFormParams;
    Id: TcxGridDBColumn;
    bbInsertMask: TdxBarButton;
    bb: TdxBarButton;
    TradeMarkName_StickerFile: TcxGridDBColumn;
    TradeMarkName_Goods: TcxGridDBColumn;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSticker_ObjectForm);

end.
