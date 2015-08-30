unit RecalcMCS_Dialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxClasses, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit, cxLabel;

type
  TRecalcMCS_DialogForm = class(TAncestorDialogForm)
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edPeriod: TcxCurrencyEdit;
    edDay: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RecalcMCS_DialogForm: TRecalcMCS_DialogForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRecalcMCS_DialogForm);

end.
