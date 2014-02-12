unit Maker;

interface

uses
  AncestorDBGrid, DataModul, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  System.Classes, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.Controls, cxCheckBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxButtonEdit;

type
  TMakerForm = class(TAncestorDBGridForm)
    spErasedUnErased: TdsdStoredProc;
    spInsertUpdateObject: TdsdStoredProc;
    spGet: TdsdStoredProc;
    dsdUpdateDataSet: TdsdUpdateDataSet;
    clCountryName: TcxGridDBColumn;
    CountryChoiceForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMakerForm);

end.
