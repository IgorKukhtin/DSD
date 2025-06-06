unit Report_ProfitLoss;

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
  cxDBPivotGrid, cxLabel, dxBarExtItems, ChoicePeriod, cxCheckBox;

type
  TReport_ProfitLossForm = class(TParentForm)
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
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxDBPivotGrid: TcxDBPivotGrid;
    clProfitLossGroupName: TcxDBPivotGridField;
    clProfitLossDirectionName: TcxDBPivotGridField;
    clProfitLossName: TcxDBPivotGridField;
    clInfoMoneyName: TcxDBPivotGridField;
    clAmount: TcxDBPivotGridField;
    clMovementDescName: TcxDBPivotGridField;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    clUnitName_ProfitLoss: TcxDBPivotGridField;
    clInfoMoneyCode: TcxDBPivotGridField;
    clInfoMoneyGroupName: TcxDBPivotGridField;
    clInfoMoneyDestinationName: TcxDBPivotGridField;
    MultiAction1: TMultiAction;
    dsdOpenForm1: TdsdOpenForm;
    dsdExecStoredProc1: TdsdExecStoredProc;
    spGetProfitLostParam: TdsdStoredProc;
    PivotAddOn: TPivotAddOn;
    PeriodChoice: TPeriodChoice;
    dxBarStatic: TdxBarStatic;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cbTotal: TcxCheckBox;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    DirectionObjectName: TcxDBPivotGridField;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ProfitLossForm);

end.
