unit Report_Check_SetErasedUser;

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
  TReport_Check_SetErasedUserForm = class(TAncestorReportForm)
    UnitName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    MovementProtocolOpenForm: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    UserName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    CashRegisterName: TcxGridDBColumn;
    FiscalCheckNumber: TcxGridDBColumn;
    JackdawsChecksName: TcxGridDBColumn;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton2: TdxBarButton;
    DateErase: TcxGridDBColumn;
    dsdOpenForm1: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    actUpdatePierced: TdsdInsertUpdateAction;
    OperDatePierced: TcxGridDBColumn;
    InvNumberPierced: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_Check_SetErasedUserForm);

end.
