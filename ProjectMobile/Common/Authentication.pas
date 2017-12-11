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
  Androidapi.JNI.App,
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
  lIMEI      : String;
  lModel     : String;
  lVesion    : String;
  lVesionSDK : String;
  ConnectOk: boolean;
  ServNum: integer;
const
  {создаем XML вызова процедуры на сервере}
  pXML =
  '<xml Session = "" >' +
    '<gpCheckLoginMobile OutputType="otResult">' +
      '<inUserLogin    DataType="ftString" Value="%s" />' +
      '<inUserPassword DataType="ftString" Value="%s" />' +
      '<inSerialNumber DataType="ftString" Value="%s" />' +
      '<inModel        DataType="ftString" Value="%s" />' +
      '<inVesion       DataType="ftString" Value="%s" />' +
      '<inVesionSDK    DataType="ftString" Value="%s" />' +
    '</gpCheckLoginMobile>' +
  '</xml>';
begin
  lIMEI      := '';
  lModel     := '';
  lVesion    := '';
  lVesionSDK := '';

  {$IFDEF ANDROID}
  obj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
  if obj <> nil then
  begin
    tm := TJTelephonyManager.Wrap( (obj as ILocalObject).GetObjectID );
    if tm <> nil then begin
      lIMEI      := JStringToString(tm.getDeviceId);
      lModel     := JStringToString(tm.getLine1Number);
      lVesion    := JStringToString(tm.getDeviceSoftwareVersion);
      lVesionSDK := '';
    end;
  end;
  if lIMEI = '' then begin
    lIMEI      := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.Activity.getContentResolver,
                                  TJSettings_Secure.JavaClass.ANDROID_ID));
    lModel     := '';
    lVesion    := '';
    lVesionSDK := '';
  end;
  {$ELSE}
  lIMEI      := '';
  lModel     := '';
  lVesion    := '';
  lVesionSDK := '';
  {$ENDIF}

  ConnectOk := false;
  ServNum := -1;
  repeat
    try
      inc(ServNum);
      if ServNum > 0 then
      begin
        gc_WebService := gc_WebServers[ServNum];
        pStorage.Connection := gc_WebService;
      end;

      N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, lIMEI, lModel, lVesion, lVesionSDK]), False, 1, ANeedShowException)).DocumentElement;
      if Assigned(N) then
      begin
        Result := N.GetAttribute(AnsiLowerCase(gcMessage));

        ConnectOk := true;

        if Result = '' then
        begin
          if Assigned(pUser) then
          begin
            pUser.Session := N.GetAttribute(AnsiLowerCase(gcSession));
            pUser.Local := false;
          end
          else
            pUser := TUser.Create(pUserName, pPassword, N.GetAttribute(AnsiLowerCase(gcSession)), false);
        end;
      end;
    except
    end;
  until ConnectOk or (ServNum >= Length(gc_WebServers) - 1);

  if not ConnectOk then
    raise Exception.Create('Не удалось установить соединение');
end;

procedure TUser.SetLocal(const Value: Boolean);
begin
  FLocal := Value;
end;

end.
