program UpdateOrdersSite;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\UpdateOrdersSite\MainUnit.pas' {MainForm},
  UtilConst in '..\..\SOURCE\UtilConst.pas',
  AncestorBase in 'D:\DSD\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  CommonData in 'D:\DSD\SOURCE\CommonData.pas',
  Authentication in 'D:\DSD\SOURCE\Authentication.pas',
  Storage in 'D:\DSD\SOURCE\Storage.pas',
  DataModul in 'D:\DSD\SOURCE\DataModul.pas' {dmMain: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ConnectionPath := '..\INIT\farmacy_init.php';
  gc_ProgramName := 'Farmacy.exe';
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
