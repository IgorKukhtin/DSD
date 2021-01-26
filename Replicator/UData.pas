unit UData;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Generics.Collections,
  System.ImageList,
  Data.DB,
  Vcl.ImgList,
  Vcl.Controls,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZDataset,
  UDefinitions,
  UCommandData;

type
  TWorkerThread = class;
  TMoveErrorsThread = class;

  TdmData = class(TDataModule)
    conMaster: TZConnection;
    conSlave: TZConnection;
    qrySelectReplicaSQL: TZReadOnlyQuery;
    qrySelectReplicaCmd: TZReadOnlyQuery;
    qryMasterHelper: TZReadOnlyQuery;
    qryLastId: TZReadOnlyQuery;
    qryCompareRecCountMS: TZReadOnlyQuery;
    qrySlaveHelper: TZReadOnlyQuery;
    qryCompareSeqMS: TZReadOnlyQuery;
    il16: TImageList;
    qrySnapshotTables: TZReadOnlyQuery;
  strict private
    FStartId: Int64;
    FLastId: Int64;
    FSelectRange: Integer;
    FPacketRange: Integer;
    FPacketNumber: Integer; // порядковый номер пакета в сессии
    FSessionNumber: Integer;
    FMsgProc: TNotifyMessage;
    FStopped: Boolean;
    FWriteCommands: Boolean;
    FStartReplicaAttempt: Integer; // номер попытки начать репликацию
    FClient_Id: Int64;// идентфикатор базы данных slave
    FCommandData: TCommandData;
    FFailCmds: TCommandData;
    FReplicaFinished: TReplicaFinished;
    FMoveErrorsThrd: TMoveErrorsThread;
    FMoveErrorsThrdFinished: Boolean;
    FOnChangeStartId: TOnChangeStartId;
    FOnNewSession: TOnNewSession;
    FOnEndSession: TNotifyEvent;
    FOnNeedRestart: TNotifyEvent;
    FOnCompareRecCountMS: TOnCompareRecCountMS;

  strict private
    procedure ApplyConnectionConfig(AConnection: TZConnection; ARank: TServerRank);
    procedure BuildReplicaCommandsSQL(const AStartId: Int64; const ARange: Integer);
    procedure ExecuteCommandsOneByOne;
    procedure ExecuteErrCommands;
    procedure LogMsg(const AMsg: string); overload;
    procedure LogMsg(const AMsg: string; const aUID: Cardinal); overload;
    procedure LogErrMsg(const AMsg: string);
    procedure LogMsgFile(const AMsg, AFileName: string);
    procedure OnTerminateMoveErrors(Sender: TObject);
    procedure FetchSequences(AServer: TServerRank; out ASeqDataArr: TSequenceDataArray);
    procedure SaveValueInDB(const AValue: Int64; const AFieldName: string; const ASaveInMaster: Boolean = True);
    procedure SaveErrorInMaster(const AStep: Integer; const AStartId, ALastId, AClientId: Int64; const AErrDescription: string);

  strict private
    procedure SetStartId(const AValue: Int64);
    function GetLastId: Int64;
    procedure SetLastId(const AValue: Int64);
    function GetLastId_DDL: Int64;
    procedure SetLastId_DDL(const AValue: Int64);

  strict private
    function ApplyScriptsFor(AScriptsContent, AScriptNames: TStrings; AServer: TServerRank): TApplyScriptResult;
    function ExecutePreparedPacket: Integer;
    function ExecuteReplica: TReplicaFinished;
    function IsConnected(AConnection: TZConnection; ARank: TServerRank): Boolean;
    function IsConnectionAlive(AConnection: TZConnection): Boolean;
    function IsBothConnectionsAlive: Boolean;
    function GetSlaveValues: TSlaveValues;
    function GetMasterValues(const AClientId: Int64): TMasterValues;
    function SaveErrorInDB(AServerRank: TServerRank; const AStep: Integer; const AStartId, ALastId, AClientId: Int64;
      const AErrDescription: string): Boolean;

  protected
    property StartId: Int64 read FStartId write SetStartId;
    property LastId_DDL: Int64 read GetLastId_DDL write SetLastId_DDL;

  public
    constructor Create(AOwner: TComponent; AMsgProc: TNotifyMessage); reintroduce; overload;
    constructor Create(AOwner: TComponent; const AStartId: Int64; const ASelectRange, APacketRange: Integer;
      AMsgProc: TNotifyMessage); reintroduce; overload;
    destructor Destroy; override;

    property OnChangeStartId: TOnChangeStartId read FOnChangeStartId write FOnChangeStartId;
    property OnNewSession: TOnNewSession read FOnNewSession write FOnNewSession;
    property OnEndSession: TNotifyEvent read FOnEndSession write FOnEndSession;
    property OnNeedRestart: TNotifyEvent read FOnNeedRestart write FOnNeedRestart;
    property OnCompareRecCountMS: TOnCompareRecCountMS read FOnCompareRecCountMS write FOnCompareRecCountMS;
    property SelectRange: Integer read FSelectRange write FSelectRange;
    property LastId: Int64 read GetLastId write SetLastId;
    property ReplicaFinished: TReplicaFinished read FReplicaFinished;

    function ApplyScripts(AScriptsContent, AScriptNames: TStrings): TApplyScriptResult;
    function GetCompareRecCountMS_SQL(const ADeviationsOnly: Boolean): string;
    function GetCompareSeqMS_SQL(const ADeviationsOnly: Boolean): string;
    function IsMasterConnected: Boolean;
    function IsSlaveConnected: Boolean;
    function IsBothConnected: Boolean;
    function GetReplicaCmdCount: Integer;
    function GetMinMaxId: TMinMaxId;
    function MinID: Int64;
    function MaxID: Int64;
    function InitConnection(AConnection: TZConnection; ARank: TServerRank): boolean;

    procedure AlterSlaveSequences;
    procedure MoveSavedProcToSlave;
    procedure MoveErrorsFromSlaveToMaster;
    procedure StartReplica;
    procedure StopReplica;
  end;

  TWorkerThread = class(TThread)
  strict private
    FStartId: Int64;
    FSelectRange: Integer;
    FPacketRange: Integer;
    FMsgProc: TNotifyMessage;
    FData: TdmData;
    FOnChangeStartId: TOnChangeStartId;
    FOnNewSession: TOnNewSession;
    FOnEndSession: TNotifyEvent;
    FOnNeedRestart: TNotifyEvent;
  strict private
    procedure InnerChangeStartId(const ANewStartId: Int64);
    procedure InnerNewSession(const AStart: TDateTime; const AMinId, AMaxId: Int64; const ARecCount, ASessionNumber: Integer);
    procedure InnerEndSession(Sender: TObject);
    procedure InnerNeedRestart(Sender: TObject);
  protected
    FReturnValue: Int64;
  protected
    procedure InnerMsgProc(const AMsg, AFileName: string; const aUID: Cardinal; AMsgType: TLogMessageType);
    procedure MySleep(const AInterval: Cardinal);
    property Data: TdmData read FData;
  public
    constructor Create(CreateSuspended: Boolean; const AStartId: Int64; const ASelectRange, APacketRange: Integer;
      AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce; overload;
    constructor Create(CreateSuspended: Boolean; AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce; overload;
    destructor Destroy; override;
    procedure Stop;
    property OnChangeStartId: TOnChangeStartId read FOnChangeStartId write FOnChangeStartId;
    property OnNewSession: TOnNewSession read FOnNewSession write FOnNewSession;
    property OnEndSession: TNotifyEvent read FOnEndSession write FOnEndSession;
    property OnNeedRestart: TNotifyEvent read FOnNeedRestart write FOnNeedRestart;
    property MyReturnValue: Int64 read FReturnValue;
  end;

  TSinglePacket = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TMinMaxIdThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TLastIdThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TReplicaThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TCompareRecCountMSThread = class(TWorkerThread)
  strict private
    FDeviationsOnly: Boolean;
    FOnCompareRecCountMS: TOnCompareRecCountMS;
  strict private
    procedure MyOnCompareRecCountMS(const aSQL: string);
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended, ADeviationsOnly: Boolean; AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce;
    property OnCompareRecCountMS: TOnCompareRecCountMS read FOnCompareRecCountMS write FOnCompareRecCountMS;
  end;

  TCompareSeqMSThread = class(TWorkerThread)
  strict private
    FDeviationsOnly: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended, ADeviationsOnly: Boolean; AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce;
  end;

  TApplyScriptThread = class(TWorkerThread)
  strict private
    FScriptsContent: TStringList;
    FScriptNames: TStringList;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; AScriptsContent, AScriptNames: TStrings; AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce;
    destructor Destroy; override;
  end;

  TMoveProcToSlaveThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TAlterSlaveSequencesThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TMoveErrorsThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Winapi.Windows,
  System.Math,
  ZDbcIntfs,
  ZClasses,
  UConstants,
  USettings,
  UCommon;

const
  // Сообщения Шаг №1 - Шаг №3
  cAttempt1 = '№1 <%d-%d>  tranId=<%d-%d>  %d записей   за %s  %s';
  cAttempt2 = '№2 <%d-%d>  ok = %d   error = %d   за %s';
  cAttempt3 = '№3 <%d-%d>  ok = %d   error = %d   за %s';

  // номера шагов
  cStep1 = 1;
  cStep2 = 2;
  cStep3 = 3;

  // Сообщения об ошибке
  cWrongRange = 'Ожидается, что MaxId >= StartId, а имеем MaxId = %d, StartId = %d';
  cTransWrongRange = 'Команды с транзакциями из диапазона <%d-%d> уже выполнялись в другом пакете';

  // Пороговые значения
  cWaitNextMsg = 500;
  cSaveInMasterAfterNSessions = 100;


{ TdmData }

procedure TdmData.AlterSlaveSequences;
const
  cAlterSequence = 'alter sequence if exists public.%s increment %d restart with %d';
  cSuccess       = 'Последние значения последовательностей перенесены в Slave';
var
  I: Integer;
  arrSeq: TSequenceDataArray;
  sAlterSequence: string;
begin
  try
    // Сначала получим все последовательности Master и их последние значения
    FetchSequences(srMaster, arrSeq);

    if FStopped then Exit;

    // Теперь готов записать последние значения последовательностей в Slave
    if IsSlaveConnected and (Length(arrSeq) > 0) then
    begin
      for I := Low(arrSeq) to High(arrSeq) do
      begin
        if FStopped then Exit;

        sAlterSequence := Format(cAlterSequence, [arrSeq[I].Name, arrSeq[I].Increment, arrSeq[I].LastValue]);
        try
          with conSlave.DbcConnection do
          begin
            SetAutoCommit(False);
            PrepareStatement(sAlterSequence).ExecutePrepared;
            Commit;
          end;
        except
          on E: Exception do
          begin
            conSlave.DbcConnection.Rollback;
            LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
            Break;
          end;
        end;
      end;

      if FStopped then Exit;

      LogMsg(cSuccess);
    end;

  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

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

    { После потери коннекта и попытке переподключиться в методе BuildReplicaCommandsSQL
      возникает исключение "[EZSQLException] SQL Error: ОШИБКА:  подготовленный оператор "156270147041" не существует".
      Параметр 'EMULATE_PREPARES' применен по рекомендации на форуме ZeosLib https://zeoslib.sourceforge.io/viewtopic.php?t=10695  }
    Properties.Values['EMULATE_PREPARES'] := 'True';
  end;
end;

function TdmData.ApplyScripts(AScriptsContent, AScriptNames: TStrings): TApplyScriptResult;
var
  masterResult, slaveResult: TApplyScriptResult;
begin
  Result := asNoAction;
  masterResult := asError;
  slaveResult  := asError;


  if (AScriptsContent = nil) or (AScriptNames = nil) or (AScriptsContent.Count = 0) or (AScriptNames.Count = 0) then Exit;

  try
    masterResult := ApplyScriptsFor(AScriptsContent, AScriptNames, srMaster);
    if masterResult = asError then
    begin
      LogErrMsg('Не удалось выполнить скрипты для Master');
      Exit;
    end;

    slaveResult := ApplyScriptsFor(AScriptsContent, AScriptNames, srSlave);
    if slaveResult = asError then
      LogErrMsg('Не удалось выполнить скрипты для Slave');

  finally
    if (masterResult = asSuccess) and (slaveResult = asSuccess) then
      Result := asSuccess
    else
      Result := asError;
  end;
end;

function TdmData.ApplyScriptsFor(AScriptsContent, AScriptNames: TStrings; AServer: TServerRank): TApplyScriptResult;
var
  I: Integer;
  bConnected: Boolean;
  tmpStmt: IZPreparedStatement;
  tmpConn: TZConnection;
const
  cExceptMsg = 'Возникла ошибка в скрипте %s' + cCrLf + cExceptionMsg;
begin
  Result     := asError;
  tmpConn    := nil;
  bConnected := False;

  if (AScriptsContent = nil) or (AScriptNames = nil) or (AScriptsContent.Count = 0) or (AScriptNames.Count = 0) then Exit;

  case AServer of
    srMaster:
      begin
        bConnected := IsMasterConnected;
        tmpConn    := conMaster;
      end;
    srSlave:
      begin
        bConnected := IsSlaveConnected;
        tmpConn    := conSlave;
      end;
  end;

  if (tmpConn <> nil) and bConnected then
    for I := 0 to Pred(AScriptsContent.Count) do
      try
        if not FStopped then
        begin
          tmpConn.DbcConnection.SetAutoCommit(False);
          tmpStmt := tmpConn.DbcConnection.PrepareStatement(AScriptsContent[I]);
          tmpStmt.ExecuteUpdatePrepared;
          tmpConn.DbcConnection.Commit;
          Result := asSuccess;
        end;
      except
        on E: Exception do
        begin
          tmpConn.DbcConnection.Rollback;
          LogErrMsg(Format(cExceptMsg, [AScriptNames[I], E.ClassName, E.Message]));
          Result := asError;
          Break;
        end;
      end;
end;

procedure TdmData.BuildReplicaCommandsSQL(const AStartId: Int64; const ARange: Integer);
const
  cGetSQL       = 'формирование SQL ...';
  cFetch        = 'получение записей ...';
  cElapsedFetch = '%s записей получено за %s';
  cBuild        = 'запись данных в локальное хранилище ...';
  cElapsedBuild = '%s уникальных записей в локальное хранилище за %s';
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
      ParamByName('id_start').AsLargeInt  := AStartId;
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

    if FStopped then Exit;

//    LogMsg(qrySelectReplicaCmd.SQL.Text, 'Replica_SQL.txt');

    { qrySelectReplicaCmd вернет набор команд репликации (INSERT, UPDATE, DELETE) в поле Result,
      которые могут быть выполнены пакетами с помощью conSlave }
    LogMsg(cFetch, crdStartFetch);
    qrySelectReplicaCmd.Open;
    qrySelectReplicaCmd.FetchAll;
    qrySelectReplicaCmd.First;
    if qrySelectReplicaCmd.RecordCount = 0 then
      FStartId := 0
    else
      FStartId := qrySelectReplicaCmd.FieldByName('Id').AsLargeInt; // откорректируем значение StartId в соответствии с реальными данными
    LogMsg(Format(cElapsedFetch, [IntToStr(qrySelectReplicaCmd.RecordCount), Elapsed(crdStartFetch)]), crdStartFetch);

    if FStopped then Exit;

    // строим свой массив данных, который позволит выбирать записи пакетами с учетом границ transaction_id
    crdStartBuild := GetTickCount;
    LogMsg(cBuild, crdStartBuild);
    FCommandData.BuildData(qrySelectReplicaCmd);
    qrySelectReplicaCmd.Close;
    LogMsg(Format(cElapsedBuild, [IntToStr(FCommandData.Count), Elapsed(crdStartBuild)]), crdStartBuild);

    if FStopped then Exit;

    FCommandData.Last; //чтобы прочитать MaxId

    // сохраним правую границу сессии для последующего использования
    FLastId := FCommandData.Data.Id;

    // показать инфу о новой сессии в GUI
    if (FStartId > 0) and (FLastId > 0) and (FStartId <= FLastId) and  Assigned(FOnNewSession) then
      FOnNewSession(dtmStart, FStartId, FLastId, FCommandData.Count, FSessionNumber);
  except
    on E: Exception do
    begin
      FStopped := True;
      FReplicaFinished := rfErrStopped;
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

constructor TdmData.Create(AOwner: TComponent; AMsgProc: TNotifyMessage);
begin
  inherited Create(AOwner);
  FMsgProc := AMsgProc;
end;

constructor TdmData.Create(AOwner: TComponent; const AStartId: Int64; const ASelectRange, APacketRange: Integer; AMsgProc: TNotifyMessage);
begin
  inherited Create(AOwner);

  FStartId := AStartId;
  FMsgProc := AMsgProc;

  FSelectRange := ASelectRange;
  FPacketRange := APacketRange;

  FCommandData := TCommandData.Create;
  FFailCmds    := TCommandData.Create;

  FReplicaFinished := rfComplete;
  FMoveErrorsThrdFinished := True;
end;

destructor TdmData.Destroy;
begin
  conMaster.Disconnect;
  conSlave.Disconnect;

  FreeAndNil(FCommandData);
  FreeAndNil(FFailCmds);
  inherited;
end;

procedure TdmData.StartReplica;
var
  bConnected: Boolean;
const
  cStartReplicaAttemptCount = 3;// столько раз попытаемся начать репликацию, прежде чем прекратим выполнение
begin
  { Каждая репликация создается в отдельном потоке, на старте создается экземпляр TdmData,
    поэтому в самом начале всегда FStopped = False. Если возникла потеря связи, программа рекурсивно вызывает
    StartReplica, чтобы восстановить соединение }
  if FStopped then Exit;// если пользователь решил прекратить рекурсивные попытки реконнекта

  bConnected := IsBothConnected; // каждый вызов IsConnected делает 3 попытки установить соединение

  // не удалось установить коннект перед началом репликации
  if not bConnected then
  begin
    if FStartReplicaAttempt = 0 then
    begin
      FReplicaFinished := rfNoConnect;
      if not FStopped and Assigned(FOnNeedRestart) then  // если коннекта нет с самого начала, тогда просим запустить реконнект
        FOnNeedRestart(nil);                             // из главного потока через [TSettings.ReconnectTimeoutMinute] минут
    end
    else
      FReplicaFinished := rfErrStopped; // если это рекурсивный вызов StartReplica из блока 'if FReplicaFinished = rfErrStopped then'
  end;

  // если связь установлена, тогда начинаем репликацию
  if bConnected then
  try
    FStopped := False;
    FStartReplicaAttempt := 0;
    FReplicaFinished := ExecuteReplica;
  except
    on E: Exception do
    begin
      FReplicaFinished := rfErrStopped;
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;

  // Если реплика была прекращена из-за ошибки, тогда нужно проверить не была ли ошибка вызвана потерей связи
  if FReplicaFinished = rfErrStopped then
  begin
    // если связи нет, тогда причиной ошибки считаем потерю связи
    if not IsBothConnectionsAlive then
    begin
      FReplicaFinished := rfLostConnect;
      Inc(FStartReplicaAttempt);

      if FStartReplicaAttempt > cStartReplicaAttemptCount then
      begin
        if not FStopped and Assigned(FOnNeedRestart) then
          FOnNeedRestart(nil);
        Exit;
      end
      else StartReplica;
    end;
  end;
end;

procedure TdmData.ExecuteCommandsOneByOne; // предполагается использовать внутри StartReplica после неудачи ExecutePreparedPacket
var
  iStartId, iLastId, iMaxId: Int64;
  iSuccCount, iFailCount: Integer;
  crdStart, crdLogMsg: Cardinal;
begin
  // будем выполнять команды по одной
  if FStopped then Exit;

  {$IFDEF NO_EXECUTE} // для проверки границ пакета, без выполнения запросов
    Exit;
  {$ENDIF}

  crdStart := GetTickCount;
  iLastId  := FStartId;

  try
    iMaxId := FCommandData.GetMaxId(FStartId, FPacketRange);

    if FStartId >= iMaxId then
    begin
      LogErrMsg(Format(cWrongRange, [iMaxId, FStartId]));
      FStopped := True;
      FReplicaFinished := rfErrStopped;
      Exit;
    end;      

    FCommandData.MoveToId(FCommandData.ValidId(FStartId));
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

            LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));

            // если нужно сохранять ошибки шага №2 в БД
            if TSettings.SaveErrStep2InDB then
              SaveErrorInMaster(cStep2, FCommandData.Data.Id, 0, FClient_Id, E.Message);
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

        iLastId := FCommandData.Data.Id; // FCommandData.Data.Id содержит table_update_data.Id
        FCommandData.Next;
        StartId := FCommandData.Data.Id; // используем св-во StartId, а не FStartId, чтобы возбудить событие OnChangeStartId
      end;

      if FCommandData.EOF then // если достигли правой границы сессии, тогда используем  iMaxId + 1
        StartId := iMaxId + 1;
        
    finally
      // обязательно записываем в лог последнее сообщение 
      LogMsg(Format(cAttempt2, [iStartId, iMaxId, iSuccCount, iFailCount, Elapsed(crdStart)]), crdStart);
    end;      
    
  finally
    TSettings.ReplicaLastId := iLastId;// сохраняем в INI-файл значение Id последней успешной команды
    // В конце сессии нужно сохранить значение LastId на Master и Slave.
    // На Master сохраняем реже, после cSaveInMasterAfterNSessions сессий
    if FCommandData.EOF then
      SaveValueInDB(iLastId, 'Last_Id', FSessionNumber > cSaveInMasterAfterNSessions);
  end;
end;

procedure TdmData.ExecuteErrCommands;
var
  iStartId, iEndId: Int64;
  iSuccCount, iFailCount: Integer;
  crdStart, crdLogMsg: Cardinal;
  sFileName: string;
const
  cFileName  = '\Err_commands\%s';
  cFileErr   = '%s  Id %d  ERR.txt';
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

            LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));

            // ошибки шага №3 нужно сохранять в БД
            SaveErrorInMaster(cStep3, FFailCmds.Data.Id, 0, FClient_Id, E.Message);

            // команды, которые так и не были выполнены, пишем в лог
            if FWriteCommands then
            begin
              sFileName := Format(cFileName, [
                Format(cFileErr, [
                  FormatDateTime(cDateTimeFileNameStr, Now),
                  FFailCmds.Data.Id
                ])
              ]);
              LogMsgFile(FFailCmds.Data.SQL, sFileName);
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
  I, iRecCount: Integer;
  iMaxId, iStartId, iLastId, iStartTrans, iEndTrans: Int64;
  rangeTransId: TMinMaxTransId;
  sFileName: string;
  tmpData: TCmdData;
  tmpSL: TStringList;
  {$IFNDEF NO_EXECUTE}
  tmpStmt: IZPreparedStatement;
  {$ENDIF}
