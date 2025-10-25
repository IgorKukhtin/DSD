unit Report_ProfitLoss_by;

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
  cxDBPivotGrid, cxLabel, dxBarExtItems, ChoicePeriod, cxCheckBox, dsdCommon;

type
  TReport_ProfitLoss_byForm = class(TParentForm)
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
    clDirectionName: TcxDBPivotGridField;
    clDestinationName: TcxDBPivotGridField;
    clBusiness: TcxDBPivotGridField;
    clMovementDescName: TcxDBPivotGridField;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    clBranchName_pl: TcxDBPivotGridField;
    clUnitName_pl: TcxDBPivotGridField;
    clInfoMoneyCode: TcxDBPivotGridField;
    clInfoMoneyGroupName: TcxDBPivotGridField;
    clInfoMoneyDestinationName: TcxDBPivotGridField;
    macReport_Account: TMultiAction;
    actOpenReport_Account: TdsdOpenForm;
    actGetProfitLostParam: TdsdExecStoredProc;
    spGetProfitLostParam: TdsdStoredProc;
    PivotAddOn: TPivotAddOn;
    PeriodChoice: TPeriodChoice;
    dxBarStatic: TdxBarStatic;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    clInvNumber: TcxDBPivotGridField;
    clOperDate: TcxDBPivotGridField;
    clComment: TcxDBPivotGridField;
    actOpenReport_AccountMotion: TdsdOpenForm;
    macReport_AccountMotion: TMultiAction;
    actPrintBranch: TdsdPrintAction;
    getMovementForm: TdsdStoredProc;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    macOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    MovementId: TcxDBPivotGridField;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ProfitLoss_byForm);

end.
