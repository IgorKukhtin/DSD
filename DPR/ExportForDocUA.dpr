program ExportForDocUA;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportForDocUA\MainUnit.pas' {MainForm},
  libssh2 in '..\SOURCE\SFTP\libssh2.pas',
  libssh2_sftp in '..\SOURCE\SFTP\libssh2_sftp.pas',
  SSHSFTPClient in '..\SOURCE\SFTP\SSHSFTPClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
