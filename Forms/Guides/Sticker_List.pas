unit Sticker_List;

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
  dxSkinXmas2008Blue, ExternalLoad, dsdCommon;

type
  TSticker_ListForm = class(TParentForm)
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
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
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
    StickerGroupChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalUnionChoiceForm: TOpenChoiceForm;
    StickerSkinChoiceForm: TOpenChoiceForm;
    clCode: TcxGridDBColumn;
    StickerSortChoiceForm: TOpenChoiceForm;
    StickerNormName: TcxGridDBColumn;
    StickerPackChoiceForm: TOpenChoiceForm;
    StickerTypeChoiceForm: TOpenChoiceForm;
    StickerNormChoiceForm: TOpenChoiceForm;
    StickerTypeName: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    StickerSortName: TcxGridDBColumn;
    StickerFileChoiceForm: TOpenChoiceForm;
    StickerFileName: TcxGridDBColumn;
    spInsertUpdateStickerProperty: TdsdStoredProc;
    InsertRecordProperty: TInsertRecord;
    bbRecordCP: TdxBarButton;
    dsdUpdateDataSet1: TdsdUpdateDataSet;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    GoodsChoiceForm: TOpenChoiceForm;
    GoodsKindChoiceForm: TOpenChoiceForm;
    spErasedUnErasedProperty: TdsdStoredProc;
    actSetErasedProperty: TdsdUpdateErased;
    actSetUnErasedProperty: TdsdUpdateErased;
    ProtocolOpenFormProperty: TdsdOpenForm;
    bbProtocolOpenFormPartner: TdxBarButton;
    StickerProperty_ValueChoiceForm: TOpenChoiceForm;
    Value1: TcxGridDBColumn;
    StickerFileChoiceForm1: TOpenChoiceForm;
    actUpdateVat: TdsdExecStoredProc;
    StickerTagName: TcxGridDBColumn;
    StickerTagChoiceForm: TOpenChoiceForm;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    actInsertPropertyMask: TdsdInsertUpdateAction;
    FormParams: TdsdFormParams;
    Id: TcxGridDBColumn;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    bbInsertPropertyMask: TdxBarButton;
    TradeMarkName_StickerFile: TcxGridDBColumn;
    TradeMarkName_Goods: TcxGridDBColumn;
    bbSetErasedProperty: TdxBarButton;
    bbSetUnErasedProperty: TdxBarButton;
    spGetReportNameSticker: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    spInsertReportName: TdsdStoredProc;
    bbPrint: TdxBarButton;
    macPrint: TMultiAction;
    actPrint: TdsdPrintAction;
    actGetReportName: TdsdExecStoredProc;
    actInsertReportName: TdsdExecStoredProc;
    spGetImportSettingId: TdsdStoredProc;
    actGetImportSetting: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    macStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    macPrintJPG: TMultiAction;
    actPrintJPG: TdsdPrintAction;
    bbPrintTwo: TdxBarButton;
    macPrintJPGLen: TMultiAction;
    actPrintJPGLen: TdsdPrintAction;
    bbPrintTwoLen: TdxBarButton;
    Panel1: TPanel;
    deDateStart: TcxDateEdit;
    deDatePack: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edPartion: TcxLabel;
    cbStartEnd: TcxCheckBox;
    cbTare: TcxCheckBox;
    cbGoodsName: TcxCheckBox;
    cbPartion: TcxCheckBox;
    ceNumPack: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    deDateProduction: TcxDateEdit;
    cxLabel5: TcxLabel;
    ceNumTech: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    deDateTare: TcxDateEdit;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    InsertProperty: TdsdInsertUpdateAction;
    spSelectPrintJPG: TdsdStoredProc;
    spSelectPrintJPGLen: TdsdStoredProc;
    Value5_SP_orig: TcxGridDBColumn;
    NormInDays_gk: TcxGridDBColumn;
    isDiff_NormInDays_gk: TcxGridDBColumn;
    priisNormInDays_not_SP: TcxGridDBColumn;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSticker_ListForm);

end.
