unit dmDSD;

interface

uses
  System.SysUtils, System.Classes, IdContext, IdCustomHTTPServer, IdCustomTCPServer, Data.DB,
  ZStoredProcedure, ZConnection, Vcl.ExtCtrls, IdBaseComponent, IdComponent,
  IdHTTPServer, System.Generics.Collections, Datasnap.Provider, Datasnap.DBClient,
  Windows, System.StrUtils, IdGlobal, Winapi.ActiveX, System.Variants, ZLibEx, IdURI,
  System.DateUtils, IniFiles, System.IOUtils, uFillDataSet, ZDataSet, ZCompatibility, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractConnection, NativeXml;

type
  TDSDStoredProcParam = record
    ParamName: string;
    DataType: string;
    Value: Variant;
  end;

  TDSDStoredProc = record
    Session: string;
    AutoWidth: Boolean;
    SPName, OutputType, DataSetType: string;
    ParamsList: TList<TDSDStoredProcParam>;
  end;

  TConnectionParam = record
    HostName: string;
    Port: integer;
    Database: string;
    User: string;
    Password: string;
  end;

  TDM = class(TDataModule)
    HTTPServer: TIdHTTPServer;
    Timer: TTimer;
    procedure HTTPServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure HTTPServerException(AContext: TIdContext; AException: Exception);
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnectionAfterConnect(Sender: TObject);
  private
    FisArchive: Boolean;
    FConnectionParam: TConnectionParam;
    function GetConnection: TZConnection;
    function FillDSDStoredProcParam(ADateNode: TXmlNode; AStoredProc: TDSDStoredProc) : boolean;
    function ParseXML(const AXML: String; out AStoredProc: TDSDStoredProc): Boolean;
    function CreateResponse(const AType, AText: RawByteString): RawByteString;
  public
    function StoredProcExecute(AStoredProc: TDSDStoredProc): RawByteString;
  end;

var
  DM: TDM;

  // TODO включить логи от параметра при вызове
procedure Log(ALogStr: string; APrefix: string = ''; AIsError: Boolean = False); overload;
procedure Log(AException: Exception; APrefix: string = ''); overload;

implementation

{$R *.dfm}

uses
  Registry;

const
  cLog = 'dsdp.log';
  cConnDef = 'DSDPG';
  cErrorXML = '<error ErrorCode="%s" ErrorMessage="%s" />';
  rspError = 'oterror';
  cDbSection = 'Database';
  cResultTypeLength = 13;
  cIsArchiveLength = 2;
  cXMLStructureLenghtLength = 10;

