unit BankAccountMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons;

type
  TBankAccountMovementForm = class(TAncestorEditDialogForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BankAccountMovementForm: TBankAccountMovementForm;

implementation

{$R *.dfm}

end.
