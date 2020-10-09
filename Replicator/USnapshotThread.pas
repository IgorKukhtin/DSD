unit USnapshotThread;

interface

uses
  Classes, SyncObjs, UData, ZAbstractConnection, ZConnection, ZAbstractRODataset,
  ZDataset, USettings, SysUtils, uConstants, System.UITypes;

type
  TOnError = procedure(AError: string) of object;
  TOnFinish = procedure of object;
  TOnNewTable = procedure(ATableName: string) of object;
  TOnFinishTable = procedure(ATableName: string) of object;
  TOnProcessed = procedure(ATotalCount, AProcessedCount: int64) of object;
  TOnMessage = procedure(AMessage: string) of object;
  TOnStatus = procedure(AStatus: string) of object;

type
  TSnapshotThread = class(TThread)
  private
    FMasterConn: TZConnection;
    FSlaveConn: TZConnection;
    FTables: TZQuery;
    FTempQuery: TZQuery;
    FEvent: TEvent;
    FPaused: Boolean;

    FOnError: TOnError;
    FOnFinish: TOnFinish;
    FOnNewTable: TOnNewTable;
    FOnFinishTable: TOnFinishTable;
    FOnProcessed: TOnProcessed;
    FOnMessage: TOnMessage;
    FOnStatus: TOnStatus;

    FCurrTable: string;
    FTotalCount: Int64;
    FProcessedCount: Int64;

    procedure SetPaused(const Value: Boolean);
  protected
    procedure Execute; override;
    procedure CheckPaused;
    function Connect(AConnection: TZConnection): boolean;

    function GetInsertQuery(ATableName: string): string;

    procedure CopyBlobRecords;
    procedure CopyBatchRecords;

    procedure ProcessError(AError: string);
    procedure ProcessMessage(AMessage: string);
    procedure UpdateStatus(AStatus: string);
    procedure UpdateProcessedCount;
  public
    constructor Create;

    property Paused: Boolean read fPaused write SetPaused;

    property OnError: TOnError read FOnError write FOnError;
    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnNewTable: TOnNewTable read FOnNewTable write FOnNewTable;
    property OnFinishTable: TOnFinishTable read FOnFinishTable write FOnFinishTable;
    property OnProcessed: TOnProcessed read FOnProcessed write FOnProcessed;
    property OnMessage: TOnMessage read FOnMessage write FOnMessage;
    property OnStatus: TOnStatus read FOnStatus write FOnStatus;
  end;

implementation

procedure TSnapshotThread.CheckPaused;
begin
  FEvent.WaitFor(INFINITE);
end;

function TSnapshotThread.Connect(AConnection: TZConnection): boolean;
var
  iAttempt: Int64;
const
  cWaitReconnect = c1Sec;
  cAttemptCount  = 3;
begin
  Result := AConnection.Connected;
  if Result then Exit;
  iAttempt := 0;
  repeat
    try
      Inc(iAttempt);
      AConnection.Connect;
      Result := AConnection.Connected;
    except
      on E: Exception do
      begin
        Result := False;
        if iAttempt >= cAttemptCount then
          ProcessError(E.Message)
        else
          Sleep(cWaitReconnect);
      end;
    end;
  until Result or (iAttempt >= cAttemptCount);
end;

procedure TSnapshotThread.CopyBatchRecords;
var LastId: integer;
    QSrc, QDst: TZQuery;
    FInsertQuery: string;
    FHadValues: boolean;
    cBatch: string;
    nBatchCount: integer;
