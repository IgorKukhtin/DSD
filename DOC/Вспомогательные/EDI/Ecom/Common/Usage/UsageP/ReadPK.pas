unit ReadPK;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EUSignCP, ComCtrls, ImgList, KeyMedia;

{ ------------------------------------------------------------------------------ }

type
  TReadPKForm = class(TForm)
    TopLabel: TLabel;
    BottomPanel: TPanel;
    BottomUnderlineImage: TImage;
    CancelButton: TButton;
    OKButton: TButton;
    TopImage: TImage;
    KeyMediaFrame: TKeyMediaFrame;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);

    public
      function ReadPrivateKey(CPInterface: PEUSignCP;
        CertOwnerInfo: PEUCertOwnerInfo): Cardinal;
  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses
  EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

function TReadPKForm.ReadPrivateKey(CPInterface: PEUSignCP;
  CertOwnerInfo: PEUCertOwnerInfo): Cardinal;
var
  Error: Cardinal;
  KeyMedia: TEUKeyMedia;

begin
  KeyMediaFrame.ConfigForm(CPInterface, @KeyMedia, False);
  if (ShowModal() = mrOk) then
  begin
    Error := CPInterface.ReadPrivateKey(@KeyMedia, CertOwnerInfo);
    if (Error <> EU_ERROR_NONE) then
      EUShowError(Handle, Error);
  end
  else
	  Error := EU_ERROR_CANCELED_BY_GUI;

  ReadPrivateKey := Error;
end;

{ ============================================================================== }

procedure TReadPKForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  KeyMediaFrame.FormCloseQuery(Sender, CanClose);
end;

{ ------------------------------------------------------------------------------ }

procedure TReadPKForm.FormShow(Sender: TObject);
begin
  KeyMediaFrame.FormShow(Sender);
end;

{ ------------------------------------------------------------------------------ }

procedure TReadPKForm.OKButtonClick(Sender: TObject);
begin
  KeyMediaFrame.OKButtonClick(Sender);
end;

{ ============================================================================== }

end.
