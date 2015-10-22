unit Report_Movement_ByPartionGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus, cxCalc,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Vcl.StdCtrls,
  cxButtons, cxMemo, dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses,
  dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC;

type
  TReport_Movement_ByPartionGoodsForm = class(TAncestorReportForm)
    mmoPartionGoods: TcxMemo;
    btnRefresh: TcxButton;
    colPartionGoods: TcxGridDBColumn;
    colMovementId: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colStatusName: TcxGridDBColumn;
    colIncomeUnitName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colGoodsId: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colIncomeAmount: TcxGridDBColumn;
    colRemains: TcxGridDBColumn;
    spGet_MovementFormClass: TdsdStoredProc;
    actOpenDocument: TdsdOpenForm;
    actGet_MovementFormClass: TdsdExecStoredProc;
    mactOpenDocument: TMultiAction;
    actRefreshOnlyComplete: TdsdDataSetRefresh;
    actRefreshHaveRemains: TdsdDataSetRefresh;
    FormParams: TdsdFormParams;
    btnRefreshOnlyComplete: TcxButton;
    btnRefreshHaveRemains: TcxButton;
    colRemainsUnitName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Movement_ByPartionGoodsForm);

end.
