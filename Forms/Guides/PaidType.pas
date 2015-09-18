unit PaidType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxRadioGroup, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses,
  dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore,
  cxGridLevel, cxGridCustomView, cxGrid, cxPC, cxPCdxBarPopupMenu;

type
  TPaidTypeForm = class(TAncestorEnumForm)
    colId: TcxGridDBColumn;
    colPaidTypeCode: TcxGridDBColumn;
    colPaidTypeName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PaidTypeForm: TPaidTypeForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPaidTypeForm)

end.
