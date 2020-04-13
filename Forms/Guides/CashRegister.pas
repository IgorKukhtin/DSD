unit CashRegister;

interface

uses
  Winapi.Windows, AncestorGuides, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.Menus, dxBarBuiltInMenu, cxNavigator, cxCalendar;

type
  TCashRegisterForm = class(TAncestorGuidesForm)
    clCashRegisterKindName: TcxGridDBColumn;
    SerialNumber: TcxGridDBColumn;
    TimePUSHFinal1: TcxGridDBColumn;
    TimePUSHFinal2: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    GetHardwareData: TcxGridDBColumn;
    BaseBoardProduct: TcxGridDBColumn;
    ProcessorName: TcxGridDBColumn;
    DiskDriveModel: TcxGridDBColumn;
    PhysicalMemory: TcxGridDBColumn;
    actUpdate_GetHardwareData_Yes: TMultiAction;
    actUpdate_GetHardwareData_No: TMultiAction;
    actExecUpdate_GetHardwareData_Yes: TdsdExecStoredProc;
    actExecUpdate_GetHardwareData_No: TdsdExecStoredProc;
    spUpdate_GetHardwareData_Yes: TdsdStoredProc;
    spUpdate_GetHardwareData_No: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    TaxRate: TcxGridDBColumn;
    ComputerName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashRegisterForm);

end.
