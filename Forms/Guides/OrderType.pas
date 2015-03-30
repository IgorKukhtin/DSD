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
  cxMaskEdit, cxCurrencyEdit;

type
  TOrderTypeForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clValue1: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
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
    clValue2: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clErased: TcxGridDBColumn;
    clValue3: TcxGridDBColumn;
    clValue4: TcxGridDBColumn;
    clValue5: TcxGridDBColumn;
    clValue6: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    clValue7: TcxGridDBColumn;
    clValue8: TcxGridDBColumn;
    clValue9: TcxGridDBColumn;
    clValue10: TcxGridDBColumn;
    GoodsChoiceForm: TOpenChoiceForm;
    actShowAll: TBooleanStoredProcAction;
    bbactShowAll: TdxBarButton;
    bb: TdxBarControlContainerItem;
    bb1: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    dsdUnitGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    RefreshDispatcher: TRefreshDispatcher;
    clGoodsGroupName: TcxGridDBColumn;
    clUnitName: TcxGridDBColumn;
    UnitChoiceForm: TOpenChoiceForm;
    clGoodsCode: TcxGridDBColumn;
    clUnitCode: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    clValue11: TcxGridDBColumn;
    clValue12: TcxGridDBColumn;
    clTermProduction: TcxGridDBColumn;
    clNormInDays: TcxGridDBColumn;
    clStartProductionInDays: TcxGridDBColumn;

    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;

    clTradeMarkName: TcxGridDBColumn;
    clGoodsGroupNameFull: TcxGridDBColumn;
    clGoodsTagName: TcxGridDBColumn;
    clGoodsGroupAnalystName: TcxGridDBColumn;

    clMeasureName: TcxGridDBColumn;

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