begin
  FHadValues := false;
  QSrc := TZQuery.Create(nil);
  QDst := TZQuery.Create(nil);
  try
    QSrc.Connection := FMasterConn;
    QDst.Connection := FSlaveConn;
    UpdateStatus('Генерация запроса на вставку ..');
    FInsertQuery := GetInsertQuery(FTables.FieldByName('table_name').AsString);
    if FInsertQuery.IsEmpty then
    begin
      ProcessError('Ошибка получения скрипта INSERT для '+ FTables.FieldByName('table_name').AsString);
      Exit;
    end;
    LastId := 0;
    while not Terminated do
    begin
      CheckPaused;
      UpdateStatus('Получение данных от мастера ..');
      QSrc.Close;
      if FTables.FieldByName('is_composite_key').AsBoolean then
        QSrc.SQL.Text :=
          FInsertQuery + sLineBreak +
          'ORDER BY '+ FTables.FieldByName('key_fields').AsString + sLineBreak +
          'LIMIT '+ IntToStr(TSettings.SnapshotSelectCount) + ' OFFSET '+ IntToStr(FProcessedCount)
      else
      begin
        QSrc.SQL.Text :=
          FInsertQuery + sLineBreak +
          'WHERE '+ FTables.FieldByName('key_fields').AsString + ' > :LastId '+ sLineBreak +
          'ORDER BY '+ FTables.FieldByName('key_fields').AsString + sLineBreak +
          'LIMIT '+ IntToStr(TSettings.SnapshotSelectCount);
        QSrc.ParamByName('LastId').Value := LastId;
      end;
      QSrc.Open;
      if (QSrc.RecordCount = 0) then
      begin
        if FHadValues then
          ProcessMessage('Данные для таблицы '+ FTables.FieldByName('table_name').AsString + ' перенесены')
        else
          ProcessMessage('В таблице '+ FTables.FieldByName('table_name').AsString + ' нет данных для переноса');
        break;
      end;
      FHadValues := true;
      CheckPaused;

      UpdateStatus('Формирование запроса на вставку ..');
      cBatch := '';
      nBatchCount := 0;
      while not Terminated and not QSrc.Eof do
      begin
        cBatch := cBatch + QSrc.FieldByName('Query').AsString + ';' + sLineBreak;
        if not FTables.FieldByName('is_composite_key').AsBoolean then
          if QSrc.FieldByName(FTables.FieldByName('key_fields').AsString).AsInteger > LastId then
            LastId := QSrc.FieldByName(FTables.FieldByName('key_fields').AsString).AsInteger;
        QSrc.Next;
        inc(nBatchCount);
        if not Terminated then
          if (nBatchCount >= TSettings.SnapshotInsertCount) or QSrc.Eof then
          begin
            try
              CheckPaused;
              UpdateStatus('Добавление записей на slave ..');
              QDst.Close;
              QDst.SQL.Text := cBatch;
              QDst.ExecSQL;
              FProcessedCount := FProcessedCount + nBatchCount;
              nBatchCount := 0;
              UpdateProcessedCount;
            except on E: Exception do
              begin
                ProcessError(E.Message);
              end;
            end;
          end;
      end;
    end;
  finally
    QSrc.Free;
    QDst.Free;
  end;
end;

procedure TSnapshotThread.CopyBlobRecords;
var LastId: integer;
    QSrc, QDst: TZQuery;
    FHadValues: boolean;
    A: TArray<string>;
    I: integer;
    cSQL: string;
