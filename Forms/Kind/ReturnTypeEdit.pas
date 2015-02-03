unit ReturnTypeEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit, cxLabel;

type
  TReturnTypeEditForm = class(TAncestorEditDialogForm)
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    edName: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnTypeEditForm);

end.
