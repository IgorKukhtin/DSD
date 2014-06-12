unit ScreenKeyboard;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Keyboard, ExtCtrls, EUSignCP;

{ ------------------------------------------------------------------------------ }

type
  TScreenKeyboardForm = class(TForm)
    TouchKeyboard: TTouchKeyboard;
    UpdateTimer: TTimer;
    TextEdit: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure TextEditKeyPress(Sender: TObject; var Key: Char);

  private
    FocusedControl: TEdit;

  public
    IsShown: Boolean;
    procedure ShowKeyboard(Focused: TObject);

  end;

{ ------------------------------------------------------------------------------ }

var
  ScreenKeyboardForm: TScreenKeyboardForm;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TScreenKeyboardForm.FormActivate(Sender: TObject);
begin
  TextEdit.Text := FocusedControl.Text;
  TextEdit.SelStart := Length(FocusedControl.Text);

  UpdateTimer.Enabled := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TScreenKeyboardForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if IsShown then
  begin
    CanClose := True;
    UpdateTimer.Enabled := False;
    IsShown := False;

    FocusedControl.SelStart := Length(FocusedControl.Text);

    FocusedControl := nil;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TScreenKeyboardForm.FormDeactivate(Sender: TObject);
begin
  UpdateTimer.Enabled := False;
end;

{ ------------------------------------------------------------------------------ }

procedure TScreenKeyboardForm.ShowKeyboard(Focused: TObject);
begin
  UpdateTimer.Enabled := True;

  FocusedControl := TEdit(Focused);

  ShowModal;
end;

{ ------------------------------------------------------------------------------ }

procedure TScreenKeyboardForm.TextEditKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) or (Key = #13) then
  begin
    ModalResult := mrOK;

    CloseModal();
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TScreenKeyboardForm.UpdateTimerTimer(Sender: TObject);
begin
  FocusedControl.Text := TextEdit.Text;
end;

{ ============================================================================== }

end.