const
  cFileName = '\Packets\%s';
  cFileOK   = '%s  Id %d-%d  %d.txt';
  cFileErr  = '%s  Id %d-%d  %d ERR.txt';
  cTransId  = '-- Id= %d    tranId= %d' + #13#10;
begin
  Result := 0;

  if FStopped then Exit;

  bStopIfError := TSettings.StopIfError;

  iStartId := FStartId;
  crdStart := GetTickCount;

  iMaxId := FCommandData.GetMaxId(FStartId, FPacketRange);

  // проверим диапазон Id нового пакета
  if iStartId > iMaxId then
  begin
    LogErrMsg(Format(cWrongRange, [iMaxId, iStartId]));
    FStopped := True;
    FReplicaFinished := rfErrStopped;
    Exit;
  end;

  rangeTransId := FCommandData.MinMaxTransId(iStartId, iMaxId);
  iStartTrans := rangeTransId.Min;
  iEndTrans   := rangeTransId.Max;

  iRecCount := FCommandData.RecordCount(FCommandData.ValidId(iStartId), iMaxId);

  // строка  "№1 Id=<56477135-56513779> tranId=<677135-63779> 3500 записей за  "
  LogMsg(Format(cAttempt1, [iStartId, iMaxId, iStartTrans, iEndTrans, iRecCount, '', '']), crdStart);

  tmpSL := TStringList.Create(True);// True означает, что tmpSL владеет объектами tmpData и освободит их в своем деструкторе
  try
    with FCommandData do
    begin
      MoveToId(ValidId(iStartId));
      while not EOF and (Data.Id <= iMaxId) and not FStopped do
      begin
        tmpData := TCmdData.Create;
        tmpData.Id := Data.Id;
        tmpData.TranId := Data.TransId;
        tmpSL.AddObject(Data.SQL, tmpData);
        Next;
      end;
    end;

    try
      Inc(FPacketNumber);
      // пакетная выгрузка (сделано по образцу кода из Release Notes "2.1.3 Batch Loading")
      if (tmpSL.Count > 0) and IsSlaveConnected and not FStopped then
      begin
        {$IFDEF NO_EXECUTE} // для проверки границ пакета, без выполнения запросов
        Result := 1;
        Sleep(1000);

        {$ELSE}
        conSlave.DbcConnection.SetAutoCommit(False);
        tmpStmt := conSlave.DbcConnection.PrepareStatement(tmpSL.Text);
        tmpStmt.ExecuteUpdatePrepared;
        conSlave.DbcConnection.Commit;
        {$ENDIF}

        // пакет успешно выполнен и можем передвинуть StartId на новую позицию

        // сначала перемещаемся на правую границу диапазона
        FCommandData.MoveToId(iMaxId);
        iLastId := FCommandData.Data.Id;
        if iLastId <= High(Integer) then
          TSettings.ReplicaLastId := iLastId// сохраняем в INI-файл значение Id последней успешной команды
        else
          TSettings.ReplicaLastId := -1;

        // последовательность Id может иметь разрывы, например 48256, 48257, 48351, 48352
        // поэтому вместо iMaxId + 1 используем Next
        FCommandData.Next;

        if FCommandData.EOF then // если достигли правой границы сессии, тогда используем  iMaxId + 1
        begin
          StartId := iMaxId + 1;
          // В конце сессии нужно сохранить значение LastId на Master и Slave.
          // На Master сохраняем реже, после cSaveInMasterAfterNSessions сессий
          SaveValueInDB(iLastId, 'Last_Id', FSessionNumber > cSaveInMasterAfterNSessions);
        end
        else
          StartId := FCommandData.Data.Id;

        // запись успешного пакета в файл
        if FWriteCommands then
        begin
          sFileName := Format(cFileName, [
            Format(cFileOK, [
              FormatDateTime(cDateTimeFileNameStr, Now),
              iStartId,
              iMaxId,
              FPacketNumber
            ])
          ]);

          for I := 0 to Pred(tmpSL.Count) do
            tmpSL[I] := Format(cTransId,
                               [TCmdData(tmpSL.Objects[I]).Id, TCmdData(tmpSL.Objects[I]).TranId]
                               ) + tmpSL[I];

          LogMsgFile(tmpSL.Text, sFileName);
        end;

        // строка  "№1 Id=<56477135-56513779> tranId=<677135-63779> 3500 записей за 00:00:00_212"
        LogMsg(Format(cAttempt1, [iStartId, iMaxId, iStartTrans, iEndTrans, iRecCount, Elapsed(crdStart), '']), crdStart);
      end;
      Result := 1;
    except
      on E: Exception do
      begin
        Result := 0;
        if bStopIfError then
        begin
          FStopped := True;
          FReplicaFinished := rfErrStopped;
        end;

        // строка  "№1 Id=<56477135-56513779> tranId=<677135-63779> 3500 записей за 00:00:00_212 error"
        LogMsg(Format(cAttempt1, [iStartId, iMaxId, iStartTrans, iEndTrans, iRecCount, Elapsed(crdStart), 'error']), crdStart);

        LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));

        // запись сбойного пакета в файл
        if FWriteCommands then
        begin
          sFileName := Format(cFileName, [
            Format(cFileErr, [
              FormatDateTime(cDateTimeFileNameStr, Now),
              iStartId,
              iMaxId,
              FPacketNumber
            ])
          ]);

          for I := 0 to Pred(tmpSL.Count) do
            tmpSL[I] := Format(cTransId,
                               [TCmdData(tmpSL.Objects[I]).Id, TCmdData(tmpSL.Objects[I]).TranId]
                              ) + tmpSL[I];

          LogMsgFile(tmpSL.Text, sFileName);
        end;

        // если нужно сохранять ошибки шага №1 в БД
        if TSettings.SaveErrStep1InDB then
          SaveErrorInMaster(cStep1, iStartId, iMaxId, FClient_Id, E.Message);

        try
          conSlave.DbcConnection.Rollback; // если утрачена связь, тогда этот метод выбросит исключение
        except
          on EE: Exception do
          begin
            LogErrMsg(Format(cExceptionMsg, [EE.ClassName, EE.Message]));
            conSlave.Disconnect;
          end;
        end;

      end;
    end;
  finally
    FreeAndNil(tmpSL);
  end;
