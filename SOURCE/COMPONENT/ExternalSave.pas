unit ExternalSave;

interface

uses dsdAction, dsdDb, Classes, DB, ExternalData;

type

  TExternalSave = class(TExternalData)
  public
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  TFileExternalSave = class(TExternalSave)
  private
    FInitializeFile: string;
    FFieldDefs: TFieldDefs;
    FSourceDataSet: TDataSet;
    FFileName: string;
  public
    constructor Create(AFieldDefs: TFieldDefs; ASourceDataSet: TDataSet; AFileName: string; AisOEM: boolean = true);
    function Execute(var AFileName: string): boolean;
    procedure Open(FileName: string; CreateFile: boolean);
    property InitializeFile: string read FInitializeFile write FInitializeFile;
  end;

  TExternalSaveAction = class(TdsdCustomAction)
  private
    FInitializeDirectory: string;
    FFileName: TdsdParam;
    FFileDataSet: TDataSet;
    FDataSet: TDataSet;
    FisOEM: boolean;
    FOpenFileDialog: boolean;
    function GetFieldDefs: TFieldDefs;
    procedure SetFieldDefs(const Value: TFieldDefs);
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean; override;
  published
    // Директория загрузки. Сделана published что бы сохранять данные по стандартной схеме
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
    property FieldDefs: TFieldDefs read GetFieldDefs write SetFieldDefs;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property isOEM: boolean read FisOEM write FisOEM default true;
    // Открывать ли диалог выбора файла
    property OpenFileDialog: boolean read FOpenFileDialog write FOpenFileDialog;
    // Файл для сохранения
    property FileName: TdsdParam read FFileName write FFileName;
  end;

  TADOQueryAction = class (TdsdCustomAction)
  private
    FConnectionString: string;
    FQueryText: string;
  protected
    function LocalExecute: Boolean; override;
  published
    property ConnectionString: string read FConnectionString write FConnectionString;
    property QueryText: string read FQueryText write FQueryText;
  end;

  procedure Register;

implementation

uses VCL.ActnList, Dialogs, VKDBFDataSet, SysUtils, ADODB, Math;

procedure Register;
begin
  RegisterActions('dsdImportExport', [TExternalSaveAction], TExternalSaveAction);
  RegisterActions('dsdImportExport', [TADOQueryAction], TADOQueryAction);
end;

{ TFileExternalSave }

constructor TFileExternalSave.Create(AFieldDefs: TFieldDefs; ASourceDataSet: TDataSet; AFileName: string; AisOEM: boolean = true);
begin
  inherited Create;
  FFieldDefs := AFieldDefs;
  if FFieldDefs.Count = 0 then
     FFieldDefs.Assign(ASourceDataSet.FieldDefs);
  FSourceDataSet := ASourceDataSet;
  Self.FOEM := AisOEM;
  FFileName := AFileName;
end;

function TFileExternalSave.Execute(var AFileName: string): boolean;
var i: integer;
    CreateFile: boolean;
begin
  result := false;
  CreateFile := false;
  if FFileName = '' then
     with TOpenDialog.Create(nil) do
     try
       CreateFile := true;
       FileName := InitializeFile;
       DefaultExt := '*.dbf';
       Filter := 'Файлы выгрузки в 1С (.dbf)|*.dbf|';
       if Execute then begin
          AFileName := FileName;
          FFileName := FileName;
          InitializeFile := FileName;
       end;
     finally
       Free;
     end
  else
    AFileName := FFileName;

  Self.Open(FFileName, CreateFile);
  FSourceDataSet.First;
  while not FSourceDataSet.Eof do begin
    FDataSet.Append;
    for I := 0 to FDataSet.FieldCount - 1 do
        FDataSet.Fields[i].Value := FSourceDataSet.FieldByName(FDataSet.Fields[i].FieldName).Value;
    FDataSet.Post;
    FSourceDataSet.Next;
  end;
  FDataSet.Close;
  result := true;
end;

procedure TFileExternalSave.Open(FileName: string; CreateFile: boolean);
var i: integer;
begin
  FDataSet := TVKSmartDBF.Create(nil);
  TVKSmartDBF(FDataSet).DBFFileName := FileName;
  TVKSmartDBF(FDataSet).OEM := FOEM;
  TVKSmartDBF(FDataSet).AccessMode.OpenReadWrite := true;
  if CreateFile or (not FileExists(FileName)) then begin
     if FileExists(FileName) then
        DeleteFile(FileName);
     for I := 0 to FFieldDefs.Count - 1 do begin
       with TVKSmartDBF(FDataSet).DBFFieldDefs.Add as TVKDBFFieldDef do begin
          Name := FFieldDefs[i].Name;
          case FFieldDefs[i].DataType of
            ftString: begin
              field_type := 'C';
              len :=  min(FFieldDefs[i].Size, 254);
            end;
            ftInteger: begin
              field_type := 'N';
              len := 10;
            end;
            ftBCD: begin
              field_type := 'N';
              len := FFieldDefs[i].Size;
              dec := FFieldDefs[i].Precision;
            end;
            ftFloat: begin
              field_type := 'N';
              len := 10;
              dec := 4;
            end;
            ftDate: field_type := 'D';
          end;
       end;
     end;
     TVKSmartDBF(FDataSet).CreateTable;
  end;
  FDataSet.Open;
  FActive := FDataSet.Active;
end;

{ TExternalSaveAction }

constructor TExternalSaveAction.Create(Owner: TComponent);
begin
  inherited;
  FFileDataSet := TVKSmartDBF.Create(Self);
  FileName := TdsdParam.Create(nil);
  isOEM := true;
end;

destructor TExternalSaveAction.Destroy;
begin
  FreeAndNil(FFileDataSet);
  FreeAndNil(FFileName);
  inherited;
end;

function TExternalSaveAction.Execute: boolean;
var lFileName: string;
begin
  with TFileExternalSave.Create(FFileDataSet.FieldDefs, DataSet, FileName.AsString, isOEM) do begin
    try
      result := Execute(lFileName);
      FileName.Value:= lFileName;
    finally
      Free
    end;
  end;
end;

function TExternalSaveAction.GetFieldDefs: TFieldDefs;
begin
  result := FFileDataSet.FieldDefs;
end;

procedure TExternalSaveAction.SetFieldDefs(const Value: TFieldDefs);
begin
  FFileDataSet.FieldDefs.Assign(Value);
end;

{ TADOQueryAction }

function TADOQueryAction.LocalExecute: Boolean;
var Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.ConnectionString := Self.ConnectionString;
    Query.SQL.Text := QueryText;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
  result := true;
end;

end.
