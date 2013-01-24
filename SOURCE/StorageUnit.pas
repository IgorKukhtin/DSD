unit StorageUnit;

interface

uses UtilType, IdHTTP;

type

  ///	<summary>
  /// Класс - мост между приложением и средним уровнем.
  ///	</summary>
  ///	<remarks>
  /// Используейте данный класс для вызова методов на сервере базе данных
  ///	</remarks>
  TStorage = class
  private
    FConnection: String;
    IdHTTP: TIdHTTP;
  public
    ///	<summary>
    /// Процедура вызова обработчика XML структры на среднем уровне.
    ///	</summary>
    ///	<remarks>
    /// Возвращает XML как результат вызова
    ///	</remarks>
    ///	<param name="pData">
    ///	  XML структура, хранящая данные для обработки на сервере
    ///	</param>
    function ExecuteProc(var pData: TXML): TXML;
    ///	<param name="pConnection">
    ///	  строчка соединения с сервером среднего уровня
    ///	</param>
    constructor Create(pConnection: string);
  end;

  TStorageFactory = class
     class function GetStorage: TStorage;
  end;

implementation

uses Classes;

class function TStorageFactory.GetStorage: TStorage;
begin
  result := TStorage.Create('http://localhost/dsd/index.php');
end;

constructor TStorage.Create(pConnection: string);
begin
  IdHTTP := TIdHTTP.Create(nil);
  FConnection := pConnection
end;

function TStorage.ExecuteProc(var pData: TXML): TXML;
begin
  result := IdHTTP.Post(FConnection, TStringList.Create)
end;


end.