end;

function TdmData.ExecuteReplica: TReplicaFinished;
var
  iPrevStartId: Int64;
begin
  iPrevStartId := -1;

  // Идентификатор базы данных Slave. Это значение хранится в единственном числе
  // в slave._replica.Settings в полях name, value как пара 'client_id = 1234565855222447722'.
  // В Master содержится инфа о всех slave-ах в master._replica.Clients.client_id
  FClient_Id := GetSlaveValues.ClientId;

  // MaxID - это ф-ия, которая возвращает 'select Max(Id) from _replica.table_update_data'
  while (FStartId > iPrevStartId) and (FStartId <= MaxID) and not FStopped do
  begin
    // Успешное выполнение методов репликации должно увеличивать FStartId и в конце итерации это значение обычно должно быть больше предыдущего.
    // Возможен сценарий, когда в пакете нет ни одной команды. В этом случае FStartId останется неизменным.
    // Сохраним предыдущеее значение FStartId, чтобы потом сравнить его с текущим значением FStartId
    // и избежать бесконечного цикла для случая, когда в пакете нет ни одной команды.
    iPrevStartId := FStartId;

    // В процессе работы программы ошибки обычно сохраняются в Master._replica.Errors. Если в какой то момент связь с Master
    // была утрачена, тогда ошибки сохраняются Slave._replica.Errors. Нужно проверить их наличие в Slave и перенести в Master
    if FMoveErrorsThrdFinished then
    begin
      FMoveErrorsThrd := TMoveErrorsThread.Create(cCreateSuspended, FMsgProc, tknNondriven);
      FMoveErrorsThrd.OnTerminate := OnTerminateMoveErrors;
      FMoveErrorsThrd.Start;
    end;

    // Формируем набор команд в дипазоне StartId..(StartId + SelectRange) - это сессия
    // Реальная правая граница может быть > (StartId + SelectRange), потому что BuildReplicaCommandsSQL учитывает номера транзакций
    // и обеспечивает условие, чтобы записи с одинаковыми номерами транзакций были в одном наборе
    BuildReplicaCommandsSQL(FStartId, FSelectRange);

    if (FStartId = 0) and (FLastId = 0) then Break;


    // FStartId увеличивается в процессе выполнения команд

    FPacketNumber := 0; // сбрасываем нумерацию пакетов перед началом сессии

    // Передаем команды из дипазона StartId..(StartId + SelectRange) порциями
    while (FStartId <= FLastId) and not FStopped do
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

  Result := FReplicaFinished;
