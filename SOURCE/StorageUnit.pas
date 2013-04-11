unit StorageUnit;

interface

uses IdHTTP, Xml.XMLDoc, XMLIntf, Classes;

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

implementation

uses SysUtils, ZLibEx, idGlobal, UtilConst, DBClient, Variants, UtilConvert;

const

   ResultTypeLenght = 13;
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
    Str: RawByteString;
    XMLDocument: IXMLDocument;
    function ExecuteProc(pData: String): Variant;
    procedure ProcessErrorCode(pData: String);
    function ProcessMultiDataSet: Variant;
  public
    class function NewInstance: TObject; override;
  end;

class function TStorage.NewInstance: TObject;
begin
  if true{not Assigned(Instance) }then begin
    Instance := TStorage(inherited NewInstance);
    Instance.FConnection := 'http://localhost/dsd/index.php';
    Instance.IdHTTP := TIdHTTP.Create(nil);
    Instance.IdHTTP.Response.CharSet := 'windows-1251';// 'Content-Type: text/xml; charset=utf-8'
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TStringStream.Create('');
    Instance.XMLDocument := TXMLDocument.Create(nil);
  end;
  NewInstance := Instance;
end;

procedure TStorage.ProcessErrorCode(pData: String);
begin
  with LoadXMLData(pData).DocumentElement do
    if NodeName = gcError then
       raise Exception.Create(StringReplace(GetAttribute(gcErrorMessage), 'ОШИБКА:  ', '', []));
end;

function TStorage.ProcessMultiDataSet: Variant;
var
  XMLStructureLenght: integer;
  DataFromServer: AnsiString;
  i, StartPosition: integer;
begin
  DataFromServer := ZDecompressStr(Str);
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

class function TStorageFactory.GetStorage: IStorage;
begin
  result := TStorage(TStorage.NewInstance);
end;

function TStorage.ExecuteProc(pData: String): Variant;
var
  ResultType: String;
begin
  FSendList.Clear;
  FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' + pData);
  FReceiveStream.Clear;
  idHTTP.Post(FConnection, FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
  // Определяем тип возвращаемого результата
  ResultType := trim(Copy(FReceiveStream.DataString, 1, ResultTypeLenght));
  // Сдвигаем указатель на нужное кол-во байт, что бы не копировать строку
  Str := RawByteString(pointer(integer(FReceiveStream.Bytes) + ResultTypeLenght));
  if ResultType = gcMultiDataSet then begin
     Result := ProcessMultiDataSet;
     exit;
  end;
  if ResultType = gcError then
     ProcessErrorCode(ZDecompressStr(Str));
  if ResultType = gcResult then
     Result := ZDecompressStr(Str);
  if ResultType = gcDataSet then
     Result := ZDecompressStr(Str);
end;


end.
