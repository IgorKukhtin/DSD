unit FormStorage;

interface

uses
  Classes, Forms, dsdDB, Xml.XMLDoc, ParentForm, UnilWin, UtilConst,
  StorageSQLite, Datasnap.DBClient;

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
//    SavePartsStoredProc: TdsdStoredProc;
    LoadStoredProc: TdsdStoredProc;
    LoadProgramProc: TdsdStoredProc;
    LoadProgramVersionProc: TdsdStoredProc;
    SaveUserFormSettingsStoredProc: TdsdStoredProc;
    LoadUserFormSettingsStoredProc: TdsdStoredProc;
//    function StringToXML(S: String): String;
    procedure SaveToFormData(DataKey: string);
  public
    function LoadFile(FileName: string; Suffics : String): AnsiString;
    function LoadFileVersion(FileName: string; Suffics : String): TVersionInfo;
    function LoadFileNoConnect(FileName: string; Suffics : String): AnsiString;
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
  // Процедура по символьно переводит строку в набор цифр
  function ReConvertConvert(S: AnsiString): AnsiString;
  // Процедура по символьно переводит строку в набор цифр
  function ConvertConvert(S: String): String;

implementation

uses UtilConvert, DB, SysUtils, ZLibEx, Dialogs, dsdAddOn, CommonData, Storage;

// Процедура по символьно переводит строку в набор цифр
function ConvertConvert(S: String): String;
var i, l: integer;
    ArcS: Ansistring;
begin
  ArcS := ZCompressStr(S);
  result := '';
  l := Length(ArcS); // чтобы каждый не вычислять в цикле
  for I := 1 to l do
    result := result + IntToHex(byte(ArcS[i]),2);
end;

  // Процедура по символьно переводит строку в набор цифр
function ReConvertConvert(S: Ansistring): AnsiString;
var i, l: integer;
begin
  i := 1;
  result := '';
  l := Length(S); // чтобы каждый не вычислять в цикле
  while i <= l do begin
    result := result + Ansichar(StrToInt('$' + s[i] + s[i+1]));
    i := i + 2;
  end;
  result := ZDecompressStr(result)
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

//    Instance.SavePartsStoredProc := TdsdStoredProc.Create(nil);
//    Instance.SavePartsStoredProc.StoredProcName := 'gpInsertUpdate_Object_FormParts';
//    Instance.SavePartsStoredProc.OutputType := otResult;
//    Instance.SavePartsStoredProc.Params.AddParam('FormName', ftString, ptInput, '');
//    Instance.SavePartsStoredProc.Params.AddParam('FormData', ftBlob, ptInput, '');

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
//  SavePartsStoredProc.Free;
  LoadStoredProc.Free;
  SaveUserFormSettingsStoredProc.Free;
  LoadUserFormSettingsStoredProc.Free;
end;

function TdsdFormStorage.Load(FormName: String): TParentForm;
var i,j: integer;
    FormStr: string;
    AttemptCount: integer;
    isNewLoad: Boolean;
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

               // Ищем кроссы и если есть то форму грузим заново
               isNewLoad := False;
               for j := 0 to Screen.Forms[i].ComponentCount - 1 do
                 if (Screen.Forms[i].Components[j] is TCrossDBViewAddOn) or
                    (Screen.Forms[i].Components[j] is TCrossDBViewReportAddOn) or
                    (Screen.Forms[i].Components[j] is TClientDataSet) and not (TClientDataSet(Screen.Forms[i].Components[j]).State in [dsInactive, dsBrowse])  then
                 begin
                    isNewLoad := True;
                    Break;
                 end;
               if isNewLoad then Break;

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
  for AttemptCount := 1 to 3 do
  try
    try
      // Создаем форму
      Application.CreateForm(TParentForm, Result);
      Result.FormClassName := FormName;
      if gc_User.Local and (SQLiteFile <> '') then
        FormStr := ReConvertConvert(LoadSQLiteFormData(FormName, 'FormData', gc_User.Session))
      else FormStr := ReConvertConvert(LoadStoredProc.Execute);
      StringStream.WriteString(FormStr);
      if StringStream.Size = 0 then
         raise Exception.Create('Форма "' + FormName + '" не загружена из базы данных');
      StringStream.Position := 0;
      // Преобразовать текст в бинарные данные
      ObjectTextToBinary(StringStream, MemoryStream);
      // Вернуть смещение
      MemoryStream.Position := 0;
      // Прочитать компонент из потока
      MemoryStream.ReadComponent(Result);
      if not SameText(gc_User.Login, '') then
        if (gc_ProgramName = 'Farmacy.exe') or (gc_ProgramName = 'FarmacyCash.exe') then
           //Result.Caption := Result.Caption + ' - Пользователь: ' + gc_User.Login;
           Result.Caption := Result.Caption + ' <' + gc_User.Login + '>';
      break;
    finally
      StringStream.Clear;
      MemoryStream.Clear;
    end;
    break;
  except
    on E: Exception do begin
      FreeAndNil(Result);
      if AttemptCount > 2 then
         raise Exception.Create(FormName + ' TdsdFormStorage.Load ' + E.Message);
    end;
  end;
