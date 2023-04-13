program FarmacyInventory;

uses
  MidasLib,
  Vcl.Forms,
  Vcl.Controls,
  Winapi.Windows,
  System.SysUtils,
  AncestorBase in '..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  AncestorDialog in '..\Forms\Ancestor\AncestorDialog.pas' {AncestorDialogForm: TParentForm},
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  Storage in '..\SOURCE\Storage.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  Log in '..\SOURCE\Log.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  Splash in '..\FormsFarmacy\Cash\Splash.pas' {frmSplash},
  MainInventoryUnit in '..\FormsFarmacy\Inventory\MainInventoryUnit.pas' {MainInventoryForm},
  IniUtils in '..\FormsFarmacy\Inventory\IniUtils.pas';

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
  gc_ProgramName := 'FarmacyInventory.exe';
  dsdProject := prFarmacy;
  TdsdApplication.Create;

  with TLoginForm.Create(Application) do
  Begin
    // Позволяем переход в локальный режим
    AllowLocalConnect := True;
    gc_User.LocalMaxAtempt:=2;

    if ShowModal <> mrOk then
    begin
      Free;
      exit;
    end;

    if not gc_User.Local then
    Begin
      //InitCashSession(True);
      if not FileExists(ExtractFilePath(ParamStr(0)) + 'sqlite3.dll') then TUpdater.UpdateDll('sqlite3.dll');
      TUpdater.AutomaticUpdateProgram;
      if not FindCmdLineSwitch('skipcheckconnect') then TUpdater.AutomaticCheckConnect;

      StartSplash('Старт', 'Проведение инвентаризации');
      try
        ChangeStatus('Получение "Сотрудников и настроек"');
        SaveUserSettings;
        ChangeStatus('Получение "Форм"');
        SaveFormData;
        ChangeStatus('Получение "Аптек"');
        SaveUserUnit;
      finally
        EndSplash;
      end;
    End;

    Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TMainInventoryForm, MainInventoryForm);
  //StartCheckConnectThread(2);
  End;
  Application.Run;
  CloseHandle(hMutexCurr);
end.
