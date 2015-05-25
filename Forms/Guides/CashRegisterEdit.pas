unit CashRegisterEdit;

interface

uses
  Winapi.Windows, DataModul, AncestorEditDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxPCdxBarPopupMenu, cxContainer,
  cxEdit, cxCheckBox, cxCurrencyEdit, cxLabel, cxTextEdit, cxPC, Vcl.Controls,
  dsdDB, dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, dsdAddOn,
  Vcl.StdCtrls, cxButtons, cxMemo, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dsdGuides, cxMaskEdit, cxButtonEdit;

type
  TCashRegisterEditForm = class(TAncestorEditDialogForm)
    edMeasureName: TcxTextEdit;
    cxLabel1: TcxLabel;
    ���: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    CashRegisterKindGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TCashRegisterEditForm);
end.
