unit ThreadbtnEqualizationUnit;

interface

uses System.Classes, System.SysUtils, System.DateUtils, DB,
     ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type

  TOnError = procedure(AError: string) of object;
  TOnFinish = procedure of object;
  TOnMessage = procedure(AText: string) of object;
  TOnAddLog = procedure(AText: string) of object;

  // Поток для уравнивания данных (получение с мастера)
  TEqualizationThread = class(TThread)
  private
  { Private declarations }
    FHostName: String;
    FDatabase: String;
    FUser: String;
    FPassword: String;
    FPort: Integer;
    FLibraryLocation: String;

    FMode : Integer;

    FRecordCountSelect : Integer;
    FRecordFull        : Int64;
    FRecordFullMax     : Int64;

    FZConnection: TZConnection;
    FZQueryTable: TZQuery;
    FZQueryExecute: TZQuery;

    FProgress, FMax: Int64;

    FError: String;
    FStartDate : TDateTime;

    FOnError: TOnError;
    FOnFinish: TOnFinish;
    FOnMessage: TOnMessage;
    FOnAddLog: TOnAddLog;
    FOnProgress: TThreadProcedure;
    function GetDataSet : TDataSet;
  protected
    procedure Execute; override;

  public

    property Mode : Integer read FMode write FMode default 0;
    property Error: String read FError write FError;
    property HostName: String read FHostName write FHostName;
    property Database: String read FDatabase write FDatabase;
    property User: String read FUser write FUser;
    property Password: String read FPassword write FPassword;
    property Port: Integer read FPort write FPort;
    property LibraryLocation: String read FLibraryLocation write FLibraryLocation;
    property Terminated;
    property StartDate : TDateTime read FStartDate write FStartDate;

    property DataSet : TDataSet read GetDataSet;
    property Progress: Int64 read FProgress;
    property Max: Int64 read FMax;

    property OnError: TOnError read FOnError write FOnError;
    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnMessage: TOnMessage read FOnMessage write FOnMessage;
    property OnAddLog: TOnAddLog read FOnAddLog write FOnAddLog;
    property OnProgress: TThreadProcedure read FOnProgress write FOnProgress;

  end;


implementation

uses UnitConst, MainUnit;

function TEqualizationThread.GetDataSet : TDataSet;
begin
  Result := TDataSet(FZQueryTable);
end;

procedure TEqualizationThread.Execute;
  var S : String;
begin
  FError := '';

  if Assigned(OnMessage) then OnMessage('Подключаемся к базе данных Slave.');

  FZConnection := TZConnection.Create(Nil);
  FZConnection.Protocol := 'postgresql-9';
  FZConnection.HostName :=  FHostName;
  FZConnection.Database :=  FDatabase;
  FZConnection.User     :=  FUser;
  FZConnection.Password :=  FPassword;
  FZConnection.Port     :=  FPort;
  FZConnection.LibraryLocation := FLibraryLocation;

  FZQueryTable := TZQuery.Create(Nil);
  FZQueryTable.Connection := FZConnection;
  FZQueryExecute := TZQuery.Create(Nil);
  FZQueryExecute.Connection := FZConnection;
  FRecordCountSelect := 10000;

  try
    try
      if Terminated then Exit;

      FZConnection.Connect;

      if (Mode and 2) = 2 then
      begin

        if Assigned(OnMessage) then OnMessage('Синхронизация данных с Мастера.');

        FProgress := 0;
        FMax := MinutesBetween(FStartDate, Now);

        if Assigned(FOnProgress) then  Synchronize(FOnProgress);

        while True do
        begin

          if Terminated then Exit;

          FZQueryTable.SQL.Text := cSQLEqualization_MasterStep;
          FZQueryTable.Open;
          if FZQueryTable.FieldByName('ErrorText').AsString <> '' then
          begin
            FError := FZQueryTable.FieldByName('ErrorText').AsString;
            Exit;
          end;
          if FZQueryTable.FieldByName('RowCount').AsInteger <= 0 then
          begin
            Exit;
          end;

          FProgress := MinutesBetween(FStartDate, FZQueryTable.FieldByName('DateEqualization').AsDateTime);

          if Assigned(FOnProgress) then  Synchronize(FOnProgress);

        end;


//        if Assigned(OnAddLog) then OnAddLog(Format(cTableLogFinish, [IntToStr(FZQueryTable.RecordCount), IntToStr(nRowCount)]));
      end;


    except
      on E: Exception do
      begin
        FError := Format(cExceptionMsg, [E.ClassName, E.Message]);
        if FZQueryTable.Active then
          FError := FError + #13#10 + FZQueryTable.FieldByName('TableName').AsString
      end;
    end;

  finally
    FZQueryExecute.Close;
    FZQueryTable.Close;
    FZConnection.Disconnect;
    FreeAndNil(FZQueryExecute);
    FreeAndNil(FZQueryTable);
    FreeAndNil(FZConnection);
    if Assigned(FOnError) then FOnError(FError);
    if Assigned(FOnFinish) then OnFinish;
  end;

end;


end.
