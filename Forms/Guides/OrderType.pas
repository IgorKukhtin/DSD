unit OrderType;

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
  DataModul, cxButtonEdit, cxContainer, cxLabel, dsdGuides, cxTextEdit,
  cxMaskEdit, cxCurrencyEdit, ExternalLoad;

type
  TOrderTypeForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Koeff1: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    Koeff2: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    Koeff3: TcxGridDBColumn;
    Koeff4: TcxGridDBColumn;
    Koeff5: TcxGridDBColumn;
    Koeff6: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    Koeff7: TcxGridDBColumn;
    Koeff8: TcxGridDBColumn;
    Koeff9: TcxGridDBColumn;
    Koeff10: TcxGridDBColumn;
    GoodsChoiceForm: TOpenChoiceForm;
    actShowAll: TBooleanStoredProcAction;
    bbactShowAll: TdxBarButton;
    bbh: TdxBarControlContainerItem;
    bb1: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    dsdUnitGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    RefreshDispatcher: TRefreshDispatcher;
    GoodsGroupName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    UnitChoiceForm: TOpenChoiceForm;
    GoodsCode: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    Koeff11: TcxGridDBColumn;
    Koeff12: TcxGridDBColumn;
    TermProduction: TcxGridDBColumn;
    NormInDays: TcxGridDBColumn;
    StartProductionInDays: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsTagName: TcxGridDBColumn;
    GoodsGroupAnalystName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    spUpdate_Koeff: TdsdStoredProc;
    ExecuteDialogKoeff: TExecuteDialog;
    actUpdate_Koeff: TdsdDataSetRefresh;
    macUpdate_Koeff_list: TMultiAction;
    macUpdate_Koeff: TMultiAction;
    FormParams: TdsdFormParams;
    bbUpdate_Koeff: TdxBarButton;
    actInsertUpdate_isPrEdit: TdsdInsertUpdateAction;
    bbInsertUpdate_isPrEdit: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;

  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TOrderTypeForm);
end.
