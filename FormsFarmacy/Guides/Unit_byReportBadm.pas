unit Unit_byReportBadm;

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
  TUnit_byReportBadmForm = class(TAncestorEnumForm)
    NumUnit: TcxGridDBColumn;
    ceParentName: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnit_byReportBadmForm);
end.
