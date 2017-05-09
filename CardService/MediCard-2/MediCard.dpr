program MediCard;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  MediCard.Intf in 'MediCard.Intf.pas',
  MediCard.Dsgn in 'MediCard.Dsgn.pas',
  MediCard.Classes in 'MediCard.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
