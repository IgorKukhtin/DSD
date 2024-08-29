unit FMX.Storage;

interface

uses System.SysUtils;

type

  ///	<summary>
  /// Интерфейс - мост между приложением и средним уровнем.
  ///	</summary>
  ///	<remarks>
  /// Используейте данный Интерфейс для вызова методов на сервере базе данных
  ///	</remarks>
  IStorage = interface
    function GetConnection: string;
    procedure SetConnection(Value: string);
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
    property Connection: String read GetConnection write SetConnection;
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
  function GetTextMessage(E: Exception): string;

implementation

uses System.StrUtils, System.Classes, System.Variants, System.SyncObjs,
     System.IOUtils, System.ZLib,
     IdHTTP, IDComponent, idGlobal, IdStack, IdExceptionCore,
     Xml.XMLDoc, XMLIntf, Xml.xmldom, XML.OmniXMLDom,
     FMX.SimpleGauge, FMX.CommonData, FMX.Forms, FMX.Dialogs,
     FMX.LogUtils, FMX.UtilConst;

const

   ResultTypeLenght = 13;
   IsArchiveLenght = 2;
   XMLStructureLenghtLenght = 10;

type

  TStorage = class(TInterfacedObject, IStorage)
  strict private
    class var
      Instance: TStorage;
  private
    FConnection: String;
    FConnections: TStringList;
    FActiveConnection: Integer;
    IdHTTP: TIdHTTP;
    FSendList: TStringList;
    FReceiveStream: TBytesStream;
    InBytes: TBytes;
    XMLDocument: IXMLDocument;
    isArchive: boolean;
    // критичесая секция нужна из-за таймера
    FCriticalSection: TCriticalSection;
    function PrepareStr: Variant;
    function PrepareDataSet: TBytes;
    function ExecuteProc(pData: String; pExecOnServer: boolean = false;
      AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
    procedure ProcessErrorCode(pData: String; ProcedureParam: String);
    function ProcessMultiDataSet: Variant;
    function GetConnection: string;
    procedure SetConnection(Value: string);
  public
    property Connection: String read GetConnection write SetConnection;
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

function GetTextMessage(E: Exception): string;
begin
   if pos('context', AnsilowerCase(E.Message)) = 0 then
      Result := E.Message
   else
      // Выбрасываем все что после Context
      Result := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1);
end;

function TStorage.GetConnection: string;
begin
  result := FConnection;
end;

procedure TStorage.SetConnection(Value: string);
begin
  FConnection := Value;
end;

class function TStorage.NewInstance: TObject;
var
  ConnectionString: string;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
    Instance.FConnections := TStringList.Create;
    Instance.FActiveConnection := 0;
    try
      if gc_WebService <> '' then
        Instance.FConnections.Add(gc_WebService);

      if Instance.FConnections.Count = 0 then
        Instance.FConnections.Add('http://localhost/dsd/index.php');

      ConnectionString := Instance.FConnections.Strings[0];
    except
      if Instance.FConnections.Count = 0 then
        Instance.FConnections.Add('http://localhost/dsd/index.php');
      ConnectionString := Instance.FConnections.Strings[0];
    end;
    Instance.FConnection := ConnectionString;
    Instance.IdHTTP := TIdHTTP.Create(nil);
//    Instance.IdHTTP.ConnectTimeout := 5000;
    if dsdHTTPCharSet = csUTF_8 then Instance.IdHTTP.Response.CharSet := 'utf-8'
    else Instance.IdHTTP.Response.CharSet := 'windows-1251';
    with Instance.IdHTTP.Request do
    begin
      Connection:='keep-alive';
    end;
    Instance.IdHTTP.OnWorkBegin := IdHTTPWork.IdHTTPWorkBegin;
    Instance.IdHTTP.OnWork := IdHTTPWork.IdHTTPWork;
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TBytesStream.Create;
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
  if AWorkMode = wmWrite then
  begin
     TIdHTTP(ASender).IOHandler.RecvBufferSize := 1;
     Gauge := TGaugeFactory.GetGauge('Выполнение процедуры на сервере', 1, 100);
     Gauge.Start;
  end;
end;

