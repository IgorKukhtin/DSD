unit Authentication;

interface

uses Storage;

type

  ///	<summary>
  /// Класс хранящий информацию о текущем пользователе
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TUser = class
  strict private
    class var FLocal: boolean;
    class var FLocalMaxAtempt: Byte;

  private
    FSession: String;
    FLogin: String;
    procedure SetLocal(const Value: Boolean);
    function GetLocal: Boolean;
    procedure SetLocalMaxAtempt(const Value: Byte = 10);
    function GetLocalMaxAtempt: Byte;
  public
    property Session: String read FSession;
    Property Local: Boolean read GetLocal Write SetLocal;
    Property LocalMaxAtempt: Byte read GetLocalMaxAtempt Write SetLocalMaxAtempt;
    property Login: String read FLogin;
    constructor Create(ASession: String; ALocal: Boolean = false);
  end;

  ///	<summary>
  /// Класс аутентификации пользователя
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TAuthentication = class
    ///	<summary>
    /// Проверка логина и пароля. В случае успеха возвращает данные о пользователе.
    ///	</summary>
    class function CheckLogin(pStorage: IStorage;
      const pUserName, pPassword: string; var pUser: TUser;
      ANeedShowException: Boolean = True): boolean;
    class function spCheckPhoneAuthentSMS (const pPhoneAuthent: string): boolean;
  end;

implementation

uses iniFiles, Xml.XMLDoc, UtilConst, SysUtils, IdIPWatch, Xml.XmlIntf, CommonData, WinAPI.Windows,
  vcl.Forms, vcl.Dialogs;

{------------------------------------------------------------------------------}
function GetIniFile(out AIniFileName: String):boolean;
const
  FileName: String = '\Boutique.ini';
var
  dir: string;
  f: TIniFile;
Begin
  result := False;
  dir := ExtractFilePath(Application.exeName)+'ini';
  AIniFileName := dir + FileName;
  //
  if not DirectoryExists(dir) AND not ForceDirectories(dir) then
  Begin
    ShowMessage('Пользователь не может получить доступ к файлу настроек:'+#13
              + AIniFileName+#13
              + 'Дальнейшая работа программы невозможна.'+#13
              + 'Обратитесь к администратору.');
    exit;
  End;
  //
  if not FileExists (AIniFileName) then
  Begin
    f := TiniFile.Create(AIniFileName);
    try
      try
        F.WriteString('Common','BoutiqueName','');
      Except
        ShowMessage('Пользователь не может получить доступ к файлу настроек:'+#13
                  + AIniFileName+#13
                  + 'Дальнейшая работа программы невозможна.'+#13
                  + 'Обратитесь к администратору.');
        exit;
      end;
    finally
      f.Free;
    end;
  end;
  //
  result := True;
End;
{------------------------------------------------------------------------------}
constructor TUser.Create(ASession: String; ALocal: Boolean = false);
begin
  FSession := ASession;
  FLocal := ALocal;
  FLogin := '';
end;
{------------------------------------------------------------------------------}
class function TAuthentication.spCheckPhoneAuthentSMS (const pPhoneAuthent: string): boolean;
begin
     // Send SMS
     // Check Enter SMS
end;
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLogin(pStorage: IStorage;
  const pUserName, pPassword: string; var pUser: TUser;
  ANeedShowException: Boolean = True): boolean;
var IP_str:string;
    N: IXMLNode;
    pXML : String;
    BoutiqueName, IniFileName: String;
    f: TIniFile;
    isBoutique, isProject : Boolean;
begin
   //
   isBoutique:= (AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Boutique.exe'))
              or(AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Boutique_Demo.exe'));
   //
   isProject:= (AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Project.exe'));

  {создаем XML вызова процедуры на сервере}
  if isBoutique = TRUE
  then begin
      //
      if GetIniFile (IniFileName) then
        try BoutiqueName:= '';
            f := TiniFile.Create(IniFileName);
            BoutiqueName:= f.ReadString('Common','BoutiqueName','');
        finally
            f.Free;
        end
      else begin
        result:=false;
        exit;
      end;

      // для Бутиков - еще 1 параметр
      pXML :=
      '<xml Session = "" >' +
        '<gpCheckLogin OutputType="otResult">' +
          '<inUserLogin    DataType="ftString" Value="%s" />' +
          '<inUserPassword DataType="ftString" Value="%s" />' +
          '<inIP           DataType="ftString" Value="%s" />' +
          '<inBoutiqueName DataType="ftString" Value="%s" />' +
        '</gpCheckLogin>' +
      '</xml>';
  end
  else
      // для Project - еще 1 параметр - Телефон для аутентификации
      if isProject = TRUE
      then
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
            '<ioPhoneAuthent DataType="ftString" Value="%s" />' +
          '</gpCheckLogin>' +
        '</xml>'
      else
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
          '</gpCheckLogin>' +
        '</xml>';

  with TIdIPWatch.Create(nil) do
  begin
        Active:=true;
        IP_str:=LocalIP;
        Free;
  end;

  if isBoutique = TRUE
  then
       // для Бутиков - еще 1 параметр
       N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, BoutiqueName]), False, 4, ANeedShowException)).DocumentElement
  else if isProject = TRUE
       then
         // для Project - еще 1 параметр - Телефон для аутентификации
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, BoutiqueName]), False, 4, ANeedShowException)).DocumentElement
       else
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str]), False, 4, ANeedShowException)).DocumentElement;
  //
  if Assigned(N) then
  begin
       // сформировали смс, проверили что он корректный
       if isProject = TRUE then spCheckPhoneAuthentSMS(N.GetAttribute(AnsiLowerCase('ioPhoneAuthent')));
       //
       pUser := TUser.Create(N.GetAttribute(AnsiLowerCase(gcSession)));
       pUser.FLogin := pUserName;
  end;
  result := pUser <> nil
end;

function TUser.GetLocal: Boolean;
begin
  Result := TUser.FLocal;
end;

procedure TUser.SetLocal(const Value: Boolean);
var
  I : Integer;
  F: TForm;
begin
  TUser.FLocal := Value;
  for I := 0 to Screen.FormCount - 1 do
  Begin
    try
      F := Screen.Forms[I];
      if assigned(F) AND (F.Handle <> 0) AND (F.ClassNameIs('TMainCashForm') or F.ClassNameIs('TMainCashForm2')) then
        PostMessage(F.Handle, UM_LOCAL_CONNECTION,0,0);
    Except
    end;
  End;
end;

function TUser.GetLocalMaxAtempt: Byte;
begin
  Result := TUser.FLocalMaxAtempt;
end;

procedure TUser.SetLocalMaxAtempt(const Value: Byte = 10);
begin
  TUser.FLocalMaxAtempt := Value;
end;

end.
