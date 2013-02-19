unit StorageUnit;

interface

uses UtilType, IdHTTP, Xml.XMLDoc, XMLIntf, Classes;

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
    function ExecuteProc(pData: TXML): OleVariant;
  end;

  TStorageFactory = class
     class function GetStorage: IStorage;
  end;

implementation

uses SysUtils, UtilConst, ZLibEx, idGlobal, DBClient;

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
    function ExecuteProc(pData: TXML): OleVariant;
    procedure ProcessErrorCode(pData: TXML);
  public
    class function NewInstance: TObject; override;
  end;

class function TStorage.NewInstance: TObject;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
    Instance.FConnection := 'http://localhost/dsd/index.php';
    Instance.IdHTTP := TIdHTTP.Create(nil);
    Instance.IdHTTP.Response.CharSet := 'windows-1251';// 'Content-Type: text/xml; charset=utf-8'
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TStringStream.Create('');
  end;
  NewInstance := Instance;
end;

procedure TStorage.ProcessErrorCode(pData: TXML);
begin
  with LoadXMLData(pData).DocumentElement do
    if NodeName = gcError then
       raise Exception.Create(StringReplace(GetAttribute(gcErrorMessage), 'ОШИБКА:  ', '', []));
end;

class function TStorageFactory.GetStorage: IStorage;
begin
  result := TStorage(TStorage.NewInstance);
end;

function TStorage.ExecuteProc(pData: TXML): OleVariant;
var
  ResultType: String;
  Str: RawByteString;
begin
  FSendList.Clear;
  FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' + pData);
  FReceiveStream.Clear;
  idHTTP.Post(FConnection, FSendList, FReceiveStream, TIdTextEncoding.GetEncoding(1251));
  // Определяем тип возвращаемого результата
  ResultType := trim(Copy(FReceiveStream.DataString, 1, 10));
  // Сдвигаем указатель на нужное кол-во байт, что бы не копировать строку
  Str := RawByteString(pointer(integer(FReceiveStream.Bytes)+10));
  if ResultType = gcError then
     ProcessErrorCode(ZDecompressStr(Str));
  if ResultType = gcResult then
     Result := ZDecompressStr(Str);
  if ResultType = gcDataSet then
     Result := ZDecompressStr(Str);
end;


end.
