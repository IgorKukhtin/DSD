unit UData;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZDataset,
  UDefinitions,
  UCommandData;

type
  TdmData = class(TDataModule)
    conMaster: TZConnection;
    conSlave: TZConnection;
    qrySelectReplicaSQL: TZReadOnlyQuery;
    qrySelectReplicaCmd: TZReadOnlyQuery;
    qryMasterHelper: TZReadOnlyQuery;
    qryLastId: TZReadOnlyQuery;
    qryCompareMasterSlave: TZReadOnlyQuery;
    qrySlaveHelper: TZReadOnlyQuery;
  strict private
    FStartId: Integer;
    FLastId: Integer;
    FSelectRange: Integer;
    FPacketRange: Integer;
    FSessionNumber: Integer;
    FMsgProc: TNotifyMessage;
    FStopped: Boolean;
    FWriteCommands: Boolean;
    FCommandData: TCommandData;
    FFailCmds: TCommandData;
    FReplicaFinished: TReplicaFinished;
    FOnChangeStartId: TOnChangeStartId;
    FOnNewSession: TOnNewSession;
    FOnEndSession: TNotifyEvent;
  strict private
    procedure ApplyConnectionConfig(AConnection: TZConnection; ARank: TServerRank);
    procedure ExecuteCommandsOneByOne;
    procedure ExecuteErrCommands;
    procedure LogMsg(const AMsg, AFileName: string); overload;
    procedure LogMsg(const AMsg: string); overload;
    procedure LogMsg(const AMsg: string; const aUID: Cardinal); overload;
  strict private
    procedure SetStartId(const AValue: Integer);
  strict private
    function IsConnected(AConnection: TZConnection; ARank: TServerRank): Boolean;
  public
    constructor Create(AOwner: TComponent; const AStartId, ASelectRange, APacketRange: Integer; AMsgProc: TNotifyMessage); reintroduce;
    destructor Destroy; override;

    property OnChangeStartId: TOnChangeStartId read FOnChangeStartId write FOnChangeStartId;
    property OnNewSession: TOnNewSession read FOnNewSession write FOnNewSession;
    property OnEndSession: TNotifyEvent read FOnEndSession write FOnEndSession;
    property StartId: Integer read FStartId write SetStartId;
    property SelectRange: Integer read FSelectRange write FSelectRange;
    property ReplicaFinished: TReplicaFinished read FReplicaFinished;

    function ExecutePreparedPacket: Integer;
    function GetCompareMasterSlaveSQL(const ADeviationsOnly: Boolean): string;
    function IsMasterConnected: Boolean;
    function IsSlaveConnected: Boolean;
    function IsBothConnected: Boolean;
    function GetReplicaCmdCount: Integer;
    function GetMinMaxId: TMinMaxId;
    function MinID: Integer;
    function MaxID: Integer;

    procedure StopReplica;
    procedure ExecuteAllPackets;
    procedure BuildReplicaCommandsSQL(const AStartId, ARange: Integer);
  end;

  TWorkerThread = class(TThread)
  strict private
    FStartId: Integer;
    FSelectRange: Integer;
    FPacketRange: Integer;
    FMsgProc: TNotifyMessage;
    FData: TdmData;
    FOnChangeStartId: TOnChangeStartId;
    FOnNewSession: TOnNewSession;
    FOnEndSession: TNotifyEvent;
  strict private
    procedure InnerChangeStartId(const ANewStartId: Integer);
    procedure InnerNewSession(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer);
    procedure InnerEndSession(Sender: TObject);
  strict private
    function GetReturnValue: Integer;
  protected
    procedure InnerMsgProc(const AMsg, AFileName: string; const aUID: Cardinal);
    procedure MySleep(const AInterval: Cardinal);
    property Data: TdmData read FData;
  public
    constructor Create(CreateSuspended: Boolean; const AStartId, ASelectRange, APacketRange: Integer;
      AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce;
    destructor Destroy; override;
    procedure Stop;
    property OnChangeStartId: TOnChangeStartId read FOnChangeStartId write FOnChangeStartId;
    property OnNewSession: TOnNewSession read FOnNewSession write FOnNewSession;
    property OnEndSession: TNotifyEvent read FOnEndSession write FOnEndSession;
    property MyReturnValue: Integer read GetReturnValue;
  end;

  TSinglePacket = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TMinMaxIdThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TReplicaThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TCompareMasterSlaveThread = class(TWorkerThread)
  strict private
    FDeviationsOnly: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended, ADeviationsOnly: Boolean; AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Winapi.Windows,
  System.Math,
  ZDbcIntfs,
  UConstants,
  USettings,
  UCommon;

const
  cAttempt1 = '№1 <%d-%d>  tranId=<%d-%d>  %d записей   за %s  %s';
  cAttempt2 = '№2 <%d-%d>  ok = %d   error = %d   за %s';
  cAttempt3 = '№3 <%d-%d>  ok = %d   error = %d   за %s';
  cWrongRange = 'Ожидается, что MaxId > StartId, а имеем MaxId = %d, StartId = %d';
  cWaitNextMsg = 500;


{ TdmData }

procedure TdmData.ApplyConnectionConfig(AConnection: TZConnection; ARank: TServerRank);
var
  sHost, sDatabase, sUser, sPassword: string;
  iPort: Integer;
begin
  iPort := TSettings.DefaultPort;

  case ARank of
    srMaster:
      begin
        sHost     := TSettings.MasterServer;
        sDatabase := TSettings.MasterDatabase;
        iPort     := TSettings.MasterPort;
        sUser     := TSettings.MasterUser;
        sPassword := TSettings.MasterPassword;
      end;
    srSlave:
      begin
        sHost     := TSettings.SlaveServer;
        sDatabase := TSettings.SlaveDatabase;
        iPort     := TSettings.SlavePort;
        sUser     := TSettings.SlaveUser;
        sPassword := TSettings.SlavePassword;
      end;
  end;

  with AConnection do
  begin
    Disconnect;
    HostName := sHost;
    Database := sDatabase;
    Port     := iPort;
    User     := sUser;
    Password := sPassword;

    LibraryLocation := TSettings.LibLocation;
//    Properties.Add('timeout=1');// таймаут сервера - 1 секунда
  end;
end;

procedure TdmData.BuildReplicaCommandsSQL(const AStartId, ARange: Integer);
const
  cGetSQL       = 'формирование SQL ...';
  cFetch        = 'получение записей ...';
  cElapsedFetch = '%s записей получено за %s';
  cBuild        = 'запись данных в локальное хранилище ...';
  cElapsedBuild = '%s записей в локальное хранилище за %s';
var
  crdStartFetch, crdStartBuild{, crdLastId}: Cardinal;
  dtmStart: TDateTime;
begin
  if FStopped then Exit;

  Inc(FSessionNumber);
  FLastId := -1;
  dtmStart := Now;
  crdStartFetch := GetTickCount;

  qrySelectReplicaCmd.Close;
  qrySelectReplicaCmd.SQL.Clear;

  if IsMasterConnected then
  try
    LogMsg(cGetSQL, crdStartFetch);
    with qrySelectReplicaSQL do // результат запроса содержит SQL-текст, записанный в виде набора строк
    begin
      Close;
      ParamByName('id_start').AsInteger  := AStartId;
      ParamByName('rec_count').AsInteger := ARange;
      Open;
      First;
      while not EOF and not FStopped do
      begin
        if not Fields[0].IsNull then
          qrySelectReplicaCmd.SQL.Add(Fields[0].AsString);
        Next;
      end;
      Close;
    end;

    // qrySelectReplicaCmd вернет набор команд репликации (INSERT, UPDATE, DELETE) в поле Result,
    // которые могут быть выполнены пакетами с помощью conSlave
    LogMsg(cFetch, crdStartFetch);
    qrySelectReplicaCmd.Open;
    qrySelectReplicaCmd.FetchAll;
    qrySelectReplicaCmd.First;
    FStartId := qrySelectReplicaCmd.FieldByName('Id').AsInteger; // откорректируем значение StartId в соответствии с реальными данными
    TSettings.ReplicaStart := StartId;
    LogMsg(Format(cElapsedFetch, [IntToStr(qrySelectReplicaCmd.RecordCount), Elapsed(crdStartFetch)]), crdStartFetch);

    // строим свой массив данных, который позволит выбирать записи пакетами с учетом границ transaction_id
    crdStartBuild := GetTickCount;
    LogMsg(cBuild, crdStartBuild);
    FCommandData.BuildData(qrySelectReplicaCmd);
    qrySelectReplicaCmd.Close;
    LogMsg(Format(cElapsedBuild, [IntToStr(FCommandData.Count), Elapsed(crdStartBuild)]), crdStartBuild);

    FCommandData.Last; //чтобы прочитать MaxId

    // показать инфу о новой сессии в GUI
    if Assigned(FOnNewSession) then
      FOnNewSession(dtmStart, FStartId, FCommandData.Data.Id, FCommandData.Count, FSessionNumber);

    // сохраним правую границу диапазона для последующего использования
    with qryLastId do
    begin
//      crdLastId := GetTickCount;
      Close;
      ParamByName('id_start').AsInteger  := AStartId;
      ParamByName('rec_count').AsInteger := ARange;
      Open;
      if not Fields[0].IsNull then
        FLastId := Fields[0].AsInteger;

//      LogMsg('Получение LastId за ' + Elapsed(crdLastId));
    end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

constructor TdmData.Create(AOwner: TComponent; const AStartId, ASelectRange, APacketRange: Integer; AMsgProc: TNotifyMessage);
begin
  inherited Create(AOwner);

  FStartId := AStartId;
  FMsgProc := AMsgProc;

  FSelectRange := ASelectRange;
  FPacketRange := APacketRange;

  FCommandData := TCommandData.Create;
  FFailCmds    := TCommandData.Create;

  FReplicaFinished := rfComplete;
end;

destructor TdmData.Destroy;
begin
  conMaster.Disconnect;
  conSlave.Disconnect;

  FreeAndNil(FCommandData);
  FreeAndNil(FFailCmds);
  inherited;
end;

procedure TdmData.ExecuteAllPackets;
var
  iPrevStartId: Integer;
begin
  iPrevStartId := -1;
  FStopped := False;

  try
  
    // MaxID - это ф-ия, которая возвращает 'select Max(Id) from _replica.table_update_data'
    while (FStartId > iPrevStartId) and (FStartId <= MaxID) and not FStopped do
    begin
      // Успешное выполнение методов репликации должно увеличивать FStartId и в конце итерации это значение обычно должно быть больше предыдущего.
      // Возможен сценарий, когда в пакете нет ни одной команды. В этом случае FStartId останется неизменным.
      // Сохраним предыдущеее значение FStartId, чтобы потом сравнить его с текущим значением FStartId
      // и избежать бесконечного цикла для случая, когда в пакете нет ни одной команды.
      iPrevStartId := FStartId;

      // Формируем набор команд в дипазоне StartId..(StartId + SelectRange) - это сессия
      // FStartId увеличивается в процессе выполнения команд
      // Реальная правая граница может быть > (FStartId + FSelectRange), потому что BuildReplicaCommandsSQL учитывает номера транзакций
      // и обеспечивает условие, чтобы записи с одинаковыми номерами транзакций были в одном наборе
      BuildReplicaCommandsSQL(FStartId, FSelectRange);

      // Передаем команды из дипазона StartId..(StartId + SelectRange) порциями
      while (FStartId < FLastId) and not FStopped do
      begin
        // проверяем, нужно ли записывать текст команд в файл
        FWriteCommands := TSettings.WriteCommandsToFile;

        // Сначала попробуем передать данные целым пакетом. Id записей пакета в диапазоне FStartId..(FStartId + FPacketRange)
        if ExecutePreparedPacket = 0 then // если передача пакета завершилась неудачей
          ExecuteCommandsOneByOne; // выполняем команды по одной. Id и SQL невыполненных команд сохраняем в FFailCmds

        // Выполняем команды, которые не удалось выполнить на этапе "по одной команде"
        if FFailCmds.Count > 0 then
          ExecuteErrCommands;
      end;

      // сессия закончена, передаем инфу в GUI
      if Assigned(FOnEndSession) then
        FOnEndSession(nil);
    end;

  except
    on E: Exception do
    begin
      FReplicaFinished := rfErrStopped;
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TdmData.ExecuteCommandsOneByOne; // предполагается использовать внутри ExecuteAllPackets после неудачи ExecutePreparedPacket
var
  iStartId, iMaxId, iSuccCount, iFailCount: Integer;
  crdStart, crdLogMsg: Cardinal;
begin
  // будем выполнять команды по одной
  if FStopped then Exit;

  crdStart := GetTickCount;

  try
    iMaxId := FStartId + FPacketRange;
    iMaxId := FCommandData.NearestId(iMaxId);

    if FStartId >= iMaxId then
    begin 
      LogMsg(Format(cWrongRange, [iMaxId, FStartId]));
      FStopped := True;
      FReplicaFinished := rfErrStopped;
      Exit;
    end;      

    FCommandData.MoveToId(FStartId);
    iStartId   := FStartId;
    iSuccCount := 0;
    iFailCount := 0;

    // строка "№2 <56477135-56513779> ок = 0 записей error = 0 записей за  "
    LogMsg(Format(cAttempt2, [iStartId, iMaxId, iSuccCount, iFailCount, EmptyStr]), crdStart);
    crdLogMsg := GetTickCount;
    
    try
      
      while not FCommandData.EOF and (FCommandData.Data.Id <= iMaxId) and not FStopped do
      begin
        try
          if IsSlaveConnected then
            with conSlave.DbcConnection do
            begin
              SetAutoCommit(False);
              PrepareStatement(FCommandData.Data.SQL).ExecutePrepared;
              Commit;
              Inc(iSuccCount);
            end;
        except
          on E: Exception do
          begin
            conSlave.DbcConnection.Rollback;
            // Id и SQL невыполненных  команд сохраняем в FFailCmds
            FFailCmds.Add(FCommandData.Data.Id, FCommandData.Data.TransId, FCommandData.Data.SQL);
            Inc(iFailCount);
          end;
        end;

        // Команды выполняются быстро и в большом количестве, но текст сообщений при этом отличается несущественно.
        // Кроме того, в файл будет сохранено только последнее сообщение. Этот спам может подвесить программу.
        // Для того, чтобы уменьшить поток сообщений, будем передавать только некоторые  из них с интервалом cWaitNextMsg.
        if (GetTickCount - crdLogMsg) > cWaitNextMsg then
        begin 
          LogMsg(Format(cAttempt2, [iStartId, iMaxId, iSuccCount, iFailCount, Elapsed(crdStart)]), crdStart);
          crdLogMsg := GetTickCount; 
        end;       

        FCommandData.Next;
        // FCommandData.Data.Id содержит table_update_data.Id
        StartId := FCommandData.Data.Id; // используем св-во StartId, а не FStartId, чтобы возбудить событие OnChangeStartId
      end;
        
    finally
      // обязательно записываем в лог последнее сообщение 
      LogMsg(Format(cAttempt2, [iStartId, iMaxId, iSuccCount, iFailCount, Elapsed(crdStart)]), crdStart);
    end;      
    
  finally
    TSettings.ReplicaStart := StartId; // сохранить в настройках актуальное значение StartId
  end;
end;

procedure TdmData.ExecuteErrCommands;
var
  iStartId, iEndId, iSuccCount, iFailCount: Integer;
  crdStart, crdLogMsg: Cardinal;
  sFileName: string;
const
  cFileName  = '\Err_commands\%s';
  cFileErr   = '%s__ERR_id-%d.txt';
begin
  // FFailCmds содержит команды, которые не удалось выполнить в пакетной выгрузке и в выгрузке "по одной команде"

  if FStopped then Exit;

  crdStart := GetTickCount;

  FFailCmds.Last;
  iEndId := FFailCmds.Data.Id;

  FFailCmds.First;
  iStartId := FFailCmds.Data.Id;

  iSuccCount := 0;
  iFailCount := 0;

  if FFailCmds.Count > 0 then
  begin 
    // строка "№3 <56477135-56513779> ок = 25 записей за  "
    LogMsg(Format(cAttempt3, [iStartId, iEndId, iSuccCount, iFailCount, EmptyStr]), crdStart);
    crdLogMsg := GetTickCount;
    
    try

      while not FFailCmds.EOF and not FStopped do
      begin
        try
          if IsSlaveConnected then
            with conSlave.DbcConnection do
            begin
              SetAutoCommit(False);
              PrepareStatement(FFailCmds.Data.SQL).ExecutePrepared;
              Commit;
              Inc(iSuccCount);
            end;
        except
          on E: Exception do
          begin
            conSlave.DbcConnection.Rollback;

            // команды, которые так и не были выполнены, пишем в лог
            if FWriteCommands then
            begin
              sFileName := Format(cFileName, [
                Format(cFileErr, [
                  FormatDateTime(cDateTimeFileNameStr, Now),
                  FFailCmds.Data.Id
                ])
              ]);
              LogMsg(FFailCmds.Data.SQL, sFileName);
            end;

            Inc(iFailCount);
          end;
        end;

        if (GetTickCount - crdLogMsg) > cWaitNextMsg then
        begin 
          // строка "№3 <56477135-56513779> ок = 25 записей за 00:00:2_225"
          LogMsg(Format(cAttempt3, [iStartId, iEndId, iSuccCount, iFailCount, Elapsed(crdStart)]), crdStart);
          crdLogMsg := GetTickCount; 
        end;         

        FFailCmds.Next;
      end;
      
    finally
      // обязательно записываем в лог последнее сообщение 
      LogMsg(Format(cAttempt3, [iStartId, iEndId, iSuccCount, iFailCount, Elapsed(crdStart)]), crdStart);
    end;       
  end;

  if iFailCount > 0 then // всегда останавливаем реплику, если остались невыполненные команды
  begin
    FStopped := True;
    FReplicaFinished := rfErrStopped;
  end;

  FFailCmds.Clear;
  Sleep(25);
end;

function TdmData.ExecutePreparedPacket: Integer;
var
  bStopIfError: Boolean;
  crdStart: Cardinal;
  iMaxId, iStartId, iRecCount: Integer;
  iStartTrans, iEndTrans: Integer;
  sFileName: string;
  tmpSL: TStringList;
  tmpStmt: IZPreparedStatement;
const
  cFileName = '\Packets\%s';
  cFileOK   = '%s__id-%d-%d.txt';
  cFileErr  = '%s__ERR_id-%d-%d.txt';
begin
  Result := 0;

  if FStopped then Exit;

  bStopIfError := TSettings.StopIfError;

  iStartId := FStartId;
  crdStart := GetTickCount;

  iMaxId := FStartId + FPacketRange;
  iMaxId := FCommandData.NearestId(iMaxId);

  if iStartId >= iMaxId then
  begin 
    LogMsg(Format(cWrongRange, [iMaxId, iStartId]));
    FStopped := True;
    FReplicaFinished := rfErrStopped;
    Exit;
  end;
    
  FCommandData.MoveToId(iMaxId);
  iEndTrans := FCommandData.Data.TransId;

  FCommandData.MoveToId(FStartId);
  iStartTrans := FCommandData.Data.TransId;

  iRecCount := FCommandData.RecordCount(FStartId, iMaxId);
//  LogMsg('Подготовка ExecutePreparedPacket за ' + Elapsed(crdStart));

  // строка  "№1 Id=<56477135-56513779> tranId=<677135-63779> 3500 записей за  "
  LogMsg(Format(cAttempt1, [iStartId, iMaxId, iStartTrans, iEndTrans, iRecCount, '', '']), crdStart);

  tmpSL := TStringList.Create;
  try
    with FCommandData do
    begin
      MoveToId(FStartId);
      while not EOF and (Data.Id <= iMaxId) and not FStopped do
      begin
        tmpSL.Add(Data.SQL);
        Next;
      end;
    end;

    try
      // пакетная выгрузка (сделано по образцу кода из Release Notes "2.1.3 Batch Loading")
      if (tmpSL.Count > 0) and IsSlaveConnected and not FStopped then
      begin
        conSlave.DbcConnection.SetAutoCommit(False);
        tmpStmt := conSlave.DbcConnection.PrepareStatement(tmpSL.Text);
        Result := tmpStmt.ExecuteUpdatePrepared;
        conSlave.DbcConnection.Commit;

        // пакет успешно выполнен и можем передвинуть StartId на новую позицию
        // - сначала перемещаемся на правую границу диапазона
        // - последовательность Id может иметь разрывы, например 48256, 48257, 48351, 48352
        //   поэтому вместо iMaxId + 1 используем Next
        FCommandData.MoveToId(iMaxId);
        FCommandData.Next;

        if FCommandData.EOF then // если достигли правой границы диапазона,
          StartId := iMaxId + 1  // тогда используем  iMaxId + 1, чтобы не выполнить последнюю команду пакета еще раз в новом пакете
        else
          StartId := FCommandData.Data.Id;

        TSettings.ReplicaStart := StartId;

        // запись успешного пакета в файл
        if FWriteCommands then
        begin
          sFileName := Format(cFileName, [
            Format(cFileOK, [
              FormatDateTime(cDateTimeFileNameStr, Now),
              iStartId,
              iMaxId
            ])
          ]);
          LogMsg(tmpSL.Text, sFileName);
        end;

        // строка  "№1 Id=<56477135-56513779> tranId=<677135-63779> 3500 записей за 00:00:00_212"
        LogMsg(Format(cAttempt1, [iStartId, iMaxId, iStartTrans, iEndTrans, iRecCount, Elapsed(crdStart), '']), crdStart);
      end;
    except
      on E: Exception do
      begin
        conSlave.DbcConnection.Rollback;

        // запись сбойного пакета в файл
        if FWriteCommands then
        begin
          sFileName := Format(cFileName, [
            Format(cFileErr, [
              FormatDateTime(cDateTimeFileNameStr, Now),
              iStartId,
              iMaxId
            ])
          ]);
          LogMsg(tmpSL.Text, sFileName);
        end;

        if bStopIfError then
        begin
          FStopped := True;
          FReplicaFinished := rfErrStopped;
        end;

        // строка  "№1 Id=<56477135-56513779> tranId=<677135-63779> 3500 записей за 00:00:00_212 error"
        LogMsg(Format(cAttempt1, [iStartId, iMaxId, iStartTrans, iEndTrans, iRecCount, Elapsed(crdStart), 'error']), crdStart);
      end;
    end;
  finally
    FreeAndNil(tmpSL);
  end;
end;

function TdmData.GetReplicaCmdCount: Integer;
const
  cSQL = 'select Count(*) from (%s) as Commands';
begin
  Result := 0;

  try
    // берем предварительно сформированный SQL из qrySelectReplicaCmd
    if IsMasterConnected and (Length(qrySelectReplicaCmd.SQL.Text) > 0) then
      with qryMasterHelper do
      begin
        Close;
        SQL.Text := Format(cSQL, [qrySelectReplicaCmd.SQL.Text]);
        Open;
        if not Fields[0].IsNull then
          Result := Fields[0].AsInteger;
        Close;
      end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.IsBothConnected: Boolean;
begin
  Result := IsMasterConnected and IsSlaveConnected;
end;

function TdmData.IsConnected(AConnection: TZConnection; ARank: TServerRank): Boolean;
begin
  Result := AConnection.Connected;
  if Result then Exit;

  try
    ApplyConnectionConfig(AConnection, ARank);
    AConnection.Connect;
    Result := AConnection.Connected;
  except
    on E: Exception do
    begin
      Result := False;
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

function TdmData.IsMasterConnected: Boolean;
begin
  Result := IsConnected(conMaster, srMaster);
end;

function TdmData.IsSlaveConnected: Boolean;
begin
  Result := IsConnected(conSlave, srSlave);
end;

procedure TdmData.LogMsg(const AMsg: string; const aUID: Cardinal);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, EmptyStr, aUID);
end;

