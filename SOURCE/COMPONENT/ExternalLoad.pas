unit ExternalLoad;

interface

uses dsdAction, dsdDb, Classes, DB, ExternalData;

type

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
  result := true
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
