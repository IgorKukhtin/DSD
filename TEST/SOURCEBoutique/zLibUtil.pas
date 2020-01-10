unit zLibUtil;

interface

uses ZConnection, ZDataset;

type

  TConnectionFactory = class
    class function GetConnection: TZConnection;
  end;

  procedure ExecFile(FileName: string; Query: TZQuery);
  procedure doLog(AText: String);
implementation

uses StrUtils, Classes, SysUtils, UtilConst, Dialogs;
{ TConnectionFactory }
procedure doLog(AText: String);
var
  F: TextFile;
const
  fl: string = 'logTest.txt';
begin
  Assign(F, fl);
  if FileExists(fl) then
    Append(F)
  else
    Rewrite(F);
  try
    Writeln(F, FormatDateTime('hh:nn:ss', now)+#9+AText);
  finally
    CloseFile(F);
  end;

end;

procedure ExecFile(FileName: string; Query: TZQuery);
var i : integer;
                st: string;
begin
  try
    doLog(FileName);
    Query.ParamCheck := false;
    Query.SQL.LoadFromFile(FileName);
    st:='';
    {for i:= 0 to Query.SQL.Count-1 do
                st:= st + #10 + #13 + Query.SQL[i];
    ShowMessage(st);}
    Query.ExecSQL;
  except
    on E: Exception do
       begin
       //ShowMessage(E.Message);
       raise Exception.Create(FileName + #10#13 + E.Message);
       end;
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
  if ConnectionString = '' then
    raise Exception.Create('Error Message нет строки подключения в ' + ConnectionPath);
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
{
    ShowMessage (result.HostName);
    ShowMessage (IntToStr(result.Port));
    ShowMessage (result.User);
    ShowMessage (result.Password);
    ShowMessage (result.Database);
    ShowMessage (result.Protocol);
    }
  finally
    List.Free
  end;
end;

end.