end;

procedure TdmData.FetchSequences(AServer: TServerRank; out ASeqDataArr: TSequenceDataArray);
const
  cSelectSequences = 'select * from gpSelect_Sequences()';
  cSelectLastValue = 'select last_value from %s';
var
  I: Integer;
  bConnected: Boolean;
  qryHelper: TZReadOnlyQuery;
  sSelectLastValue: string;
begin
  try

    SetLength(ASeqDataArr, 0);
    qryHelper  := nil;
    bConnected := False;

    case AServer of
      srMaster:
        begin
          bConnected := IsMasterConnected;
          qryHelper  := qryMasterHelper;
        end;

      srSlave:
        begin
          bConnected := IsSlaveConnected;
          qryHelper  := qrySlaveHelper;
        end;
    end;

    if bConnected and Assigned(qryHelper) then
    begin
      // получим все последовательности
      with qryHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(cSelectSequences);
        Open;
        FetchAll;
        First;
        SetLength(ASeqDataArr, RecordCount);

        if not IsEmpty then
        begin
          Assert(Lowercase(Fields[0].FieldName) = 'sequencename',
            'Ожидается, что gpSelect_Sequences() вернет датасет, в котором первое поле "SequenceName"');
          Assert(Lowercase(Fields[1].FieldName) = 'increment',
            'Ожидается, что gpSelect_Sequences() вернет датасет, в котором второе поле "Increment"');

          I := 0;
          while not EOF and not FStopped do
          begin
            ASeqDataArr[I].Name := Fields[0].AsString;
            ASeqDataArr[I].Increment := Fields[1].AsInteger;
            Inc(I);
            Next;
          end;
        end;
      end;

      // получим последние значения каждой последовательности
      for I := Low(ASeqDataArr) to High(ASeqDataArr) do
      begin
        if FStopped then Exit;

        sSelectLastValue := Format(cSelectLastValue, [ASeqDataArr[I].Name]);
        with qryHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(sSelectLastValue);
          Open;
          if not IsEmpty and not Fields[0].IsNull then
            ASeqDataArr[I].LastValue := Fields[0].AsLargeInt;
        end;
      end;
    end;

  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
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
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.GetSlaveValues: TSlaveValues;
const
  cSelectSettings = 'select * from _replica.gpSelect_Settings()';
