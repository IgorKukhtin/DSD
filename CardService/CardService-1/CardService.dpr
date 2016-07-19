program CardService;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uCardService in 'uCardService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
