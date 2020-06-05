program ExportForDocUA;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportForDocUA\MainUnit.pas' {MainForm},
  uMySFTPClient in '..\FormsFarmacy\MainUnitService\ExportForDocUA\uMySFTPClient.pas',
  libssh2 in '..\FormsFarmacy\MainUnitService\ExportForDocUA\libssh2.pas',
  libssh2_sftp in '..\FormsFarmacy\MainUnitService\ExportForDocUA\libssh2_sftp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
