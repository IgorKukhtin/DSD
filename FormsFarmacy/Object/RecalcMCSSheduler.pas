unit RecalcMCSSheduler;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.ExtCtrls, cxSplitter, cxDropDownEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarBuiltInMenu, cxNavigator, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxLabel, cxTextEdit, cxMaskEdit, cxCalendar, dsdGuides;

type
  TRecalcMCSShedulerForm = class(TAncestorDBGridForm)
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    Ord: TcxGridDBColumn;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    Color_cal: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    actOpenUnitTree: TOpenChoiceForm;
    actAddUnit: TMultiAction;
    actOpenRecalcMCSShedulerEdit: TdsdOpenForm;
    FormParams: TdsdFormParams;
    Panel1: TPanel;
    edBeginHolidays: TcxDateEdit;
    cxLabel2: TcxLabel;
    edEndHolidays: TcxDateEdit;
    cxLabel1: TcxLabel;
    spGetHolidays: TdsdStoredProc;
    spUpdateHolidays: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    AllRetail: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    DateRun: TcxGridDBColumn;
    actRecalcMCSSheduler: TdsdExecStoredProc;
    spRecalcMCSSheduler: TdsdStoredProc;
    dxBarButton6: TdxBarButton;
    UserRun: TcxGridDBColumn;
    SelectRun: TcxGridDBColumn;
    actRecalcMCSShedulerSelect: TdsdExecStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    spRecalcMCSShedulerSelect: TdsdStoredProc;
    spUpdate_SelectRun: TdsdStoredProc;
    dxBarButton7: TdxBarButton;
    DateRunSun: TcxGridDBColumn;
    dsdSetUnErased: TdsdUpdateErased;
    dsdSetErased: TdsdUpdateErased;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    spErasedUnErased: TdsdStoredProc;
    Period: TcxGridDBColumn;
    Period1: TcxGridDBColumn;
    Period2: TcxGridDBColumn;
    Period3: TcxGridDBColumn;
    Period4: TcxGridDBColumn;
    Period5: TcxGridDBColumn;
    Period6: TcxGridDBColumn;
    Period7: TcxGridDBColumn;
    PeriodSun1: TcxGridDBColumn;
    PeriodSun2: TcxGridDBColumn;
    PeriodSun3: TcxGridDBColumn;
    PeriodSun4: TcxGridDBColumn;
    PeriodSun5: TcxGridDBColumn;
    PeriodSun6: TcxGridDBColumn;
    PeriodSun7: TcxGridDBColumn;
    actExecuteSunDialog: TExecuteDialog;
    actUpdateSun: TMultiAction;
    actExecSPUpdateactSun: TdsdExecStoredProc;
    spUpdateactSun: TdsdStoredProc;
    dxBarButton10: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    Comment: TcxGridDBColumn;
    actExecuteDialogMain: TExecuteDialog;
    actUpdateMain: TMultiAction;
    actExecSPUpdateactMain: TdsdExecStoredProc;
    spUpdateactMain: TdsdStoredProc;
    dxBarButton11: TdxBarButton;
    actReport_RecalcMCS: TdsdOpenForm;
    bbReport_RecalcMCS: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRecalcMCSShedulerForm);

end.
