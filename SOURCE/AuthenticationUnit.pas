unit AuthenticationUnit;

interface

uses StorageUnit;

type

  ///	<summary>
  /// Класс хранящий информацию о текущем пользователе
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TUser = class
  private
    FSession: String;
  public
    property Session: String read FSession;
    constructor Create(ASession: String);
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
    class function CheckLogin(pStorage: TStorage; const pUserName, pPassword: string; var pUser: TUser): boolean;
  end;

implementation

uses UtilType, Xml.XMLDoc, UtilConst;

constructor TUser.Create(ASession: String);
begin
  FSession := ASession;
end;

class function TAuthentication.CheckLogin(pStorage: TStorage; const pUserName, pPassword: string; var pUser: TUser): boolean;
var pXML: TXML;
begin
  {создаем XML вызова процедуры на сервере}
  pXML :=
  '<xml>' +
    '<gpCheckLogin>' +
      '<inUserLogin    ParamType="ptInput" DataType="ftString" Value="' + pUserName + '" />' +
      '<inUserPassword ParamType="ptInput" DataType="ftString" Value="' + pPassword + '" />' +
    '</gpCheckLogin>' +
  '</xml>';

  with LoadXMLData(pStorage.ExecuteProc(pXML)).DocumentElement do
       pUser := TUser.Create(GetAttribute(gcSession));
  result := pUser <> nil
 (* try
    {вызов процедуры проверки пользователя}
    gpExecuteInsertUpdateOnApplicationLevel(gcCurrentObjectName,gcCurrentComputerName,pXML);
    {получение сессии}
    gc_CurrentSession:=gfGetXMLAttribute(gfCreateLoadXML(pXML).DocumentElement,gcSession);
    {получаем группу пользователей и пользователя}
    gcUserGroup:=gfGetXMLAttribute(gfCreateLoadXML(pXML).DocumentElement,gcUserGroupName);
    gcUser:=gfGetXMLAttribute(gfCreateLoadXML(pXML).DocumentElement,gcUserName);
    AllowLogin:=true;
  except
    on E:Exception do begin
        gpProcessError(E,fShowSystemInformation, self);
      AllowLogin:=false;
    end;
  end;     *)
end;

end.