function PADR(Src: string; Lg: integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := Result + ' ';
end;

function ModifyStr(AStr: AnsiString): AnsiString;
var
  LRes: string;
begin
  LRes := AStr;
  LRes := ReplaceText(LRes, '&', '&amp;');
  LRes := ReplaceText(LRes, '"', '&quot;');
  LRes := ReplaceText(LRes, '''', '&apos;');
  LRes := ReplaceText(LRes, '<', '&lt;');
  LRes := ReplaceText(LRes, '>', '&gt;');
  Result := LRes;
end;

function ReadRegEntry(strSubKey, strValueName: string): string;
var
  LReg: TRegistry;
begin
  LReg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  LReg.RootKey := HKEY_LOCAL_MACHINE;
  if LReg.OpenKey(strSubKey, False) then
    Result := LReg.ReadString(strValueName)
  else
    Result := ExtractFilePath(ParamStr(0));
  LReg.Free;
end;

function LocalAppDataPath: string;
var
  LPath: string;
begin
  LPath := ExtractFilePath(ReadRegEntry('SYSTEM\CurrentControlSet\Services\FarmacyProvider', 'ImagePath'));
  if Length(LPath) = 0 then
    LPath := ExtractFilePath(ParamStr(0));
  Result := LPath;
end;

// TODO включить логи от параметра при вызове
procedure Log(ALogStr: string; APrefix: string = ''; AIsError: Boolean = False); overload;
var
  LPrefix, LError: WideString;
  F: TextFile;
begin
  AssignFile(F, LocalAppDataPath + cLog);
  try
    if FileExists(LocalAppDataPath + cLog) then
      Append(F)
    else
      Rewrite(F);
    if Trim(APrefix) <> '' then
      LPrefix := '[' + APrefix + '] '
    else
      LPrefix := '';
    if AIsError then
      LError := '! '
    else
      LError := '';
    WriteLn(F, LError + DateTimeToStr(Now) + ' ' + LPrefix + ALogStr);
  except
    // on E: Exception do
    // LogMessage(S + #13#10#13#10 + E.Message, EVENTLOG_ERROR_TYPE);
  end;
  CloseFile(F);
end;

// TODO включить логи от параметра при вызове
procedure Log(AException: Exception; APrefix: string = ''); overload;
begin
  Log(AException.ClassName + ': ' + AException.Message, APrefix, True);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(LocalAppDataPath + 'init.ini');
  try
    FConnectionParam.HostName := LIniFile.ReadString(cDbSection, 'host', '172.17.2.5');
    FConnectionParam.Port := LIniFile.ReadInteger(cDbSection, 'port', 5432);
    FConnectionParam.Database := LIniFile.ReadString(cDbSection, 'dbname', 'farmacy');
    FConnectionParam.User := LIniFile.ReadString(cDbSection, 'user', 'postgres');
    FConnectionParam.Password := LIniFile.ReadString(cDbSection, 'password', 'eej9oponahT4gah3');
  finally
    FreeAndNil(LIniFile)
  end;

  try
    HTTPServer.ParseParams := False;
    HTTPServer.Active := True;
    FisArchive := True;
  except
    on E: Exception do
      Log(E, 'DataModuleCreate');
  end;
end;

function TDM.FillDSDStoredProcParam(ADateNode: TXmlNode; AStoredProc: TDSDStoredProc) : boolean;
var
  I : integer;
  LArrayItem: TXmlNode;
  LParam: TDSDStoredProcParam;
  Locale: TFormatSettings;
begin
  for I := 0 to ADateNode.NodeCount - 1 do
  begin
    LArrayItem := ADateNode.Nodes[I];
    with LParam do
    begin
      ParamName := LArrayItem.Name;
      if LArrayItem.AttributeIndexByName('Value') >= 0 then
      begin
        if UpperCase(LArrayItem.AttributeByName['Value'].Value) = 'NULL' then Value := Null
        else Value := LArrayItem.AttributeByName['Value'].Value;

        case IndexStr(LArrayItem.AttributeValueByNameWide['DataType'], ['ftInteger', 'ftString', 'ftFloat', 'ftBlob', 'ftDateTime',
          'ftBoolean']) of
          0:
            DataType := 'integer';
          1:
            DataType := 'TVarChar';
          2: begin
               DataType := 'TFloat';
               Value := LArrayItem.AttributeByName['Value'].ValueAsFloat;
             end;
          3:
            DataType := 'TBlob';
          4:
            begin
              DataType := 'TDateTime';
              if Value <> Null then
              begin
                Locale := TFormatSettings.Create;
                Locale.DateSeparator := '.';
                Locale.ShortDateFormat := 'dd.MM.yyyy';
                Locale.TimeSeparator := ':';
                Locale.ShortTimeFormat := 'H:mm';
                Value := StrToDateTime(VarToStr(Value), Locale);
              end;
            end;
          5:
            DataType := 'Boolean';
        end;
        AStoredProc.ParamsList.Add(LParam);
      end;
    end;
  end;
end;

function TDM.ParseXML(const AXML: String; out AStoredProc: TDSDStoredProc): Boolean;
var
  LXML: TNativeXml;
  LDocument, LArrayItem: TXmlNode;
  LStoredProc: TDSDStoredProc;
  LParam: TDSDStoredProcParam;
  nNode, I: integer;
  Locale: TFormatSettings;
  MStream : TStringStream;
begin
  CoInitialize(nil);
  try
    LXML := TNativeXml.Create(Self);
    MStream := TStringStream.Create;
    MStream.WriteString(AXML);
    MStream.Position := 0;
    LXML.LoadFromStream(MStream);
    LDocument := LXML.Root;
    nNode := 0;

    if LDocument.AttributeIndexByName('Session') >= 0 then
    begin
      LStoredProc.Session := LDocument.AttributeValueByNameWide['Session'];
      Inc(nNode)
    end else LStoredProc.Session := '';

    if LDocument.AttributeIndexByName('AutoWidth') >= 0 then
    begin
      LStoredProc.AutoWidth := LDocument.AttributeByName['AutoWidth'].ValueAsBool;
      Inc(nNode);
    end else LStoredProc.AutoWidth := False;

    LStoredProc.SPName := LDocument.Nodes[nNode].Name;

    LStoredProc.OutputType := LDocument.Nodes[nNode].AttributeValueByNameWide['OutputType'];

    if LDocument.Nodes[nNode].AttributeIndexByName('DataSetType') >= 0 then
      LStoredProc.DataSetType := LDocument.Nodes[nNode].AttributeByName['DataSetType'].Value
    else LStoredProc.DataSetType := '';

    LStoredProc.ParamsList := TList<TDSDStoredProcParam>.Create;
    if LStoredProc.OutputType = 'otMultiExecute' then
    begin
      if LDocument.Nodes[nNode].NodeCount > 0 then
        FillDSDStoredProcParam(LDocument.Nodes[nNode], LStoredProc);
      Inc(nNode);
      if nNode < LDocument.NodeCount then StoredProcExecute(LStoredProc);

      if nNode < LDocument.NodeCount then
        for I := 0 to LDocument.Nodes[nNode].NodeCount - 1 do
        begin
          LStoredProc.ParamsList := TList<TDSDStoredProcParam>.Create;
          if LDocument.Nodes[nNode].Nodes[I].NodeCount > 0 then
            FillDSDStoredProcParam(LDocument.Nodes[nNode].Nodes[I], LStoredProc);
          if I < (LDocument.Nodes[nNode].NodeCount - 1) then StoredProcExecute(LStoredProc);
        end;
    end else
    begin
      if LDocument.Nodes[nNode].NodeCount > 0 then
        FillDSDStoredProcParam(LDocument.Nodes[nNode], LStoredProc);
    end;
    AStoredProc := LStoredProc;
    Result := True;
  finally
    MStream.Free;
    LXML.Free;
    CoUninitialize;
  end;
end;

function TDM.StoredProcExecute(AStoredProc: TDSDStoredProc): RawByteString;
var
  LStoredProc: TZStoredProc;
  LDataSet: TZQuery;
  I: integer;
  LCursorsClose, LDataSetStr, LRes, LXMLStructure: RawByteString;
begin
  LStoredProc := TZStoredProc.Create(nil);

  try
    LStoredProc.Connection := GetConnection;
    LStoredProc.StoredProcName := AStoredProc.SPName;

    for I := 0 to AStoredProc.ParamsList.Count - 1 do
      with LStoredProc.Params.AddParameter do
      begin
        Name := AStoredProc.ParamsList[I].ParamName;
        Value := AStoredProc.ParamsList[I].Value;
        case AnsiIndexStr(AStoredProc.ParamsList[I].DataType, ['TVarChar', 'TDateTime', 'Boolean', 'TBlob', 'TFloat']) of
          0:
            DataType := ftString;
          1:
            DataType := ftDateTime;
          2:
            DataType := ftBoolean;
          3:
            begin
              DataType := ftMemo;
              Value := VarToStr(AStoredProc.ParamsList[I].Value);
            end;
          4:
            DataType := ftFloat;
        else
          DataType := ftInteger;
        end;
      end;

    with LStoredProc.Params.AddParameter do
      if AStoredProc.Session = '' then
      begin
        Name := 'session';
        DataType := ftString;
        ParamType := ptInputOutput;
      end
      else
      begin
        Value := AStoredProc.Session;
        DataType := ftString;
        ParamType := ptInput;
      end;

    // Выполнение SQL запроса
    if AStoredProc.OutputType = 'otMultiDataSet' then
      LStoredProc.Connection.ExecuteDirect('BEGIN;');

    LStoredProc.Open;

    case IndexStr(AStoredProc.OutputType, ['otResult', 'otBlob', 'otDataSet', 'otMultiDataSet']) of
      0:
        begin
          Result := '<Result';

          for I := 0 to LStoredProc.FieldCount - 1 do
              case LStoredProc.Fields[I].DataType of
                ftDate, ftDateTime, ftTime:
                  if LStoredProc.Fields[I].IsNull then Result := Result + ' ' + LStoredProc.Fields[I].FieldName + '=""'
                  else Result := Result + ' ' + LStoredProc.Fields[I].FieldName + '="' + DateToISO8601(LStoredProc.Fields[I].asDateTime) + '"';
                ftString, ftMemo:
                  Result := Result + ' ' + LStoredProc.Fields[I].FieldName + '="' +
                    StringsReplace(StringsReplace(StringsReplace(StringsReplace(StringsReplace(VarToStr(LStoredProc.Fields[I].Value),
                      ['&'], ['&amp;']),
                      ['"'], ['&quot;']),
                      [''''], ['&apos;']),
                      ['<'], ['&lt;']),
                      ['>'], ['&gt;']) + '"';
                else
                  Result := Result + ' ' + LStoredProc.Fields[I].FieldName + '="' + VarToStr(LStoredProc.Fields[I].Value) + '"';
              end;

          Result := Result + '/>';
        end;
      1:
        Result := LStoredProc.Fields[0].AsAnsiString;
      2:
        Result := TFillDataSet.PackDataset(LStoredProc);
      3:
        begin
          LDataSet := TZQuery.Create(nil);
          try
            LDataSet.Connection := LStoredProc.Connection;
            Result := '';
            LXMLStructure := '<DataSets>';
            while not LStoredProc.EOF do
            begin
              LCursorsClose := LCursorsClose + 'CLOSE "' + LStoredProc.Fields[0].AsString + '";';
              LDataSet.SQL.Text := 'FETCH ALL "' + LStoredProc.Fields[0].AsString + '";';
              LDataSet.Open;
              LDataSetStr := TFillDataSet.PackDataset(LDataSet);
              LRes := LRes + LDataSetStr;
              LXMLStructure := LXMLStructure + '<DataSet length = "' + Length(LDataSetStr).ToString + '"/>';
              LStoredProc.Next;
            end;
            LXMLStructure := LXMLStructure + '</DataSets>';
            LStoredProc.Connection.ExecuteDirect(LCursorsClose + 'COMMIT; END;');

            Result := Length(LXMLStructure).ToString.PadLeft(10, '0') + LXMLStructure + LRes;
          finally
            LDataSet.Free
          end;
        end;
    end;
  finally
    AStoredProc.ParamsList.Free;
    LStoredProc.Connection.Free;
    LStoredProc.Free;
  end;
