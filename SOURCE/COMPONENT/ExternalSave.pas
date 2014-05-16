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
    constructor Create(AFieldDefs: TFieldDefs; ASourceDataSet: TDataSet; AisOEM: boolean = true);
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
    FisOEM: boolean;
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
  end;

  procedure Register;

implementation

uses VCL.ActnList, Dialogs;

procedure Register;
begin
  RegisterActions('DSDLib', [TExternalSaveAction], TExternalSaveAction);
end;

{ TFileExternalSave }

constructor TFileExternalSave.Create(AFieldDefs: TFieldDefs; ASourceDataSet: TDataSet; AisOEM: boolean = true);
begin
  inherited Create;
  FFieldDefs := AFieldDefs;
  if FFieldDefs.Count = 0 then
     FFieldDefs.Assign(ASourceDataSet.FieldDefs);
  FSourceDataSet := ASourceDataSet;
  Self.FOEM := AisOEM;
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
    Filter := 'Файлы выгрузки в 1С (.dbf)|*.dbf|';
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
  isOEM := true;
end;

destructor TExternalSaveAction.Destroy;
begin

  inherited;
end;

function TExternalSaveAction.Execute: boolean;
begin
  with TFileExternalSave.Create(FFileDataSet.FieldDefs, DataSet, isOEM) do begin
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
