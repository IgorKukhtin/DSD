program Rewiring;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  UnitSettings in 'UnitSettings.pas',
  UnitConst in 'UnitConst.pas',
  ThreaHistoryCostUnit in 'ThreaHistoryCostUnit.pas',
  ThreaRewiringUnit in 'ThreaRewiringUnit.pas',
  ThreaSendMovementUnit in 'ThreaSendMovementUnit.pas',
  ThreaFunctionUnit in 'ThreaFunctionUnit.pas',
  ThreaCheckingHistoryCostUnit in 'ThreaCheckingHistoryCostUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
