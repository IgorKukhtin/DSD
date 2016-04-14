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
  private
    FSession: String;
    FLocal: Boolean;
    procedure SetLocal(const Value: Boolean);
  public
    property Session: String read FSession;
    Property Local: Boolean read FLocal Write SetLocal;
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
  end;

implementation

uses Xml.XMLDoc, UtilConst, SysUtils, IdIPWatch, Xml.XmlIntf, CommonData, WinAPI.Windows,
  vcl.Forms;

{------------------------------------------------------------------------------}
constructor TUser.Create(ASession: String; ALocal: Boolean = false);
begin
  FSession := ASession;
  FLocal := ALocal;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLogin(pStorage: IStorage;
  const pUserName, pPassword: string; var pUser: TUser;
  ANeedShowException: Boolean = True): boolean;
var IP_str:string;
  N: IXMLNode;
const
  {создаем XML вызова процедуры на сервере}
  pXML =
  '<xml Session = "" >' +
    '<gpCheckLogin OutputType="otResult">' +
      '<inUserLogin    DataType="ftString" Value="%s" />' +
      '<inUserPassword DataType="ftString" Value="%s" />' +
      '<inIP           DataType="ftString" Value="%s" />' +
    '</gpCheckLogin>' +
  '</xml>';
begin

  with TIdIPWatch.Create(nil) do
  begin
        Active:=true;
        IP_str:=LocalIP;
        Free;
  end;

  N := LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str]), False, 4, ANeedShowException)).DocumentElement;
  if Assigned(N) then
       pUser := TUser.Create(N.GetAttribute(AnsiLowerCase(gcSession)));
  result := pUser <> nil
end;

procedure TUser.SetLocal(const Value: Boolean);
var
  I : Integer;
begin
  FLocal := Value;
  for I := 0 to Screen.FormCount - 1 do
  Begin
    PostMessage(Screen.Forms[I].Handle, UM_LOCAL_CONNECTION,0,0);
  End;
end;

end.
