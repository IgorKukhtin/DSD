unit USnapshotThread;

interface

uses
  Classes, SyncObjs, UData, ZAbstractConnection, ZConnection, ZAbstractRODataset,
  ZDataset, USettings, SysUtils, uConstants, System.UITypes, DateUtils;

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
    FKeyFields: string;
    FHasBlob: boolean;
    FIsCompositeKey: boolean;
    FRealKeyField: string;
    FTotalCount: Int64;
    FProcessedCount: Int64;

    FSnapshotSelectCount: Int64;
    FSnapshotInsertCount: Int64;
    FSnapshotBlobSelectCount: Int64;
    FSnapshotSelectTextCount: Int64;
    FSnapshotInsertTextCount: Int64;

    procedure SetPaused(const Value: Boolean);
  protected
    procedure Execute; override;
    procedure CheckPaused;
    function Connect(AConnection: TZConnection): boolean;

    function GetInsertQuery(ATableName: string): string;

    procedure CopyBlobRecords;
    procedure CopyBatchRecords;
    procedure CopyBatchRecordsValues;

    procedure ProcessError(AError: string);
    procedure ProcessMessage(AMessage: string);
    procedure UpdateStatus(AStatus: string);
    procedure UpdateProcessedCount;
    procedure ReadSettings;
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
var LastId: int64;
    QSrc: TZQuery;
    FInsertQuery: string;
    FHadValues: boolean;
    cBatch: string;
    nBatchCount: integer;
var tmpDate:TDateTime;
    Hour, Min, Sec, MSec: Word;
    StrTime:String;
    tmpBatchTime: TDateTime;

    function GetSelectCount: int64;
    begin
      if FHasBlob then
        Result := FSnapshotSelectTextCount
      else
        Result := FSnapshotSelectCount;
    end;

    function GetInsertCount: int64;
    begin
      if FHasBlob then
        Result := FSnapshotInsertTextCount
      else
        Result := FSnapshotInsertCount;
    end;

begin
  FHadValues := false;
  QSrc := TZQuery.Create(nil);
  try
    QSrc.Connection := FMasterConn;
    UpdateStatus('Генерация запроса на вставку ..');
    FInsertQuery := GetInsertQuery(FCurrTable);
    if FInsertQuery.IsEmpty then
    begin
      ProcessError('Ошибка получения скрипта INSERT для '+ FCurrTable);
      Exit;
    end;
    LastId := 0;
    while not Terminated do
    begin
      CheckPaused;
      UpdateStatus('Получение данных от мастера ..');
      QSrc.Close;
      if FIsCompositeKey then
        QSrc.SQL.Text :=
          FInsertQuery + sLineBreak +
          'WHERE '+ FRealKeyField + ' >= :LastId '+ sLineBreak +
          'ORDER BY '+ FRealKeyField + ',' + FKeyFields + sLineBreak +
          'LIMIT '+ IntToStr(GetSelectCount)
      else
        QSrc.SQL.Text :=
          FInsertQuery + sLineBreak +
          'WHERE '+ FRealKeyField + ' > :LastId '+ sLineBreak +
          'ORDER BY '+ FKeyFields + sLineBreak +
          'LIMIT '+ IntToStr(GetSelectCount);
      QSrc.ParamByName('LastId').Value := LastId;

      //
      tmpDate:=NOw;
      //
      QSrc.Open;
      //
      DecodeTime(now-tmpDate, Hour, Min, Sec, MSec);
      StrTime:=IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(MSec);
      DecodeTime(now, Hour, Min, Sec, MSec);
      ProcessMessage('---');
      ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) + ' - open master time : ' + StrTime);
      //

      if (QSrc.RecordCount = 0) then
      begin
        if FHadValues then
          ProcessMessage('Данные для таблицы '+ FCurrTable + ' перенесены')
        else
          ProcessMessage('В таблице '+ FCurrTable + ' нет данных для переноса');
        break;
      end;
      FHadValues := true;
      CheckPaused;

      UpdateStatus('Формирование запроса на вставку ..');
      cBatch := '';
      nBatchCount := 0;
      tmpBatchTime := Now;
      while not Terminated and not QSrc.Eof do
      begin
        cBatch := cBatch + QSrc.FieldByName('Query').AsString + ';' + sLineBreak;
        if QSrc.FieldByName(FRealKeyField).AsLargeInt > LastId then
          LastId := QSrc.FieldByName(FRealKeyField).AsLargeInt;
        QSrc.Next;
        inc(nBatchCount);
        if not Terminated then
          if (nBatchCount >= GetInsertCount) or QSrc.Eof then
          begin
            try
