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
    function ExecuteProc(pData: String; pExecOnServer: boolean = false): Variant;
  end;

  TStorageFactory = class
     class function GetStorage: IStorage;
  end;

  EStorageException = class(Exception)
  private
    FErrorCode: string;
  public
    constructor Create(AMessage, AErrorCode: String);
    property ErrorCode: string read FErrorCode write FErrorCode;
  end;

  function ConvertXMLParamToStrings(XMLParam: String): String;

implementation

uses IdHTTP, Xml.XMLDoc, XMLIntf, Classes, ZLibEx, idGlobal, UtilConst, Variants, UtilConvert,
     MessagesUnit, Dialogs, StrUtils, IDComponent, SimpleGauge, Forms, Log;

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
    IdHTTP: TIdHTTP;
    FSendList: TStringList;
    FReceiveStream: TStringStream;
    Str: AnsiString;//RawByteString;
    XMLDocument: IXMLDocument;
    isArchive: boolean;
    function PrepareStr: AnsiString;
    function ExecuteProc(pData: String; pExecOnServer: boolean = false): Variant;
    procedure ProcessErrorCode(pData: String);
    function ProcessMultiDataSet: Variant;
  public
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

class function TStorage.NewInstance: TObject;
var
  f: text;
  ConnectionString: string;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
    try
      AssignFile(F, ConnectionPath);
      Reset(f);
      readln(f, ConnectionString);
      readln(f, ConnectionString);
      readln(f, ConnectionString);
      CloseFile(f);
      // Вырезаем строку подключения
      ConnectionString := Copy(ConnectionString, Pos('=', ConnectionString) + 3, maxint);
      ConnectionString := Copy(ConnectionString, 1, length(ConnectionString) - 2);
      ConnectionString := ReplaceStr(ConnectionString, ' ', #13#10);
    except
      ConnectionString := 'http://localhost/dsd/index.php';
    end;
    Instance.FConnection := ConnectionString;
    Instance.IdHTTP := TIdHTTP.Create(nil);
    Instance.IdHTTP.Response.CharSet := 'windows-1251';// 'Content-Type: text/xml; charset=utf-8'
    Instance.IdHTTP.OnWorkBegin := IdHTTPWork.IdHTTPWorkBegin;
    Instance.IdHTTP.OnWork := IdHTTPWork.IdHTTPWork;
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TStringStream.Create('');
    Instance.XMLDocument := TXMLDocument.Create(nil);
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

procedure TStorage.ProcessErrorCode(pData: String);
begin
  with LoadXMLData(pData).DocumentElement do
    if NodeName = gcError then
       raise EStorageException.Create(StringReplace(GetAttribute(gcErrorMessage), 'ОШИБКА:  ', '', []), GetAttribute(gcErrorCode));
end;

function TStorage.ProcessMultiDataSet: Variant;
var
  XMLStructureLenght: integer;
  DataFromServer: AnsiString;
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

function TStorage.ExecuteProc(pData: String; pExecOnServer: boolean = false): Variant;
  function GetAddConnectString(pExecOnServer: boolean): Ansistring;
  begin
    if pExecOnServer then
       result := 'server.php'
    else
       result := '';
  end;
var
  ResultType: String;
begin
  if gc_isDebugMode then
     TMessagesForm.Create(nil).Execute(ConvertXMLParamToStrings(pData), ConvertXMLParamToStrings(pData), true);
  FSendList.Clear;
  FSendList.Add('XML=' + '<?xml version="1.1" encoding="windows-1251"?>' + pData);
  Logger.AddToLog(pData);
  FReceiveStream.Clear;
  IdHTTPWork.FExecOnServer := pExecOnServer;
  try
    idHTTP.Post(FConnection + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
  finally
    if IdHTTPWork.FExecOnServer then
       IdHTTPWork.Gauge.Finish;
    IdHTTPWork.FExecOnServer := false;
    idHTTP.Disconnect;
  end;
//  if pExecOnServer then

  // Определяем тип возвращаемого результата
  ResultType := trim(Copy(FReceiveStream.DataString, 1, ResultTypeLenght));
  isArchive := trim(lowercase(Copy(FReceiveStream.DataString, ResultTypeLenght + 1, IsArchiveLenght))) = 't';
  Str := Copy(FReceiveStream.DataString, ResultTypeLenght + IsArchiveLenght + 1, maxint);
  if ResultType = gcMultiDataSet then begin
     Result := ProcessMultiDataSet;
     exit;
  end;
  if ResultType = gcError then
     ProcessErrorCode(PrepareStr);
  if ResultType = gcResult then
     Result := PrepareStr;
  if ResultType = gcDataSet then
     Result := PrepareStr;

  Logger.AddToLog(Result);
end;

class function TStorageFactory.GetStorage: IStorage;
begin
  result := TStorage(TStorage.NewInstance);
end;

{ EStorageException }

constructor EStorageException.Create(AMessage, AErrorCode: String);
begin
  inherited Create(AMessage);
  ErrorCode := AErrorCode;
end;

initialization
  IdHTTPWork := TIdHTTPWork.Create;

end.
