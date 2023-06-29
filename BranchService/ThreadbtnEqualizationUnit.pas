unit ThreadbtnEqualizationUnit;

interface

uses System.Classes, System.SysUtils, System.DateUtils, DB,
     ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type

  TOnFinish = procedure(AError: String) of object;
  TOnMessage = procedure(AText: string) of object;

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
    FTimeSec           : Int64;

    FZConnection: TZConnection;
    FZQueryTable: TZQuery;
    FZQueryExecute: TZQuery;

    FProgress, FMax: Int64;

    FError: String;
    FStartDate : TDateTime;

    FOnFinish: TOnFinish;
    FOnMessage: TOnMessage;
    FOnAddLog: TThreadProcedure;
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
    property TimeSec: Int64 read FTimeSec;

    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnMessage: TOnMessage read FOnMessage write FOnMessage;
    property OnAddLog: TThreadProcedure read FOnAddLog write FOnAddLog;
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
      CurrDate : TDateTime;
      StartDate : TDateTime;
begin
  FError := '';
  StartDate := Now;

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

      // Получить дату конца
      FZQueryTable.SQL.Text := cSQLSELECT_CLOCK_TIMESTAMP;
      FZQueryTable.Open;
      CurrDate := FZQueryTable.FieldByName('CurrDate').AsDateTime;
      FZQueryTable.Close;

      try

        if (Mode and 1) = 1 then
        begin

          if Assigned(OnMessage) then OnMessage('Синхронизация данных с Slave.');

          FProgress := 0;
          FMax := MinutesBetween(FStartDate, CurrDate);

          if Assigned(FOnProgress) then  Synchronize(FOnProgress);

          while True do
          begin

            if Terminated then Exit;

            FZQueryTable.Close;
            FZQueryTable.SQL.Text := cSQLEqualization_SlaveStep;
            FZQueryTable.Open;
            if FZQueryTable.FieldByName('ErrorText').AsString <> '' then
            begin
              FError := FZQueryTable.FieldByName('ErrorText').AsString;
              Exit;
            end;

            FProgress := MinutesBetween(FStartDate, FZQueryTable.FieldByName('DateEqualization').AsDateTime);

            if Assigned(FOnProgress) then  Synchronize(FOnProgress);

            if FZQueryTable.FieldByName('RowCount').AsInteger <= 0 then
            begin
              Break;
            end;
            if CurrDate <= FZQueryTable.FieldByName('DateEqualization').AsDateTime then
            begin
              Break;
            end;

          end;
        end;


        if (Mode and 2) = 2 then
        begin

          if Assigned(OnMessage) then OnMessage('Синхронизация данных с Мастера.');

          FProgress := 0;
          FMax := MinutesBetween(FStartDate, CurrDate);

          if Assigned(FOnProgress) then  Synchronize(FOnProgress);

          while True do
          begin

            if Terminated then Exit;

            FZQueryTable.Close;
            FZQueryTable.SQL.Text := cSQLEqualization_MasterStep;
            FZQueryTable.Open;
            if FZQueryTable.FieldByName('ErrorText').AsString <> '' then
            begin
              FError := FZQueryTable.FieldByName('ErrorText').AsString;
              Exit;
            end;

            FProgress := MinutesBetween(FStartDate, FZQueryTable.FieldByName('DateEqualization').AsDateTime);

            if Assigned(FOnProgress) then  Synchronize(FOnProgress);

            if FZQueryTable.FieldByName('RowCount').AsInteger <= 0 then
            begin
              Break;
            end;
            if CurrDate <= FZQueryTable.FieldByName('DateEqualization').AsDateTime then
            begin
              Break;
            end;

          end;
        end;

      finally
        FTimeSec := SecondsBetween(Now, StartDate);
        if Assigned(OnAddLog) then Synchronize(OnAddLog);
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
    if Assigned(FOnFinish) then OnFinish(FError);
  end;

end;


end.