procedure TdmData.LogMsg(const AMsg: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg);
end;

procedure TdmData.LogMsg(const AMsg, AFileName: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, AFileName);
end;

function TdmData.GetCompareMasterSlaveSQL(const ADeviationsOnly: Boolean): string;
type
  TTableData = record
    Name: string;
    MasterCount: Integer;
    SlaveCount: Integer;
    CountSQL: string;
  end;
const
  cSelect        = 'SELECT * FROM _replica.gpSelect_Replica_tables()';
  cSelectUnion   = 'SELECT ''%s'' as TableName, %d AS CountMaster, %d AS CountSlave';
  cSelectCount   = 'SELECT COUNT(*) AS RecCount FROM %s';
  cSelectCountId = 'SELECT COUNT(Id) AS RecCount FROM %s';
  cUnion         = ' UNION ALL ';
var
  I: Integer;
  arrTables: array of TTableData;
  sTableName, sSQL: string;
begin
  Result := Format(cSelectUnion, ['<нет данных>', 0, 0]) + ';';

  try
    // строим массив имен таблиц
    if IsSlaveConnected then
      with qrySlaveHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(cSelect);
        Open;
        FetchAll;
        if IsEmpty then Exit;

        First;
        while not EOF do
        begin
          if not FieldByName('Master_table').IsNull then
          begin
            sTableName := FieldByName('Master_table').AsString;
            if Length(Trim(sTableName)) > 0 then
            begin
              SetLength(arrTables, Length(arrTables) + 1);
              arrTables[High(arrTables)].Name := sTableName;
            end;
          end;

          Next;
        end;
      end;

    // Вычисляем Count(*) для таблиц из массива arrTables.
    // Для 'MovementItemContainer' отдельный случай: select Count(Id).

    // сначала формируем текст запроса
    for I := Low(arrTables) to High(arrTables) do
      if arrTables[I].Name = 'MovementItemContainer'  then
        arrTables[I].CountSQL := Format(cSelectCountId, [arrTables[I].Name])
      else
        arrTables[I].CountSQL := Format(cSelectCount, [arrTables[I].Name]);

    // теперь выполняем запрос для каждой таблицы
    for I := Low(arrTables) to High(arrTables) do
    begin
      // для таблиц сервера Master
      if IsMasterConnected then
        with qryMasterHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(arrTables[I].CountSQL);
          Open;
          if not Fields[0].IsNull then
            arrTables[I].MasterCount := Fields[0].AsInteger;
          Close;
        end;

      // для таблиц сервера Slave
      if IsSlaveConnected then
        with qrySlaveHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(arrTables[I].CountSQL);
          Open;
          if not Fields[0].IsNull then
            arrTables[I].MasterCount := Fields[0].AsInteger;
          Close;
        end;
    end;

    // формируем текст запроса SELECT UNION, используя данные массива arrTables
    sSQL := '';
    for I := Low(arrTables) to High(arrTables) do
    begin
      if ADeviationsOnly then
        if arrTables[I].MasterCount = arrTables[I].SlaveCount then Continue;

      if Length(sSQL) = 0 then
        sSQL := Format(cSelectUnion, [arrTables[I].Name, arrTables[I].MasterCount, arrTables[I].SlaveCount])
      else
        sSQL := sSQL + cUnion + Format(cSelectUnion, [arrTables[I].Name, arrTables[I].MasterCount, arrTables[I].SlaveCount]);
    end;

    if Length(sSQL) > 0 then
      Result := sSQL + ';';
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.GetMinMaxId: TMinMaxId;
const
  cSelect = 'SELECT * FROM _replica.gpSelect_MinMaxId()';
