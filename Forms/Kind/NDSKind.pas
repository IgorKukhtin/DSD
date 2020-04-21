unit NDSKind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dsdDB, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPCdxBarPopupMenu, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus, ParentForm,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TNDSKindForm = class(TAncestorEnumForm)
    clName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TNDSKindForm);

end.

