unit Report_Top100GoodsSUN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, cxCustomPivotGrid,
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, dsdPivotGrid;

type
  TReport_Top100GoodsSUNForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    RefreshDispatcher: TRefreshDispatcher;
    bbStaticText: TdxBarButton;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bbcbTotal: TdxBarControlContainerItem;
    bbOpenReport_AccountMotion: TdxBarButton;
    bbReport_Account: TdxBarButton;
    bbPrint3: TdxBarButton;
    bbGroup: TdxBarControlContainerItem;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    GoodsCode: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    bbUpdate: TdxBarButton;
    AmountV1: TcxGridDBColumn;
    AmountV2: TcxGridDBColumn;
    AmountV3: TcxGridDBColumn;
    AmountV4: TcxGridDBColumn;
    AmountV1_Supplement: TcxGridDBColumn;
    AmountV1_SUA: TcxGridDBColumn;
    AmountV1_UKTZED: TcxGridDBColumn;
    Ord: TcxGridDBColumn;
    AmountV1_PartionDate: TcxGridDBColumn;
    ce“op: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    dxBarContainerItem1: TdxBarContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Top100GoodsSUNForm);

end.