begin
  Result.MinId := -1;
  Result.MaxId := -1;
  Result.RecCount := 0;

  try
    if IsMasterConnected then
      with qryMasterHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(cSelect);
        Open;

        if not FieldByName('MinId').IsNull then
          Result.MinId := FieldByName('MinId').AsInteger;

        if not FieldByName('MaxId').IsNull then
          Result.MaxId := FieldByName('MaxId').AsInteger;

        if not FieldByName('RecCount').IsNull then
          Result.RecCount := FieldByName('RecCount').AsInteger;

        Close;
      end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.MaxID: Integer;
const
  cSelect = 'select * from _replica.gpSelect_MaxId()';
begin
  Result := -1;
  try
    if IsMasterConnected then
      with qryMasterHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(cSelect);
        Open;

        if not Fields[0].IsNull then
          Result := Fields[0].AsInteger;

        Close;
      end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.MinID: Integer;
const
  cSelect = 'select * from _replica.gpSelect_MinId()';
begin
  Result := -1;
  try
    if IsMasterConnected then
      with qryMasterHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(cSelect);
        Open;

        if not Fields[0].IsNull then
          Result := Fields[0].AsInteger;

        Close;
      end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TdmData.SetStartId(const AValue: Integer);
begin
  if FStartId <> AValue then
  begin
    FStartId := AValue;
    if Assigned(FOnChangeStartId) then
      FOnChangeStartId(FStartId);
  end;
