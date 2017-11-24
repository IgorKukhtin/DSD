program EDIOrdersLoader;

uses
  Vcl.Forms,
  Storage,
  Authentication,
  CommonData,
  EDIOrdersLoader.Main in '..\EDIOrdersLoader\EDIOrdersLoader.Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�������� EDI', '��������123EDI', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
