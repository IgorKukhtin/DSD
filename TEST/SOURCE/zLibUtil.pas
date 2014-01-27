unit zLibUtil;

interface

uses ZConnection, ZDataset;

type

  TConnectionFactory = class
    class function GetConnection: TZConnection;
  end;

  procedure ExecFile(FileName: string; Query: TZQuery);

implementation

uses StrUtils, Classes, SysUtils, UtilConst;
{ TConnectionFactory }

procedure ExecFile(FileName: string; Query: TZQuery);
begin
  try
    Query.SQL.LoadFromFile(FileName);
    Query.ExecSQL;
  except
    on E: Exception do
       raise Exception.Create(FileName + #10#13 + E.Message);
  end;
end;

class function TConnectionFactory.GetConnection: TZConnection;
var
  f: text;
  ConnectionString: string;
  List: TStringList;
begin
  AssignFile(F, ConnectionPath);
  Reset(f);
  readln(f, ConnectionString);
  readln(f, ConnectionString);
  CloseFile(f);
  // Вырезаем строку подключения
  ConnectionString := Copy(ConnectionString, Pos('=', ConnectionString) + 3, maxint);
  ConnectionString := Copy(ConnectionString, 1, length(ConnectionString) - 2);
  ConnectionString := ReplaceStr(ConnectionString, ' ', #13#10);
  List := TStringList.Create;
  result := TZConnection.Create(nil);
  try
    List.Text := ConnectionString;
    result.HostName := List.Values['host'];
    result.Port := StrToInt(List.Values['port']);
    result.User := List.Values['user'];
    result.Password := List.Values['password'];
    result.Database := List.Values['dbname'];
    result.Protocol := 'postgresql-9';
  finally
    List.Free
  end;
end;

end.
