unit Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmSplash = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;
procedure StartSplash(AStatus: String = ''; ACaption: String = 'Farmacy cash');
procedure EndSplash;
procedure ChangeStatus(AStatus: String);

implementation

{$R *.dfm}

procedure StartSplash(AStatus: String = ''; ACaption: String = 'Farmacy cash');
Begin
  if not assigned(frmSplash) then
  begin
    frmSplash := TfrmSplash.Create(nil);
    frmSplash.Caption := ACaption;
  end;
  frmSplash.Show;
  frmSplash.Refresh;
  if AStatus <> '' then
    ChangeStatus(AStatus);
End;

procedure EndSplash;
Begin
  if Assigned(frmSplash) then
  Begin
    frmSplash.Close;
    freeAndNil(frmSplash);
  End;
End;

procedure ChangeStatus(AStatus: String);
Begin
  if not assigned(frmSplash) then
    StartSplash(AStatus)
  else
  Begin
    frmSplash.Label1.Caption := AStatus;
    frmSplash.Label1.Repaint;
  End;
End;

end.
