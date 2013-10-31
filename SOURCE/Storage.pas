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
    function ExecuteProc(pData: String): Variant;
  end;

  TStorageFactory = class
     class function GetStorage: IStorage;
  end;

  EStorageException = class(Exception)

  end;

  function ConvertXMLParamToStrings(XMLParam: String): String;

implementation

uses IdHTTP, Xml.XMLDoc, XMLIntf, Classes, ZLibEx, idGlobal, UtilConst, DBClient, Variants, UtilConvert,
     MessagesUnit, Dialogs, StrUtils;

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
    function ExecuteProc(pData: String): Variant;
    procedure ProcessErrorCode(pData: String);
    function ProcessMultiDataSet: Variant;
  public
    class function NewInstance: TObject; override;
  end;

class function TStorage.NewInstance: TObject;
var
  f: text;
  ConnectionString: string;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
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
    Instance.FConnection := ConnectionString;
    Instance.IdHTTP := TIdHTTP.Create(nil);
    Instance.IdHTTP.Response.CharSet := 'windows-1251';// 'Content-Type: text/xml; charset=utf-8'
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TStringStream.Create('');
    Instance.XMLDocument := TXMLDocument.Create(nil);
  end;
  NewInstance := Instance;
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
       raise EStorageException.Create(StringReplace(GetAttribute(gcErrorMessage), 'ОШИБКА:  ', '', []));
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

function TStorage.ExecuteProc(pData: String): Variant;
var
  ResultType: String;
begin
  if gc_isDebugMode then
     TMessagesForm.Create(nil).Execute(ConvertXMLParamToStrings(pData), ConvertXMLParamToStrings(pData), true);
  FSendList.Clear;
  FSendList.Add('XML=' + '<?xml version="1.1" encoding="windows-1251"?>' + pData);
  FReceiveStream.Clear;
  idHTTP.Post(FConnection, FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
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
end;

class function TStorageFactory.GetStorage: IStorage;
begin
  result := TStorage(TStorage.NewInstance);
end;


end.
