unit SendJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dxBarBuiltInMenu, cxNavigator;

type
  TSendJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbPrint: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    TotalSumm: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    isAuto: TcxGridDBColumn;
    MCSDay: TcxGridDBColumn;
    MCSPeriod: TcxGridDBColumn;
    isComplete: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    deOperDate: TcxDateEdit;
    spUpdate_Movement_OperDate: TdsdStoredProc;
    actUpdate_OperDate: TdsdExecStoredProc;
    macUpdate_OperDate: TMultiAction;
    macUpdate_OperDateList: TMultiAction;
    bbUpdate_OperDateList: TdxBarButton;
    macUpdateisDeferredYes: TMultiAction;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    macUpdateisDeferredNo: TMultiAction;
    bbDeferredYes: TdxBarButton;
    bbDeferredNo: TdxBarButton;
    ReportInvNumber_full: TcxGridDBColumn;
    isSUN: TcxGridDBColumn;
    isReceived: TcxGridDBColumn;
    spUpdate_Movement_Received: TdsdStoredProc;
    actExecSetReceived: TdsdExecStoredProc;
    actSetReceived: TMultiAction;
    bbSetReceived: TdxBarButton;
    actSetSent: TMultiAction;
    actExecSetSent: TdsdExecStoredProc;
    bbSetSent: TdxBarButton;
    spUpdate_Movement_Sent: TdsdStoredProc;
    isSent: TcxGridDBColumn;
    isOverdueSUN: TcxGridDBColumn;
    spUpdate_isDefSun: TdsdStoredProc;
    spUpdate_isSun: TdsdStoredProc;
    actUpdate_isSun: TdsdExecStoredProc;
    actUpdate_isDefSun: TdsdExecStoredProc;
    bbUpdate_isDefSun: TdxBarButton;
    bbUpdate_isSun: TdxBarButton;
    isSUN_v2: TcxGridDBColumn;
    isNotDisplaySUN: TcxGridDBColumn;
    actUnCompleteView: TMultiAction;
    actExecUnCompleteView: TdsdExecStoredProc;
    spUnCompleteView: TdsdStoredProc;
    dxBarButton3: TdxBarButton;
    NumberSeats: TcxGridDBColumn;
    actUpdate_NotDisplaySUN_Yes: TMultiAction;
    spUpdate_NotDisplaySUN_Yes: TdsdStoredProc;
    actExecUpdate_NotDisplaySUN_Yes: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    actCompileFilter: TMultiAction;
    spComplete_Filter: TdsdStoredProc;
    actExecComplete_Filter: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    actSetErasedFilter: TMultiAction;
    actExecSetErased_Filter: TdsdExecStoredProc;
    spSetErased_Filter: TdsdStoredProc;
    dxBarButton6: TdxBarButton;
    isVIP: TcxGridDBColumn;
    isUrgently: TcxGridDBColumn;
    isConfirmed: TcxGridDBColumn;
    isBanFiscalSale: TcxGridDBColumn;
    macSetDriverSun: TMultiAction;
    actOpenChoiceDriverSun: TOpenChoiceForm;
    bbSetDriverSun: TdxBarButton;
    spUpdate_Movement_DriverSun: TdsdStoredProc;
    actExecSPDriverSun: TdsdExecStoredProc;
    isSendLoss: TcxGridDBColumn;
    actPrintFilter: TdsdPrintAction;
    macPrintFilter: TMultiAction;
    bbPrintFilter: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSendJournalForm);
end.