end;

procedure TdmData.StopReplica;
begin
  FStopped := True;
  FReplicaFinished := rfStopped;
end;

{ TWorkerThread }

constructor TWorkerThread.Create(CreateSuspended: Boolean; const AStartId, ASelectRange, APacketRange: Integer;
  AMsgProc: TNotifyMessage; AKind: TThreadKind);
begin
  FStartId := AStartId;
  FMsgProc := AMsgProc;

  FSelectRange := ASelectRange;
  FPacketRange := APacketRange;

  FData := TdmData.Create(nil, FStartId, FSelectRange, FPacketRange, InnerMsgProc);
  FData.OnChangeStartId := InnerChangeStartId;
  FData.OnNewSession    := InnerNewSession;
  FData.OnEndSession    := InnerEndSession;

  FreeOnTerminate := (AKind = tknNondriven);

  inherited Create(CreateSuspended);
end;

destructor TWorkerThread.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

function TWorkerThread.GetReturnValue: Integer;
begin
  Result := ReturnValue;
end;

procedure TWorkerThread.InnerChangeStartId(const ANewStartId: Integer);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FOnChangeStartId) then FOnChangeStartId(ANewStartId);
                     end);
end;

procedure TWorkerThread.InnerEndSession(Sender: TObject);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FOnEndSession) then FOnEndSession(nil);
                     end);