begin
  FHadValues := false;
  QSrc := TZQuery.Create(nil);
  QDst := TZQuery.Create(nil);
  try
    QSrc.Connection := FMasterConn;
    QDst.Connection := FSlaveConn;
    LastId := 0;

    A := FTables.FieldByName('key_fields').AsString.Split([','], TStringSplitOptions.ExcludeEmpty);
    cSQL := '';
    for I := 0 to Length(A) - 1 do
    begin
      if cSQL.IsEmpty  then
        cSQL := ' WHERE '
      else
        cSQL := cSQL + ' AND ';
      cSQL := cSQL + A[I] + ' = :' + A[I];
    end;
    cSQL := 'SELECT * FROM '+ FTables.FieldByName('table_name').AsString + sLineBreak + cSQL;
    QDst.SQL.Text := cSQL;

    while not Terminated do
    begin
      CheckPaused;
      UpdateStatus('Получение данных от мастера ..');
      QSrc.Close;
      if FTables.FieldByName('is_composite_key').AsBoolean then
        QSrc.SQL.Text :=
          'SELECT * FROM '+ FTables.FieldByName('table_name').AsString + sLineBreak +
          'ORDER BY '+ FTables.FieldByName('key_fields').AsString + sLineBreak +
          'LIMIT '+ IntToStr(TSettings.SnapshotBlobSelectCount) + ' OFFSET '+ IntToStr(FProcessedCount)
      else
      begin
        QSrc.SQL.Text :=
          'SELECT * FROM '+ FTables.FieldByName('table_name').AsString + sLineBreak +
          'WHERE '+ FTables.FieldByName('key_fields').AsString + ' > :LastId '+ sLineBreak +
          'ORDER BY '+ FTables.FieldByName('key_fields').AsString + sLineBreak +
          'LIMIT '+ IntToStr(TSettings.SnapshotBlobSelectCount);
        QSrc.ParamByName('LastId').Value := LastId;
      end;
      QSrc.Open;
      if (QSrc.RecordCount = 0) then
      begin
        if FHadValues then
          ProcessMessage('Данные для таблицы '+ FTables.FieldByName('table_name').AsString + ' перенесены')
        else
          ProcessMessage('В таблице '+ FTables.FieldByName('table_name').AsString + ' нет данных для переноса');
        break;
      end;
      FHadValues := true;
      CheckPaused;

      UpdateStatus('Добавление записей на slave ..');
      while not Terminated and not QSrc.Eof do
      begin
        QDst.Close;
        for I := 0 to QDst.Params.Count - 1 do
          QDst.Params.Items[I].Value := QSrc.FieldByName(QDst.Params.Items[I].Name).Value;
        QDst.Open;
        if QDst.RecordCount = 0 then
        begin
          QDst.Append;
          for I := 0 to QSrc.Fields.Count - 1 do
            QDst.FieldByName(QSrc.Fields.Fields[I].FieldName).Value := QSrc.Fields.Fields[I].Value;
          try
            QDst.Post;
          except on E: Exception do
            begin
              ProcessError(E.Message);
            end;
          end;
        end;

        FProcessedCount := FProcessedCount + 1;
        UpdateProcessedCount;

        if not FTables.FieldByName('is_composite_key').AsBoolean then
          if QSrc.FieldByName(FTables.FieldByName('key_fields').AsString).AsInteger > LastId then
            LastId := QSrc.FieldByName(FTables.FieldByName('key_fields').AsString).AsInteger;

        QSrc.Next;
        CheckPaused;
      end;
    end;
  finally
    QSrc.Free;
    QDst.Free;
  end;

end;

constructor TSnapshotThread.Create;
begin
  FreeOnTerminate := false;
  inherited Create(true);
end;

