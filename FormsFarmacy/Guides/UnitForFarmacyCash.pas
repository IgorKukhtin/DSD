unit UnitForFarmacyCash;

interface

uses
  Winapi.Windows, AncestorEnum, DataModul, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  Datasnap.DBClient, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, Vcl.Controls, cxGrid,
  cxPCdxBarPopupMenu, Vcl.Menus, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, cxCalendar;

type
  TUnitForFarmacyCashForm = class(TAncestorEnumForm)
    ceJuridicalName: TcxGridDBColumn;
    ceParentName: TcxGridDBColumn;
    UnitId: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnitForFarmacyCashForm);
end.
