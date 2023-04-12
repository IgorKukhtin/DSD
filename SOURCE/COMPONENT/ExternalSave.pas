unit ExternalSave;

{$I ..\dsdVer.inc}

interface

uses
  dsdAction, dsdDb, Classes, Forms, DB, ExternalData, System.Win.ComObj,
  cxGrid, cxGridDBTableView {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

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

  TExportGridToLibre = class
  private
    FFileName: string;
    FView: TcxGridDBTableView;
    FDataSet: TDataSet;
    FConnected: Boolean;
    FLibre: Variant;
    FDesktop: Variant;
    FCalc: Variant;
    FSheet: Variant;
    procedure LibreConnect;
    procedure LibreDisconnect;
    procedure CheckDesktop;
    function MakePropertyValue(APropertyName: string; APropertyValue: Variant): Variant;
    function CreateCalc: Boolean;
    procedure OpenCalc;
    procedure SaveCalc;
    procedure CloseCalc;
    procedure CheckSheet;
  public
    constructor Create(const AFileName: string; AGrid: TcxGrid);
    procedure BeforeDestruction; override;
    procedure Execute;
    property Connected: Boolean read FConnected;
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

uses
  Vcl.ActnList, Vcl.Dialogs, VKDBFDataSet, System.SysUtils, ADODB, Math, System.StrUtils,
  System.Variants;

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
      if not FSourceDataSet.FieldByName(FDataSet.Fields[i].FieldName).IsNull then
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

{ TExportGridToLibre }

procedure TExportGridToLibre.BeforeDestruction;
begin
  LibreDisconnect;
  inherited BeforeDestruction;
end;

procedure TExportGridToLibre.CheckDesktop;
begin
  if VarIsEmpty(FDesktop) or VarIsNull(FDesktop) then
    FDesktop := FLibre.createInstance('com.sun.star.frame.Desktop');
end;

procedure TExportGridToLibre.CheckSheet;
begin
  if VarIsEmpty(FSheet) or VarIsNull(FSheet) then
    FSheet := FCalc.GetSheets.getByIndex(0);
end;

procedure TExportGridToLibre.CloseCalc;
begin
  FCalc.Close(False);
end;

constructor TExportGridToLibre.Create(const AFileName: string; AGrid: TcxGrid);
var
  FilePath: string;
begin
  inherited Create;
  FilePath := ExtractFilePath(AFileName);

  if Trim(FilePath) = '' then
    FilePath := ExtractFilePath(Application.ExeName);

  FFileName := 'file:///' + AnsiReplaceText(FilePath + ExtractFileName(AFileName), '\', '/');
  FView := AGrid.ActiveView as TcxGridDBTableView;
  FDataSet := FView.DataController.DataSource.DataSet;
  FConnected := False;
  LibreConnect;
end;

function TExportGridToLibre.CreateCalc: Boolean;
var
  VariantArray: Variant;
begin
  CheckDesktop;
  VariantArray := VarArrayCreate([0, 0], varVariant);
  VariantArray[0] := MakePropertyValue('Hidden', True);
  FCalc := FDesktop.LoadComponentFromURL('private:factory/scalc', '_blank', 0, VariantArray);
  Result := not (VarIsEmpty(FCalc) or VarIsNull(FCalc));
end;

procedure TExportGridToLibre.Execute;
const
  RusBoolStrs: array[Boolean] of string = ('Нет', 'Да');
var
  Field: TField;
  BM: TBookmark;
  I, J, N: Integer;
  Cell: Variant;
begin
  if CreateCalc then
  begin
    CheckSheet;

    with FDataSet do
    begin
      DisableControls;
      BM := Bookmark;
      N := -1;

      for J := 0 to Pred(FView.ColumnCount) do
        if FView.Columns[J].Visible then
        begin
          Inc(N);
          Cell := FSheet.getCellByPosition(N, 0);
          Cell.getColumns.getByIndex(0).Width := FView.Columns[J].Width * 30;
          Cell.charWeight := 150;
          Cell.setString(FView.Columns[J].Caption);
        end;

      I := 0;
      First;

      while not Eof do
      begin
        Inc(I);
        N := -1;

        for J := 0 to Pred(FView.ColumnCount) do
          if FView.Columns[J].Visible then
          begin
            Inc(N);
            Field := FView.Columns[J].DataBinding.Field;
            Cell := FSheet.getCellByPosition(N, I);

            if Field.DataType in [ftSmallint, ftInteger, ftWord] then
              Cell.SetValue(Field.AsInteger)
            else if Field.DataType in [ftFloat, ftCurrency, ftLargeint] then
              Cell.SetValue(Field.AsFloat)
            else if Field.DataType = ftBoolean then
              Cell.SetString(RusBoolStrs[Field.AsBoolean])
            else
              Cell.SetString(Field.AsString);
          end;

        Next;
      end;

      if BookmarkValid(BM) then
        Bookmark := BM;

      EnableControls;
    end;

    SaveCalc;
    CloseCalc;
    //OpenCalc;
  end;
end;

procedure TExportGridToLibre.LibreConnect;
begin
  try
    if VarIsEmpty(FLibre) then
      FLibre := CreateOleObject('com.sun.star.ServiceManager');

    FConnected := not (VarIsEmpty(FLibre) or VarIsNull(FLibre));
  except
    on E: EOleSysError do
      FConnected := False;
  end;
end;

procedure TExportGridToLibre.LibreDisconnect;
begin
  FSheet := Unassigned;
  FCalc := Unassigned;
  FDesktop := Unassigned;
  FLibre := Unassigned;
  FConnected := False;
end;

function TExportGridToLibre.MakePropertyValue(APropertyName: string;
  APropertyValue: Variant): Variant;
begin
  Result := FLibre.Bridge_GetStruct('com.sun.star.beans.PropertyValue');
  Result.Name := APropertyName;
  Result.Value := APropertyValue;
end;

procedure TExportGridToLibre.OpenCalc;
var
  VariantArray: Variant;
begin
  CheckDesktop;
  VariantArray := VarArrayCreate([0, 0], varVariant);
  VariantArray[0] := MakePropertyValue('FilterName', 'MS Excel 97');
  FDesktop.LoadComponentFromURL(FFileName, '_blank', 0, VariantArray);
end;

procedure TExportGridToLibre.SaveCalc;
var
  VariantArray: Variant;
begin
  VariantArray := VarArrayCreate([0, 1], varVariant);
  VariantArray[0] := MakePropertyValue('FilterName', 'MS Excel 97');
  VariantArray[1] := MakePropertyValue('Overwrite', True);
  FCalc.StoreToURL(FFileName, VariantArray);
end;

initialization
  RegisterClass (TADOQueryAction);
  RegisterClass (TExternalSaveAction);

end.