//              DecodeTime(now, Hour, Min, Sec, MSec);
//              ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) +
//                '  - insert start');
              CheckPaused;
              UpdateStatus('Добавление записей на slave ..');

              tmpDate:=NOw;
              //
              FSlaveConn.ExecuteDirect(cBatch);
              //
              DecodeTime(now-tmpDate, Hour, Min, Sec, MSec);
              StrTime:=IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(MSec);
              DecodeTime(now, Hour, Min, Sec, MSec);
              ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) + ' - insert slave time : ' + IntToStr (nBatchCount)+ '(' + IntToStr (FProcessedCount)+ ') : ' + StrTime);
              //
              FProcessedCount := FProcessedCount + nBatchCount;
              nBatchCount := 0;
              cBatch := '';
              UpdateProcessedCount;

//              if FProcessedCount >= 300000 then
//                Exit;

            except on E: Exception do
              begin
                ProcessError(E.Message);
              end;
            end;
          end;
      end;
      // увеличиваем lastid, чтобы следующий QSrc.open вернул 0 записей
      if FIsCompositeKey and (QSrc.RecordCount < GetSelectCount) then
        inc(LastId);
      DecodeTime(now-tmpBatchTime, Hour, Min, Sec, MSec);
      StrTime:=IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(MSec);
      DecodeTime(now, Hour, Min, Sec, MSec);
      ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) + ' - batch total insert slave time : ' + IntToStr (nBatchCount)+ '(' + IntToStr (FProcessedCount)+ ') : ' + StrTime);
    end;
  finally
    QSrc.Free;
  end;
end;

procedure TSnapshotThread.CopyBatchRecordsValues;
var LastId: int64;
    QSrc: TZQuery;
    FHadValues: boolean;
    cBatch: string;
    nBatchCount: integer;
var tmpDate:TDateTime;
    Hour, Min, Sec, MSec: Word;
    StrTime:String;
    tmpBatchTime: TDateTime;
    FInsertPart, FValuesPart: string;

    function GetSelectCount: int64;
    begin
      if FHasBlob then
        Result := FSnapshotSelectTextCount
      else
        Result := FSnapshotSelectCount;
    end;

    function GetInsertCount: int64;
    begin
      if FHasBlob then
        Result := FSnapshotInsertTextCount
      else
        Result := FSnapshotInsertCount;
    end;

