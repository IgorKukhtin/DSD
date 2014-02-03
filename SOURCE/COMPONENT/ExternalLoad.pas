unit ExternalLoad;

interface

uses dsdAction, dsdDb, Classes, DB;

type

  TExternalLoad = class
  protected
    FActive: boolean;
    FDataSet: TDataSet;
    FOEM: boolean;
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    // Установка на первую запись
    procedure First; virtual;
  public
    constructor Create; virtual;
    destructor Destroy;
    function EOF: boolean;
    function RecordCount: integer;
    procedure Next;     virtual;
    procedure Activate; virtual;
    property Active: boolean read FActive;
  end;

  TFileExternalLoad = class(TExternalLoad)
  private
    FInitializeDirectory: string;
  public
    constructor Create; override;
    procedure Open(FileName: string);
    procedure Activate; override;
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TExternalLoadAction = class(TdsdCustomAction)
  private
    FInitializeDirectory: string;
    FEndDate: TdsdParam;
    FStartDate: TdsdParam;
    FFileName: string;
  protected
    function StartDate: TDateTime;
    function EndDate: TDateTime;
    function GetStoredProc: TdsdStoredProc; virtual; abstract;
    function GetExternalLoad: TExternalLoad; virtual; abstract;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); virtual; abstract;
  public
    property FileName: string read FFileName write FFileName;
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean; override;
  published
    // Директория загрузки. Сделана published что бы сохранять данные по стандартной схеме
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
    property StartDateParam: TdsdParam read FStartDate write FStartDate;
    property EndDateParam: TdsdParam read FEndDate write FEndDate;
  end;


implementation

uses SysUtils, MemDBFTable, Dialogs, SimpleGauge;

{ TExternalLoad }

procedure TExternalLoad.Activate;
begin

end;

constructor TExternalLoad.Create;
begin
  FActive := false;
  FOEM := false;
end;

destructor TExternalLoad.Destroy;
begin
  if Assigned(FDataSet) then
     FreeAndNil(FDataSet);
end;

function TExternalLoad.EOF: boolean;
begin
  result := (not Assigned(FDataSet)) or (not FDataSet.Active) or FDataSet.Eof;
end;

procedure TExternalLoad.First;
begin

end;

procedure TExternalLoad.Next;
begin
  FDataSet.Next;
end;

function TExternalLoad.RecordCount: integer;
begin
  result  := FDataSet.RecordCount
end;

{ TFileExternalLoad }

procedure TFileExternalLoad.Activate;
begin
  with {File}TOpenDialog.Create(nil) do
  try
    InitialDir := InitializeDirectory;
//    DefaultFolder := InitializeDirectory;
    DefaultExt := '*.dbf';
    Filter := '*.dbf';
    {with FileTypes.Add do
    begin
      DisplayName := 'Файлы загрузки';
      FileMask := '*.dbf';
    end;}
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
  FStartDate := TdsdParam.Create(nil);
  FEndDate := TdsdParam.Create(nil);
end;

destructor TExternalLoadAction.Destroy;
begin
  FreeAndNil(FStartDate);
  FreeAndNil(FEndDate);
  inherited;
end;

function TExternalLoadAction.EndDate: TDateTime;
begin
  result := EndDateParam.Value;
end;

function TExternalLoadAction.Execute: boolean;
var
   FExternalLoad: TFileExternalLoad;
   FStoredProc: TdsdStoredProc;
begin
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
         end;
       finally
         FStoredProc.Free
       end;
    end;
  finally
    FExternalLoad.Free;
  end;
end;

function TExternalLoadAction.StartDate: TDateTime;
begin
  result := StartDateParam.Value;
end;

constructor TFileExternalLoad.Create;
begin
  inherited;
  FOEM := true;
end;

procedure TFileExternalLoad.Open(FileName: string);
begin
  FDataSet := TMemDBFTable.Create(nil);
  TMemDBFTable(FDataSet).FileName := FileName;
  TMemDBFTable(FDataSet).OEM := FOEM;
  FDataSet.Open;
  First;
  FActive := FDataSet.Active;
end;

end.
