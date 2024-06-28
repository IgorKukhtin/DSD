unit FMX.Authentication;

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
  Androidapi.JNI.Os,  //TJBuild
  //Androidapi.Helpers, // StringToJString
  FMX.Platform,
  {$ENDIF}
  FMX.Storage;


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

    property Login: String read FLogin write FLogin;
    property Password: String read FPassword write FPassword;
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
    class function CheckLoginCode(pStorage: IStorage;
      const pCode: string; var pUser: TUser;
      ANeedShowException: Boolean = True): string;
  end;

implementation

uses Xml.XMLDoc, FMX.UtilConst, SysUtils, IdIPWatch, Xml.XmlIntf, FMX.CommonData;

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
  LocaleService: IFMXLocaleService;
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
  {$ENDIF}
  lIMEI      : String;
  lBrand     : String;
  lModel     : String;
  lLang      : String;
  lVesion    : String;
  lVesion_two: String;
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
  lBrand     := '';
  lModel     := '';
  lLang      := '';
  lVesion    := '';
  lVesion_two:= '';
  lVesionSDK := '';

  {$IFDEF ANDROID}
  // Модель телефона
  try lBrand := JStringToString(TJBuild.JavaClass.BRAND); except lBrand:='???'; end;
  // Модель телефона
  try lModel := JStringToString(TJBuild.JavaClass.MODEL); except lModel:='???'; end;
  try lModel := lModel + ' PRODUCT:' + JStringToString(TJBuild.JavaClass.PRODUCT)
                       + ' SERIAL:' + JStringToString(TJBuild.JavaClass.SERIAL)
                       + ' DEVICE:' + JStringToString(TJBuild.JavaClass.DEVICE)
                        ;
  except lModel:= lModel + ' ???'; end;
  // Версия Android
  try lVesion:= TOSVersion.Name; except lVesion:='???'; end;
  // Версия Android
  try lVesion_two:= Format('%d.%d', [TOSVersion.Major,TOSVersion.Minor]); except lVesion_two:='?.?'; end;
  try lVesion_two:= lVesion_two + ' Platform :' + Format('%d', [Ord(TOSVersion.Platform)]); except lVesion_two:= lVesion_two + ' Platform :???'; end;
  // Версия SDK
  try lVesionSDK:= JStringToString(TJBuild_VERSION.JavaClass.SDK); except lVesionSDK:= '???'; end;
  try lVesionSDK:= lVesionSDK + '(' + IntToStr(TJBuild_VERSION.JavaClass.SDK_INT)+')'; except lVesionSDK:= lVesionSDK + ' (?)'; end;
  // Версия ПРОГРАММЫ
  PackageManager := TAndroidHelper.Activity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  lVesionSDK:= lVesionSDK + ' + PM: ' + JStringToString(PackageInfo.versionName);
  //
  try
    if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, IInterface(LocaleService))
    then
      lLang := LocaleService.GetCurrentLangID()
    else lLang := '?1?';
  except lLang:='???'; end;

  try
    obj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
    if obj <> nil then
    begin
      tm := TJTelephonyManager.Wrap( (obj as ILocalObject).GetObjectID );
      if tm <> nil then begin
        // IMEI телефона - работает
         lIMEI      := JStringToString(tm.getDeviceId);
        // Модель телефона
        //lModel     := '???'; //
        // Версия Android
        //lVesion    := '???'; // JStringToString(tm.getDeviceSoftwareVersion);
        // Версия SDK
        //lVesionSDK := '???';
      end;
    end;
  except lIMEI:=''; end;

  if lIMEI = '' then begin
    // IMEI телефона - работает
    lIMEI      := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.Activity.getContentResolver,
                                  TJSettings_Secure.JavaClass.ANDROID_ID));
    // Модель телефона
    //lModel     := '???';
    // Версия Android
    //lVesion    := '???';
    // Версия SDK
    //lVesionSDK := '???';
  end;
  {$ELSE}
  lIMEI      := '';
  lBrand     := '';
  lModel     := '';
  lLang      := '';
  lVesion    := '';
  lVesion_two:= '';
  lVesionSDK := '';
  {$ENDIF}

  ConnectOk := false;
  ServNum := -1;
  repeat
    try
      inc(ServNum);
      if ServNum > 0 then gc_WebService := gc_WebServers[ServNum];
      pStorage.Connection := gc_WebService;

      lModel:= lBrand + ' ' + lModel;
      lVesion:= lVesion + ' '  + lVesion_two;
      //lVesionSDK:= lVesionSDK;

      N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, lIMEI, lModel, lVesion, lVesionSDK]), False, 2, ANeedShowException)).DocumentElement;
      if Assigned(N) then
      begin
        Result := N.GetAttribute(AnsiLowerCase(gcMessage));

        ConnectOk := true;

        if Result = '' then
        begin
          if Assigned(pUser) then
          begin
            pUser.Login := pUserName;
            pUser.Password := pPassword;
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
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLoginCode(pStorage: IStorage;
  const pCode: string; var pUser: TUser;
  ANeedShowException: Boolean = True): string;
