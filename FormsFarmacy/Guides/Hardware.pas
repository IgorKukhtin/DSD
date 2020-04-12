unit Hardware;

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
  THardwareForm = class(TAncestorGuidesForm)
    isCashRegister: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    BaseBoardProduct: TcxGridDBColumn;
    ProcessorName: TcxGridDBColumn;
    DiskDriveModel: TcxGridDBColumn;
    PhysicalMemory: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(THardwareForm);

end.
