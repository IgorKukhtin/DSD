program EDIOrdersLoader;

uses
  Vcl.Forms,
  Storage,
  Authentication,
  CommonData,
  EDIOrdersLoader.Main in '..\EDIOrdersLoader\EDIOrdersLoader.Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� EDI', '��������123EDI', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
