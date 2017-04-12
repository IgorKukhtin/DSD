unit CommonData;

//  В модуле хранятся глобальные переменные ддя приложения
interface
uses Authentication,
     {$IFDEF MSWINDOWS}
     WinApi.Messages,
     {$ENDIF}
     System.Classes;

var
  gc_User: TUser;  // Пользователь, под которым зашли в программу
  gc_ProgramName: String = 'ProjectMobile.exe'; // Название программы
  gc_WebServers: TArray<string>;
  gc_WebService: String = '';
  gc_allowLocalConnection: Boolean = False;
  gc_StartParams: TStringList;

{$IFDEF MSWINDOWS}
CONST
  UM_THREAD_EXCEPTION = WM_USER + 101;
  UM_LOCAL_CONNECTION = WM_USER + 102;
  UM_INSERTRECORD = WM_USER + 103;
  UM_EDITRECORD = WM_USER + 104;
  UM_DELETERECORD = WM_USER + 105;
  UM_SAVEANDCLOSE = WM_USER + 106;
  UM_CANCEL = WM_USER + 107;
  UM_MDICREATE = WM_USER + 108;
  UM_MDIDESTROY = WM_USER + 109;
  UM_MDIACTIVATE = WM_USER + 110;
  UM_MDIDEACTIVATE = WM_USER + 111;
{$ENDIF}

implementation

var
  i: Integer;
initialization
   gc_StartParams := TStringList.Create;
   for I := 1 to ParamCount do
     gc_StartParams.Add(ParamStr(I));
finalization
  gc_StartParams.Free;
end.
