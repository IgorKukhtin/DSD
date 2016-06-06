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
//    function StringToXML(S: String): String;
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
  // ��������� �� ��������� ��������� ������ � ����� ����
  function ReConvertConvert(S: AnsiString): AnsiString;
  // ��������� �� ��������� ��������� ������ � ����� ����
  function ConvertConvert(S: String): String;

implementation

uses UtilConvert, DB, SysUtils, ZLibEx, Dialogs, dsdAddOn;

// ��������� �� ��������� ��������� ������ � ����� ����
function ConvertConvert(S: String): String;
var i, l: integer;
    ArcS: Ansistring;
begin
  ArcS := ZCompressStr(S);
  result := '';
  l := Length(ArcS); // ����� ������ �� ��������� � �����
  for I := 1 to l do
    result := result + IntToHex(byte(ArcS[i]),2);
end;

  // ��������� �� ��������� ��������� ������ � ����� ����
function ReConvertConvert(S: Ansistring): AnsiString;
var i, l: integer;
begin
  i := 1;
  result := '';
  l := Length(S); // ����� ������ �� ��������� � �����
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
    FormStr: string;
    AttemptCount: integer;
begin
  if (FormName = 'NULL') or (FormName = '') then
     raise Exception.Create('�� �������� �������� �����');
  // �������� ����� ����� ��������
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
    for AttemptCount := 1 to 3 do
      try
        try
          // ������� �����
          Application.CreateForm(TParentForm, Result);
          Result.FormClassName := FormName;
          FormStr := ReConvertConvert(LoadStoredProc.Execute);
          StringStream.WriteString(FormStr);
          if StringStream.Size = 0 then
             raise Exception.Create('����� "' + FormName + '" �� ��������� �� ���� ������');
          StringStream.Position := 0;
          // ������������� ����� � �������� ������
          ObjectTextToBinary(StringStream, MemoryStream);
          // ������� ��������
          MemoryStream.Position := 0;
          // ��������� ��������� �� ������
          MemoryStream.ReadComponent(Result);
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
    // ��������� ��������������� �������!!!
      for i := 0 to Result.ComponentCount - 1 do
          if Result.Components[i] is TdsdUserSettingsStorageAddOn then
             TdsdUserSettingsStorageAddOn(Result.Components[i]).LoadUserSettings;
end;

function TdsdFormStorage.LoadFile(FileName: string): AnsiString;
begin
  LoadProgramProc.ParamByName('inProgramName').Value := FileName;
  result := ReConvertConvert(LoadProgramProc.Execute);
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
  if ReportName = '' then
     raise Exception.Create('��� �������� ����� �� ����������� ��������');
  LoadStoredProc.ParamByName('FormName').Value := ReportName;
  StringStream.Clear;
  StringStream.WriteString( ReConvertConvert(LoadStoredProc.Execute));
  if StringStream.Size = 0 then
     raise Exception.Create('����� "' + ReportName + '" �� ��������� �� ���� ������');
  StringStream.Position := 0;

  result := StringStream
end;

function TdsdFormStorage.LoadUserFormSettings(FormName: String): String;
begin
  LoadUserFormSettingsStoredProc.ParamByName('inFormName').Value := FormName;
  Result := LoadUserFormSettingsStoredProc.Execute;
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
  SaveStoredProc.ParamByName('FormData').Value := ConvertConvert(StringStream.DataString);
  SaveStoredProc.Execute;
end;

procedure TdsdFormStorage.SaveToFormData(DataKey: string);
begin
  SaveStoredProc.ParamByName('FormName').Value := DataKey;
  SaveStoredProc.ParamByName('FormData').Value := ConvertConvert(StringStream.DataString);
  SaveStoredProc.Execute;
end;

procedure TdsdFormStorage.SaveUserFormSettings(FormName: String; Data: String);
begin
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