begin
  try
    if IsSlaveConnected then
      with qrySlaveHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(cSelectSettings);
        Open;

        if Locate('Name', 'Last_Id', [loCaseInsensitive]) then
          if not FieldByName('Value').IsNull then
            Result.LastId := StrToInt64Def(FieldByName('Value').AsString, 0);

        if Locate('Name', 'Last_Id_DDL', [loCaseInsensitive]) then
          if not FieldByName('Value').IsNull then
            Result.LastId_DDL := StrToInt64Def(FieldByName('Value').AsString, 0);

        if Locate('Name', 'Client_Id', [loCaseInsensitive]) then
          if not FieldByName('Value').IsNull then
            Result.ClientId := StrToInt64Def(FieldByName('Value').AsString, 0);
        Close;
      end;
  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.GetLastId: Int64;
var
  slvValues: TSlaveValues;
  iMasterId, iSlaveId: Int64;
begin
  slvValues := GetSlaveValues;

  iSlaveId  := slvValues.LastId;
  iMasterId := GetMasterValues(slvValues.ClientId).LastId;

  Result := Max(iSlaveId, iMasterId);
end;

function TdmData.GetLastId_DDL: Int64;
var
  slvValues: TSlaveValues;
  iMasterId, iSlaveId: Int64;
begin
  slvValues := GetSlaveValues;

  iSlaveId  := slvValues.LastId_DDL;
  iMasterId := GetMasterValues(slvValues.ClientId).LastId_DDL;

  Result := Max(iSlaveId, iMasterId);
end;

function TdmData.InitConnection(AConnection: TZConnection;
  ARank: TServerRank): boolean;
begin
  if not Assigned(AConnection) then
    raise Exception.Create('Connection is not created');
  Result := IsConnected(AConnection, ARank);
end;
function TdmData.IsBothConnected: Boolean;
begin
  Result := IsMasterConnected and IsSlaveConnected;
end;

function TdmData.IsBothConnectionsAlive: Boolean;
var
  bMasterAlive, bSlaveAlive: Boolean;
begin
  bMasterAlive := IsConnectionAlive(conMaster);
  bSlaveAlive  := IsConnectionAlive(conSlave);
  Result := bMasterAlive and bSlaveAlive;
  // Нужно именно так проверять, по очереди, а не в одну строку 'Result := IsConnectionAlive(conMaster) and IsConnectionAlive(conSlave)'
  // Если выражение в одну строку, тогда если IsConnectionAlive(conMaster) = False компилятор не станет вызывать IsConnectionAlive(conSlave),
  // и не будет вызван conSlave.Disconnect (см. код IsConnectionAlive)
end;

function TdmData.IsConnected(AConnection: TZConnection; ARank: TServerRank): Boolean;
var
  iAttempt: Integer;
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
      ApplyConnectionConfig(AConnection, ARank);
      AConnection.Connect;
      Result := AConnection.Connected;
    except
      on E: Exception do
      begin
        Result := False;

        if iAttempt >= cAttemptCount then
          LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]))
        else
          Sleep(cWaitReconnect);
      end;
    end;
  until Result or (iAttempt >= cAttemptCount);
end;

function TdmData.IsConnectionAlive(AConnection: TZConnection): Boolean;
begin
  Result := AConnection.Ping;
  if not Result and AConnection.Connected then
    AConnection.Disconnect;
end;

function TdmData.IsMasterConnected: Boolean;
begin
  Result := IsConnected(conMaster, srMaster);
end;

function TdmData.IsSlaveConnected: Boolean;
begin
  Result := IsConnected(conSlave, srSlave);
end;

procedure TdmData.LogErrMsg(const AMsg: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, EmptyStr, 0, lmtError);
end;

procedure TdmData.LogMsg(const AMsg: string; const aUID: Cardinal);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, EmptyStr, aUID);
end;

procedure TdmData.LogMsg(const AMsg: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg);
end;

procedure TdmData.LogMsgFile(const AMsg, AFileName: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, AFileName);
end;

function TdmData.GetCompareRecCountMS_SQL(const ADeviationsOnly: Boolean): string;
type
  TTableData = record
    Name: string;
    PK_Id: Boolean; // таблица имеет  Primary Key field = Id
    PK_field: string;
    MaxIdSlave: Int64;
    MasterCount: Int64;
    SlaveCount: Int64;
    CountSQLSlave: string;
    CountSQLMaster: string;
  end;
const
  cSelectPKFields        = 'SELECT * FROM _replica.gpSelect_PKFields(%s)';
//  cSelectPKFields        = 'SELECT pk_keys FROM _replica.table_update_data WHERE table_name ILIKE %s limit 1';
  cSelectTableNames      = 'SELECT * FROM _replica.gpSelect_Replica_tables()';
  cSelectUnion           = 'SELECT ''%s'' as TableName, %d AS CountMaster, %d AS CountSlave';
  cSelectCount           = 'SELECT COUNT(*) FROM %s AS RecCount';
  cSelectCountSlaveNoId  = 'SELECT Max(%s) as MaxIdSlave, COUNT(*) AS RecCount FROM %s';
  cSelectCountSlave      = 'SELECT Max(Id) as MaxIdSlave, COUNT(*) AS RecCount FROM %s';
  cSelectCountIdSlave    = 'SELECT Max(Id) as MaxIdSlave, COUNT(Id) AS RecCount FROM %s';
  cSelectCountMasterNoId = 'SELECT COUNT(*) AS RecCount FROM %s WHERE %s <= %d';
  cSelectCountMaster     = 'SELECT COUNT(*) AS RecCount FROM %s WHERE Id <= %d';
  cSelectCountIdMaster   = 'SELECT COUNT(Id) AS RecCount FROM %s WHERE Id <= %d';
  cUnion                 = ' UNION ALL ';