end;

procedure TDM.FDConnectionAfterConnect(Sender: TObject);
begin
  (Sender as TZConnection).ExecuteDirect('SET client_encoding=''win1251''');
end;

function TDM.GetConnection: TZConnection;
var
  LConnection: TZConnection;
begin
  LConnection := TZConnection.Create(nil);
  LConnection.Protocol := 'postgresql-7';
  LConnection.UseMetadata := False;
  LConnection.ClientCodepage := 'win1251';
  LConnection.ControlsCodePage := TZControlsCodePage.cGET_ACP;

  LConnection.HostName := FConnectionParam.HostName;
  LConnection.Port := FConnectionParam.Port;
  LConnection.Database := FConnectionParam.Database;
  LConnection.User := FConnectionParam.User;
  LConnection.Password := FConnectionParam.Password;

  LConnection.AfterConnect := FDConnectionAfterConnect;
  Result := LConnection;
end;

procedure TDM.HTTPServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo);
var
  LDSDStoredProc: TDSDStoredProc;
  LQuery: RawByteString;
begin
  AResponseInfo.ResponseNo := 200;
  AResponseInfo.ContentText := 'HELLO WORLD';
  AResponseInfo.ContentType := 'text/html; charset=windows-1251';

  LQuery := TIdURI.URLDecode(ReplaceAll(ARequestInfo.UnparsedParams, '+', ' '), IndyTextEncoding_OSDefault)
    .Split(['XML='])[1];

  try
    if ParseXML(LQuery, LDSDStoredProc) then
      AResponseInfo.ContentText := CreateResponse(LDSDStoredProc.OutputType, StoredProcExecute(LDSDStoredProc));
  except
    on E: Exception do
    begin
      Log(E, 'HTTPServerCommandGet');
      AResponseInfo.ContentText := CreateResponse(rspError, Format(cErrorXML, ['P0001', ModifyStr(E.Message)]));
    end;
  end;
end;

function TDM.CreateResponse(const AType, AText: RawByteString): RawByteString;
var
  LType: RawByteString;
begin
  case IndexStr(AType, ['otResult', 'otBlob', 'otDataSet', 'otMultiDataSet', 'otMultiExecute']) of
    0, 1:
      LType := PADR('Result', cResultTypeLength);
    2:
      LType := PADR('DataSet', cResultTypeLength);
    3:
      LType := 'MultiDataSet ';
    4: begin
         Result := '';
         Exit;
       end
  else
    LType := PADR('error', cResultTypeLength);
  end;

  if FisArchive then
    Result := LType + PADR('t', cIsArchiveLength) + ZCompressStr(AText)
  else
    Result := LType + PADR('f', cIsArchiveLength) + AText;
end;

procedure TDM.HTTPServerException(AContext: TIdContext; AException: Exception);
begin
  Log(AException, 'HTTPServerException');
end;

end.
