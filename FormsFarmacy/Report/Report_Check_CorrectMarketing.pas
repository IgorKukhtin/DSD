unit Report_Check_CorrectMarketing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit;

type
  TReport_Check_CorrectMarketingForm = class(TAncestorReportForm)
    UnitName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actGet_MovementFormClass: TdsdExecStoredProc;
    spGet_MovementFormClass: TdsdStoredProc;
    mactOpenDocument: TMultiAction;
    actOpenDocument: TdsdOpenForm;
    MovementProtocolOpenForm: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    JuridicalName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_Check_CorrectMarketingForm);

end.
