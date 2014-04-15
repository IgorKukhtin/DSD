unit FormStorage;

interface

uses
  Classes, Forms, dsdDB, Xml.XMLDoc, ParentForm, UnilWin;

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
    LoadProgramProc: TdsdStoredProc;
    LoadProgramVersionProc: TdsdStoredProc;
    SaveUserFormSettingsStoredProc: TdsdStoredProc;
    LoadUserFormSettingsStoredProc: TdsdStoredProc;
    function StringToXML(S: String): String;
    procedure SaveToFormData(DataKey: string);
  public
    function LoadFile(FileName: string): AnsiString;
    function LoadFileVersion(FileName: string): TVersionInfo;
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
  function ANSIToXMLFile(S: String): String;
  function XMLToAnsi(S: String): String;

  // Процедура по символьно переводит строку в набор цифр
function ReConvertConvert(S: Ansistring): AnsiString;
// Процедура по символьно переводит строку в набор цифр
function ConvertConvert(S: RawByteString): String;

implementation

uses UtilConvert, DB, SysUtils, ZLibEx, Dialogs, dsdAddOn;

// Процедура по символьно переводит строку в набор цифр
function ConvertConvert(S: RawByteString): String;
var i: integer;
begin
  result := '';
  for I := 1 to Length(S) do
      result := result + IntToHex(byte(s[i]),2);
end;

  // Процедура по символьно переводит строку в набор цифр
function ReConvertConvert(S: Ansistring): AnsiString;
var i: integer;
begin
  i := 1;
  result := '';
  while i <= Length(S) do begin
    result := result + Ansichar(StrToInt('$' + s[i] + s[i+1]));
    i := i + 2;
  end;
end;



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

function ANSIToXMLFile(S: String): String;
var i: integer;
begin
  result := '';
  for I := 1 to Length(S) do
      result := result + '999999999';//'&amp;#' + IntToHex(byte(s[i]),2) + ';'
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

    Instance.LoadProgramProc := TdsdStoredProc.Create(nil);
    Instance.LoadProgramProc.StoredProcName := 'gpGet_Object_Program';
    Instance.LoadProgramProc.OutputType := otBlob;
    Instance.LoadProgramProc.Params.AddParam('inProgramName', ftString, ptInput, '');

    Instance.LoadProgramVersionProc := TdsdStoredProc.Create(nil);
    Instance.LoadProgramVersionProc.StoredProcName := 'gpGet_Object_ProgramVersion';
    Instance.LoadProgramVersionProc.OutputType := otResult;
    Instance.LoadProgramVersionProc.Params.AddParam('inProgramName', ftString, ptInput, '');
    Instance.LoadProgramVersionProc.Params.AddParam('outMajorVersion', ftInteger, ptOutput, 0);
    Instance.LoadProgramVersionProc.Params.AddParam('outMinorVersion', ftInteger, ptOutput, 0);

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
var i: integer;
begin
  if (FormName = 'NULL') or (FormName = '') then
     raise Exception.Create('Не передано название формы');
  // Пытаемся найти среди открытых
  for i := 0 to Screen.FormCount - 1 do begin
     if Screen.Forms[i] is TParentForm then
        with TParentForm(Screen.Forms[i]) do begin
          if FormClassName = FormName then begin
             if AddOnFormData.isSingle or (not Visible) then
                result := TParentForm(Screen.Forms[i])
             else begin
               Result := TParentForm.Create(Application);
               Result.FormClassName := FormName;
               try
                 MemoryStream.WriteComponent(Screen.Forms[i]);
                 MemoryStream.Position := 0;
                 MemoryStream.ReadComponent(Result);
               finally
                 MemoryStream.Clear;
               end;
             end;
             exit;
          end;
        end;
  end;
  LoadStoredProc.ParamByName('FormName').Value := FormName;
  try
    StringStream.WriteString(gfStrXmlToStr(LoadStoredProc.Execute));
    // ПОКА ОСТАВЛЯЕМ ПО СТАРОМУ!!!
    //StringStream.WriteString(ReConvertConvert(LoadStoredProc.Execute));
    if StringStream.Size = 0 then
       raise Exception.Create('Форма "' + FormName + '" не загружена из базы данных');
    StringStream.Position := 0;
    // Преобразовать текст в бинарные данные
    ObjectTextToBinary(StringStream, MemoryStream);
    // Вернуть смещение
    MemoryStream.Position := 0;

    // Создаем форму
    Application.CreateForm(TParentForm, Result);
    Result.FormClassName := FormName;

    // Прочитать компонент из потока
    MemoryStream.ReadComponent(Result);
    // Загрузить пользователские дефотлы!!!
    for i := 0 to Result.ComponentCount - 1 do
      if Result.Components[i] is TdsdUserSettingsStorageAddOn then
         try
            TdsdUserSettingsStorageAddOn(Result.Components[i]).LoadUserSettings;
         except

         end;
  finally
    StringStream.Clear;
    MemoryStream.Clear;
  end;
end;

function TdsdFormStorage.LoadFile(FileName: string): AnsiString;
begin
  LoadProgramProc.ParamByName('inProgramName').Value := FileName;
  result := ZDeCompressStr(ReConvertConvert(LoadProgramProc.Execute));
end;

function TdsdFormStorage.LoadFileVersion(FileName: string): TVersionInfo;
begin
  LoadProgramVersionProc.ParamByName('inProgramName').Value := FileName;
  LoadProgramVersionProc.Execute;
  result.VerHigh := StrToInt(LoadProgramVersionProc.ParamByName('outMajorVersion').asString);
  result.VerLow := StrToInt(LoadProgramVersionProc.ParamByName('outMinorVersion').asString);
end;

function TdsdFormStorage.LoadReport(ReportName: String): TStream;
begin
  LoadStoredProc.ParamByName('FormName').Value := ReportName;
  StringStream.Clear;
  StringStream.WriteString(StringReplace(LoadStoredProc.Execute, '&#98;',char(StrToInt('$98')), [rfReplaceAll]));
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

  SaveStoredProc.ParamByName('FormName').Value := ReportName;
  SaveStoredProc.ParamByName('FormData').Value := AnsiToXML(StringStream.DataString);
  SaveStoredProc.Execute;
end;

procedure TdsdFormStorage.SaveToFormData(DataKey: string);
begin
  SaveStoredProc.ParamByName('FormName').Value := DataKey;
    // ПОКА ОСТАВЛЯЕМ ПО СТАРОМУ!!! ConvertConvert(StringStream.DataString);//
  SaveStoredProc.ParamByName('FormData').Value := StringToXML(StringStream.DataString);
  SaveStoredProc.Execute;
end;

procedure TdsdFormStorage.SaveUserFormSettings(FormName: String; Data: String);
begin
  SaveUserFormSettingsStoredProc.ParamByName('inFormName').Value := FormName;
  SaveUserFormSettingsStoredProc.ParamByName('inUserFormSettingsData').Value := Data;
  //SaveUserFormSettingsStoredProc.ParamByName('inUserFormSettingsData').Value := ANSIToXML(Data);
  SaveUserFormSettingsStoredProc.Execute;
end;

{ TdsdFormStorageFactory }

class function TdsdFormStorageFactory.GetStorage: TdsdFormStorage;
begin
  result := TdsdFormStorage(TdsdFormStorage.NewInstance);
end;

end.
