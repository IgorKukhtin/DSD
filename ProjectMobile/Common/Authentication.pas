unit Authentication;

interface

uses
  {$IFDEF ANDROID}
  FMX.Platform.Android,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.Provider ,
  Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  {$ENDIF}
  Storage;


type

  ///	<summary>
  /// Класс хранящий информацию о текущем пользователе
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TUser = class
  private
    FLogin: String;
    FPassword: String;
    FSession: String;
    FLocal: Boolean;

    procedure SetLocal(const Value: Boolean);
  public
    constructor Create(ALogin, APassword: string;
      ASession: String = ''; ALocal: Boolean = true);

    property Login: String read FLogin;
    property Password: String read FPassword;
    property Session: String read FSession write FSession;
    Property Local: Boolean read FLocal Write SetLocal;
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
      ANeedShowException: Boolean = True): string;
  end;

implementation

uses Xml.XMLDoc, UtilConst, SysUtils, IdIPWatch, Xml.XmlIntf, CommonData;

{------------------------------------------------------------------------------}
constructor TUser.Create(ALogin, APassword: string; ASession: String = '';
  ALocal: Boolean = true);
begin
  FLogin := ALogin;
  FPassword := APassword;
  FSession := ASession;
  FLocal := ALocal;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLogin(pStorage: IStorage;
  const pUserName, pPassword: string; var pUser: TUser;
  ANeedShowException: Boolean = True): string;
var
  N: IXMLNode;
  {$IFDEF ANDROID}
  obj: JObject;
  tm: JTelephonyManager;
  {$ENDIF}
  IMEI: String;
const
  {создаем XML вызова процедуры на сервере}
  pXML =
  '<xml Session = "" >' +
    '<gpCheckLoginMobile OutputType="otResult">' +
      '<inUserLogin    DataType="ftString" Value="%s" />' +
      '<inUserPassword DataType="ftString" Value="%s" />' +
      '<inSerialNumber DataType="ftString" Value="%s" />' +
    '</gpCheckLoginMobile>' +
  '</xml>';
begin
  {$IFDEF ANDROID}
  obj := SharedActivityContext.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
  if obj <> nil then
  begin
    tm := TJTelephonyManager.Wrap( (obj as ILocalObject).GetObjectID );
    if tm <> nil then
      IMEI := JStringToString(tm.getDeviceId);
  end;
  if IMEI = '' then
    IMEI := JStringToString(TJSettings_Secure.JavaClass.getString(SharedActivity.getContentResolver,
                            TJSettings_Secure.JavaClass.ANDROID_ID));
  {$ELSE}
  IMEI := '';
  {$ENDIF}

  N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IMEI]), False, 4, ANeedShowException)).DocumentElement;

  if Assigned(N) then
  begin
    if Assigned(pUser) then
    begin
      pUser.Session := N.GetAttribute(AnsiLowerCase(gcSession));
      pUser.Local := false;
    end
    else
      pUser := TUser.Create(pUserName, pPassword, N.GetAttribute(AnsiLowerCase(gcSession)), false);

    Result := N.GetAttribute(AnsiLowerCase(gcMessage));
  end
  else
    Result := 'Не удалось установить соединение';
end;

procedure TUser.SetLocal(const Value: Boolean);
var
  I : Integer;
  //F: TForm;
begin
  FLocal := Value;
  {for I := 0 to Screen.FormCount - 1 do
  Begin
    try
      F := Screen.Forms[I];
      if assigned(F) AND (F.Handle <> 0) AND (F.ClassNameIs('TMainCashForm')) then
        PostMessage(F.Handle, UM_LOCAL_CONNECTION,0,0);
    Except
    end;
  End; }
end;

end.
