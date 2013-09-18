unit FormStorage;

interface

uses
  Classes, Forms, dsdDB, Xml.XMLDoc, ParentForm;

type

  TdsdFormStorage = class
  strict private
    class var
      Instance: TdsdFormStorage;
  private
    XMLDocument: TXMLDocument;
    StringStream: TStringStream;
    MemoryStream: TMemoryStream;
    SaveStoredProc: TdsdStoredProc;
    LoadStoredProc: TdsdStoredProc;
    SaveUserFormSettingsStoredProc: TdsdStoredProc;
    LoadUserFormSettingsStoredProc: TdsdStoredProc;
    function StringToXML(S: String): String;
    procedure SaveToFormData(DataKey: string);
  public
    procedure Save(Form: TComponent);
    function Load(FormName: String): TParentForm;
    procedure SaveReport(Stream: TStream; ReportName: string);
    function LoadReport(ReportName: String): TStream;
    procedure SaveUserFormSettings(FormName: String; Data: String);
    function LoadUserFormSettings(FormName: String): String;
    class function NewInstance: TObject; override;
    destructor Destroy; override;
  end;

  TdsdFormStorageFactory = class
     class function GetStorage: TdsdFormStorage;
  end;
  function StreamToString(Stream: TStream): String;
  function ANSIToXML(S: String): String;
  function XMLToAnsi(S: String): String;

implementation

uses UtilConvert, DB, SysUtils;

function ANSIToXML(S: String): String;
var i: integer;
begin
  result := '';
  for I := 1 to Length(S) do
    if (s[i] < #32) or (s[i] = #$0098) then
      result := result + '&amp;#' + IntToHex(byte(s[i]),2) + ';'
    else
      result := result + gfStrToXmlStr(s[i]);
end;

function XMLToAnsi(S: String): String;
var i: integer;
begin
  i := 1;
  while i <= Length(S) do begin
      if (s[i] = '&') and (s[i+1] = '#') and (s[i+4] = ';') then begin
         result := result + char(StrToInt('$' + s[i+2] + s[i+3]));
         i := i + 4;
      end
      else
        result := result + s[i];
      i := i + 1;
  end;
end;

function StreamToString(Stream: TStream): String;
begin
    with TStringStream.Create('') do
    try
        CopyFrom(Stream, Stream.Size - Stream.Position);
        Result := DataString;
    finally
        Free;
    end;
end;
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

    Instance.SaveUserFormSettingsStoredProc := TdsdStoredProc.Create(nil);
    Instance.SaveUserFormSettingsStoredProc.StoredProcName := 'gpInsertUpdate_Object_UserFormSettings';
    Instance.SaveUserFormSettingsStoredProc.OutputType := otResult;
    Instance.SaveUserFormSettingsStoredProc.Params.AddParam('inFormName', ftString, ptInput, '');
    Instance.SaveUserFormSettingsStoredProc.Params.AddParam('inUserFormSettingsData', ftBlob, ptInput, '');

    Instance.LoadUserFormSettingsStoredProc := TdsdStoredProc.Create(nil);
    Instance.LoadUserFormSettingsStoredProc.StoredProcName := 'gpGet_Object_UserFormSettings';
    Instance.LoadUserFormSettingsStoredProc.OutputType := otBlob;
    Instance.LoadUserFormSettingsStoredProc.Params.AddParam('inFormName', ftString, ptInput, '');

    Instance.XMLDocument:= TXMLDocument.Create(nil);
    Instance.StringStream := TStringStream.Create;
    Instance.MemoryStream := TMemoryStream.Create;

  end;
  NewInstance := Instance;
end;

destructor TdsdFormStorage.Destroy;
begin
  XMLDocument.Free;
  StringStream.Free;
  MemoryStream.Free;
  SaveStoredProc.Free;
  LoadStoredProc.Free;
  SaveUserFormSettingsStoredProc.Free;
  LoadUserFormSettingsStoredProc.Free;
end;

function TdsdFormStorage.Load(FormName: String): TParentForm;
begin
  Result := TParentForm.CreateNew(Application);
  Result.FormClassName := FormName;

  LoadStoredProc.ParamByName('FormName').Value := FormName;

  StringStream.Clear;
  MemoryStream.Clear;
  StringStream.WriteString(gfStrXmlToStr(LoadStoredProc.Execute));
  if StringStream.Size = 0 then
     raise Exception.Create('Форма "' + FormName + '" не загружена из базы данных');
  StringStream.Position := 0;
  // Преобразовать текст в бинарные данные
  ObjectTextToBinary(StringStream, MemoryStream);
  // Вернуть смещение
  MemoryStream.Position := 0;
  // Прочитать компонент из потока
  MemoryStream.ReadComponent(Result);
end;

function TdsdFormStorage.LoadReport(ReportName: String): TStream;
begin
  LoadStoredProc.ParamByName('FormName').Value := ReportName;
  StringStream.Clear;
  StringStream.WriteString(gfStrXmlToStr((LoadStoredProc.Execute)));
  if StringStream.Size = 0 then
     raise Exception.Create('Форма "' + ReportName + '" не загружена из базы данных');
  StringStream.Position := 0;

  result := StringStream
end;

function TdsdFormStorage.LoadUserFormSettings(FormName: String): String;
begin
  LoadUserFormSettingsStoredProc.ParamByName('inFormName').Value := FormName;
  Result := LoadUserFormSettingsStoredProc.Execute;
end;

function TdsdFormStorage.StringToXML(S: String): String;
begin
  // Оборачиваем символы #13 и #10
  XMLDocument.LoadFromXML('<xml Data="' + gfStrToXmlStr(S) + ' "/>');
  XMLDocument.SaveToXML(Result);
  Result := gfStrToXmlStr(copy(Result, 12, length(Result) - 16))
end;

procedure TdsdFormStorage.Save(Form: TComponent);
begin
  MemoryStream.Clear;
  MemoryStream.WriteComponent(Form);
  MemoryStream.Position := 0;
  StringStream.Clear;
  ObjectBinaryToText(MemoryStream, StringStream);

  SaveToFormData(Form.ClassName);
end;

procedure TdsdFormStorage.SaveReport(Stream: TStream; ReportName: string);
begin
  StringStream.Clear;
  StringStream.LoadFromStream(Stream);
  StringStream.Position := 0;

  SaveToFormData(ReportName);
end;

procedure TdsdFormStorage.SaveToFormData(DataKey: string);
begin
  SaveStoredProc.ParamByName('FormName').Value := DataKey;
  SaveStoredProc.ParamByName('FormData').Value := StringToXML(StringStream.DataString);
  SaveStoredProc.Execute;
end;

procedure TdsdFormStorage.SaveUserFormSettings(FormName: String; Data: String);
begin
  SaveUserFormSettingsStoredProc.ParamByName('inFormName').Value := FormName;
  SaveUserFormSettingsStoredProc.ParamByName('inUserFormSettingsData').Value := ANSIToXML(Data);
  SaveUserFormSettingsStoredProc.Execute;
end;

{ TdsdFormStorageFactory }

class function TdsdFormStorageFactory.GetStorage: TdsdFormStorage;
begin
  result := TdsdFormStorage(TdsdFormStorage.NewInstance);
end;

end.
