unit FormStorageUnit;

interface

uses
  Classes, Forms, dsdDataSetWrapperUnit, FormUnit;

type

  TdsdFormStorage = class
  strict private
    class var
      Instance: TdsdFormStorage;
  private
    SaveStoredProc: TdsdStoredProc;
    LoadStoredProc: TdsdStoredProc;
  public
    procedure Save(Form: TComponent);
    function Load(FormName: String): TParentForm;
    class function NewInstance: TObject; override;
  end;

  TdsdFormStorageFactory = class
     class function GetStorage: TdsdFormStorage;
  end;

implementation

uses Xml.XMLDoc, UtilConvert, DB;

{ TdsdFormStorage }

class function TdsdFormStorage.NewInstance: TObject;
begin
  if not Assigned(Instance) then begin
    Instance := TdsdFormStorage(inherited NewInstance);
    Instance.SaveStoredProc := TdsdStoredProc.Create(nil);
    Instance.SaveStoredProc.StoredProcName := 'gpInsertUpdate_Object_Form';
    Instance.SaveStoredProc.OutputType := otResult;
    Instance.SaveStoredProc.Params.AddParam('FormName', ftString, ptInput, '');
    Instance.SaveStoredProc.Params.AddParam('FormData', ftBlob, ptInput, '');

    Instance.LoadStoredProc := TdsdStoredProc.Create(nil);
    Instance.LoadStoredProc.StoredProcName := 'gpGet_Object_Form';
    Instance.LoadStoredProc.OutputType := otBlob;
    Instance.LoadStoredProc.Params.AddParam('FormName', ftString, ptInput, '');
  end;
  NewInstance := Instance;
end;

function TdsdFormStorage.Load(FormName: String): TParentForm;
var Stream: TStringStream;
    MemoryStream: TMemoryStream;
begin
  Result := TParentForm.CreateNew(Application);

  LoadStoredProc.ParamByName('FormName').Value := FormName;

  Stream := TStringStream.Create(gfStrXmlToStr(LoadStoredProc.Execute));
  MemoryStream := TMemoryStream.Create;
  try
    // Преобразовать текст в бинарные данные
    ObjectTextToBinary(Stream, MemoryStream);
    // Вернуть смещение
    MemoryStream.Position := 0;
    // Прочитать компонент из потока
    MemoryStream.ReadComponent(Result);
  finally
    Stream.Free;
    MemoryStream.Free;
  end;
end;

procedure TdsdFormStorage.Save(Form: TComponent);
var
  Stream: TStringStream;
  MemoryStream: TMemoryStream;
  XMLDocument: TXMLDocument;
  XML: String;
begin
  Stream := TStringStream.Create;
  MemoryStream := TMemoryStream.Create;
  XMLDocument:= TXMLDocument.Create(nil);
  try
    MemoryStream.WriteComponent(Form);
    MemoryStream.Position := 0;
    ObjectBinaryToText(MemoryStream, Stream);
    SaveStoredProc.ParamByName('FormName').Value := Form.ClassName;
    // Оборачиваем символы #13 и #10
    XMLDocument.LoadFromXML('<xml Data="' + gfStrToXmlStr(Stream.DataString) + '"/>');
    XMLDocument.SaveToXML(XML);

    SaveStoredProc.ParamByName('FormData').Value := gfStrToXmlStr(copy(XML, 12, length(XML) - 15));
    SaveStoredProc.Execute;
  finally
    Stream.Free;
    MemoryStream.Free;
  end;
end;

{ TdsdFormStorageFactory }

class function TdsdFormStorageFactory.GetStorage: TdsdFormStorage;
begin
  result := TdsdFormStorage(TdsdFormStorage.NewInstance);
end;

end.
