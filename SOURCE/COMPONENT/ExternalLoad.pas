unit ExternalLoad;

interface

uses dsdAction, dsdDb, Classes, DB, ExternalData, ADODB;

type

  TDataSetType = (dtDBF, dtXLS, dtMMO);

  TExternalLoad = class(TExternalData)
  protected
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  public
    property Active: boolean read FActive;
  end;

  TFileExternalLoad = class(TExternalLoad)
  private
    FInitializeDirectory: string;
    FDataSetType: TDataSetType;
    FAdoConnection: TADOConnection;
    FFileExtension: string;
    FFileFilter: string;
    FExtendedProperties: string;
    FStartRecord: integer;
  protected
    procedure First; override;
  public
    constructor Create(DataSetType: TDataSetType = dtDBF; StartRecord: integer = 1; ExtendedProperties: string = '');
    destructor Destroy; override;
    procedure Open(FileName: string);
    procedure Activate; override;
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TExternalLoadAction = class(TdsdCustomAction)
  private
    FInitializeDirectory: string;
    FFileName: string;
  protected
    function GetStoredProc: TdsdStoredProc; virtual; abstract;
    function GetExternalLoad: TExternalLoad; virtual; abstract;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); virtual; abstract;
  public
    property FileName: string read FFileName write FFileName;
    constructor Create(Owner: TComponent); override;
    function Execute: boolean; override;
  published
    // Директория загрузки. Сделана published что бы сохранять данные по стандартной схеме
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TImportSettingsItems = class (TCollectionItem)
  public
    ItemName: string;
    Param: TdsdParam;
  end;

  TImportSettings = class (TCollection)
  public
    JuridicalId: Integer;
    ContractId: Integer;
    FileType: TDataSetType;
    StoredProc: TdsdStoredProc;
    StartRow: integer;
    Directory: string;
    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;
  end;

  TImportSettingsFactory = class
  private
    function CreateImportSettings(Id: integer): TImportSettings;
  public
    class function GetImportSettings(Id: integer): TImportSettings;
  end;

  TExecuteProcedureFromFile = class
  private
    FExternalLoad: TFileExternalLoad;
    FImportSettings: TImportSettings;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AImportSettings: TImportSettings);
  public
    constructor Create(FileType: TDataSetType; FileName: string; ImportSettings: TImportSettings);
    procedure Load;
  end;

  TExecuteImportSettings = class
    procedure Execute(ImportSettings: TImportSettings);
  end;

implementation

uses SysUtils, Dialogs, SimpleGauge, VKDBFDataSet, UnilWin, DBClient;

function GetFileType(FileTypeName: string): TDataSetType;
begin
  if FileTypeName = '' then
     result := dtDBF
  else
    if FileTypeName = '' then
       result := dtXLS
    else
      if FileTypeName = '' then
         result := dtMMO
      else
        raise Exception.Create('Тип файла "' + FileTypeName + '" не определен в программе');
end;

{ TFileExternalLoad }

procedure TFileExternalLoad.Activate;
begin
  with {File}TOpenDialog.Create(nil) do
  try
    InitialDir := InitializeDirectory;
    DefaultExt := FFileExtension;
    Filter := FFileFilter;
    if Execute then begin
       InitializeDirectory := ExtractFilePath(FileName);
       Self.Open(FileName);
    end;
  finally
    Free;
  end;
end;

constructor TExternalLoadAction.Create(Owner: TComponent);
begin
  FileName := '';
  inherited;
end;

function TExternalLoadAction.Execute: boolean;
var
   FExternalLoad: TFileExternalLoad;
   FStoredProc: TdsdStoredProc;
begin
  result := false;
  FExternalLoad := TFileExternalLoad(GetExternalLoad);
  try
    FExternalLoad.InitializeDirectory := InitializeDirectory;
    if FileName <> '' then
       FExternalLoad.Open(FileName)
    else
       FExternalLoad.Activate;
    if FExternalLoad.Active then begin
       InitializeDirectory := FExternalLoad.InitializeDirectory;
       FStoredProc := GetStoredProc;
       try
         if  FExternalLoad.RecordCount > 0 then
             with TGaugeFactory.GetGauge('Загрузка данных', 1, FExternalLoad.RecordCount) do begin
               Start;
               try
                 while not FExternalLoad.EOF do begin
                   ProcessingOneRow(FExternalLoad, FStoredProc);
                   IncProgress;
                   FExternalLoad.Next;
                 end;
               finally
                 Finish
               end;
               result := true
             end;
       finally
         FStoredProc.Free
       end;
    end;
  finally
    FExternalLoad.Free;
  end;
end;

constructor TFileExternalLoad.Create(DataSetType: TDataSetType; StartRecord: integer; ExtendedProperties: string);
begin
  inherited Create;
  FOEM := true;
  FDataSetType := DataSetType;
  FExtendedProperties := ExtendedProperties;
  FStartRecord := StartRecord;
  case FDataSetType of
    dtDBF: begin
             FFileExtension := '*.dbf';
             FFileFilter := 'Файлы DBF (*.dbf)|*.dbf|';
           end;
    dtXLS: begin
             FFileExtension := '*.xls';
             FFileFilter := 'Файлы выгрузки Excel|*.xls;*.xlsx|';
           end;
  end;
end;

destructor TFileExternalLoad.Destroy;
begin
  if Assigned(FDataSet) then
     FreeAndNil(FDataSet);
  if Assigned(FAdoConnection) then
     FreeAndNil(FAdoConnection);
  inherited;
end;

procedure TFileExternalLoad.First;
begin
  inherited;
  FDataSet.First
end;

procedure TFileExternalLoad.Open(FileName: string);
var strConn :  widestring;
    List: TStringList;
