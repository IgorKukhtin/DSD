program EDIOrdersLoader;

uses
  Vcl.Forms,
  Storage,
  SysUtils,
  Authentication,
  CommonData,
  EDIOrdersLoader.Main in '..\EDIOrdersLoader\EDIOrdersLoader.Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  Log in '..\SOURCE\Log.pas',
  UtilConst in '..\SOURCE\UtilConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
//  Logger.Enabled:= TRUE;

//  gc_isDebugMode:= TRUE;
//  gc_isShowTimeMode:= TRUE;

  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Авто-Загрузка EDI', 'Загрузка123EDI', gc_User);
  //TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'qsxqsxw1', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
