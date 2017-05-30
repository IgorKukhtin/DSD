unit Storage;

interface

uses SysUtils;

type

  ///	<summary>
  /// Интерфейс - мост между приложением и средним уровнем.
  ///	</summary>
  ///	<remarks>
  /// Используейте данный Интерфейс для вызова методов на сервере базе данных
  ///	</remarks>
  IStorage = interface
    function GetConnection: string;
    ///	<summary>
    /// Процедура вызова обработчика XML структры на среднем уровне.
    ///	</summary>
    ///	<remarks>
    /// Возвращает XML как результат вызова
    ///	</remarks>
    ///	<param name="pData">
    ///	  XML структура, хранящая данные для обработки на сервере
    ///	</param>
    ///	<param name="pExecOnServer">
    ///	  если true, то процедуры выполняются в цикле на среднем уровне
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
    function GetConnection(Index: Integer): TConnection;
    procedure SetConnection(Index: Integer; const Value: TConnection);
  public
    procedure AddFromFile(AFileName: string; AConnectionType: TConnectionType);
    property Items[Index: Integer]: TConnection read GetConnection write SetConnection; default;
  end;

  TStorage = class(TInterfacedObject, IStorage)
  strict private
    class var
      Instance: TStorage;
  private
    FConnection: String;
    FReportConnection: string;
    FConnections: TStringList;
    FReportConnections: TStringList;
    FActiveConnection: Integer;
    IdHTTP: TIdHTTP;
    FSendList: TStringList;
    FReceiveStream: TStringStream;
    Str: AnsiString;//RawByteString;
    XMLDocument: IXMLDocument;
    isArchive: boolean;
    // критичесая секция нужна из-за таймера
    FCriticalSection: TCriticalSection;
    FReportList: TStringList;
    function PrepareStr: AnsiString;
    function ExecuteProc(pData: String; pExecOnServer: boolean = false;
      AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
    procedure ProcessErrorCode(pData: String; ProcedureParam: String);
    function ProcessMultiDataSet: Variant;
    function GetConnection: string;
    procedure LoadReportList(ASession: string);
    function CheckReportConnection(pData: string): string;
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
  result := FConnection;
end;

procedure TStorage.LoadReportList(ASession: string);
const
  {создаем XML вызова процедуры на сервере}
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
      Stream.Free;
      DataSet.Free;
    end;
  except
  end;
end;

class function TStorage.NewInstance: TObject;
var
  StringList, StringListRep: TStringList;
  ConnectionString, ReportConnectionString: string;
  lConnectionPathRep:String;
  i: Integer;
  StartPHP: Boolean;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
    Instance.FConnections := TStringList.Create;
    Instance.FReportConnections := TStringList.Create;
    Instance.FReportList := TStringList.Create;
    Instance.FActiveConnection := 0;
    try
      StringList := TStringList.Create;
      StringListRep := TStringList.Create;
      try
        lConnectionPathRep := ReplaceStr(ConnectionPath, '\init.php', '\initRep.php');
        //
        StringList.LoadFromFile(ConnectionPath);
        if (lConnectionPathRep <> ConnectionPath) and FileExists(lConnectionPathRep) then
          StringListRep.LoadFromFile(lConnectionPathRep);
        //
        //составление списка возможных альтернативных серверов - ОСНОВНОЙ
        StartPHP := False;
        for i := 0 to StringList.Count - 1 do
        begin
          if not StartPHP and (Pos('<?php', StringList[i]) = 1) then
            StartPHP := True
          else
          if StartPHP and (Pos('?>', StringList[i]) = 1) then
            StartPHP := False
          else
          begin
            if StartPHP and (Pos('$host', StringList[i]) > 0) then
            begin
              ConnectionString := AnsiDequotedStr(Trim(StringList.ValueFromIndex[i]), '"');
              Instance.FConnections.Add(Trim(ConnectionString));
            end else
            if not StartPHP then
            begin
              Instance.FConnections.Add(Trim(StringList[i]));
            end;
          end;
        end;
        //
        //составление списка возможных альтернативных серверов - для ОТЧЕТОВ
        StartPHP := False;
        ReportConnectionString := '';
        for i := 0 to StringListRep.Count - 1 do
        begin
          if not StartPHP and (Pos('<?php', StringListRep[i]) = 1) then
            StartPHP := True
          else
          if StartPHP and (Pos('?>', StringListRep[i]) = 1) then
            StartPHP := False
          else
          begin
            if StartPHP and (Pos('$host', StringListRep[i]) > 0) then
            begin
              ReportConnectionString := AnsiDequotedStr(Trim(StringListRep.ValueFromIndex[i]), '"');
              Instance.FReportConnections.Add(Trim(ReportConnectionString));
            end else
            if not StartPHP then
            begin
              Instance.FReportConnections.Add(Trim(StringListRep[i]));
            end;
          end;
        end;
        //
        if Instance.FConnections.Count = 0 then
          Instance.FConnections.Add('http://localhost/dsd/index.php');
        ConnectionString := Instance.FConnections[0];
        if Instance.FReportConnections.Count > 0 then
          ReportConnectionString := Instance.FReportConnections[0];
        //
        if ReportConnectionString = '' then
          ReportConnectionString := ConnectionString;
        (*
        if StringList.Count = 1 then
           ConnectionString := StringList[0]
        else begin
           // Вырезаем строку подключения
           ConnectionString := StringList[2];
           ConnectionString := Copy(ConnectionString, Pos('=', ConnectionString) + 3, maxint);
           ConnectionString := Copy(ConnectionString, 1, length(ConnectionString) - 2);
        end;*)
      finally
        StringList.Free;
        StringListRep.Free;
      end;
    except
      if Instance.FConnections.Count = 0 then
        Instance.FConnections.Add('http://localhost/dsd/index.php');
      ConnectionString := Instance.FConnections.Strings[0];
      if ReportConnectionString = '' then
        ReportConnectionString := ConnectionString;
      //ConnectionString := 'http://localhost/dsd/index.php';
    end;
    Instance.FConnection := ConnectionString;
    Instance.FReportConnection := ReportConnectionString;
    Instance.IdHTTP := TIdHTTP.Create(nil);
//    Instance.IdHTTP.ConnectTimeout := 5000;
    Instance.IdHTTP.Response.CharSet := 'windows-1251';// 'Content-Type: text/xml; charset=utf-8'
    with Instance.IdHTTP.Request do
    begin
      Connection:='keep-alive';
    end;
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
     Gauge := TGaugeFactory.GetGauge('Выполнение процедуры на сервере', 1, 100);
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
       raise EStorageException.Create(StringReplace(GetAttribute(gcErrorMessage), 'ОШИБКА:  ', '', []) + ' context: ' + ProcedureParam, GetAttribute(gcErrorCode));
end;

function TStorage.ProcessMultiDataSet: Variant;
var
  XMLStructureLenght: integer;
  DataFromServer: String;
  i, StartPosition: integer;
begin
  DataFromServer := PrepareStr;
  // Для нескольких датасетов процедура более сложная.
  // В начале надо получить XML, где хранятся данные по ДатаСетам.

  XMLStructureLenght := StrToInt(Copy(DataFromServer, 1, XMLStructureLenghtLenght));
  XMLDocument.LoadFromXML(Copy(DataFromServer, XMLStructureLenghtLenght + 1, XMLStructureLenght));
  with XMLDocument.DocumentElement do begin
    result := VarArrayCreate([0, ChildNodes.Count - 1], varVariant);
    // Сдвигаем указатель на нужное кол-во байт, что бы не копировать строку
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

function TStorage.CheckReportConnection(pData: string): string;
var
  S: string;
begin
  Result := FConnection;
  if FReportList.Count > 0 then
    for S in FReportList do
      if Pos(S, pData) > 0 then
      begin
        Result := FReportConnection;
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
  ResultType: String;
  AttemptCount: integer;
  ok: Boolean;
  StartActiveConnection: Integer;
  LastError: integer;
  OldConnection: string;
  function NextActiveConnection: Integer;
  Begin
    Result := (FActiveConnection+1) mod FConnections.Count;
  End;
  function LastAttempt: Boolean;
  Begin
    Result := (AttemptCount >= AMaxAtempt) AND (NextActiveConnection = StartActiveConnection);
  End;
  function Midle: Boolean;
  Begin
    Result := (AttemptCount = (AMaxAtempt div 2));
  End;
begin
  FCriticalSection.Enter;
  try
    if (gc_User.Local = true)  and  (AMaxAtempt = 10) then
     AMaxAtempt := 2;   // для локольного режима один проход
    if gc_isDebugMode then
       TMessagesForm.Create(nil).Execute(ConvertXMLParamToStrings(pData), ConvertXMLParamToStrings(pData), true);
    FSendList.Clear;
    FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' + pData);
    Logger.AddToLog(pData);
    FReceiveStream.Clear;
    IdHTTPWork.FExecOnServer := pExecOnServer;
    AttemptCount := 0;
    ok := False;
    OldConnection := FConnection;
    FConnection := CheckReportConnection(pData);
    StartActiveConnection := FActiveConnection;
    try
      repeat
        for AttemptCount := 1 to AMaxAtempt do
        Begin
          try
            idHTTP.Post(FConnection + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
            OldConnection := FConnection;
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
                    //ShowMessage('Программа переведена в режим автономной работы.'+#13+
                    //            'Перезайдите в программу после восстановления связи с сервером.')
                  end;
                  case E.LastError of
                    10051: raise EStorageException.Create('Отсутсвует подключение к сети. Обратитесь к системному администратору. context TStorage. ' + E.Message, );
                    10054: raise EStorageException.Create('Соединение сброшено сервером. Попробуйте действие еще раз. context TStorage. ' + E.Message);
                    10060: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    11001: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    10065: raise EStorageException.Create('Нет соединения с интернетом. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    10061: raise EStorageException.Create('Потеряно соединения с WEB сервером. Необходимо перезайти в программу после восстановления соединения.');
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
                raise Exception.Create('Ошибка соединения с Web сервером.'+#10+#13+'Обратитесь к разработчику.'+#10+#13+E.Message);
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
          FActiveConnection := NextActiveConnection;
          FConnection := FConnections .Strings[FActiveConnection];
          try
            idHTTP.Disconnect;
          except
          end;
        end
        else
          Break;
      until ok;
      (*
      for AttemptCount := 1 to 10 do
        try
          idHTTP.Post(FConnection + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
          break;
        except
          on E: EIdSocketError do begin
             case E.LastError of
               10051: raise EStorageException.Create('Отсутсвует подключение к сети. Обратитесь к системному администратору. context TStorage. ' + E.Message, );
               10054: raise EStorageException.Create('Соединение сброшено сервером. Попробуйте действие еще раз. context TStorage. ' + E.Message);
               10060: begin
                         if AttemptCount > 9 then
                            raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                      end;
               11001: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
               10065: raise EStorageException.Create('Нет соединения с интернетом. Обратитесь к системному администратору. context TStorage. ' + E.Message);
               10061: raise EStorageException.Create('Потеряно соединения с WEB сервером. Необходимо перезайти в программу после восстановления соединения.');
               else
                      raise E;
             end;
          end;
          on E: Exception do
                raise Exception.Create('Ошибка соединения с Web сервером.'+#10+#13+'Обратитесь к разработчику.'+#10+#13+E.Message);
        end;
      *)
    finally
      FConnection := OldConnection;
      if IdHTTPWork.FExecOnServer then
         IdHTTPWork.Gauge.Finish;
      IdHTTPWork.FExecOnServer := false;
   //   idHTTP.Disconnect;
    end;
  //  if pExecOnServer then

    // Определяем тип возвращаемого результата
    if Ok then
    Begin
      ResultType := trim(Copy(FReceiveStream.DataString, 1, ResultTypeLenght));
      isArchive := trim(lowercase(Copy(FReceiveStream.DataString, ResultTypeLenght + 1, IsArchiveLenght))) = 't';
      Str := Copy(FReceiveStream.DataString, ResultTypeLenght + IsArchiveLenght + 1, maxint);
      if ResultType = gcMultiDataSet then begin
         Result := ProcessMultiDataSet;
         exit;
      end;
      if ResultType = gcError then
         ProcessErrorCode(PrepareStr, ConvertXMLParamToStrings(pData));
      if ResultType = gcResult then
         Result := PrepareStr;
      if ResultType = gcDataSet then
         Result := PrepareStr;

      Logger.AddToLog(Result);
    End;
  finally
    // Выход из критической секции
    FCriticalSection.Leave;
  end;
end;

class function TStorageFactory.GetStorage: IStorage;
begin
  result := TStorage(TStorage.NewInstance);
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

function TConnectionList.GetConnection(Index: Integer): TConnection;
begin
  Result := inherited GetItem(Index) as TConnection;
end;

procedure TConnectionList.SetConnection(Index: Integer; const Value: TConnection);
begin
  inherited SetItem(Index, Value);
end;

initialization
  IdHTTPWork := TIdHTTPWork.Create;

end.
