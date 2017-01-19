unit Unit_Object;

interface

uses
  Winapi.Windows, AncestorEnum, DataModul, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  Datasnap.DBClient, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, Vcl.Controls, cxGrid,
  cxPCdxBarPopupMenu, Vcl.Menus, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit;

type
  TUnit_ObjectForm = class(TAncestorEnumForm)
    ceJuridicalName: TcxGridDBColumn;
    ceParentName: TcxGridDBColumn;
    UnitId: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    spUpdate_Unit_isOver: TdsdStoredProc;
    colisOver: TcxGridDBColumn;
    actUpdateisOver: TdsdExecStoredProc;
    bbUpdateisOver: TdxBarButton;
    spUpdateisOverYes: TdsdExecStoredProc;
    macUpdateisOverYes: TMultiAction;
    bbUpdateisOverList: TdxBarButton;
    spUpdate_Unit_isOver_Yes: TdsdStoredProc;
    spUpdate_Unit_isOver_No: TdsdStoredProc;
    spUpdateisOverNo: TdsdExecStoredProc;
    macUpdateisOverNo: TMultiAction;
    bbUpdateisOverNoList: TdxBarButton;
    colisUploadBadm: TcxGridDBColumn;
    spUpdate_Unit_isUploadBadm: TdsdStoredProc;
    actUpdateisUploadBadm: TdsdExecStoredProc;
    bbUpdateisUploadBadm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnit_ObjectForm);
end.
