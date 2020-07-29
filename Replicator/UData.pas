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
  TMinMaxId = record
    MinId: Integer;
    MaxId: Integer;
    RecCount: Integer;
  end;

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
    FSelectRange: Integer;
    FPacketRange: Integer;
    FSessionNumber: Integer;
    FMsgProc: TNotifyMessage;
    FStopped: Boolean;
    FCommandData: TCommandData;
    FFailCmds: TCommandData;
    FOnChangeStartId: TOnChangeStartId;
    FOnNewSession: TOnNewSession;
    FOnEndSession: TNotifyEvent;
  strict private
    procedure ApplyConnectionConfig(AConnection: TZConnection; ARank: TServerRank);
    procedure ExecuteCommandsOneByOne;
    procedure ExecuteErrCommands;
    procedure LogMsg(const AMsg, AFileName: string); overload;
    procedure LogMsg(const AMsg: string); overload;
    procedure LogSameMsg(const AMsg: string);
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

    function ExecutePreparedPacket: Integer;
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
    procedure InnerMsgProc(const AMsg, AFileName: string; ALine: TMessageLine);
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

  TReplicaThread = class(TWorkerThread)
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
  UConstants,
  USettings,
  UCommon;

const
  cAttempt1 = '������� �1 %d-%d  ����� %s  ������ %s  %s';
  cAttempt2 = '������� �2 %d-%d  ����� %d  ����� %s �������: %d  ���������: %d  ������ %s';
  cAttempt3 = '������� �3 ����� %d  ����� %s �������: %d  ���������: %d  ������ %s';


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
//    Properties.Add('timeout=1');// ������� ������� - 1 �������
  end;
end;

procedure TdmData.BuildReplicaCommandsSQL(const AStartId, ARange: Integer);
const
  cLastId       = '������ ������� ���������: %d';
  cCreateCmdSQL = '�������� ������ ������ ������';
  cElapsedTime  = '������ ������ ������ ������ �� %s' + #13#10;
  cElapsedFetch = '��������� ������ �������: %s  ����� �������� �������: %d';
  cElapsedBuild = '������������ ������ TCommandData: %s';
var
  crdStart, crdStartFetch, crdStartBuild: Cardinal;
  dtmStart: TDateTime;
begin
  if FStopped then Exit;

  Inc(FSessionNumber);
  FLastId := -1;
  crdStart := GetTickCount;
  dtmStart := Now;
  LogMsg(cCreateCmdSQL);

  qrySelectReplicaCmd.Close;
  qrySelectReplicaCmd.SQL.Clear;

  if IsMasterConnected then
  try
    with qrySelectReplicaSQL do // ��������� ������� �������� SQL-�����, ���������� � ���� ������ �����
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

    // qrySelectReplicaCmd ������ ����� ������ ���������� (INSERT, UPDATE, DELETE) � ���� Result,
    // ������� ����� ���� ��������� �������� � ������� conSlave
    crdStartFetch := GetTickCount;
    qrySelectReplicaCmd.Open;
    qrySelectReplicaCmd.FetchAll;
    LogMsg(Format(cElapsedFetch, [Elapsed(crdStartFetch), qrySelectReplicaCmd.RecordCount]));

    // ������ ���� ������ ������, ������� �������� �������� ������ �������� � ������ ������ transaction_id
    crdStartBuild := GetTickCount;
    FCommandData.BuildData(qrySelectReplicaCmd);
    qrySelectReplicaCmd.Close;
    LogMsg(Format(cElapsedBuild, [Elapsed(crdStartBuild)]));

    FCommandData.Last; //����� ��������� MaxId

    // �������� ���� � ����� ������ � GUI
    if Assigned(FOnNewSession) then
      FOnNewSession(dtmStart, AStartId, FCommandData.Data.Id, FCommandData.Count, FSessionNumber);

    // �������� ������ ������� ��������� ��� ������������ �������������
    with qryLastId do
    begin
      Close;
      ParamByName('id_start').AsInteger  := AStartId;
      ParamByName('rec_count').AsInteger := ARange;
      Open;
      if not Fields[0].IsNull then
      begin 
        FLastId := Fields[0].AsInteger;