// Загрузить пользователские дефолты!!!
  for i := 0 to Result.ComponentCount - 1 do
      if Result.Components[i] is TdsdUserSettingsStorageAddOn then
         TdsdUserSettingsStorageAddOn(Result.Components[i]).LoadUserSettings;
end;

function TdsdFormStorage.LoadFile(FileName: string; Suffics : String): AnsiString;
begin
  LoadProgramProc.ParamByName('inProgramName').Value := FileName + Suffics;
  result := ReConvertConvert(LoadProgramProc.Execute);
end;

function TdsdFormStorage.LoadFileVersion(FileName: string; Suffics : String): TVersionInfo;
begin
  LoadProgramVersionProc.ParamByName('inProgramName').Value := FileName + Suffics;
  LoadProgramVersionProc.Execute;
  result.VerHigh := StrToInt(LoadProgramVersionProc.ParamByName('outMajorVersion').asString);
  result.VerLow := StrToInt(LoadProgramVersionProc.ParamByName('outMinorVersion').asString);
end;

function TdsdFormStorage.LoadFileNoConnect(FileName: string; Suffics : String): AnsiString;
var pXML, S : String;
begin
  result := '';
  {создаем XML вызова процедуры на сервере}
  pXML :=
    '<xml Session = "" >' +
      '<gpGet_Object_Program OutputType="otBlob">' +
      '<inProgramName    DataType="ftString" Value="' + gc_ProgramName + '" />' +
      '</gpGet_Object_Program>' +
    '</xml>';

  S := TStorageFactory.GetStorage.ExecuteProc(pXML, False, 4, False);
  //
  if S <> '' then
  begin
    result := ReConvertConvert(S);
  end;
end;

function TdsdFormStorage.LoadReport(ReportName: String): TStream;
begin
  if ReportName = '' then
     raise Exception.Create('Для печатной формы не установлено название');
  LoadStoredProc.ParamByName('FormName').Value := ReportName;
  StringStream.Clear;
  StringStream.WriteString( ReConvertConvert(LoadStoredProc.Execute));
  if StringStream.Size = 0 then
     raise Exception.Create('Форма "' + ReportName + '" не загружена из базы данных');
  StringStream.Position := 0;

  result := StringStream
end;

function TdsdFormStorage.LoadUserFormSettings(FormName: String): String;
begin
  LoadUserFormSettingsStoredProc.ParamByName('inFormName').Value := FormName;
  if gc_User.Local and (SQLiteFile <> '') then
  begin
    Result := LoadSQLiteFormData(FormName, 'FormSettings', gc_User.Session)
  end else if not gc_User.Local then
    Result := LoadUserFormSettingsStoredProc.Execute
  else Result := '';
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

  if (GetFilePlatfotm64(ParamStr(0))) and (Pos(AnsiUpperCase('Project'),AnsiUpperCase(gc_ProgramName)) > 0)
  then
     raise Exception.Create('Ошибка.Нет прав в 64-bit сохранить отчет <'+ReportName+'>');

  SaveStoredProc.ParamByName('FormName').Value := ReportName;
  SaveStoredProc.ParamByName('FormData').Value := ConvertConvert(StringStream.DataString);
  SaveStoredProc.Execute;
end;

procedure TdsdFormStorage.SaveToFormData(DataKey: string);
//  var s : String;  i : Integer;
begin
//  if (dsdProject = prBoat) and (Length(StringStream.DataString) > 80000) then
//  begin
//    s := ConvertConvert(StringStream.DataString);
//
//    SaveStoredProc.ParamByName('FormName').Value := DataKey;
//    SaveStoredProc.ParamByName('FormData').Value := Copy(S, 1, 15000);
//    SaveStoredProc.Execute;
//
//    i := 15001;
//    while Copy(S, i, 15000) <> '' do
//    begin
//      SavePartsStoredProc.ParamByName('FormName').Value := DataKey;
//      SavePartsStoredProc.ParamByName('FormData').Value := Copy(S, i, 15000);
//      SavePartsStoredProc.Execute;
//      Inc(i, 15000);
//    end;
//  end else
  begin
    SaveStoredProc.ParamByName('FormName').Value := DataKey;
    SaveStoredProc.ParamByName('FormData').Value := ConvertConvert(StringStream.DataString);
    SaveStoredProc.Execute;
  end;
end;

procedure TdsdFormStorage.SaveUserFormSettings(FormName: String; Data: String);
begin
  if gc_User.Local then exit;
  SaveUserFormSettingsStoredProc.ParamByName('inFormName').Value := FormName;
  SaveUserFormSettingsStoredProc.ParamByName('inUserFormSettingsData').Value := Data;
  SaveUserFormSettingsStoredProc.Execute;
end;

{ TdsdFormStorageFactory }

class function TdsdFormStorageFactory.GetStorage: TdsdFormStorage;
begin
  result := TdsdFormStorage(TdsdFormStorage.NewInstance);
end;

end.