var
  I, J: Integer;
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
        SQL.Add(cSelectTableNames);
        Open;
        FetchAll;
        if IsEmpty then Exit;

        First;
        while not EOF and not FStopped do
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

    if FStopped then Exit;

    // Вычисляем Count(*) для таблиц из массива arrTables.
    // Для 'MovementItemContainer' отдельный случай: select Count(Id).

    { В master все время идет запись, поэтому сверить практически нереально
     Надо сделать сначала на slave
      select count(*), max(Id) from table...
     потом на master
      select count(*) from table... where Id <= :max_Id_slave }

    // выполняем запрос для каждой таблицы
    for I := Low(arrTables) to High(arrTables) do
    begin
      if FStopped then Exit;

      // Не у всех таблиц PrimaryKey состоит из одного поля Id. Определим имена полей, которые составляют PrimaryKey.
      // ВСЕ составные индексы - 2 поля и обязательно присутствует descid, надо его отбросить.
      // Если вдруг будет составной из 3-х или более полей, или вообще не будет, тогда и для Master делаем select Count(*) from ......
      if IsMasterConnected then
        with qryMasterHelper do
        begin
          Close;
          SQL.Clear;
          sSQL := Format(cSelectPKFields, [QuotedStr(arrTables[I].Name)]);
          SQL.Add(sSQL);
          Open;
          FetchAll;
          First;
          arrTables[I].PK_Id := not Fields[0].IsNull and (RecordCount = 1) and SameText(Fields[0].AsString, 'Id');

          arrTables[I].PK_field := '';

          case RecordCount of
            0, 3: // нет PrimaryKey
               arrTables[I].PK_field := '';

            1: // одно поле в PrimaryKey
               if not Fields[0].IsNull then
                 arrTables[I].PK_field := Fields[0].AsString;

            2: // 2 поля в PrimaryKey
               while not EOF do
               begin
                 if not Fields[0].IsNull then
                   if not SameText(Fields[0].AsString, 'descid') then // поле 'descid' отбрасываем
                     arrTables[I].PK_field := Fields[0].AsString;

                 Next;
               end;
          end;
        end;

      // для таблиц сервера Slave
      if arrTables[I].Name = 'MovementItemContainer'  then
        arrTables[I].CountSQLSlave := Format(cSelectCountIdSlave, [arrTables[I].Name])
      else
        if arrTables[I].PK_Id then
          arrTables[I].CountSQLSlave := Format(cSelectCountSlave, [arrTables[I].Name])
        else
          if Length(arrTables[I].PK_field) > 0 then
            arrTables[I].CountSQLSlave := Format(cSelectCountSlaveNoId, [arrTables[I].PK_field, arrTables[I].Name])
          else
            arrTables[I].CountSQLSlave := Format(cSelectCount, [arrTables[I].Name]);

      if IsSlaveConnected then
        with qrySlaveHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(arrTables[I].CountSQLSlave);
          Assert(Length(Trim(SQL.Text)) > 0, 'Ожидается, что CountSQLSlave <> "" для таблицы ' + arrTables[I].Name);
          Open;

          if Length(arrTables[I].PK_field) > 0 then
          begin
            if not Fields[0].IsNull then
              arrTables[I].MaxIdSlave := Fields[0].AsLargeInt;

            if not Fields[1].IsNull then
              arrTables[I].SlaveCount := Fields[1].AsLargeInt;
          end
          else
            if not Fields[0].IsNull then
              arrTables[I].SlaveCount := Fields[0].AsLargeInt;

          Close;
        end;

      if FStopped then Exit;

      // для таблиц сервера Master
      if arrTables[I].Name = 'MovementItemContainer'  then
        arrTables[I].CountSQLMaster := Format(cSelectCountIdMaster, [arrTables[I].Name, arrTables[I].MaxIdSlave])
      else
        if arrTables[I].PK_Id then
          arrTables[I].CountSQLMaster := Format(cSelectCountMaster, [arrTables[I].Name, arrTables[I].MaxIdSlave])
        else
          if Length(arrTables[I].PK_field) > 0 then
            arrTables[I].CountSQLMaster := Format(cSelectCountMasterNoId, [arrTables[I].Name, arrTables[I].PK_field, arrTables[I].MaxIdSlave])
          else
            arrTables[I].CountSQLMaster := Format(cSelectCount, [arrTables[I].Name]);

      if IsMasterConnected then
        with qryMasterHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(arrTables[I].CountSQLMaster);
          Assert(Length(Trim(SQL.Text)) > 0, 'Ожидается, что CountSQLMaster <> "" для таблицы ' + arrTables[I].Name);
          Open;
          if not Fields[0].IsNull then
            arrTables[I].MasterCount := Fields[0].AsLargeInt;
          Close;
        end;

      if Assigned(FOnCompareRecCountMS) then
      begin
        // формируем промежуточный текст запроса SELECT UNION, используя имеющиеся на данный момент данные массива arrTables
        sSQL := '';
        for J := Low(arrTables) to I do
        begin
          if FStopped then Exit;

          if ADeviationsOnly then
            if arrTables[J].MasterCount = arrTables[J].SlaveCount then Continue;

          if Length(sSQL) = 0 then
            sSQL := Format(cSelectUnion, [arrTables[J].Name, arrTables[J].MasterCount, arrTables[J].SlaveCount])
          else
            sSQL := sSQL + cUnion + Format(cSelectUnion, [arrTables[J].Name, arrTables[J].MasterCount, arrTables[J].SlaveCount]);
        end;

        if Length(sSQL) > 0 then
        begin
          Result := sSQL + ';';
          FOnCompareRecCountMS(Result);
        end;
      end;
    end;

    // формируем итоговый текст запроса SELECT UNION, используя данные массива arrTables
    sSQL := '';
    for I := Low(arrTables) to High(arrTables) do
    begin
//      if FStopped then Exit;

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
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.GetCompareSeqMS_SQL(const ADeviationsOnly: Boolean): string;
type
  TUnionData = record
    Name: string;
    MasterValue: Int64;
    SlaveValue: Int64;
    MasterIncrement: Integer;
    SlaveIncrement: Integer;
  end;
const
  cSelectUnion = 'select ''%s'' as SequenceName, %d as MasterValue, %d as SlaveValue, %d as MasterIncrement, %d as SlaveIncrement';
var
  I, J: Integer;
  arrMasterSeq, arrSlaveSeq: TSequenceDataArray;
  arrUnion: array of TUnionData;
  sSelect: string;
begin
  Result := Format(cSelectUnion, ['<нет данных>', 0, 0, 0, 0]);

  try

    // Получим список последовательностей Master
    FetchSequences(srMaster, arrMasterSeq);
    if Length(arrMasterSeq) = 0 then Exit;

    if FStopped then Exit;

    // Получим список последовательностей Slave
    FetchSequences(srSlave, arrSlaveSeq);

    if FStopped then Exit;

    SetLength(arrUnion, Length(arrMasterSeq));

    for I := Low(arrUnion) to High(arrUnion) do
    begin
      if FStopped then Exit;
      arrUnion[I].Name            := arrMasterSeq[I].Name;
      arrUnion[I].MasterValue     := arrMasterSeq[I].LastValue;
      arrUnion[I].MasterIncrement := arrMasterSeq[I].Increment;
    end;

    // Репликация может быть еще не закончена и в Slave меньше последовательностей, чем в Master
    for I := Low(arrUnion) to High(arrUnion) do
    begin
      if FStopped then Exit;

      for J := Low(arrSlaveSeq) to High(arrSlaveSeq) do
        if SameText(arrSlaveSeq[J].Name, arrUnion[I].Name) then
        begin
          if FStopped then Exit;
          arrUnion[I].SlaveValue     := arrSlaveSeq[J].LastValue;
          arrUnion[I].SlaveIncrement := arrSlaveSeq[J].Increment;
          Break;
        end;
    end;

    // Теперь готов сформировать UNION
    if Length(arrUnion) > 0 then Result := '';

    for I := Low(arrUnion) to High(arrUnion) do
    begin
      if FStopped then Exit;

      // если нужно показать только отличия, тогда пропускаем равные значения
      if ADeviationsOnly then
        if (arrUnion[I].MasterValue = arrUnion[I].SlaveValue) and
           (arrUnion[I].MasterIncrement = arrUnion[I].SlaveIncrement)
        then Continue;

      sSelect := Format(cSelectUnion, [
        arrUnion[I].Name, arrUnion[I].MasterValue, arrUnion[I].SlaveValue, arrUnion[I].MasterIncrement, arrUnion[I].SlaveIncrement
      ]);

      if Length(Result) = 0 then
        Result := sSelect
      else
        Result := Result + ' union ' + sSelect;
    end;

    if Length(Result) > 0 then
      Result := Result + ' order by 1';

  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.GetMasterValues(const AClientId: Int64): TMasterValues;
const
  cSelectClients = 'select * from _replica.gpSelect_Clients(%d)';
begin
  try
    if IsMasterConnected then
      with qryMasterHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(Format(cSelectClients, [AClientId]));
        Open;

        if not IsEmpty then
        begin
          if not FieldByName('last_id').IsNull then
            Result.LastId := StrToInt64Def(FieldByName('last_id').AsString, 0);

          if not FieldByName('last_id_ddl').IsNull then
            Result.LastId_DDL := StrToInt64Def(FieldByName('last_id_ddl').AsString, 0);
        end;

        Close;
      end;
  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
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
          Result.MinId := FieldByName('MinId').AsLargeInt;

        if not FieldByName('MaxId').IsNull then
          Result.MaxId := FieldByName('MaxId').AsLargeInt;

        if not FieldByName('RecCount').IsNull then
          Result.RecCount := FieldByName('RecCount').AsLargeInt;

        Close;
      end;
  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.MaxID: Int64;
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
          Result := Fields[0].AsLargeInt;

        Close;
      end;
  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.MinID: Int64;
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
          Result := Fields[0].AsLargeInt;

        Close;
      end;
  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TdmData.MoveErrorsFromSlaveToMaster;
const
  cSelectSlave = 'select * from _replica.gpSelect_Errors()';
  cDeleteSlave = 'select _replica.gpDelete_Errors()';
  cInsertMaster = 'select _replica.gpInsert_Errors (%d, %d, %d, %d, %s);';
  cFailMoveErrors = 'Не удалось перенести ошибки из Slave в Master';
  cFailDeleteErrors = 'Ошибки перенесены в Master, но не удалось удалить их в Slave';
var
  bMoveSuccess: Boolean;
  slCmds: TStringList;
  tmpStmt: IZPreparedStatement;
