unit Country;

interface

uses
  AncestorDBGrid, DataModul, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  System.Classes, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.Controls, cxCheckBox;

type
  TCountryForm = class(TAncestorDBGridForm)
    spErasedUnErased: TdsdStoredProc;
    spInsertUpdateObject: TdsdStoredProc;
    spGet: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCountryForm);

end.
