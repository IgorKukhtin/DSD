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
    constructor Create(ASession: String; ALogin: String = ''; ALocal: Boolean = false);
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
    // Получить список логинов с сервера
    class function GetLoginList(pStorage: IStorage): string;
    class function spCheckGoogleOTPAuthent (pStorage: IStorage; const pSession, pProjectName, pUserName, pGoogleSecret: string; ANeedShowException: Boolean = True): boolean;
  end;

implementation

uses iniFiles, Xml.XMLDoc, UtilConst, SysUtils, IdIPWatch, Xml.XmlIntf, CommonData, WinAPI.Windows,
  vcl.Forms, vcl.Dialogs, dsdAction, GoogleOTPRegistration, GoogleOTPDialogPsw;

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
constructor TUser.Create(ASession: String; ALogin: String = ''; ALocal: Boolean = false);
begin
  FSession := ASession;
  FLocal := ALocal;
  FLogin := ALogin;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.spCheckGoogleOTPAuthent (pStorage: IStorage; const pSession, pProjectName, pUserName, pGoogleSecret: string; ANeedShowException: Boolean = True): boolean;
var GoogleSecret: string;
    N: IXMLNode;
    pXML : String;
begin
   Result := True;

   // Genegate and registretion GoogleSecret
   if pGoogleSecret = '' then
   begin
     with TGoogleOTPRegistrationForm.Create(nil) do
     try
       Result:= Execute (pProjectName, pUserName, GoogleSecret);
     finally
       Free;
     end;
   end else GoogleSecret := pGoogleSecret;

   if not Result OR (GoogleSecret = '') then Exit;

   // Validate Pas
   with TGoogleOTPDialogPswForm.Create(nil) do
   try
     Result:= Execute (pStorage, pSession, GoogleSecret);
   finally
     Free;
   end;

   if Result and (pGoogleSecret <> GoogleSecret) then
   begin
      pXML :=
      '<xml Session = "' + pSession + '" >' +
        '<gpUpdate_Object_User_GoogleSecret OutputType="otResult">' +
          '<inGoogleSecret DataType="ftString" Value="%s" />' +
        '</gpUpdate_Object_User_GoogleSecret>' +
      '</xml>';

      N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [GoogleSecret]), False, 4, TRUE)).DocumentElement;
      //
      Result:= Assigned(N);
   end;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLogin(pStorage: IStorage;
  const pUserName, pPassword: string; var pUser: TUser;
  ANeedShowException: Boolean = True): boolean;
var IP_str:string;
    N: IXMLNode;
    pXML : String;
    BoutiqueName, IniFileName, S, ProjectName: String;
    f: TIniFile;
    isBoutique, isProject : Boolean;
begin
   //ловим ProjectTest.exe
   S:= ExtractFileName(ParamStr(0));
   //
   isBoutique:= (AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Podium.exe'))
              or(AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Boutique.exe'))
              or(AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Boutique_Demo.exe'));
   //
   isProject:= (AnsiUpperCase(gc_ProgramName) =  AnsiUpperCase('Project.exe'))
           and (UpperCase(S) <> UpperCase('ProjectTest.exe'))
              ;
   if Pos('.', gc_ProgramName) > 0 then
     ProjectName := Copy(gc_ProgramName, 1, Pos('.', gc_ProgramName) - 1)
   else ProjectName := gc_ProgramName;

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
      // для Project - еще 2 параметра - для Google Authenticator
      if isProject = TRUE
      then
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
            '<ioisGoogleOTP  DataType="ftBoolean" Value="%s" />' +
            '<ioGoogleSecret DataType="ftString" Value="%s" />' +
          '</gpCheckLogin>' +
        '</xml>'
      else if POS(AnsiUpperCase('Farmacy'), AnsiUpperCase(ProjectName)) = 1
      then
        pXML :=
        '<xml Session = "" >' +
          '<gpCheckLogin OutputType="otResult">' +
            '<inUserLogin    DataType="ftString" Value="%s" />' +
            '<inUserPassword DataType="ftString" Value="%s" />' +
            '<inIP           DataType="ftString" Value="%s" />' +
            '<inProjectName  DataType="ftString" Value="%s" />' +
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
         // для Project - еще еще 2 параметра - для Google Authenticator
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, 'False', '']), False, 4, ANeedShowException)).DocumentElement
       else if POS(AnsiUpperCase('Farmacy'), AnsiUpperCase(ProjectName)) = 1 then
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str, ProjectName]), False, 4, ANeedShowException)).DocumentElement
       else
         N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str]), False, 4, ANeedShowException)).DocumentElement;
  //
  result := TRUE;
  //
  if Assigned(N) then
  begin
       // Google Authenticator
       if (isProject = TRUE) and N.GetAttribute(AnsiLowerCase('ioisGoogleOTP')) then
         result := spCheckGoogleOTPAuthent(pStorage, N.GetAttribute(AnsiLowerCase(gcSession)), ProjectName, pUserName, N.GetAttribute(AnsiLowerCase('ioGoogleSecret')), ANeedShowException);
       //
       pUser := TUser.Create(N.GetAttribute(AnsiLowerCase(gcSession)));
       pUser.FLogin := pUserName;
  end;
  //
  if result = FALSE then pUser:= nil;
  //
  result := (pUser <> nil);
end;

{------------------------------------------------------------------------------}
class function TAuthentication.GetLoginList(pStorage: IStorage): string;
var N: IXMLNode;
    pXML : String;
begin

  Result := '';

  {создаем XML вызова процедуры на сервере}
  pXML :=
    '<xml Session = "" >' +
      '<gpSelect_Object_UserLogin OutputType="otResult">' +
      '</gpSelect_Object_UserLogin>' +
    '</xml>';


  N := LoadXMLData(pStorage.ExecuteProc(pXML, False, 2, False)).DocumentElement;
  //
  if Assigned(N) then
  begin
     Result := N.GetAttribute(AnsiLowerCase('outLogin'));
  end;
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
