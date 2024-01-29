program RecoveryFarmacy;

uses
  MidasLib,
  Vcl.Forms,
  System.SysUtils,
  MainUnit in '..\FormsFarmacy\MainUnitService\RecoveryFarmacy\MainUnit.pas' {MainForm},
  UtilConst in '..\SOURCE\UtilConst.pas',
  AncestorBase in '..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  Storage in '..\SOURCE\Storage.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas';

{$R *.res}

begin
  gc_ProgramName := 'Farmacy.exe';
  dsdProject := prFarmacy;
  if FileExists(ExtractFilePath(ParamStr(0)) + gc_ProgramName) and (CompareText(ParamStr(1), 'manual') <> 0) then
  begin
    Exit;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ConnectionPath := '..\INIT\farmacy_init.php';
 // TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
