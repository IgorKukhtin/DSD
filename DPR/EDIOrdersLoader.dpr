program EDIOrdersLoader;

uses
  Vcl.Forms,
  Storage,
  SysUtils,
  Authentication,
  CommonData,
  EDIOrdersLoader.Main in '..\EDIOrdersLoader\EDIOrdersLoader.Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  Log in '..\SOURCE\Log.pas';

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');

  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Авто-Загрузка EDI', 'Загрузка123EDI', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
