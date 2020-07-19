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
  UDefinitions;

type
  TCmdPair = TPair<Integer, string>;
  TFailCommands = TDictionary<Integer, string>;

  TMinMaxId = (mmMin, mmMax);

  TdmData = class(TDataModule)
    conMaster: TZConnection;
    conSlave: TZConnection;
    qrySelectReplicaSQL: TZReadOnlyQuery;
    qrySelectReplicaCmd: TZReadOnlyQuery;
    qryMasterHelper: TZReadOnlyQuery;
    qryLastId: TZReadOnlyQuery;
  strict private
    FStartId: Integer;
    FLastId: Integer;
    FRange: Integer;
    FMsgProc: TNotifyMessage;
    FFailCommands: TFailCommands; // содержит пары 'table_update_data.Id' - '<SQL-текст запроса>'
    FOnChangeStartId: TOnChangeStartId;
  strict private
    procedure ApplyConnectionConfig(AConnection: TZConnection; ARank: TServerRank);
    procedure ExecuteCommandsOneByOne;
    procedure ExecuteErrCommands;
    procedure LogMsg(const AMsg: string);
  strict private
    procedure SetStartId(const AValue: Integer);
  strict private
    function IsConnected(AConnection: TZConnection; ARank: TServerRank): Boolean;
    function GetMinMaxId(AMinMax: TMinMaxId): Integer;
  public
    constructor Create(AOwner: TComponent; const AStartId, ARange: Integer; AMsgProc: TNotifyMessage); reintroduce;
    destructor Destroy; override;
    
    property OnChangeStartId: TOnChangeStartId read FOnChangeStartId write FOnChangeStartId;
    property StartId: Integer read FStartId write SetStartId;
    property Range: Integer read FRange write FRange;

    function IsMasterConnected: Boolean;
    function IsSlaveConnected: Boolean;
    function IsBothConnected: Boolean;
    function GetReplicaCmdCount: Integer;
    function ExecutePreparedPacket: Integer;
    function MinID: Integer;
    function MaxID: Integer;

    procedure ExecuteAllPackets;
    procedure BuildReplicaCommandsSQL(const AStartId, ARange: Integer);
  end;

  TWorkerThread = class(TThread)
  strict private
    FStartId: Integer;
    FRange: Integer;
    FMsgProc: TNotifyMessage;
    FData: TdmData;
    FOnChangeStartId: TOnChangeStartId;
  strict private
    procedure InnerChangeStartId(const ANewStartId: Integer);
  strict private
    function GetReturnValue: Integer;
  protected
    procedure InnerMsgProc(const AMsg: string);
    procedure MySleep(const AInterval: Cardinal);
    property Data: TdmData read FData;
  public
    constructor Create(CreateSuspended: Boolean; const AStartId, ARange: Integer;
      AMsgProc: TNotifyMessage; AKind: TThreadKind = tknNondriven); reintroduce;
    destructor Destroy; override;
    property OnChangeStartId: TOnChangeStartId read FOnChangeStartId write FOnChangeStartId;
    property MyReturnValue: Integer read GetReturnValue;
  end;

  TSinglePacket = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TReplicaThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  ZDbcIntfs,
  UConstants,
  USettings;


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
  cLastId       = 'Правая граница диапазона: %d';
  cCreateCmdSQL = 'Создание списка команд пакета';
begin
  FLastId := -1;
  LogMsg(cCreateCmdSQL);
  
  qrySelectReplicaCmd.SQL.Clear;

  if IsMasterConnected then
  try
    with qrySelectReplicaSQL do // результат запроса содержит SQL-текст, записанный в виде набора строк
    begin
      Close;
      ParamByName('id_start').AsInteger  := AStartId;
      ParamByName('rec_count').AsInteger := ARange;
      Open;
      First;
      while not EOF do
      begin
        if not Fields[0].IsNull then
          qrySelectReplicaCmd.SQL.Add(Fields[0].AsString); // qrySelectReplicaCmd вернет набор команд репликации (INSERT, UPDATE, DELETE) в поле Result,
        Next;                                              // которые могут быть выполнены пакетами с помощью conSlave
      end;
      Close;
    end;

    // сохраним правую границу диапазона для последующего использования
    with qryLastId do
    begin
      Close;
      ParamByName('id_start').AsInteger := AStartId;
      ParamByName('rec_count').AsInteger := ARange;
      Open;
      if not Fields[0].IsNull then
      begin 
        FLastId := Fields[0].AsInteger;
        LogMsg(Format(cLastId, [FLastId]));
      end;
    end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

