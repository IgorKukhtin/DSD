program ProcesUkraineAlarm;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ProcesUkraineAlarm\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
