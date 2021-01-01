program SendDataEmail;

uses
  Vcl.Forms,
  Storage,
  Authentication,
  CommonData,
  SendDataEmail.Main in '..\SendDataEmail\SendDataEmail.Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� EDI', '��������123EDI', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
