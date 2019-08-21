unit Report_CheckSendSUN_InOut;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdGuides,
  cxButtonEdit, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView, cxGrid, cxPC,
  cxPCdxBarPopupMenu, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox, cxImageComboBox;

type
  TReport_CheckSendSUN_InOutForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount_In: TcxGridDBColumn;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actOpenDocument: TdsdOpenForm;
    N2: TMenuItem;
    N3: TMenuItem;
    FormParams: TdsdFormParams;
    spGet_MovementFormClass: TdsdStoredProc;
    actGet_MovementFormClass: TdsdExecStoredProc;
    mactOpenDocument: TMultiAction;
    rgUnit: TRefreshDispatcher;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ContractName_Income: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    GuidesGoods: TdsdGuides;
    edGoods: TcxButtonEdit;
    cxLabel6: TcxLabel;
    deStart2: TcxDateEdit;
    deEnd2: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel5: TcxLabel;
    UnitName: TcxGridDBColumn;
    PeriodChoice2: TPeriodChoice;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_CheckSendSUN_InOutForm: TReport_CheckSendSUN_InOutForm;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_CheckSendSUN_InOutForm);
end.