//        LogMsg(Format(cLastId, [FLastId]));
      end;
    end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

  LogMsg(Format(cElapsedTime, [Elapsed(crdStart)]));
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
end;

destructor TdmData.Destroy;
begin
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

  // MaxID - ��� �-��, ������� ���������� 'select Max(Id) from _replica.table_update_data'
  while (FStartId > iPrevStartId) and (FStartId <= MaxID) and not FStopped do
  begin
    // �������� ���������� ������� ���������� ������ ����������� FStartId � � ����� �������� ��� �������� ������ ������ ���� ������ �����������.
    // �������� ��������, ����� � ������ ��� �� ����� �������. � ���� ������ FStartId ��������� ����������.
    // �������� ����������� �������� FStartId, ����� ����� �������� ��� � ������� ��������� FStartId
    // � �������� ������������ ����� ��� ������, ����� � ������ ��� �� ����� �������.
    iPrevStartId := FStartId;

    // ��������� ����� ������ � �������� StartId..(StartId + SelectRange)
    // FStartId ������������� � �������� ���������� ������
    // �������� ������ ������� ����� ���� > (FStartId + FSelectRange), ������ ��� BuildReplicaCommandsSQL ��������� ������ ����������
    // � ������������ �������, ����� ������ � ����������� �������� ���������� ���� � ����� ������
    BuildReplicaCommandsSQL(FStartId, FSelectRange);

    // �������� ������� �� �������� StartId..(StartId + SelectRange) ��������
    while (FStartId < FLastId) and not FStopped do
    begin
      // ������� ��������� �������� ������ ����� �������. Id ������� ������ � ��������� FStartId..(FStartId + FPacketRange)
      if ExecutePreparedPacket = 0 then // ���� �������� ������ ����������� ��������
        ExecuteCommandsOneByOne; // ��������� ������� �� �����. Id � SQL ������������� ������ ��������� � FFailCmds

      // ��������� �������, ������� �� ������� ��������� �� ����� "�� ����� �������"
      if FFailCmds.Count > 0 then
        ExecuteErrCommands;
    end;

    // ������ ���������, �������� ���� � GUI
    if Assigned(FOnEndSession) then
      FOnEndSession(nil);
  end;
end;

procedure TdmData.ExecuteCommandsOneByOne; // �������������� ������������ ������ ExecuteAllPackets ����� ������� ExecutePreparedPacket
var
  iStartId, iMaxId, iSuccCount, iFailCount, iTotCount: Integer;
  dtmStart: TDateTime;