procedure TSnapshotThread.Execute;
begin
  FPaused := false;
  FEvent := TEvent.Create(nil, true, not FPaused, '');
  FMasterConn := TZConnection.Create(nil);
  FSlaveConn := TZConnection.Create(nil);
  FTables := TZQuery.Create(nil);
  FTempQuery := TZQuery.Create(nil);
  try
    try
      with FMasterConn do
      begin
        Disconnect;
        Protocol := 'postgresql-9';
        HostName := TSettings.MasterServer;
        Database := TSettings.MasterDatabase;
        Port     := TSettings.MasterPort;
        User     := TSettings.MasterUser;
        Password := TSettings.MasterPassword;
        LibraryLocation := TSettings.LibLocation;
        Properties.Values['EMULATE_PREPARES'] := 'True';
      end;
      with FSlaveConn do
      begin
        Disconnect;
        Protocol := 'postgresql-9';
        HostName := TSettings.SlaveServer;
        Database := TSettings.SlaveDatabase;
        Port     := TSettings.SlavePort;
        User     := TSettings.SlaveUser;
        Password := TSettings.SlavePassword;
        LibraryLocation := TSettings.LibLocation;
        Properties.Values['EMULATE_PREPARES'] := 'True';
      end;
      if not Connect(FMasterConn) then Exit;
      if not Connect(FSlaveConn) then Exit;

      FTables.Connection := FMasterConn;
      FTables.SQL.Text :=
        ' select * from _replica.grSelect_Tables_For_Snapshot() '+
        //' where table_name = ''object'' '+
        ' ;';
      FTables.Open;

      CheckPaused;
      while not Terminated and not FTables.Eof do
      begin
        FCurrTable := FTables.FieldByName('table_name').AsString;

        Synchronize(
          procedure
          begin
            if Assigned(OnNewTable) then
              OnNewTable(FCurrTable);
          end);
        UpdateStatus('Получение количества записей ..');

        FTempQuery.Close;
        FTempQuery.Connection := FMasterConn;
        FTempQuery.SQL.Text := 'select count(*) as TotalCount from '+ FCurrTable;
        FTempQuery.Open;

        FTotalCount := FTempQuery.FieldByName('TotalCount').AsInteger;
        FProcessedCount := 0;

        UpdateProcessedCount;

        if FSlaveConn.ExecuteDirect('ALTER TABLE '+ FCurrTable +' DISABLE TRIGGER ALL') then
          try
            if not FTables.FieldByName('has_blob').AsBoolean then
              CopyBatchRecords
            else
              CopyBlobRecords;
          finally
            if not FSlaveConn.ExecuteDirect('ALTER TABLE '+ FCurrTable +' ENABLE TRIGGER ALL') then
              ProcessError('Для таблицы '+ FCurrTable +' триггеры были отключены, но не восстановлены');
          end;

        if not Terminated then
          Synchronize(
            procedure
            begin
              if Assigned(OnFinishTable) then
                OnFinishTable(FCurrTable);
            end);
        FTables.Next;
        CheckPaused;
      end;
    except on E: Exception do
      ProcessError(E.Message);
    end;
  finally
    if Assigned(FTables) then
      FreeAndNil(FTables);
    if Assigned(FTempQuery) then
      FreeAndNil(FTempQuery);
    if Assigned(FMasterConn) then
      FreeAndNil(FMasterConn);
    if Assigned(FSlaveConn) then
      FreeAndNil(FSlaveConn);
    if FPaused then
      FEvent.SetEvent;
    FEvent.Free;

    Synchronize(
      procedure
      begin
        if Assigned(OnFinish) then
          OnFinish;
      end);
  end;
end;

function TSnapshotThread.GetInsertQuery(ATableName: string): string;
var Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FMasterConn;
    Q.SQL.Text := 'select _replica.grSelect_Snapshot_Insert_Query(:TableName) as Query';
    Q.ParamByName('TableName').Value := ATableName;
    Q.Open;
    Result := Q.FieldByName('Query').AsString;
  finally
    Q.Free;
  end;
end;

procedure TSnapshotThread.ProcessError(AError: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnError) then
        OnError(AError);
    end);
end;

procedure TSnapshotThread.ProcessMessage(AMessage: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnMessage) then
        OnMessage(AMessage);
    end);
end;

procedure TSnapshotThread.SetPaused(const Value: Boolean);
begin
  if (not Terminated) and (FPaused <> Value) then
  begin
    FPaused := Value;
    if FPaused then
      FEvent.ResetEvent
    else
      FEvent.SetEvent;
  end;
end;

procedure TSnapshotThread.UpdateProcessedCount;
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnProcessed) then
        OnProcessed(FTotalCount, FProcessedCount);
    end);
end;

procedure TSnapshotThread.UpdateStatus(AStatus: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnStatus) then
        OnStatus(AStatus);
    end);
end;

end.
