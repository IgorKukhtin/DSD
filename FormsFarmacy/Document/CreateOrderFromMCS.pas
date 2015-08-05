unit CreateOrderFromMCS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxCheckBox, cxButtonEdit, dsdAction, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore,
  cxGridLevel, cxGridCustomView, cxGrid, cxPC;

type
  TCreateOrderFromMCSForm = class(TAncestorEnumForm)
    colNeedReorder: TcxGridDBColumn;
    colUnitCode: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colExistsOrderInternal: TcxGridDBColumn;
    colMovementId: TcxGridDBColumn;
    actOpenOrderInternalForm: TdsdOpenForm;
    spInsertUpdate_MovementItem_OrderInternalMCS: TdsdStoredProc;
    actExecInsertUpdate_MovementItem_OrderInternalMCS: TdsdExecStoredProc;
    actStartInsertUpdate_MovementItem_OrderInternalMCS: TMultiAction;
    dxBarButton1: TdxBarButton;
    actStartExec: TMultiAction;
    spGet_MovementId_OrderInternal_Auto: TdsdStoredProc;
    FormParams: TdsdFormParams;
    mactOpenForm: TMultiAction;
    actGet_MovementId_OrderInternal_Auto: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    actSelectAll: TBooleanStoredProcAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateOrderFromMCSForm: TCreateOrderFromMCSForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCreateOrderFromMCSForm)
end.
