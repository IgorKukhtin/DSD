unit InternshipConfirmation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, System.RegularExpressions;

type
  TInternshipConfirmationForm = class(TForm)
    bbOk: TcxButton;
    pn1: TPanel;
    pn2: TPanel;
    cxButton1: TcxButton;
    cxTextEdit1: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowInternshipConfirmation : Integer;

implementation

{$R *.dfm}

function ShowInternshipConfirmation : Integer;
  var InternshipConfirmationForm : TInternshipConfirmationForm;
begin
  InternshipConfirmationForm := TInternshipConfirmationForm.Create(Screen.ActiveControl);
  try
    Result := InternshipConfirmationForm.ShowModal;
  finally
    InternshipConfirmationForm.Free;
  end;
end;

end.
