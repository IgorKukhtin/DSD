unit ExternalSave;

interface

uses dsdAction, dsdDb, Classes, DB, MemDBFTable, ExternalData;

type

  TExternalSave = class(TExternalData)
  public
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  TFileExternalSave = class(TExternalSave)
  private
    FInitializeFile: string;
    FFileDataSet: TMemDBFTable;
    FFieldDefs: TFieldDefs;
    FSourceDataSet: TDataSet;
    procedure CreateFieldList;
  public
    constructor Create(AFieldDefs: TFieldDefs; ASourceDataSet: TDataSet);
    function Execute: boolean;
    procedure Open(FileName: string);
    property InitializeFile: string read FInitializeFile write FInitializeFile;
  end;

  TExternalSaveAction = class(TdsdCustomAction)
  private
    FInitializeDirectory: string;
    FFileName: string;
    FFileDataSet: TMemDBFTable;
    FDataSet: TDataSet;
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
  end;

  procedure Register;

implementation

uses VCL.ActnList, Dialogs;

procedure Register;
begin
  RegisterActions('DSDLib', [TExternalSaveAction], TExternalSaveAction);
end;

{ TFileExternalSave }

constructor TFileExternalSave.Create;
begin
  inherited Create;
  FFieldDefs := AFieldDefs;
  FSourceDataSet := ASourceDataSet;
  Self.FOEM := true;
end;

procedure TFileExternalSave.CreateFieldList;
begin

end;

function TFileExternalSave.Execute: boolean;
var i: integer;
begin
  result := false;
  with TOpenDialog.Create(nil) do
  try
    FileName := InitializeFile;
    DefaultExt := '*.dbf';
    Filter := '*.dbf';
    if Execute then begin
       InitializeFile := FileName;
       Self.Open(FileName);
       FSourceDataSet.First;
       while not FSourceDataSet.Eof do begin
         FDataSet.Append;
         for I := 0 to FDataSet.FieldCount - 1 do
             FDataSet.Fields[i].Value := FSourceDataSet.FieldByName(FDataSet.Fields[i].FieldName).Value;
         FDataSet.Post;

         FSourceDataSet.Next;
       end;
       TMemDBFTable(FDataSet).Save;
       result := true;
    end;
  finally
    Free;
  end;
end;

procedure TFileExternalSave.Open(FileName: string);
begin
  FDataSet := TMemDBFTable.Create(nil);
  TMemDBFTable(FDataSet).FieldDefs.Assign(FFieldDefs);
  TMemDBFTable(FDataSet).FileName := FileName;
  TMemDBFTable(FDataSet).OEM := FOEM;
  TMemDBFTable(FDataSet).CreateTable;
  FDataSet.Open;
  FActive := FDataSet.Active;
end;

{ TExternalSaveAction }

constructor TExternalSaveAction.Create(Owner: TComponent);
begin
  inherited;
  FFileDataSet := TMemDBFTable.Create(Self);
end;

destructor TExternalSaveAction.Destroy;
begin

  inherited;
end;

function TExternalSaveAction.Execute: boolean;
begin
  with TFileExternalSave.Create(FFileDataSet.FieldDefs, DataSet) do begin
    try
      result := Execute
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

end.