begin
  case FDataSetType of
    dtDBF: begin
        FDataSet := TVKSmartDBF.Create(nil);
        TVKSmartDBF(FDataSet).DBFFileName := FileName;
        TVKSmartDBF(FDataSet).OEM := FOEM;
        try
          FDataSet.Open;
        except
          on E: Exception do begin
             if Pos('TVKSmartDBF.InternalOpen: Open error', E.Message) > -1 then
                raise Exception.Create('Файл' + copy (E.Message, length('TVKSmartDBF.InternalOpen: Open error') + 1, MaxInt) + ' открыт другой программой. Закройте ее и попробуйте еще раз!')
             else
                raise Exception.Create(E.Message);
          end;
        end;
    end;
    dtXLS: begin
      strConn:='Provider=Microsoft.Jet.OLEDB.4.0;' +
               'Data Source=' + FileName + ';' +
               'Extended Properties=Excel 8.0' + FExtendedProperties + ';';
      if not Assigned(FAdoConnection) then begin
         FAdoConnection := TAdoConnection.Create(nil);
         FAdoConnection.LoginPrompt := false;
         FDataSet := TADOQuery.Create(nil);
         TADOQuery(FDataSet).Connection := FAdoConnection;
      end;
      FAdoConnection.Connected := False;
      FAdoConnection.ConnectionString := strConn;
      FAdoConnection.Open;
      List := TStringList.Create;
      try
        FAdoConnection.GetTableNames(List, True);
        TADOQuery(FDataSet).ParamCheck := false;
        TADOQuery(FDataSet).SQL.Text := 'SELECT * FROM [' + List[0]  + 'A' + IntToStr(FStartRecord)+ ':Z65000]';
        TADOQuery(FDataSet).Open;
      finally
        FreeAndNil(List);
      end;
    end;
  end;
  First;
  FActive := FDataSet.Active;
end;

{ TExecuteProcedureFromFile }

constructor TExecuteProcedureFromFile.Create(FileType: TDataSetType; FileName: string; ImportSettings: TImportSettings);
begin
  FImportSettings := ImportSettings;
  FExternalLoad := TFileExternalLoad.Create(FileType, ImportSettings.StartRow);
  FExternalLoad.Open(FileName);
end;

procedure TExecuteProcedureFromFile.Load;
begin
  with TGaugeFactory.GetGauge('Загрузка данных', 1, FExternalLoad.RecordCount) do begin
    Start;
    try
      while not FExternalLoad.EOF do begin
        ProcessingOneRow(FExternalLoad, FImportSettings);
        IncProgress;
        FExternalLoad.Next;
      end;
    finally
     Finish
    end;
  end;
end;

procedure TExecuteProcedureFromFile.ProcessingOneRow(AExternalLoad: TExternalLoad;
  AImportSettings: TImportSettings);
var i: integer;
begin
  with AImportSettings do begin
    for i := 0 to Count - 1 do
        TImportSettingsItems(Items[i]).Param.Value := AExternalLoad.FDataSet.FieldByName(TImportSettingsItems(Items[i]).ItemName).Value;
    StoredProc.Execute;
  end;
end;

{ TExecuteImportSettings }

procedure TExecuteImportSettings.Execute(ImportSettings: TImportSettings);
var iFilesCount: Integer;
    saFound: TStrings;
    i: integer;
begin
  saFound := TStringList.Create;
  try
    if ImportSettings.FileType = dtXLS then
       FilesInDir('*.xls', ImportSettings.Directory, iFilesCount, saFound);
    TStringList(saFound).Sort;
    for I := 0 to saFound.Count - 1 do
        with TExecuteProcedureFromFile.Create(ImportSettings.FileType, saFound[i], ImportSettings) do
          try
            Load;
          finally
            Free;
          end;
  finally
    saFound.Free
  end;

end;

{ TImportSettings }

constructor TImportSettings.Create(ItemClass: TCollectionItemClass);
begin
  inherited;
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.OutputType := otResult;
end;

destructor TImportSettings.Destroy;
begin
  FreeAndNil(StoredProc);
  inherited;
end;

{ TImportSettingsFactory }

function TImportSettingsFactory.CreateImportSettings(
  Id: integer): TImportSettings;
var
  GetStoredProc: TdsdStoredProc;
  DataSet: TDataSet;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  GetStoredProc.OutputType := otResult;
  GetStoredProc.StoredProcName := 'gpGet_Object_ImportSettings';
  GetStoredProc.Params.AddParam('inId', ftInteger, ptInput, Id);
  GetStoredProc.Execute;
  {Заполняем параметрами процедуру}
  Result := TImportSettings.Create(TImportSettingsItems);
  Result.StartRow := GetStoredProc.Params.ParamByName('StartRow').Value;
  Result.Directory := GetStoredProc.Params.ParamByName('Directory').Value;
  Result.FileType := GetFileType(GetStoredProc.Params.ParamByName('FileTypeName').Value);
  Result.JuridicalId := GetStoredProc.Params.ParamByName('JuridicalId').Value;
  Result.ContractId := GetStoredProc.Params.ParamByName('ContractId').Value;

  Result.StoredProc := TdsdStoredProc.Create(nil);
  Result.StoredProc.StoredProcName := GetStoredProc.Params.ParamByName('ImportTypeName').Value;

  {Заполняем параметрами параметры процедуры}
  GetStoredProc.StoredProcName := 'gpSelect_Object_ImportSettingsItems';
  GetStoredProc.Params.AddParam('inId', ftInteger, ptInput, Id);
  GetStoredProc.OutputType := otDataSet;
  GetStoredProc.DataSet := TClientDataSet.Create(nil);
  GetStoredProc.Execute;

end;

class function TImportSettingsFactory.GetImportSettings(
  Id: integer): TImportSettings;
begin

end;

end.