var
  N: IXMLNode;
  {$IFDEF ANDROID}
  obj: JObject;
  tm: JTelephonyManager;
  LocaleService: IFMXLocaleService;
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
  {$ENDIF}
  lIMEI      : String;
  lBrand     : String;
  lModel     : String;
  lLang      : String;
  lVesion    : String;
  lVesion_two: String;
  lVesionSDK : String;
  ConnectOk: boolean;
  ServNum: integer;
const
  {создаем XML вызова процедуры на сервере}
  pXML =
  '<xml Session = "" >' +
    '<gpCheckLoginCodeMobile OutputType="otResult">' +
      '<inUserId       DataType="ftInteger" Value="%s" />' +
      '<inSerialNumber DataType="ftString" Value="%s" />' +
      '<inModel        DataType="ftString" Value="%s" />' +
      '<inVesion       DataType="ftString" Value="%s" />' +
      '<inVesionSDK    DataType="ftString" Value="%s" />' +
    '</gpCheckLoginCodeMobile>' +
  '</xml>';
begin
  lIMEI      := '';
  lBrand     := '';
  lModel     := '';
  lLang      := '';
  lVesion    := '';
  lVesion_two:= '';
  lVesionSDK := '';

  {$IFDEF ANDROID}
  // Модель телефона
  try lBrand := JStringToString(TJBuild.JavaClass.BRAND); except lBrand:='???'; end;
  // Модель телефона
  try lModel := JStringToString(TJBuild.JavaClass.MODEL); except lModel:='???'; end;
  try lModel := lModel + ' PRODUCT:' + JStringToString(TJBuild.JavaClass.PRODUCT)
                       + ' SERIAL:' + JStringToString(TJBuild.JavaClass.SERIAL)
                       + ' DEVICE:' + JStringToString(TJBuild.JavaClass.DEVICE)
                        ;
  except lModel:= lModel + ' ???'; end;
  // Версия Android
  try lVesion:= TOSVersion.Name; except lVesion:='???'; end;
  // Версия Android
  try lVesion_two:= Format('%d.%d', [TOSVersion.Major,TOSVersion.Minor]); except lVesion_two:='?.?'; end;
  try lVesion_two:= lVesion_two + ' Platform :' + Format('%d', [Ord(TOSVersion.Platform)]); except lVesion_two:= lVesion_two + ' Platform :???'; end;
  // Версия SDK
  try lVesionSDK:= JStringToString(TJBuild_VERSION.JavaClass.SDK); except lVesionSDK:= '???'; end;
  try lVesionSDK:= lVesionSDK + '(' + IntToStr(TJBuild_VERSION.JavaClass.SDK_INT)+')'; except lVesionSDK:= lVesionSDK + ' (?)'; end;
  // Версия ПРОГРАММЫ - захардкодим в SDK
  PackageManager := TAndroidHelper.Activity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  lVesionSDK:= lVesionSDK + ' + PM: ' + JStringToString(PackageInfo.versionName);
  //
  try
    if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, IInterface(LocaleService))
    then
      lLang := LocaleService.GetCurrentLangID()
    else lLang := '?1?';
  except lLang:='???'; end;

  try
    obj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
    if obj <> nil then
    begin
      tm := TJTelephonyManager.Wrap( (obj as ILocalObject).GetObjectID );
      if tm <> nil then begin
        // IMEI телефона - работает
         lIMEI      := JStringToString(tm.getDeviceId);
        // Модель телефона
        //lModel     := '???'; //
        // Версия Android
        //lVesion    := '???'; // JStringToString(tm.getDeviceSoftwareVersion);
        // Версия SDK
        //lVesionSDK := '???';
      end;
    end;
  except lIMEI:=''; end;

  if lIMEI = '' then begin
    // IMEI телефона - работает
    lIMEI      := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.Activity.getContentResolver,
                                  TJSettings_Secure.JavaClass.ANDROID_ID));
    // Модель телефона
    //lModel     := '???';
    // Версия Android
    //lVesion    := '???';
    // Версия SDK
    //lVesionSDK := '???';
  end;
  {$ELSE}
  lIMEI      := '';
  lBrand     := '';
  lModel     := '';
  lLang      := '';
  lVesion    := '';
  lVesion_two:= '';
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

      lModel:= lBrand + ' ' + lModel;
      lVesion:= lVesion + ' '  + lVesion_two;
      //lVesionSDK:= lVesionSDK;

      N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pCode, lIMEI, lModel, lVesion, lVesionSDK]), False, 2, ANeedShowException)).DocumentElement;
      if Assigned(N) then
      begin
        Result := N.GetAttribute(AnsiLowerCase(gcMessage));

        ConnectOk := true;

        if Result = '' then
        begin
          if Assigned(pUser) then
          begin
            pUser.Login := N.GetAttribute(AnsiLowerCase(gcUserLogin));
            pUser.Password := N.GetAttribute(AnsiLowerCase(gcUserPassword));
            pUser.Session := N.GetAttribute(AnsiLowerCase(gcSession));
            pUser.Local := false;
          end
          else
            pUser := TUser.Create(N.GetAttribute(AnsiLowerCase(gcUserLogin)), N.GetAttribute(AnsiLowerCase(gcUserPassword)), N.GetAttribute(AnsiLowerCase(gcSession)), false);
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
