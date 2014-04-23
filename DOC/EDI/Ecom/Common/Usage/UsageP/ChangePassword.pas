unit ChangePassword;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  KeyMedia, Forms, StdCtrls, Controls, ExtCtrls, EUSignCP;

{ ------------------------------------------------------------------------------ }

type
  TChangePasswordForm = class(TForm)
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    CancelButton: TButton;
    OKButton: TButton;
    KeyMediaFrame: TKeyMediaFrame;
    TopImage: TImage;
    TopLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OKButtonClick(Sender: TObject);

  public
    function ChangePrivateKeyPassword(CPInterface: PEUSignCP;
      KeyMedia: PEUKeyMedia): Cardinal;
  end;

{ ------------------------------------------------------------------------------ }

var
  ChangePasswordForm: TChangePasswordForm;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ------------------------------------------------------------------------------ }

uses
  EUSignCPOwnUI;

{ ============================================================================== }

function TChangePasswordForm.ChangePrivateKeyPassword(CPInterface: PEUSignCP;
  KeyMedia: PEUKeyMedia): Cardinal;
var
  Error: Cardinal;
  NewPassword: array [0 .. EU_PASS_MAX_LENGTH - 1] of AnsiChar;
  KeyMediaIn: TEUKeyMedia;
  IsPKReaded: Boolean;

begin
  IsPKReaded := KeyMedia <> nil;
  if (not IsPKReaded) then
    KeyMedia := @KeyMediaIn;

  KeyMediaFrame.ConfigForm(CPInterface, KeyMedia, True, @NewPassword, IsPKReaded);
  if (ShowModal() = mrOk) then
  begin
    Error := CPInterface.ChangePrivateKeyPassword(KeyMedia, @NewPassword);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
    end
    else
     StrCopy(KeyMedia.Password, NewPassword);
  end
  else
	  Error := EU_ERROR_CANCELED_BY_GUI;

  ChangePrivateKeyPassword := Error;
end;

{ ============================================================================== }

procedure TChangePasswordForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  KeyMediaFrame.FormCloseQuery(Sender, CanClose);
end;

{ ------------------------------------------------------------------------------ }

procedure TChangePasswordForm.FormShow(Sender: TObject);
begin
  KeyMediaFrame.FormShow(Sender);
end;

{ ------------------------------------------------------------------------------ }

procedure TChangePasswordForm.OKButtonClick(Sender: TObject);
begin
  KeyMediaFrame.OKButtonClick(Sender);
end;

{ ============================================================================== }

end.
