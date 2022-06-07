unit UnitMyIP;

{$I dsdVer.inc}

interface

uses System.SysUtils, Vcl.Forms, System.DateUtils, System.IOUtils, IdHTTP
     {$IFDEF DELPHI103RIO}, System.JSON {$ELSE} , Data.DBXJSON {$ENDIF};

function GetMyIP : String;
function GetMyIP_Day : String;

implementation

uses System.IniFiles;

function GetIniFile(var AIniFileName: String):boolean;
var
  FileName: string;
  f: TIniFile;
Begin
  result := False;
  FileName := ExtractFilePath(Application.exeName) + TPath.GetFileNameWithoutExtension(Application.exeName) + '_LogIP.ini';
  if not FileExists(FileName) then
  Begin
    f := TiniFile.Create(FileName);
    try
      try
        F.WriteString('LogIP', 'IP', '');
        F.WriteDate('LogIP','DataUpdate', IncDay(Date, - 1));
      Except
      end;
    finally
      f.Free;
    end;
    AIniFileName := FileName;
  End
  else
    AIniFileName := FileName;
  result := True;
End;

function GetString(const ASection, AParamName: String): String;
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    Result := '';
    exit;
  End;

  ini := TiniFile.Create(IniFileName);
  try
    Result := ini.ReadString(ASection,AParamName,'');
  finally
    ini.Free;
  end;
End;

function GetDate(const ASection, AParamName: String): TDateTime;
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    Result := IncDay(Date, - 1);
    exit;
  End;

  ini := TiniFile.Create(IniFileName);
  try
    Result := ini.ReadDate(ASection,AParamName,IncDay(Date, - 1));
  finally
    ini.Free;
  end;
End;

procedure SetString(const ASection, AParamName: String; AStr : String);
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    exit;
  End;

  ini := TiniFile.Create(IniFileName);
  try
    ini.WriteString(ASection, AParamName, AStr);
  finally
    ini.Free;
  end;
End;

procedure SetDate(const ASection, AParamName: String; ADate : TDateTime);
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    exit;
  End;

  ini := TiniFile.Create(IniFileName);
  try
    ini.WriteDate(ASection, AParamName, ADate);
  finally
    ini.Free;
  end;
End;

// ***************************************************************

function GetMyIP : String;
  var IdHTTP: TIdHTTP;
      jsonObject: TJSONObject;
      S : String;
begin
  Result := '';
  IdHTTP := TIdHTTP.Create;
  try
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.CustomHeaders.Clear;
    IdHTTP.Request.CustomHeaders.FoldLines := False;

    try
      S := IdHTTP.Get('http://ipwho.is/');

      if IdHTTP.ResponseCode = 200 then
      begin
        jsonObject := TJSONObject.ParseJSONValue(s) as TJSONObject;
        try
          Result := jsonObject.Get('ip').JsonValue.Value;
        finally
          jsonObject.Free;
        end;
      end;
    except  on E: Exception do
       Result := Copy('Ошибка получения IP: ' + E.Message, 1, 250);
    end;

  finally
    IdHTTP.Free;
  end;
end;

function GetMyIP_Day : String;
begin

  Result := GetString('LogIP','IP');

  if (GetDate('LogIP','DataUpdate') < Date) or (Result = '') then
  begin
    Result := GetMyIP;
    SetString('LogIP','IP',Result);
    SetDate('LogIP', 'DataUpdate', Date);
  end;
end;

end.
