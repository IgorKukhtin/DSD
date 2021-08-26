unit CreateOrderFromMCSLayout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxCheckBox, cxButtonEdit, dsdAction, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore,
  cxGridLevel, cxGridCustomView, cxGrid, cxPC, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter;

type
  TCreateOrderFromMCSLayoutForm = class(TAncestorEnumForm)
    NeedReorder: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    ExistsOrderInternal: TcxGridDBColumn;
    MovementId: TcxGridDBColumn;
    actOpenOrderInternalForm: TdsdOpenForm;
    spInsertUpdate_MovementItem_OrderInternalMCSLayout: TdsdStoredProc;
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
    JuridicalName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateOrderFromMCSLayoutForm: TCreateOrderFromMCSLayoutForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCreateOrderFromMCSLayoutForm)
end.
