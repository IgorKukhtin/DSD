unit WorkTimeKind;

interface

uses
  cxPC, AncestorEnum, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdAddOn,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  System.Classes, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGrid, Vcl.Controls, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxButtonEdit;

type
  TWorkTimeKindForm = class(TAncestorEnumForm)
    spInsertUpdateObject: TdsdStoredProc;
    PayrollTypeName: TcxGridDBColumn;
    actPayrollTypeChoice: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWorkTimeKindForm);

end.
