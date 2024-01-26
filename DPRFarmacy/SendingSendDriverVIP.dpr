program SendingSendDriverVIP;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\SendingSendDriverVIP\MainUnit.pas' {MainForm},
  UtilTelegram in '..\SOURCE\UtilTelegram.pas',
  Report_Movement_Send_RemainsSun_Supplement_v2 in '..\FormsFarmacy\Report\Report_Movement_Send_RemainsSun_Supplement_v2.pas' {Report_Movement_Send_RemainsSun_Supplement_v2Form: TParentForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TReport_Movement_Send_RemainsSun_Supplement_v2Form, Report_Movement_Send_RemainsSun_Supplement_v2Form);
  Application.Run;
end.
