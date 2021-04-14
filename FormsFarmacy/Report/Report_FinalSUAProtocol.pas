unit Report_FinalSUAProtocol;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxGridBandedTableView, cxGridDBBandedTableView, Vcl.Grids, Vcl.DBGrids,
  cxSplitter, cxTimeEdit, ChoicePeriod;

type
  TReport_FinalSUAProtocolForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelect: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edDateStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbStatic: TdxBarStatic;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    actShowErased: TBooleanStoredProcAction;
    ExecuteDialog: TExecuteDialog;
    deEnd: TcxDateEdit;
    cxLabel7: TcxLabel;
    bbExecuteDialog: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter2: TcxSplitter;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxGridRecipient: TcxGrid;
    cxGridDBTableViewRecipient: TcxGridDBTableView;
    RecipientCode: TcxGridDBColumn;
    RecipientName: TcxGridDBColumn;
    cxGridLevelRecipient: TcxGridLevel;
    cxGridAssortment: TcxGrid;
    cxGridDBTableViewAssortment: TcxGridDBTableView;
    AssortmentCode: TcxGridDBColumn;
    AssortmentName: TcxGridDBColumn;
    cxGridLevelAssortment: TcxGridLevel;
    DateStart: TcxGridDBColumn;
    DateEnd: TcxGridDBColumn;
    Threshold: TcxGridDBColumn;
    DaysStock: TcxGridDBColumn;
    CountPharmacies: TcxGridDBColumn;
    ResolutionParameter: TcxGridDBColumn;
    isGoodsClose: TcxGridDBColumn;
    isMCSIsClose: TcxGridDBColumn;
    isNotCheckNoMCS: TcxGridDBColumn;
    RecipientDS: TDataSource;
    RecipientCDS: TClientDataSet;
    AssortmentDS: TDataSource;
    AssortmentCDS: TClientDataSet;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    isMCSValue: TcxGridDBColumn;
    isRemains: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_FinalSUAProtocolForm);

end.
