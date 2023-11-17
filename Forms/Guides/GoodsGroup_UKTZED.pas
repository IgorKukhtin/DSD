unit GoodsGroup_UKTZED;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  ExternalLoad;

type
  TGoodsGroup_UKTZEDForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    CodeUKTZED: TcxGridDBColumn;
    CodeUKTZED_new: TcxGridDBColumn;
    DateUKTZED_new: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    GoodsTagName: TcxGridDBColumn;
    GoodsPlatformName: TcxGridDBColumn;
    TaxImport: TcxGridDBColumn;
    DKPP: TcxGridDBColumn;
    TaxAction: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    ParentName: TcxGridDBColumn;
    spUpdateCodeUKTZED: TdsdStoredProc;
    actUpdateDataSource: TdsdUpdateDataSet;
    isAsset: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    actGetImportSetting_UKTZEDnew: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    macStartLoad_UKTZEDnew: TMultiAction;
    bbStartLoad_UKTZEDnew: TdxBarButton;
    spGetImportSettingId_byName: TdsdStoredProc;
    actGetImportSetting_UKTZEDnewByName: TdsdExecStoredProc;
    macStartLoad_UKTZEDnewByName: TMultiAction;
    bbStartLoad_UKTZEDnewByName: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TGoodsGroup_UKTZEDForm);
end.