begin
  bMoveSuccess := False;
  // Обычно ошибки сохраняются сразу в Master.Errors. Если во время выполнения программы связь с Master была утрачена,
  // тогда ошибки сохраняются в Slave.Errors. Нужно перенести эти ошибки в Master и потом удалить их в Slave
  try

    slCmds := TStringList.Create;
    try

      if IsSlaveConnected then
        with qrySlaveHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(cSelectSlave);
          Open;
          if not IsEmpty then // если в Slave есть сохраненные ошибки, тогда сформируем список команд
          begin
            First;
            while not Eof do
            begin
              slCmds.Add(Format(cInsertMaster, [
                FieldByName('Step').AsInteger,
                FieldByName('Start_Id').AsLargeInt,
                FieldByName('Last_Id').AsLargeInt,
                FieldByName('Client_Id').AsLargeInt,
                QuotedStr(FieldByName('Description').AsString)
              ]));
              Next;
            end;
          end;
        end;

      // теперь можем перенести ошибки в Master
      if (slCmds.Count > 0) and IsMasterConnected then
      begin
        try
          conMaster.DbcConnection.SetAutoCommit(False);
          tmpStmt := conMaster.DbcConnection.PrepareStatement(slCmds.Text);
          tmpStmt.ExecuteUpdatePrepared;
          conMaster.DbcConnection.Commit;
          bMoveSuccess := True;
        except
          on E: Exception do
          begin
            LogErrMsg(cFailMoveErrors);
            LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
            conMaster.DbcConnection.Rollback;
          end;
        end;
      end;

      // если ошибки успешно перенесены, тогда можем удалить их в Slave
      if bMoveSuccess and IsSlaveConnected then
        try
          conSlave.DbcConnection.SetAutoCommit(False);
          tmpStmt := conSlave.DbcConnection.PrepareStatement(cDeleteSlave);
          tmpStmt.ExecuteUpdatePrepared;
          conSlave.DbcConnection.Commit;
        except
          on E: Exception do
          begin
            LogErrMsg(cFailDeleteErrors);
            LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
            conSlave.DbcConnection.Rollback;
          end;
        end;
    finally
      FreeAndNil(slCmds);
    end;

  except
    on E: Exception do
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TdmData.MoveSavedProcToSlave;
const
  cSelect = 'select * from _replica.gpSelect_Table_ddl(:Id)';
  cSession = '\DDL_Commands\%s\';            // \DDL_Commands\2020-08-11_14-49-00
  cFileName = cSession + 'Id_%d.txt';        // \DDL_Commands\2020-08-11_14-49-00\Id_2095014.txt
  cFileNameErr = cSession + 'Id_%d_ERR.txt'; // \DDL_Commands\2020-08-11_14-49-00\id_2095014_Error.txt
  cFileContent = c2CrLf + 'Last_modified: %s' + c2CrLf + '%s';
var
  I, idxId, idxQry, idxLM: Integer;
  iId, iLastId: Int64;
  sQry, sSessionStart, sFileName, sFileContent: string;
  dtmLM: TDateTime;
  tmpStmt: IZPreparedStatement;
begin
  idxId  := -1;
  idxQry := -1;
  idxLM  := -1;
  iLastId := LastId_DDL; // Id, на котором в прошлый раз завершилось выполнение
  sSessionStart := FormatDateTime(cDateTimeFileNameStr, Now);

  try
    try
      if IsMasterConnected then
        with qryMasterHelper do
        begin
          Close;
          SQL.Clear;
          SQL.Add(Format(cSelect, [iLastId]));
          ParamByName('Id').AsLargeInt  := iLastId;
          Open;
          First;

          // определим индексы полей в датасете, чтобы использовать в цикле 'while not EOF do'
          for I := 0 to Pred(Fields.Count) do
            if      LowerCase(Fields[I].FieldName) = 'id'            then idxId  := I
            else if LowerCase(Fields[I].FieldName) = 'query'         then idxQry := I
            else if LowerCase(Fields[I].FieldName) = 'last_modified' then idxLM  := I;

          if Locate('Id', iLastId, []) then // Найдем позицию, на которой закончили в прошлый раз
            Next;                            // и передвинем на следующую для нового выполнения

          while not EOF do
          begin
            iId   := Fields[idxId].AsLargeInt;
            sQry  := Fields[idxQry].AsString;
            dtmLM := Fields[idxLM].AsDateTime;

            sFileContent := Format(cFileContent, [FormatDateTime(cDateTimeStrShort, dtmLM), sQry]);

            try
              if IsSlaveConnected and not FStopped then
              begin
                conSlave.DbcConnection.SetAutoCommit(False);
                tmpStmt := conSlave.DbcConnection.PrepareStatement(sQry);
                tmpStmt.ExecuteUpdatePrepared;
                conSlave.DbcConnection.Commit;
                iLastId := iId;
                sFileName := Format(cFileName, [sSessionStart, iId]);
                LogMsgFile(sFileContent, sFileName);
              end;
            except
              on E: Exception do
              begin
                conSlave.DbcConnection.Rollback;
                sFileName := Format(cFileNameErr, [sSessionStart, iId]);
                LogMsgFile(sFileContent, sFileName);
                LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
                // Прекращаем выполнение из-за ошибки
                Break;
              end;
            end;

            Next;
          end;
          Close;
        end;
    except
      on E: Exception do
        LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  finally
    if iLastId <= High(Integer) then
      TSettings.DDLLastId := iLastId
    else
      TSettings.DDLLastId := -1;

    LastId_DDL := iLastId;
  end;
end;

procedure TdmData.OnTerminateMoveErrors(Sender: TObject);
begin
  FMoveErrorsThrdFinished := True;
end;

procedure TdmData.SetLastId_DDL(const AValue: Int64);
begin
  SaveValueInDB(AValue, 'Last_Id_DDL');
end;

procedure TdmData.SetLastId(const AValue: Int64);
begin
  SaveValueInDB(AValue, 'Last_Id');
end;

function TdmData.SaveErrorInDB(AServerRank: TServerRank; const AStep: Integer; const AStartId, ALastId, AClientId: Int64;
  const AErrDescription: string): Boolean;
const
  cInsert    = 'SELECT _replica.gpInsert_Errors (%d, %d, %d, %d, %s)';
  cExceptMsg = 'Не удалось сохранить в %s информацию об ошибке команды с StartId = %d, Client_Id = %d';
var
  bConnected: Boolean;
  sInsert, sSrvrLable: string;
  tmpConn: TZConnection;
  tmpStmt: IZPreparedStatement;
begin
  Result := False;

  bConnected := False;
  tmpConn    := nil;

  case AServerRank of
    srMaster:
      begin
        bConnected := IsMasterConnected;
        sSrvrLable := 'Master';
        tmpConn    := conMaster;
      end;
    srSlave:
      begin
        bConnected := IsSlaveConnected;
        sSrvrLable := 'Slave';
        tmpConn    := conSlave;
      end;
  end;

  if bConnected and (tmpConn <> nil) then
  try
    with tmpConn.DbcConnection do
    begin
      SetAutoCommit(False);
      sInsert := Format(cInsert, [AStep, AStartId, ALastId, AClientId, QuotedStr(AErrDescription)]);
      tmpStmt := PrepareStatement(sInsert);
      tmpStmt.ExecuteUpdatePrepared;
      Commit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      LogErrMsg(Format(cExceptMsg, [sSrvrLable, AStartId, AClientId]));
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
      try
        tmpConn.DbcConnection.Rollback; // если утрачена связь, тогда этот метод выбросит исключение
      except
        on EE: Exception do
        begin
          LogErrMsg(Format(cExceptionMsg, [EE.ClassName, EE.Message]));
          tmpConn.Disconnect;
        end;
      end;
    end;
  end;
end;

procedure TdmData.SaveErrorInMaster(const AStep: Integer; const AStartId, ALastId, AClientId: Int64; const AErrDescription: string);
begin
  // сначала попытаемся сохранить ошибку в Master, а в случае неудачи - в Slave
  if not SaveErrorInDB(srMaster, AStep, AStartId, ALastId, AClientId, AErrDescription) then
    SaveErrorInDB(srSlave, AStep, AStartId, ALastId, AClientId, AErrDescription);
end;

procedure TdmData.SaveValueInDB(const AValue: Int64; const AFieldName: string; const ASaveInMaster: Boolean);
const
  cSelectSettings    = 'select * from _replica.gpSelect_Settings()';
  cUpdateMaster      = 'select * from _replica.gpUpdate_Clients_LastId(%d, %d)';
  cUpdateMasterDDL   = 'select * from _replica.gpUpdate_Clients_LastId_Ddl(%d, %d)';
  cInsUpdateSettings = 'select * from _replica.gpInsertUpdate_Settings(0, %s, %s)';
  cFailSave          = 'Не удалось сохранить значение %s на %s';
var
  iClientId: Int64;
  tmpStmt: IZPreparedStatement;
  sServerRank, sFieldName, sUpdate, sInsUpdate: string;