begin
  FHadValues := false;
  QSrc := TZQuery.Create(nil);
  try
    QSrc.Connection := FMasterConn;
    UpdateStatus('Генерация запроса на вставку ..');
    FTempQuery.Close;
    FTempQuery.Connection := FMasterConn;
    FTempQuery.SQL.Text := 'select * from  _replica.grSelect_Snapshot_Insert_QueryV2(:table);';
    FTempQuery.ParamByName('table').Value := FCurrTable;
    FTempQuery.Open;

    FInsertPart := FTempQuery.FieldByName('InsertPart').AsString;
    FValuesPart := FTempQuery.FieldByName('ValuesPart').AsString;
    if FInsertPart.IsEmpty or FValuesPart.IsEmpty then
    begin
      ProcessError('Ошибка получения скрипта INSERT для '+ FCurrTable);
      Exit;
    end;
    LastId := 0;
    while not Terminated do
    begin
      CheckPaused;
      UpdateStatus('Получение данных от мастера ..');
      QSrc.Close;
      if FIsCompositeKey then
        QSrc.SQL.Text :=
          FValuesPart + ', ' + FRealKeyField + sLineBreak +
          'FROM '+ FCurrTable + sLineBreak +
          'WHERE '+ FRealKeyField + ' >= :LastId '+ sLineBreak +
          'ORDER BY '+ FRealKeyField + ',' + FKeyFields + sLineBreak +
          'LIMIT '+ IntToStr(GetSelectCount)
      else
        QSrc.SQL.Text :=
          FValuesPart + ', ' + FRealKeyField + sLineBreak +
          'FROM '+ FCurrTable + sLineBreak +
          'WHERE '+ FRealKeyField + ' > :LastId '+ sLineBreak +
          'ORDER BY '+ FKeyFields + sLineBreak +
          'LIMIT '+ IntToStr(GetSelectCount);
      QSrc.ParamByName('LastId').Value := LastId;

      //
      tmpDate:=NOw;
      //
      QSrc.Open;
      //
      DecodeTime(now-tmpDate, Hour, Min, Sec, MSec);
      StrTime:=IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(MSec);
      DecodeTime(now, Hour, Min, Sec, MSec);
      ProcessMessage('---');
      ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) + ' - open master time : ' + StrTime);
      //

      if (QSrc.RecordCount = 0) then
      begin
        if FHadValues then
          ProcessMessage('Данные для таблицы '+ FCurrTable + ' перенесены')
        else
          ProcessMessage('В таблице '+ FCurrTable + ' нет данных для переноса');
        break;
      end;
      FHadValues := true;
      CheckPaused;

      UpdateStatus('Формирование запроса на вставку ..');
      cBatch := '';
      nBatchCount := 0;
      tmpBatchTime := Now;
      while not Terminated and not QSrc.Eof do
      begin
        if cBatch.IsEmpty then
          cBatch := FInsertPart + ' VALUES '
        else
          cBatch := cBatch + ',';
        cBatch := cBatch + QSrc.FieldByName('Query').AsString;
        //cBatch := cBatch + QSrc.FieldByName('Query').AsString + ';' + sLineBreak;
        if QSrc.FieldByName(FRealKeyField).AsLargeInt > LastId then
          LastId := QSrc.FieldByName(FRealKeyField).AsLargeInt;
        QSrc.Next;
        inc(nBatchCount);
        if not Terminated then
          if (nBatchCount >= GetInsertCount) or QSrc.Eof then
          begin
            try
//              DecodeTime(now, Hour, Min, Sec, MSec);
//              ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) +
//                '  - insert start');
              CheckPaused;
              UpdateStatus('Добавление записей на slave ..');

              tmpDate:=NOw;
              //
              FSlaveConn.ExecuteDirect(cBatch + ' ON CONFLICT DO NOTHING');
              //
              DecodeTime(now-tmpDate, Hour, Min, Sec, MSec);
              StrTime:=IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(MSec);
              DecodeTime(now, Hour, Min, Sec, MSec);
              ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) + ' - insert slave time : ' + IntToStr (nBatchCount)+ '(' + IntToStr (FProcessedCount)+ ') : ' + StrTime);
              //
              FProcessedCount := FProcessedCount + nBatchCount;
              nBatchCount := 0;
              cBatch := '';
              UpdateProcessedCount;