function TStorage.PrepareStr: Variant;
var inStream: TBytesStream; outStream: TStringStream;
begin
  if isArchive then
  begin
    inStream := TBytesStream.Create(InBytes);
    if dsdHTTPCharSet = cswindows_1251 then
      outStream := TStringStream.Create('', TEncoding.ANSI)
    else outStream := TStringStream.Create('', TEncoding.UTF8);

    try
      ZDecompressStream(inStream, outStream);
      Result := outStream.DataString;
    finally
      inStream.Free;
      outStream.Free;
    end;
  end
  else if dsdHTTPCharSet = cswindows_1251 then
    Result := StringReplace(TEncoding.ANSI.GetString(InBytes), #0, '', [rfReplaceAll])
  else Result := StringReplace(TEncoding.UTF8.GetString(InBytes), #0, '', [rfReplaceAll]);
end;

function TStorage.PrepareDataSet: TBytes;
  var inStream, outStream: TBytesStream;
begin
  if isArchive then
  begin
    inStream := TBytesStream.Create(InBytes);
    outStream := TBytesStream.Create;
    try
      ZDecompressStream(inStream, outStream);
      Result := outStream.Bytes;
    finally
      inStream.Free;
      outStream.Free;
    end;
  end
  else
    Result := InBytes;
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
       result := result + ' ioSession := ' + chr(39) + Session + chr(39) + ');';
     end;
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
  AttemptCount, ReadOnlyCount: integer;
  ok: Boolean;
  StartActiveConnection: Integer;
  ResStr : string;
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
    FSendList.Clear;

    if dsdHTTPCharSet = csUTF_8 then
    begin
      FSendList.Add('XML=' + '<?xml version="' + dsdXML_Version + '" encoding="utf-8"?>' + pData);
      if dsdXML_SufixUTF8 then FSendList.Add('ENC=UTF8');
    end else FSendList.Add('XML=' + '<?xml version="' + dsdXML_Version + '" encoding="windows-1251"?>' + pData);

    Logger.AddToLog(pData);
    FReceiveStream.Clear;
    IdHTTPWork.FExecOnServer := pExecOnServer;
    AttemptCount := 0;
    ReadOnlyCount := -1;
    ok := False;
    StartActiveConnection := FActiveConnection;
    try
      repeat
        for AttemptCount := 1 to AMaxAtempt do
        Begin
          try
            if CheckReadOnlyProcs(pData) and (Length(gc_WebServers_r) <> 0) and (ReadOnlyCount < 1) then
            begin
              Inc(ReadOnlyCount);
              if dsdHTTPCharSet = csUTF_8 then
                idHTTP.Post(gc_WebServers_r[ReadOnlyCount] + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, IndyTextEncoding(encUTF8))
              else idHTTP.Post(gc_WebServers_r[ReadOnlyCount] + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, IndyTextEncoding(1251));
            end else
            begin
              if dsdHTTPCharSet = csUTF_8 then
                idHTTP.Post(FConnection + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, IndyTextEncoding(encUTF8))
              else idHTTP.Post(FConnection + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, IndyTextEncoding(1251));
            end;

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
                    10051: raise EStorageException.Create('Отсутсвует подключение к сети. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    10054: raise EStorageException.Create('Соединение сброшено сервером. Попробуйте действие еще раз. context TStorage. ' + E.Message);
                    10060: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    11001: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    10065: raise EStorageException.Create('Нет соединения с интернетом. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                    10061: raise EStorageException.Create('Потеряно соединения с WEB сервером. Необходимо перезайти в программу после восстановления соединения. context TStorage. ' + E.Message);
                  else
                    raise EStorageException.Create(E.Message+ '.context TStorage');
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
                raise Exception.Create('Ошибка соединения с Web сервером.'+#10+#13+'Обратитесь к разработчику.context TStorage. '+#10+#13+E.Message);
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
          FConnection := FConnections.Strings[FActiveConnection];
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
   //   idHTTP.Disconnect;
    end;
  //  if pExecOnServer then

    // Определяем тип возвращаемого результата
    if Ok then
    Begin
      ResStr := StringReplace(TEncoding.UTF8.GetString(FReceiveStream.Bytes, 0, ResultTypeLenght + IsArchiveLenght), #0, '', [rfReplaceAll]);

      ResultType := trim(Copy(ResStr, 1, ResultTypeLenght));
      isArchive := trim(lowercase(Copy(ResStr, ResultTypeLenght + 1, IsArchiveLenght))) = 't';

      SetLength(InBytes, Length(FReceiveStream.Bytes) - ResultTypeLenght - IsArchiveLenght);
      Move(FReceiveStream.Bytes[ResultTypeLenght + IsArchiveLenght], InBytes[0], Length(InBytes));

      if ResultType = gcMultiDataSet then begin
         Result := ProcessMultiDataSet;
         exit;
      end;
      if ResultType = gcError then
         ProcessErrorCode(PrepareStr, ConvertXMLParamToStrings(pData));
      if ResultType = gcResult then
         Result := PrepareStr;
      if ResultType = gcDataSet then
         Result := PrepareDataSet;

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

initialization
  IdHTTPWork := TIdHTTPWork.Create;

finalization

  IdHTTPWork.Free;

end.