begin
  // ����� ��������� ������� �� �����
  if FStopped then Exit;

  dtmStart := Now;

  try
    iMaxId := FStartId + FPacketRange;
    iMaxId := FCommandData.NearestId(iMaxId);

    FCommandData.MoveToId(FStartId);
    iStartId   := FStartId;
    iSuccCount := 0;
    iFailCount := 0;
    iTotCount  := FCommandData.RecordCount(FStartId, iMaxId);

    // ������ "������� �2 �����: 2036 ����� 12:03:54 �������:0  ���������:0  ������ "
    LogMsg(Format(cAttempt2, [iStartId, iMaxId, iTotCount, FormatDateTime(cTimeStrShort, dtmStart), iSuccCount, iFailCount, EmptyStr]));

    while not FCommandData.EOF and (FCommandData.Data.Id <= iMaxId) and not FStopped do
    begin
      try
        if IsSlaveConnected then
          with conSlave.DbcConnection do
          begin
            SetAutoCommit(False);
            PrepareStatement(FCommandData.Data.SQL).ExecutePrepared;
            Commit;
            // FCommandData.Data.Id �������� table_update_data.Id
            // ���� 'ExecutePrepared' �������� �������, ����� ����� �������� StartId
            StartId := FCommandData.Data.Id + 1; // ���������� ��-�� StartId, � �� FStartId, ����� �������� ����� ����������� � TSettings.ReplicaStart
            Inc(iSuccCount);
            // ������ "������� �2 �����: 2036 ����� 12:03:54 �������: 1235 ���������: 235 ������ 00:05:03_759"
            // LogSameMsg ����� � ��������� ������ Memo, ������� �����, ����� ����� ������ ������� "LogMsg(Format(cAttempt2,..." �
            // LogSameMsg �� ���� ������� LogMsg(Msg) ����� ���, ������� ����� � ��������� ���� LogMsg(Msg, 'Some-file')
            LogSameMsg(Format(cAttempt2, [iStartId, iMaxId, iTotCount, FormatDateTime(cTimeStrShort, dtmStart), iSuccCount, iFailCount, Elapsed(dtmStart)]));
          end;
      except
        on E: Exception do
        begin
          conSlave.DbcConnection.Rollback;
          // Id � SQL �������������  ������ ��������� � FFailCmds
          FFailCmds.Add(FCommandData.Data.Id, FCommandData.Data.TransId, FCommandData.Data.SQL);
          Inc(iFailCount);
          // ������ "������� �2 �����: 2036 ����� 12:03:54 �������: 1235 ���������: 236 ������ 00:05:03_759"
          LogSameMsg(Format(cAttempt2, [iStartId, iMaxId, iTotCount, FormatDateTime(cTimeStrShort, dtmStart), iSuccCount, iFailCount, Elapsed(dtmStart)]));
        end;
      end;

      FCommandData.Next;
    end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TdmData.ExecuteErrCommands;
var
  iSuccCount, iFailCount, iTotCount: Integer;
  dtmStart: TDateTime;
  sFileName: string;
const
  cFileName  = '\Err_commands\%s';
  cFileErr   = '%s__ERR_id-%d.txt';
begin
  // FFailCmds �������� �������, ������� �� ������� ��������� � �������� �������� � � �������� "�� ����� �������"

  if FStopped then Exit;
  
  dtmStart := Now;

  FFailCmds.First;

  iTotCount  := FFailCmds.Count;
  iSuccCount := 0;
  iFailCount := 0;

  // ������ "������� �3 �����: 2036 ����� 12:03:54 �������:0  ���������:0  ������ "
  if FFailCmds.Count > 0 then
    LogMsg(Format(cAttempt3, [iTotCount, FormatDateTime(cTimeStrShort, dtmStart), iSuccCount, iFailCount, EmptyStr]));


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
          // LogSameMsg ����� � ��������� ������ Memo, ������� �����, ����� ����� ������ ������� "LogMsg(Format(cAttempt3,..." �
          // LogSameMsg �� ���� ������� LogMsg(Msg) ����� ���, ������� ����� � ��������� ���� LogMsg(Msg, 'Some-file')
          LogSameMsg(Format(cAttempt3, [iTotCount, FormatDateTime(cTimeStrShort, dtmStart), iSuccCount, iFailCount, Elapsed(dtmStart)]));
        end;
    except
      on E: Exception do
      begin
        conSlave.DbcConnection.Rollback;
        // �������, ������� ��� � �� ���� ���������, ����� � ���
        sFileName := Format(cFileName, [
          Format(cFileErr, [
            FormatDateTime(cDateTimeFileNameStr, Now),
            FFailCmds.Data.Id
          ])
        ]);
        LogMsg(FFailCmds.Data.SQL, sFileName);

        Inc(iFailCount);
        LogSameMsg(Format(cAttempt3, [iTotCount, FormatDateTime(cTimeStrShort, dtmStart), iSuccCount, iFailCount, Elapsed(dtmStart)]));
      end;
    end;

    FFailCmds.Next;
  end;

  FFailCmds.Clear;
end;

function TdmData.ExecutePreparedPacket: Integer;
var
  dtmStart: TDateTime;
  iMaxId, iStartId: Integer;
  sFileName: string;
  tmpSL: TStringList;
  tmpStmt: IZPreparedStatement;