constructor TdmData.Create(AOwner: TComponent; const AStartId, ARange: Integer; AMsgProc: TNotifyMessage);
begin
  inherited Create(AOwner);
  FStartId := AStartId;
  FRange   := ARange;
  FMsgProc := AMsgProc;

  FFailCommands := TFailCommands.Create;
end;

destructor TdmData.Destroy;
begin
  FreeAndNil(FFailCommands);
  inherited;
end;

procedure TdmData.ExecuteAllPackets;
var
  iPrevStartId: Integer;
begin
  iPrevStartId := -1;

  while (FStartId > iPrevStartId) and (FStartId <= MaxID) do
  begin
    // Усешное выполнение методов репликации должно увеличивать FStartId и в конце итерации это значение обычно должно быть больше предыдущего.
    // Возможен сценарий, когда в пакете нет ни одной команды. В этом случае FStartId останется неизменным.
    // Сохраним предыдущеее значение FStartId, чтобы потом сравнить его с текущим значением FStartId
    // и избежать бесконечного цикла для случая, когда в пакете нет ни одной команды.
    iPrevStartId := FStartId;

    // формируем пакет команд
    BuildReplicaCommandsSQL(FStartId, FRange);
    
    // пытаемся передать пакет за один раз
    if ExecutePreparedPacket = 0 then // если передача пакета завершилась неудачей
      ExecuteCommandsOneByOne; // выполняем команды по одной. Id и SQL невыполненных команд сохраняем в словарь FFailCommands
      
    // выполняем команды, которые не удалось выполнить на этапе "по одной команде"  
    if FFailCommands.Count > 0 then
      ExecuteErrCommands;
  end;
end;

procedure TdmData.ExecuteCommandsOneByOne; // предполагается использовать внутри ExecuteAllPackets
var
  sSQL: string;
const
  cErrCmdMsg = '>> Команда c Id= %d и SQL=' + #13#10 + ' %s ' + #13#10 + 'не выполнена';
begin
  conSlave.AutoCommit := True;
  try
    // будем выполнять команды по одной
    if IsBothConnected then
      with qrySelectReplicaCmd do // SQL был предварительно сформирован в BuildReplicaCommandsSQL
      begin
        Close;
        Open;
        First;
        while not EOF do
        begin
          // поле 'Result' содержит SQL-текст команды
          if not FieldByName('Result').IsNull then
          begin 
            sSQL := FieldByName('Result').AsString; 
            conSlave.DbcConnection.PrepareStatement(sSQL).ExecutePrepared;
          end;

          // поле 'Id' содержит table_update_data.Id 
          // если 'conSlave.DbcConnection.PrepareStatement(sSQL).ExecutePrepared' выполнен успешно, тогда можем обновить StartId
          if not FieldByName('Id').IsNull then
            StartId := FieldByName('Id').AsInteger + 1; // используем св-во StartId, а не FStartId, чтобы значение сразу сохранилось в TSettings.ReplicaStart
            
          Next;
        end;
        Close;
      end;
  except
    on E: Exception do
    begin
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
        
      // Id и SQL невыполненных  команд сохраняем в словарь FFailCommands
      with qrySelectReplicaCmd do
      begin 
        if not FieldByName('Id').IsNull then
          FFailCommands.Add(
            FieldByName('Id').AsInteger, 
            FieldByName('Result').AsString
          );

        if not FieldByName('Id').IsNull then
          LogMsg(
            Format(cErrCmdMsg, [
              FieldByName('Id').AsInteger,
              FieldByName('Result').AsString
            ])
          );
      end;    
    end;
  end;
end;

procedure TdmData.ExecuteErrCommands;
var
  I: Integer;
  tmpPair: TCmdPair;
  arrId: TIntegerDynArray;
const
  cRemainedErrCmds = '>> Есть команды, которые не были выполнены:';
  cErrCmd = 'Id= %d  SQL= %s';  
begin
  // словарь FFailCommands содержит команды, которые 
  // не удалось выполнить в пакетной выгрузке и в выгрузке "по одной команде"

  SetLength(arrId, 0); // в этот массив будем записывать Id успешных команд

  conSlave.AutoCommit := True;      
  try
    // будем выполнять команды по одной из словаря FFailCommands
    if IsSlaveConnected then
      for tmpPair in FFailCommands do
      begin  
        conSlave.DbcConnection.PrepareStatement(tmpPair.Value).ExecutePrepared;
        // ключ словаря tmpPair.Key содержит table_update_data.Id 
        // сохраним Id успешной команды, чтобы потом удалить ее из словаря
        SetLength(arrId, Length(arrId) + 1);
        arrId[High(arrId)] := tmpPair.Key; 
        // возможно, эта команда является последней в диапазоне Id
        // теперь, после успешного выполнения, ее Id можно использовать, чтобы изменить StartId
        if tmpPair.Key > StartId then
          StartId := tmpPair.Key + 1;
      end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;   

  // удалим из словаря команды, которые были успешно выполнены
  for I := Low(arrId) to High(arrId) do
    if FFailCommands.ContainsKey(arrId[I]) then
      FFailCommands.Remove(arrId[I]);

  FFailCommands.TrimExcess;  

  // если остались команды, которые так и не были выполнены, тогда пишем их в лог
  if FFailCommands.Count > 0 then
  begin
    LogMsg(cRemainedErrCmds);
    for tmpPair in FFailCommands do
      LogMsg(Format(cErrCmd, [tmpPair.Key, tmpPair.Value]));
  end;