//              if FProcessedCount >= 300000 then
//                Exit;

            except on E: Exception do
              begin
                ProcessError(E.Message);
              end;
            end;
          end;
      end;
      // увеличиваем lastid, чтобы следующий QSrc.open вернул 0 записей
      if FIsCompositeKey and (QSrc.RecordCount < GetSelectCount) then
        inc(LastId);
      DecodeTime(now-tmpBatchTime, Hour, Min, Sec, MSec);
      StrTime:=IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(MSec);
      DecodeTime(now, Hour, Min, Sec, MSec);
      ProcessMessage(IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ':' + IntToStr(MSec) + ' - batch total insert slave time : ' + IntToStr (nBatchCount)+ '(' + IntToStr (FProcessedCount)+ ') : ' + StrTime);
    end;
  finally
    QSrc.Free;
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

    A := FKeyFields.Split([','], TStringSplitOptions.ExcludeEmpty);
    cSQL := '';
    for I := 0 to Length(A) - 1 do
    begin
      if cSQL.IsEmpty  then
        cSQL := ' WHERE '
      else
        cSQL := cSQL + ' AND ';
      cSQL := cSQL + A[I] + ' = :' + A[I];
    end;
    cSQL := 'SELECT * FROM '+ FCurrTable + sLineBreak + cSQL;
    QDst.SQL.Text := cSQL;

    while not Terminated do
    begin
      CheckPaused;
      UpdateStatus('Получение данных от мастера ..');
      QSrc.Close;
      if FIsCompositeKey then
        QSrc.SQL.Text :=
          'SELECT * FROM '+ FCurrTable + sLineBreak +
          'ORDER BY '+ FKeyFields + sLineBreak +
          'LIMIT '+ IntToStr(FSnapshotBlobSelectCount) + ' OFFSET '+ IntToStr(FProcessedCount)
      else
      begin
        QSrc.SQL.Text :=
          'SELECT * FROM '+ FCurrTable + sLineBreak +
          'WHERE '+ FRealKeyField + ' > :LastId '+ sLineBreak +
          'ORDER BY '+ FKeyFields + sLineBreak +
          'LIMIT '+ IntToStr(FSnapshotBlobSelectCount);
        QSrc.ParamByName('LastId').Value := LastId;
      end;
      QSrc.Open;
      if (QSrc.RecordCount = 0) then
      begin
        if FHadValues then
          ProcessMessage('Данные для таблицы '+ FCurrTable + ' перенесены')
        else
          ProcessMessage('В таблице '+ FCurrTable + ' нет данных для переноса');
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

        if not FIsCompositeKey then
          if QSrc.FieldByName(FRealKeyField).AsInteger > LastId then
            LastId := QSrc.FieldByName(FRealKeyField).AsInteger;

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
  ReadSettings;
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
        //' where table_name ILIKE ''MovementItemContainer'' '+
        ' ;';
      FTables.Open;

      CheckPaused;
      while not Terminated and not FTables.Eof do
      begin
        FCurrTable := FTables.FieldByName('table_name').AsString;
        FKeyFields := FTables.FieldByName('key_fields').AsString;
        FHasBlob := FTables.FieldByName('has_blob').AsBoolean;
        FIsCompositeKey := FTables.FieldByName('is_composite_key').AsBoolean;
        if SameText(FCurrTable, 'containerlinkobject') then
          FRealKeyField := 'containerid'
        else if FIsCompositeKey then
          FRealKeyField := Copy(FKeyFields, 1, Pos(',', FKeyFields) - 1)
        else
          FRealKeyField := FKeyFields;

        Synchronize(
          procedure
          begin
            if Assigned(OnNewTable) then
              OnNewTable(FCurrTable);
          end);
        UpdateStatus('Получение количества записей ..');

        FTempQuery.Close;
        FTempQuery.Connection := FMasterConn;

//        if FTables.FieldByName('is_composite_key').AsBoolean then
//          FTempQuery.SQL.Text := 'select count(*) as TotalCount from '+ FCurrTable
//        else
//          FTempQuery.SQL.Text := 'select count('+ FTables.FieldByName('key_fields').AsString +') as TotalCount from '+ FCurrTable;

        FTempQuery.ParamCheck := false;
        FTempQuery.SQL.Text := 'SELECT reltuples::bigint AS TotalCount FROM pg_class WHERE relname ILIKE '+ QuotedStr(FCurrTable) +';';
        FTempQuery.Open;

        FTotalCount := FTempQuery.FieldByName('TotalCount').AsInteger;
        FTempQuery.Close;
        FTempQuery.ParamCheck := true;
        FProcessedCount := 0;

        UpdateProcessedCount;

        if FSlaveConn.ExecuteDirect('ALTER TABLE '+ FCurrTable +' DISABLE TRIGGER ALL') then
          try
            if SameText(FCurrTable, 'objectblob') then
              CopyBlobRecords
            else
              CopyBatchRecordsValues;
              //CopyBatchRecords;
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

procedure TSnapshotThread.ReadSettings;
begin
  FSnapshotSelectCount := TSettings.SnapshotSelectCount;
  FSnapshotInsertCount := TSettings.SnapshotInsertCount;
  FSnapshotBlobSelectCount := TSettings.SnapshotBlobSelectCount;
  FSnapshotSelectTextCount := TSettings.SnapshotSelectTextCount;
  FSnapshotInsertTextCount := TSettings.SnapshotInsertTextCount;
end;

procedure TSnapshotThread.SetPaused(const Value: Boolean);
begin
  if (not Terminated) and (FPaused <> Value) then
  begin
    FPaused := Value;
    if FPaused then
      FEvent.ResetEvent
    else
    begin
      FEvent.SetEvent;
      ReadSettings;
    end;
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
