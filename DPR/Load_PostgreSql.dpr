program Load_PostgreSql;

uses
  Forms,
  Main in '..\Load_PostgreSql\Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