end;

function TdmData.ExecutePreparedPacket: Integer;
var
  tmpSL: TStringList;
  tmpStmt: IZPreparedStatement;
const
  cCmdListComplete = 'Создан список из %d команд';
  cStartBatchLoad  = 'Старт пакетной передачи';
  cEndBatchLoad    = 'Окончание пакетной передачи';
  cFailBatchLoad   = '>> Пакетная передача завершилась неудачей';
  cNewStartId      = 'StartId = %d';
begin
  Result := 0;

  tmpSL := TStringList.Create;
  try
    try
      // будем формировать пакет из набора команд, которые вернет qrySelectReplicaCmd
      if IsMasterConnected then
        with qrySelectReplicaCmd do
        begin
          Close;
          Open;
          First;
          while not EOF do
          begin
            tmpSL.Add(FieldByName('Result').AsString + ';');
            Next;
          end;
          Close;
          LogMsg(Format(cCmdListComplete, [tmpSL.Count]));
        end;
    except
      on E: Exception do
        LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;

    try
      // пакетная выгрузка (сделано по образцу кода из Release Notes "2.1.3 Batch Loading")
      if (tmpSL.Count > 0) and IsSlaveConnected then
      begin
        LogMsg(cStartBatchLoad);
        conSlave.DbcConnection.SetAutoCommit(False);
        tmpStmt := conSlave.DbcConnection.PrepareStatement(tmpSL.Text);
        Result := tmpStmt.ExecuteUpdatePrepared;
        conSlave.DbcConnection.Commit;
        LogMsg(cEndBatchLoad);
        // пакет успешно выполнен и можем передвинуть StartId на новую позицию
        StartId := FLastId + 1;
        LogMsg(Format(cNewStartId, [StartId]));
      end;
    except
      on E: Exception do
      begin
        conSlave.DbcConnection.Rollback;
        LogMsg(cFailBatchLoad);
        LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
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

procedure TdmData.LogMsg(const AMsg: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg);
end;

function TdmData.GetMinMaxId(AMinMax: TMinMaxId): Integer;
const
  cMinSQL = 'select Min(Id) from _replica.table_update_data';
  cMaxSQL = 'select Max(Id) from _replica.table_update_data';
var
  sSQL: string;
begin
  Result := -1;

  case AMinMax of
    mmMin: sSQL := cMinSQL;
    mmMax: sSQL := cMaxSQL;
  end;

  try
    if IsMasterConnected then
      with qryMasterHelper do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sSQL);
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

function TdmData.MaxID: Integer;
begin
  Result := GetMinMaxId(mmMax);
end;

function TdmData.MinID: Integer;
begin
  Result := GetMinMaxId(mmMin);
end;

procedure TdmData.SetStartId(const AValue: Integer);
begin
  if FStartId <> AValue then
  begin
    FStartId := AValue;
    TSettings.ReplicaStart := FStartId;
    if Assigned(FOnChangeStartId) then
      FOnChangeStartId(FStartId);
  end;
end;


{ TWorkerThread }

constructor TWorkerThread.Create(CreateSuspended: Boolean; const AStartId, ARange: Integer;
  AMsgProc: TNotifyMessage; AKind: TThreadKind);
begin
  FStartId := AStartId;
  FRange   := ARange;
  FMsgProc := AMsgProc;

  FData := TdmData.Create(nil, FStartId, FRange, InnerMsgProc);
  FData.OnChangeStartId := InnerChangeStartId;

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

procedure TWorkerThread.InnerMsgProc(const AMsg: string);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FMsgProc) then FMsgProc(AMsg);
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


{ TSinglePacket }

procedure TSinglePacket.Execute;
begin
  inherited;
  Data.BuildReplicaCommandsSQL(Data.StartId, Data.Range);
  ReturnValue := Data.ExecutePreparedPacket;
end;

{ TReplicaThread }

procedure TReplicaThread.Execute;
begin
  inherited;
  Data.ExecuteAllPackets;
end;

end.
