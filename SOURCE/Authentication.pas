unit Authentication;

interface

uses Storage;

type

  ///	<summary>
  /// ����� �������� ���������� � ������� ������������
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
  /// ����� �������������� ������������
  ///	</summary>
  ///	<remarks>
  ///	</remarks>
  TAuthentication = class
    ///	<summary>
    /// �������� ������ � ������. � ������ ������ ���������� ������ � ������������.
    ///	</summary>
    class function CheckLogin(pStorage: IStorage; const pUserName, pPassword: string; var pUser: TUser): boolean;
  end;

implementation

uses Xml.XMLDoc, UtilConst, SysUtils, IdIPWatch;

{------------------------------------------------------------------------------}
constructor TUser.Create(ASession: String);
begin
  FSession := ASession;
end;
{------------------------------------------------------------------------------}
class function TAuthentication.CheckLogin(pStorage: IStorage; const pUserName, pPassword: string; var pUser: TUser): boolean;
var IP_str:string;
const
  {������� XML ������ ��������� �� �������}
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

  with LoadXMLData(pStorage.ExecuteProc(Format(pXML, [pUserName, pPassword, IP_str]))).DocumentElement do
       pUser := TUser.Create(GetAttribute(AnsiLowerCase(gcSession)));
  result := pUser <> nil
end;

end.
