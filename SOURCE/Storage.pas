unit Storage;

interface

uses SysUtils;

type

  ///	<summary>
  /// ��������� - ���� ����� ����������� � ������� �������.
  ///	</summary>
  ///	<remarks>
  /// ������������ ������ ��������� ��� ������ ������� �� ������� ���� ������
  ///	</remarks>
  IStorage = interface
    function GetConnection: string;
    ///	<summary>
    /// ��������� ������ ����������� XML �������� �� ������� ������.
    ///	</summary>
    ///	<remarks>
    /// ���������� XML ��� ��������� ������
    ///	</remarks>
    ///	<param name="pData">
    ///	  XML ���������, �������� ������ ��� ��������� �� �������
    ///	</param>
    ///	<param name="pExecOnServer">
    ///	  ���� true, �� ��������� ����������� � ����� �� ������� ������
    ///	</param>
    function ExecuteProc(pData: String; pExecOnServer: boolean = false;
      AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
    procedure LoadReportList(ASession: string);
    property Connection: String read GetConnection;
  end;

  TStorageFactory = class
     class function GetStorage: IStorage;
  end;

  EStorageException = class(Exception)
  private
    FErrorCode: string;
  public
    constructor Create(AMessage: String; AErrorCode: String = '');
    property ErrorCode: string read FErrorCode write FErrorCode;
  end;

  function ConvertXMLParamToStrings(XMLParam: String): String;

implementation

uses IdHTTP, Xml.XMLDoc, XMLIntf, System.Classes, ZLibEx, idGlobal, UtilConst, System.Variants,
     UtilConvert, MessagesUnit, Dialogs, StrUtils, IDComponent, SimpleGauge,
     Forms, Log, IdStack, IdExceptionCore, SyncObjS, CommonData, System.AnsiStrings,
     Datasnap.DBClient, System.Contnrs;

const

   ResultTypeLenght = 13;
   IsArchiveLenght = 2;
   XMLStructureLenghtLenght = 10;

type
  TConnectionType = (ctMain, ctReport);

  TConnection = class
  private
    FCString: string;
    FCType: TConnectionType;
  public
    constructor Create(ACString: string; ACType: TConnectionType);
    property CString: string read FCString;
    property CType: TConnectionType read FCType;
  end;

  TConnectionList = class(TObjectList)
  private
    FCurrentConnection: array[TConnectionType] of TConnection;
    function GetConnection(Index: Integer): TConnection;
    procedure SetConnection(Index: Integer; const Value: TConnection);
    function GetCurrentConnection(ACType: TConnectionType): TConnection;
  public
    procedure AfterConstruction; override;
    procedure AddFromFile(AFileName: string; AConnectionType: TConnectionType);
    function FirstConnection(ACType: TConnectionType): TConnection;
    function NextConnection(ACType: TConnectionType): TConnection;
    property Items[Index: Integer]: TConnection read GetConnection write SetConnection; default;
    property CurrentConnection[ACType: TConnectionType]: TConnection read GetCurrentConnection;
  end;

  TStorage = class(TInterfacedObject, IStorage)
  strict private
    class var
      Instance: TStorage;
  private
    IdHTTP: TIdHTTP;
    FSendList: TStringList;
    FReceiveStream: TStringStream;
    Str: AnsiString;//RawByteString;
    XMLDocument: IXMLDocument;
    isArchive: boolean;
    // ���������� ������ ����� ��-�� �������
    FCriticalSection: TCriticalSection;
    FReportList: TStringList;
    FConnectionList: TConnectionList;
    function PrepareStr: AnsiString;
    function ExecuteProc(pData: String; pExecOnServer: boolean = false;
      AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
    procedure ProcessErrorCode(pData: String; ProcedureParam: String);
    function ProcessMultiDataSet: Variant;
    function GetConnection: string;
    procedure LoadReportList(ASession: string);
    function CheckConnectionType(pData: string): TConnectionType;
    procedure InsertReportProtocol(pData: string);
  public
    property Connection: String read GetConnection;
    class function NewInstance: TObject; override;
  end;

  TIdHTTPWork = class
    FExecOnServer: boolean;
    Gauge: IGauge;
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
  end;

  var
    IdHTTPWork: TIdHTTPWork;

function TStorage.GetConnection: string;
begin
  if FConnectionList.CurrentConnection[ctMain] <> nil then
    Result := FConnectionList.CurrentConnection[ctMain].CString
  else
    Result := FConnectionList.FirstConnection(ctMain).CString;
end;

procedure TStorage.InsertReportProtocol(pData: string);
const
  {������� XML ������ ��������� �� �������}
  pXML =
    '<xml Session = "%s" AutoWidth = "0">' +
      '<gpInsert_ReportProtocol OutputType = "otResult" DataSetType = "">' +
      '<inProtocolData DataType="ftBlob" Value="%s" />' +
      '</gpInsert_ReportProtocol>' +
    '</xml>';
var
  XML: IXMLDocument;
  Data, NodeFun, NodeParam: IXMLNode;
  I, J: Integer;
  S, T, Q: string;
begin
  TXMLDocument.Create(nil).GetInterface(IXMLDocument, XML);

  XML.LoadFromXML(pData);
  Data := XML.DocumentElement;
  S := '';

  if Data <> nil then
  begin
    for I := 0 to Pred(Data.ChildNodes.Count) do
    begin
      NodeFun := Data.ChildNodes.Get(I);
      S := S + NodeFun.NodeName + ' (';
      for J := 0 to Pred(NodeFun.ChildNodes.Count) do
      begin
        NodeParam := NodeFun.ChildNodes.Get(J);
        T := NodeParam.Attributes['DataType'];
        Q := '';
        if (T = 'ftString') or (T = 'ftBlob') or (T = 'ftDateTime') or (T = 'ftDate') then
          Q := '''';
        S := S + NodeParam.NodeName + ':= ' + Q + NodeParam.Attributes['Value'] + Q + ', ';
      end;
      S := S + 'inSession:= ''' + Data.Attributes['Session'] + ''')';
    end;
  end;

  FSendList.Clear;
  FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' +
    Format(pXML, [gc_User.Session, S {pData}]));
  FReceiveStream.Clear;
  IdHTTPWork.FExecOnServer := False;

  try
    IdHTTP.Post(FConnectionList.CurrentConnection[ctMain].CString, FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
  except
    IdHTTP.Disconnect;
  end;
end;

procedure TStorage.LoadReportList(ASession: string);
const
  {������� XML ������ ��������� �� �������}
  pXML =
    '<xml Session = "%s" AutoWidth = "0">' +
      '<gpSelect_Object_ReportExternal OutputType = "otDataSet" DataSetType = "TClientDataSet">' +
      '</gpSelect_Object_ReportExternal>' +
    '</xml>';
var
  DataSet: TClientDataSet;
  Stream: TStringStream;
begin
  FReportList.Clear;
  try
    DataSet := TClientDataSet.Create(nil);
    Stream := nil;
    try
      Stream := TStringStream.Create(TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [ASession])));
      DataSet.LoadFromStream(Stream);
      if not DataSet.IsEmpty then
        while not DataSet.Eof do
        begin
          if not DataSet.FieldByName('isErased').AsBoolean then
            FReportList.Add(DataSet.FieldByName('Name').AsString);
          DataSet.Next;
        end;
    finally
      if Assigned(Stream) then
        Stream.Free;
      DataSet.Free;
    end;
  except
  end;
end;

class function TStorage.NewInstance: TObject;
var
  lConnectionPathRep:String;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
    Instance.FReportList := TStringList.Create;
    Instance.FConnectionList := TConnectionList.Create;

    lConnectionPathRep := ReplaceStr(ConnectionPath, '\init.php', '\initRep.php');

    Instance.FConnectionList.AddFromFile(ConnectionPath, ctMain);
    if (lConnectionPathRep <> ConnectionPath) and FileExists(lConnectionPathRep) then
      Instance.FConnectionList.AddFromFile(lConnectionPathRep, ctReport);

    if Instance.FConnectionList.Count = 0 then
      Instance.FConnectionList.Add(TConnection.Create('http://localhost/dsd/index.php', ctMain));

    Instance.IdHTTP := TIdHTTP.Create(nil);
//    Instance.IdHTTP.ConnectTimeout := 5000;
    Instance.IdHTTP.Response.CharSet := 'windows-1251';// 'Content-Type: text/xml; charset=utf-8'
    Instance.IdHTTP.Request.Connection:='keep-alive';
    Instance.IdHTTP.OnWorkBegin := IdHTTPWork.IdHTTPWorkBegin;
    Instance.IdHTTP.OnWork := IdHTTPWork.IdHTTPWork;
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TStringStream.Create('');
    Instance.XMLDocument := TXMLDocument.Create(nil);
    Instance.FCriticalSection := TCriticalSection.Create;
  end;

  NewInstance := Instance;
end;

procedure TIdHTTPWork.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if not FExecOnServer then
     exit;
  if AWorkMode = wmRead then
     Gauge.IncProgress(1);
end;

procedure TIdHTTPWork.IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  if not FExecOnServer then
     exit;
  if AWorkMode = wmWrite then begin
     TIdHTTP(ASender).IOHandler.RecvBufferSize := 1;
     Gauge := TGaugeFactory.GetGauge('���������� ��������� �� �������', 1, 100);
     Gauge.Start;
  end;
end;

function TStorage.PrepareStr: AnsiString;
begin
  if isArchive then
     result := ZDecompressStr(Str)
  else
     result := Str
end;

procedure TStorage.ProcessErrorCode(pData: String; ProcedureParam: String);
begin
  with LoadXMLData(pData).DocumentElement do
    if NodeName = gcError then
       raise EStorageException.Create(StringReplace(GetAttribute(gcErrorMessage), '������:  ', '', []) + ' context: ' + ProcedureParam, GetAttribute(gcErrorCode));
end;

function TStorage.ProcessMultiDataSet: Variant;
var
  XMLStructureLenght: integer;
  DataFromServer: String;
  i, StartPosition: integer;
begin
  DataFromServer := PrepareStr;
  // ��� ���������� ��������� ��������� ����� �������.
  // � ������ ���� �������� XML, ��� �������� ������ �� ���������.

  XMLStructureLenght := StrToInt(Copy(DataFromServer, 1, XMLStructureLenghtLenght));
  XMLDocument.LoadFromXML(Copy(DataFromServer, XMLStructureLenghtLenght + 1, XMLStructureLenght));
  with XMLDocument.DocumentElement do begin
    result := VarArrayCreate([0, ChildNodes.Count - 1], varVariant);
    // �������� ��������� �� ������ ���-�� ����, ��� �� �� ���������� ������
    StartPosition := XMLStructureLenghtLenght + 1 + XMLStructureLenght;
    for I := 0 to ChildNodes.Count - 1 do begin
      XMLStructureLenght := StrToInt(ChildNodes[i].GetAttribute('length'));
      result[i] := Copy(DataFromServer, StartPosition,  XMLStructureLenght);
      StartPosition := StartPosition + XMLStructureLenght;
    end;
  end;
end;

function PrepareValue(Value, DataType: string): string;
begin
  if (DataType = 'ftBlob') or (DataType = 'ftString') or (DataType = 'ftBoolean') then
     result := chr(39) + Value + chr(39);
  if (DataType = 'ftFloat') or (DataType = 'ftInteger') then
     result := Value;
  if (DataType = 'ftDateTime') then
     result := '(' + chr(39) + Value + chr(39) + ')::TDateTime';
end;

function ConvertXMLParamToStrings(XMLParam: String): String;
var i: integer;
    Session: String;
begin
  result := '';
  with LoadXMLData(XMLParam).DocumentElement do begin
     Session := GetAttribute('Session');
     with ChildNodes.First do begin
       result := 'select * from ' + NodeName + '(';
       for I := 0 to ChildNodes.Count - 1 do
         with ChildNodes[i] do begin
           result := result + NodeName + ' := ' + PrepareValue(GetAttribute('Value'), GetAttribute('DataType')) + ' , ';
         end;
       result := result + ' inSession := ' + chr(39) + Session + chr(39) + ');';
     end;
  end;
end;

function TStorage.CheckConnectionType(pData: string): TConnectionType;
var
  S: string;
begin
  Result := ctMain;
  if FReportList.Count > 0 then
    for S in FReportList do
      if Pos(S + ' ', pData) > 0 then
      begin
        Result := ctReport;
        Break;
      end;
end;

function TStorage.ExecuteProc(pData: String; pExecOnServer: boolean = false;
  AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
  function GetAddConnectString(pExecOnServer: boolean): String;
  begin
    if pExecOnServer then
       result := 'server.php'
    else
       result := '';
  end;
var
  ResultType: string;
  AttemptCount: Integer;
  ok: Boolean;
  CType: TConnectionType;
  CString, DString: string;
  function LastAttempt: Boolean;
  Begin
    Result := (AttemptCount >= AMaxAtempt) AND (FConnectionList.CurrentConnection[CType] = nil);
  End;
  function Midle: Boolean;
  Begin
    Result := (AttemptCount = (AMaxAtempt div 2));
  End;
begin
  //!!!�������������� ��� �� �����
  if gc_User.LocalMaxAtempt > 0 then AMaxAtempt:= gc_User.LocalMaxAtempt;
  //

  FCriticalSection.Enter;
  try
    if (gc_User.Local = true)  and  (AMaxAtempt = 10) then
     AMaxAtempt := 2;   // ��� ���������� ������ ���� ������
    if gc_isDebugMode then
       TMessagesForm.Create(nil).Execute(ConvertXMLParamToStrings(pData), ConvertXMLParamToStrings(pData), true);

    CType := CheckConnectionType(pData);

    if CType = ctReport then
      InsertReportProtocol(pData);

    FSendList.Clear;
    FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' + pData);
    Logger.AddToLog(pData);
    FReceiveStream.Clear;
    IdHTTPWork.FExecOnServer := pExecOnServer;
    AttemptCount := 0;
    ok := False;

    if FConnectionList.CurrentConnection[CType] <> nil then
      CString := FConnectionList.CurrentConnection[CType].CString
    else
      CString := FConnectionList.FirstConnection(CType).CString;

    try
      repeat
        for AttemptCount := 1 to AMaxAtempt do
        Begin
          try
            idHTTP.Post(CString + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
            ok := true;
            break;
          except
            on E: EIdSocketError do
            Begin
              if LastAttempt then
              Begin
                if ANeedShowException then
                Begin
                  if gc_allowLocalConnection AND not gc_User.Local then
                  Begin
                    gc_User.Local := True;
                    //ShowMessage('��������� ���������� � ����� ���������� ������.'+#13+
                    //            '����������� � ��������� ����� �������������� ����� � ��������.')
                  end;
                  case E.LastError of
                    10051: raise EStorageException.Create('���������� ����������� � ����. ���������� � ���������� ��������������. context TStorage. ' + E.Message, );
                    10054: raise EStorageException.Create('���������� �������� ��������. ���������� �������� ��� ���. context TStorage. ' + E.Message);
                    10060: raise EStorageException.Create('��� ������� � �������. ���������� � ���������� ��������������. context TStorage. ' + E.Message);
                    11001: raise EStorageException.Create('��� ������� � �������. ���������� � ���������� ��������������. context TStorage. ' + E.Message);
                    10065: raise EStorageException.Create('��� ���������� � ����������. ���������� � ���������� ��������������. context TStorage. ' + E.Message);
                    10061: raise EStorageException.Create('�������� ���������� � WEB ��������. ���������� ��������� � ��������� ����� �������������� ����������.');
                  else
                    raise E;
                  end;
                End;
              End
              else
              Begin
                if Midle then
                  idHTTP.Disconnect;
                Sleep(1000);
              End;
            End;
            on E: Exception do
            Begin
              if LastAttempt then
              Begin
                raise Exception.Create('������ ���������� � Web ��������.'+#10+#13+'���������� � ������������.'+#10+#13+E.Message);
              End
              else
              Begin
                if Midle then
                  idHTTP.Disconnect;
                Sleep(1000);
              End;
            End;
          end;
        End;
        if not Ok AND Not LastAttempt then
        Begin
          if FConnectionList.NextConnection(CType) <> nil then
            CString := FConnectionList.CurrentConnection[CType].CString;
          try
            idHTTP.Disconnect;
          except
          end;
        end
        else
          Break;
      until ok;
    finally
      if IdHTTPWork.FExecOnServer then
         IdHTTPWork.Gauge.Finish;
      IdHTTPWork.FExecOnServer := false;
    end;

    // ���������� ��� ������������� ����������
    if Ok then
    begin
      Logger.AddToLog(' TStorage.ExecuteProc( ... if Ok then ...');

      DString := FReceiveStream.DataString;

      Logger.AddToLog(' TStorage.ExecuteProc( ... Length(FReceiveStream.DataString) = ' + IntToStr(Length(DString)) + ' ...');

      ResultType := trim(Copy(DString, 1, ResultTypeLenght));
      isArchive := trim(lowercase(Copy(DString, ResultTypeLenght + 1, IsArchiveLenght))) = 't';
      Str := Copy(DString, ResultTypeLenght + IsArchiveLenght + 1, MaxInt);

      Logger.AddToLog(' TStorage.ExecuteProc( ... if ResultType = gc' + ResultType + ' then ...');

      if ResultType = gcMultiDataSet then
         Result := ProcessMultiDataSet
      else if ResultType = gcError then
         ProcessErrorCode(PrepareStr, ConvertXMLParamToStrings(pData))
      else if ResultType = gcResult then
         Result := PrepareStr
      else if ResultType = gcDataSet then
         Result := PrepareStr;

      Logger.AddToLog(Result);
    end else
      Logger.AddToLog(' TStorage.ExecuteProc( ... else ...');
  finally
    Logger.AddToLog(' TStorage.ExecuteProc( ... finally ...');
    // ����� �� ����������� ������
    FCriticalSection.Leave;
  end;
end;

class function TStorageFactory.GetStorage: IStorage;
begin
  Result := TStorage.NewInstance as TStorage;
end;

{ EStorageException }

constructor EStorageException.Create(AMessage: String; AErrorCode: String = '');
begin
  inherited Create(AMessage);
  ErrorCode := AErrorCode;
end;

{ TConnection }

constructor TConnection.Create(ACString: string; ACType: TConnectionType);
begin
  inherited Create;
  FCString := ACString;
  FCType := ACType;
end;

{ TConnectionList }

procedure TConnectionList.AddFromFile(AFileName: string; AConnectionType: TConnectionType);
var
  InitList: TStringList;
  StartPHP: Boolean;
  I: Integer;
  ConnectionString: string;
begin
  if FileExists(AFileName) then
  begin
    InitList := TStringList.Create;

    try
      InitList.LoadFromFile(AFileName);
      StartPHP := False;

      for I := 0 to InitList.Count - 1 do
      begin
        if not StartPHP and (Pos('<?php', InitList[I]) = 1) then
          StartPHP := True
        else
        if StartPHP and (Pos('?>', InitList[I]) = 1) then
          StartPHP := False
        else
        begin
          ConnectionString := '';

          if StartPHP and (Pos('$host', InitList[I]) > 0) then
            ConnectionString := Trim(AnsiDequotedStr(Trim(InitList.ValueFromIndex[I]), '"'))
          else
          if not StartPHP then
            ConnectionString := Trim(InitList[I]);

          if ConnectionString <> '' then
            Add(TConnection.Create(ConnectionString, AConnectionType));
        end;
      end;
    finally
      InitList.Free;
    end;
  end;
end;

procedure TConnectionList.AfterConstruction;
var
  I: TConnectionType;
begin
  inherited AfterConstruction;

  for I := Low(FCurrentConnection) to High(FCurrentConnection) do
    FCurrentConnection[I] := nil;
end;

function TConnectionList.GetConnection(Index: Integer): TConnection;
begin
  Result := inherited GetItem(Index) as TConnection;
end;

function TConnectionList.GetCurrentConnection(ACType: TConnectionType): TConnection;
begin
  Result := FCurrentConnection[ACType];

  if (Result <> nil) and (IndexOf(Result) = -1) then
    Result := FirstConnection(ACType);
end;

function TConnectionList.FirstConnection(ACType: TConnectionType): TConnection;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to Pred(Count) do
    if Items[I].CType = ACType then
    begin
      Result := Items[I];
      Break;
    end;

  FCurrentConnection[ACType] := Result;
end;

function TConnectionList.NextConnection(ACType: TConnectionType): TConnection;
var
  I: Integer;
begin
  Result := CurrentConnection[ACType];

  if Result <> nil then
  begin
    I := IndexOf(Result);
    Result := nil;

    repeat
      Inc(I);

      if (I < Count) and (Items[I].CType = ACType) then
      begin
        Result := Items[I];
        Break;
      end;
    until I >= Count;
  end;

  FCurrentConnection[ACType] := Result;
end;

procedure TConnectionList.SetConnection(Index: Integer; const Value: TConnection);
begin
  inherited SetItem(Index, Value);
end;

initialization
  IdHTTPWork := TIdHTTPWork.Create;

end.