begin
  {$IFDEF NO_EXECUTE} // для проверки границ пакета, без выполнения запросов
    Exit;
  {$ENDIF}

  iClientId := 0;


  sFieldName := LowerCase(AFieldName);
  Assert((sFieldName = 'last_id') or (sFieldName = 'last_id_ddl'), 'Ф-ия SaveValueInDB предназначена для полей Last_Id и Last_Id_DDL');

  if sFieldName = 'last_id'  then
    sUpdate := cUpdateMaster;

  if sFieldName = 'last_id_ddl'  then
    sUpdate := cUpdateMasterDDL;


  try
    if IsSlaveConnected then
    begin  // Блок ниже с qrySlaveHelper работает в ExecutePreparedPacket,
           // но не работает в ExecuteCommandsOneByOne - ошибок нет, iClientId возвращает, но значение не сохраняется в таб. Settings
           // Причина не установлена. Пришлось использовать отдельно GetSlaveValues.ClientId;

//      with qrySlaveHelper do
//      begin
//        sServerRank := 'Slave';
//        Close;
//        SQL.Clear;
//        SQL.Add(Format(cInsUpdateSettings, [QuotedStr(sFieldName), QuotedStr(IntToStr(AValue))]));
//        Open;
//        iClientId := Fields[0].AsLargeInt;
//        Close;
//      end;


      try
        sServerRank := 'Slave';
        conSlave.DbcConnection.SetAutoCommit(False);
        sInsUpdate := Format(cInsUpdateSettings, [QuotedStr(sFieldName), QuotedStr(IntToStr(AValue))]);
        tmpStmt := conSlave.DbcConnection.PrepareStatement(sInsUpdate);
        tmpStmt.ExecuteUpdatePrepared;
        conSlave.DbcConnection.Commit;
        iClientId := GetSlaveValues.ClientId;
      except
        on E: Exception do
        begin
          conSlave.DbcConnection.Rollback;
          LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
          LogErrMsg(Format(cFailSave, [sFieldName, sServerRank]));
        end;
      end;
    end;

    // Сохранение в Master требуется реже, чем в Slave, поэтому сохранением в Master управляет параметр ASaveInMaster

    // Сохраняем значение AValue в Master._replica.Clients
    if ASaveInMaster and (iClientId > 0) and IsMasterConnected then
    begin
      try
        sServerRank := 'Master';
        conMaster.DbcConnection.SetAutoCommit(False);
        tmpStmt := conMaster.DbcConnection.PrepareStatement(Format(sUpdate, [iClientId, AValue]));
        tmpStmt.ExecuteUpdatePrepared;
        conMaster.DbcConnection.Commit;
      except
        on E: Exception do
        begin
          conMaster.DbcConnection.Rollback;
          LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
          LogErrMsg(Format(cFailSave, [sFieldName, sServerRank]));
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      LogErrMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
      LogErrMsg(Format(cFailSave, [sFieldName, sServerRank]));
    end;
  end;
end;

procedure TdmData.SetStartId(const AValue: Int64);
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

constructor TWorkerThread.Create(CreateSuspended: Boolean; const AStartId: Int64;
  const ASelectRange, APacketRange: Integer; AMsgProc: TNotifyMessage; AKind: TThreadKind);
begin
  FStartId := AStartId;
  FMsgProc := AMsgProc;

  FSelectRange := ASelectRange;
  FPacketRange := APacketRange;

  FData := TdmData.Create(nil, FStartId, FSelectRange, FPacketRange, InnerMsgProc);
  FData.OnChangeStartId := InnerChangeStartId;
  FData.OnNewSession    := InnerNewSession;
  FData.OnEndSession    := InnerEndSession;
  FData.OnNeedRestart   := InnerNeedRestart;

  FreeOnTerminate := (AKind = tknNondriven);

  inherited Create(CreateSuspended);
end;

constructor TWorkerThread.Create(CreateSuspended: Boolean; AMsgProc: TNotifyMessage; AKind: TThreadKind);
begin
  Create(CreateSuspended, 0, 0, 0, AMsgProc, AKind);
end;

destructor TWorkerThread.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

//function TWorkerThread.GetReturnValue: Int64;
//begin
//  Result := ReturnValue;
//end;

procedure TWorkerThread.InnerChangeStartId(const ANewStartId: Int64);
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

procedure TWorkerThread.InnerMsgProc(const AMsg, AFileName: string; const aUID: Cardinal; AMsgType: TLogMessageType);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FMsgProc) then FMsgProc(AMsg, AFileName, aUID, AMsgType);
                     end);
end;

procedure TWorkerThread.InnerNeedRestart(Sender: TObject);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FOnNeedRestart) then FOnNeedRestart(nil);
                     end);
end;

procedure TWorkerThread.InnerNewSession(const AStart: TDateTime; const AMinId, AMaxId: Int64; const ARecCount, ASessionNumber: Integer);
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
//  Data.BuildReplicaCommandsSQL(Data.StartId, Data.SelectRange);
//  ReturnValue := Data.ExecutePreparedPacket;
end;

{ TReplicaThread }

procedure TReplicaThread.Execute;
begin
  inherited;
  Data.StartReplica;
  FReturnValue := Ord(Data.ReplicaFinished);
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
  FReturnValue := LongWord(P);
  Terminate;
end;


{ TCompareRecCountMSThread }

constructor TCompareRecCountMSThread.Create(CreateSuspended, ADeviationsOnly: Boolean; AMsgProc: TNotifyMessage;
  AKind: TThreadKind);
begin
  FDeviationsOnly := ADeviationsOnly;
  inherited Create(CreateSuspended, AMsgProc, AKind);
end;

procedure TCompareRecCountMSThread.Execute;
var
  P: PCompareMasterSlave;
  sSQL: string;
begin
  inherited;
  Data.OnCompareRecCountMS := MyOnCompareRecCountMS;
  sSQL := Data.GetCompareRecCountMS_SQL(FDeviationsOnly);

  New(P);
  P^.ResultSQL := sSQL;
  FReturnValue := LongWord(P);
  Terminate;
end;

procedure TCompareRecCountMSThread.MyOnCompareRecCountMS(const aSQL: string);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FOnCompareRecCountMS) then FOnCompareRecCountMS(aSQL);
                     end);
end;

{ TCompareSeqMSThread }

constructor TCompareSeqMSThread.Create(CreateSuspended, ADeviationsOnly: Boolean; AMsgProc: TNotifyMessage;
  AKind: TThreadKind);
begin
  FDeviationsOnly := ADeviationsOnly;
  inherited Create(CreateSuspended, AMsgProc, AKind);
end;

procedure TCompareSeqMSThread.Execute;
var
  P: PCompareMasterSlave;
  sSQL: string;
begin
  inherited;
  sSQL := Data.GetCompareSeqMS_SQL(FDeviationsOnly);

  New(P);
  P^.ResultSQL := sSQL;
  FReturnValue := LongWord(P);
  Terminate;
end;

{ TApplyScriptThread }

constructor TApplyScriptThread.Create(CreateSuspended: Boolean; AScriptsContent, AScriptNames: TStrings;
  AMsgProc: TNotifyMessage; AKind: TThreadKind);
begin
  FScriptsContent := TStringList.Create;
  FScriptNames    := TStringList.Create;

  FScriptsContent.Assign(AScriptsContent);
  FScriptNames.Assign(AScriptNames);

  inherited Create(CreateSuspended, AMsgProc, AKind);
end;

destructor TApplyScriptThread.Destroy;
begin
  FreeAndNil(FScriptsContent);
  FreeAndNil(FScriptNames);
  inherited;
end;

procedure TApplyScriptThread.Execute;
begin
  inherited;
  FReturnValue := Ord(Data.ApplyScripts(FScriptsContent, FScriptNames));
  Terminate;
end;

{ TMoveProcToSlaveThread }

procedure TMoveProcToSlaveThread.Execute;
begin
  inherited;
  Data.MoveSavedProcToSlave;
  Terminate;
end;

{ TLastIdThread }

procedure TLastIdThread.Execute;
begin
  inherited;
  FReturnValue := Data.LastId;
  Terminate;
end;

{ TAlterSlaveSequencesThread }

procedure TAlterSlaveSequencesThread.Execute;
begin
  inherited;
  Data.AlterSlaveSequences;
  Terminate;
end;

{ TMoveErrorsThread }

procedure TMoveErrorsThread.Execute;
begin
  inherited;
  Data.MoveErrorsFromSlaveToMaster;
end;

end.