end;

procedure TWorkerThread.InnerMsgProc(const AMsg, AFileName: string; const aUID: Cardinal);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FMsgProc) then FMsgProc(AMsg, AFileName, aUID);
                     end);
end;

procedure TWorkerThread.InnerNewSession(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FOnNewSession) then FOnNewSession(AStart, AMinId, AMaxId, ARecCount, ASessionNumber);
                     end);
end;

procedure TWorkerThread.MySleep(const AInterval: Cardinal);
var
  Start: Cardinal;
begin
  // метод имитирует действие стандартного Sleep, но в отличие от него может выйти досрочно если поток Terminated
  Start := GetTickCount;
  while ((GetTickCount - Start) < AInterval) and not Terminated do
    Sleep(1);
end;

procedure TWorkerThread.Stop;
begin
  Data.StopReplica;
end;

{ TSinglePacket }

procedure TSinglePacket.Execute;
begin
  inherited;
  Data.BuildReplicaCommandsSQL(Data.StartId, Data.SelectRange);
  ReturnValue := Data.ExecutePreparedPacket;
end;

{ TReplicaThread }

procedure TReplicaThread.Execute;
begin
  inherited;
  Data.ExecuteAllPackets;
  ReturnValue := Ord(Data.ReplicaFinished);
  Terminate;
end;

{ TMinMaxIdThread }

procedure TMinMaxIdThread.Execute;
var
  P: PMinMaxId;
  tmpMinMax: TMinMaxId;
begin
  inherited;
  tmpMinMax := Data.GetMinMaxId;

  New(P);
  P^.MinId := tmpMinMax.MinId;
  P^.MaxId := tmpMinMax.MaxId;
  P^.RecCount := tmpMinMax.RecCount;
  ReturnValue := LongWord(P);
  Terminate;
end;


{ TCompareMasterSlaveThread }

constructor TCompareMasterSlaveThread.Create(CreateSuspended, ADeviationsOnly: Boolean; AMsgProc: TNotifyMessage;
  AKind: TThreadKind);
begin
  FDeviationsOnly := ADeviationsOnly;
  inherited Create(CreateSuspended, 0, 0, 0, AMsgProc, AKind);
end;

procedure TCompareMasterSlaveThread.Execute;
var
  P: PCompareMasterSlave;
  sSQL: string;
begin
  inherited;
  sSQL := Data.GetCompareMasterSlaveSQL(FDeviationsOnly);

  New(P);
  P^.ResultSQL := sSQL;
  ReturnValue := LongWord(P);
  Terminate;
end;

end.