const
  cCmdListComplete = '������ ������ �� %d ������';
  cStartBatchLoad  = '����� �������� ��������';
  cEndBatchLoad    = '��������� �������� ��������. ����� �������� %s';
  cFailBatchLoad   = '>> �������� �������� ����������� ��������: %s';
  cNewStartId      = 'StartId = %d';
  cFileName        = '\Packets\%s';
  cFileOK          = '%s__id-%d-%d.txt';
  cFileErr         = '%s__ERR_id-%d-%d.txt';
begin
  Result := 0;

  if FStopped then Exit;

  iStartId := FStartId;
  dtmStart := Now;

  iMaxId := FStartId + FPacketRange;
  iMaxId := FCommandData.NearestId(iMaxId);
  // ������  "������� �1 523601-529001 ����� 12:01:22 ������"
  LogMsg(Format(cAttempt1, [iStartId, iMaxId, FormatDateTime(cTimeStrShort, dtmStart), EmptyStr, EmptyStr]));

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
      // �������� �������� (������� �� ������� ���� �� Release Notes "2.1.3 Batch Loading")
      if (tmpSL.Count > 0) and IsSlaveConnected and not FStopped then
      begin
        conSlave.DbcConnection.SetAutoCommit(False);
        tmpStmt := conSlave.DbcConnection.PrepareStatement(tmpSL.Text);
        Result := tmpStmt.ExecuteUpdatePrepared;
        conSlave.DbcConnection.Commit;

        // ����� ������� �������� � ����� ����������� StartId �� ����� �������
        StartId := FLastId + 1;

        // ������ ������ � ����
        sFileName := Format(cFileName, [
          Format(cFileOK, [
            FormatDateTime(cDateTimeFileNameStr, Now),
            iStartId,
            iMaxId
          ])
        ]);
        LogMsg(tmpSL.Text, sFileName);

        // ������  "������� �1 523601-529001 ����� 12:01:22 ������ 00:01:23_259 "
        // LogSameMsg ����� � ��������� ������ Memo, ������� �����, ����� ����� ������ ������� "LogMsg(Format(cAttempt1,..." �
        // LogSameMsg �� ���� ������� LogMsg(Msg) ����� ���, ������� ����� � ��������� ���� LogMsg(Msg, 'Some-file')
        LogSameMsg(Format(cAttempt1, [iStartId, iMaxId, FormatDateTime(cTimeStrShort, dtmStart), Elapsed(dtmStart), EmptyStr]));
      end;
    except
      on E: Exception do
      begin
        conSlave.DbcConnection.Rollback;
        sFileName := Format(cFileName, [
          Format(cFileErr, [
            FormatDateTime(cDateTimeFileNameStr, Now),
            iStartId,
            iMaxId
          ])
        ]);
        LogMsg(tmpSL.Text, sFileName);
        // ������  "������� �1 523601-529001 ����� 12:01:22 ������ 00:01:23_259 error"
        LogSameMsg(Format(cAttempt1, [iStartId, iMaxId, FormatDateTime(cTimeStrShort, dtmStart), Elapsed(dtmStart), 'error']));
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
    // ����� �������������� �������������� SQL �� qrySelectReplicaCmd
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

procedure TdmData.LogSameMsg(const AMsg: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, EmptyStr, mlSame);
end;

procedure TdmData.LogMsg(const AMsg, AFileName: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg, AFileName);
end;

function TdmData.GetMinMaxId: TMinMaxId;
const
  cSelect = 'select * from _replica.gpSelect_MinMaxId()';
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
begin
  Result := GetMinMaxId.MaxId;
end;

function TdmData.MinID: Integer;
begin
  Result := GetMinMaxId.MinId;
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

procedure TdmData.StopReplica;
begin
  FStopped := True;
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

procedure TWorkerThread.InnerMsgProc(const AMsg, AFileName: string; ALine: TMessageLine);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FMsgProc) then FMsgProc(AMsg, AFileName, ALine);
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
  // ����� ��������� �������� ������������ Sleep, �� � ������� �� ���� ����� ����� �������� ���� ����� Terminated
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
end;

end.
