program FarmacyInventory;

uses
  MidasLib,
  Vcl.Forms,
  Winapi.Windows,
  System.SysUtils,
  AncestorBase in '..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  AncestorDialog in '..\Forms\Ancestor\AncestorDialog.pas' {AncestorDialogForm: TParentForm},
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  Storage in '..\SOURCE\Storage.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas',
  Log in '..\SOURCE\Log.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  MainUnit in '..\FormsFarmacy\Inventory\MainUnit.pas' {MainForm};

{$R *.res}

  var hMutexCurr: HWND;

begin

  hMutexCurr := CreateMutex(nil, false, PChar(ExtractFileName(ParamStr(0))));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(hMutexCurr);
    MessageBox(FindWindow('ProgMan', nil), PChar('Программа уже запущена.'), 'Ошибка', MB_OK);
    Exit;
  end;

  Application.Initialize;

  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';
  SQLiteFile := iniLocalDataBaseSQLite;
  gc_ProgramName := 'FarmacyCash.exe';
  dsdProject := prFarmacy;
  TdsdApplication.Create;


  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
