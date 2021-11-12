unit WorkTimeKind_Holiday;

interface

uses
  cxPC, AncestorEnum, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdAddOn,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  System.Classes, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGrid, Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit;

type
  TWorkTimeKind_HolidayForm = class(TAncestorEnumForm)
    spUpdateObject: TdsdStoredProc;
    FormParams: TdsdFormParams;
    clValue: TcxGridDBColumn;
    Tax: TcxGridDBColumn;
    actShowErased: TBooleanStoredProcAction;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    bbShowErased: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWorkTimeKind_HolidayForm);

end.
