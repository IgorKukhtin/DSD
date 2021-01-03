program SendDataEmail;

uses
  Vcl.Forms,
  Storage,
  System.SysUtils,
  Authentication,
  CommonData,
  UtilConst in '..\SOURCE\UtilConst.pas',
  Log in '..\SOURCE\Log.pas',
  SendDataEmail.Main in '..\SendDataEmail\SendDataEmail.Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas';

{$R *.res}

begin
  ConnectionPath := '..\INIT\podium_init.php';
  gc_ProgramName := 'Boutique.exe';
  Logger.Enabled := FindCmdLineSwitch('log');
  //gc_isDebugMode := true;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� Email', '������������2315Email', gc_User);
//  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
