unit UMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  DateUtils,
  Data.DB,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin,
  Vcl.Grids,
  Vcl.DBGrids,
  UConstants,
  UDefinitions,
  ULog,
  UScriptFiles,
  UData,
  USnapshotThread;


type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    tsLog: TTabSheet;
    tsSettings: TTabSheet;
    pnlLogTop: TPanel;
    pnlLogLeft: TPanel;
    pnlLog: TPanel;
    grpMaster: TGroupBox;
    grpSlave: TGroupBox;
    lbMasterServer: TLabel;
    edtMasterServer: TEdit;
    lbDatabase: TLabel;
    edtMasterDatabase: TEdit;
    lbSlaveServer: TLabel;
    edtSlaveServer: TEdit;
    lbSlaveDatabase: TLabel;
    edtSlaveDatabase: TEdit;
    btnSendSinglePacket: TButton;
    pgcLog: TPageControl;
    tsMemo: TTabSheet;
    tsChk: TTabSheet;
    lbMasterUser: TLabel;
    lbMasterPort: TLabel;
    edtMasterUser: TEdit;
    edtMasterPort: TEdit;
    lbMasterPassword: TLabel;
    edtMasterPassword: TEdit;
    lbSlaveUser: TLabel;
    edtSlaveUser: TEdit;
    lbSlavePassword: TLabel;
    edtSlavePassword: TEdit;
    lbSlavePort: TLabel;
    edtSlavePort: TEdit;
    lbLibLocation: TLabel;
    edtLibLocation: TEdit;
    btnLibLocation: TButton;
    {$WARNINGS OFF}
    opndlgMain: TFileOpenDialog;
    btnTestMaster: TButton;
    btnTestSlave: TButton;
    btnReplicaCommandsSQL: TButton;
    btnMinId: TButton;
    btnMaxId: TButton;
    btnUseMinId: TButton;
    btnStartReplication: TButton;
    chkWriteLog: TCheckBox;
    grpAllData: TGroupBox;
    lbAllMinId: TLabel;
    edtAllMinId: TEdit;
    lbAllMaxId: TLabel;
    edtAllMaxId: TEdit;
    lbAllStart: TLabel;
    edtAllRecCount: TEdit;
    lbAllRecCount: TLabel;
    lbAllElapsed: TLabel;
    pbAll: TProgressBar;
    grpSession: TGroupBox;
    lbSsnMinId: TLabel;
    edtSsnMinId: TEdit;
    lbSsnMaxId: TLabel;
    edtSsnMaxId: TEdit;
    lbSsnRecCount: TLabel;
    edtSsnRecCount: TEdit;
    lbSsnStart: TLabel;
    lbSsnElapsed: TLabel;
    sePacketRange: TSpinEdit;
    lbPacketRange: TLabel;
    seSelectRange: TSpinEdit;
    lbSelectRange: TLabel;
    pbSession: TProgressBar;
    chkShowLog: TCheckBox;
    btnStop: TButton;
    lbSsnNumber: TLabel;
    tmrElapsed: TTimer;
    lstLog: TListBox;
    chkWriteCommands: TCheckBox;
    chkStopIfErr: TCheckBox;
    tsCompare: TTabSheet;
    pnlCompareTop: TPanel;
    pnlCompareGrid: TPanel;
    grdCompareRecCount: TDBGrid;
    btnUpdateCompareRecCount: TButton;
    chkDeviationOnlyRecCount: TCheckBox;
    dsCompareRecCount: TDataSource;
    lbCompareExecutingRecCount: TLabel;
    btnCancelCompareRecCount: TButton;
    lbReconnectTimeout: TLabel;
    seReconnectTimeout: TSpinEdit;
    lbReconnectMinute: TLabel;
    grpScripts: TGroupBox;
    pnlScriptBottom: TPanel;
    pnlScriptTop: TPanel;
    btnApplyScript: TButton;
    pnlScriptList: TPanel;
    mmoScriptLog: TMemo;
    tmrRestartReplica: TTimer;
    btnCancelScript: TButton;
    btnUpdateScriptIni: TButton;
    edtScriptPath: TEdit;
    lbScriptPath: TLabel;
    btnScriptPath: TButton;
    btnMoveProcsToSlave: TButton;
    btnStopMoveProcsToSlave: TButton;
    chkSaveErr1: TCheckBox;
    chkSaveErr2: TCheckBox;
    btnStartAlterSlaveSequences: TButton;
    btnStopAlterSlaveSequences: TButton;
    pgcCompare: TPageControl;
    tsCompareRecCount: TTabSheet;
    tsCompareSequences: TTabSheet;
    pnl1: TPanel;
    grdCompareSeq: TDBGrid;
    pnl2: TPanel;
    lbCompareExecutingSeq: TLabel;
    btnUpdateCompareSeq: TButton;
    chkDeviationOnlySeq: TCheckBox;
    btnCancelCompareSeq: TButton;
    dsCompareSeq: TDataSource;
    tmrUpdateAllData: TTimer;
    splHrz: TSplitter;
    mmoError: TMemo;
    tsSnapshot: TTabSheet;
    SnapshotLog: TMemo;
    btnSnapshotStart: TButton;
    btnSnapshotPause: TButton;
    lvTables: TListView;
    SnapshotElapsedTimer: TTimer;
    Panel1: TPanel;
    lbElapsed: TLabel;
    lbElapsedCaption: TLabel;
    lbErrorsCaption: TLabel;
    lbErrors: TLabel;
    lbCurrentTableCaption: TLabel;
    lbCurrentTable: TLabel;
    lbProcessed: TLabel;
    lbProcessedPercent: TLabel;
    lbStatus: TLabel;
    lbBatchCount: TLabel;
    edtSnapshotSelectCount: TEdit;
    Label1: TLabel;
    edtSnapshotInsertCount: TEdit;
    Label2: TLabel;
    edtSnapshotBlobSelectCount: TEdit;
    lbBatchTextCount: TLabel;
    edtSnapshotSelectTextCount: TEdit;
    Label4: TLabel;
    edtSnapshotInsertTextCount: TEdit;
    btnClearSnapshotLog: TButton;
    {$WARNINGS ON}
    procedure chkShowLogClick(Sender: TObject);
    procedure btnLibLocationClick(Sender: TObject);
    procedure btnTestMasterClick(Sender: TObject);
    procedure btnTestSlaveClick(Sender: TObject);
    procedure btnSendSinglePacketClick(Sender: TObject);
    procedure btnReplicaCommandsSQLClick(Sender: TObject);
    procedure seSelectRangeChange(Sender: TObject);
    procedure edtStartReplicaExit(Sender: TObject);
    procedure mmoLogChange(Sender: TObject);
    procedure btnMinIdClick(Sender: TObject);
    procedure btnMaxIdClick(Sender: TObject);
    procedure btnUseMinIdClick(Sender: TObject);
    procedure btnStartReplicationClick(Sender: TObject);
    procedure chkWriteLogClick(Sender: TObject);
    procedure sePacketRangeChange(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure tmrElapsedTimer(Sender: TObject);
    procedure chkWriteCommandsClick(Sender: TObject);
    procedure edtLibLocationChange(Sender: TObject);
    procedure chkStopIfErrClick(Sender: TObject);
    procedure btnUpdateCompareRecCountClick(Sender: TObject);
    procedure btnCancelCompareRecCountClick(Sender: TObject);
    procedure seReconnectTimeoutChange(Sender: TObject);
    procedure btnApplyScriptClick(Sender: TObject);
    procedure btnCancelScriptClick(Sender: TObject);
    procedure btnScriptPathClick(Sender: TObject);
    procedure btnMoveProcsToSlaveClick(Sender: TObject);
    procedure btnStopMoveProcsToSlaveClick(Sender: TObject);
    procedure btnUpdateScriptIniClick(Sender: TObject);
    procedure chkSaveErr1Click(Sender: TObject);
    procedure chkSaveErr2Click(Sender: TObject);
    procedure btnStartAlterSlaveSequencesClick(Sender: TObject);
    procedure chkDeviationOnlyRecCountClick(Sender: TObject);
    procedure chkDeviationOnlySeqClick(Sender: TObject);
    procedure btnUpdateCompareSeqClick(Sender: TObject);
    procedure btnCancelCompareSeqClick(Sender: TObject);
    procedure btnStopAlterSlaveSequencesClick(Sender: TObject);
    procedure tmrUpdateAllDataTimer(Sender: TObject);
    procedure btnSnapshotStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSnapshotPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SnapshotElapsedTimerTimer(Sender: TObject);
    procedure btnClearSnapshotLogClick(Sender: TObject);
  private
    FLog: TLog;
    FData: TdmData;
    FScriptFiles: TScriptFiles;
    FReplicaThrd: TReplicaThread;
    FMinMaxThrd: TMinMaxIdThread;
    FLastIdThrd: TLastIdThread;
    FCompareRecCountMSThrd: TCompareRecCountMSThread;
    FCompareSeqMSThrd: TCompareSeqMSThread;
    FApplyScriptThrd: TApplyScriptThread;
    FMoveProcToSlaveThrd: TMoveProcToSlaveThread;
    FAlterSlaveSequencesThrd: TAlterSlaveSequencesThread;
    FSsnMinId: Int64;
    FSsnMaxId: Int64;
    FSsnStep: Double;
    FStartTimeReplica: TDateTime;
    FStartTimeSession: TDateTime;
    FPrevUID: Cardinal;
    FSnapshotRunning: boolean;
    FSnapShotThread: TSnapshotThread;
    FSnapshotStartTime: TDateTime;
    FSnapshotElapsedSeconds: Int64;
    FSnapshotElapsedSecondsBeforePause: Int64;
    FErrors: integer;
    FSnapshotTableHasErrors: boolean;
  private
    procedure ReadSettings;
    procedure WriteSettings;
    procedure AssignOnExitSettings;
    procedure ApplyScript;
    procedure SwitchShowLog;
    procedure CompareMasterSlaveRecCount;
    procedure CompareMasterSlaveSeq;
    procedure CheckReplicaMaxMin;
    procedure FetchLastId;
    procedure StartReplica;
    procedure StopReplicaThread;
    procedure StopMinMaxThread;
    procedure StopLastIdThread;
    procedure StopCompareRecCountMSThread;
    procedure StopCompareSeqMSThread;
    procedure StopAlterSlaveSequences;
    procedure StopApplyScriptThread;
    procedure StopMoveProcToSlaveThread;
    procedure UpdateProgBarPosition(AProgBar: TProgressBar; const AMax, ACurrValue, ARecCount: Int64);
    procedure LogMessage(const AMsg: string; const AFileName: string = ''; const aUID: Cardinal = 0;
      AMsgType: TLogMessageType = lmtPlain);
    procedure LogApplyScript(const AMsg: string; const AFileName: string = ''; const aUID: Cardinal = 0;
      AMsgType: TLogMessageType = lmtPlain);

    procedure OnChangeStartId(const ANewStartId: Int64);
    procedure OnNewSession(const AStart: TDateTime; const AMinId, AMaxId: Int64; const ARecCount, ASessionNumber: Integer);
    procedure OnEndSession(Sender: TObject);
    procedure OnNeedReplicaRestart(Sender: TObject);
    procedure OnTerminateAlterSlaveSequences(Sender: TObject);
    procedure OnTimerRestartReplica(Sender: TObject);
    procedure OnTerminateSinglePacket(Sender: TObject);
    procedure OnTerminateReplica(Sender: TObject);
    procedure OnTerminateMinMaxId(Sender: TObject);
    procedure OnTerminateLastId(Sender: TObject);
    procedure OnTerminateCompareRecCountMS(Sender: TObject);
    procedure OnTerminateCompareSeqMS(Sender: TObject);
    procedure OnTerminateApplyScript(Sender: TObject);
    procedure OnTerminateMoveSavedProcToSlave(Sender: TObject);
    procedure grdDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);

    procedure SaveSnapshotLog(ALogMessage: string);
    procedure SnapshotThreadError(AError: string);
    procedure SnapshotThreadFinish;
    procedure SnapshotThreadNewTable(ATableName: string);
    procedure SnapshotThreadFinishTable(ATableName: string);
    procedure SnapshotThreadProcessed(ATotalCount, AProcessedCount: int64);
    procedure SnapshotThreadMessage(AMessage: string);
    procedure SnapshotThreadStatus(AStatus: string);
  private
    procedure OnExitSettings(Sender: TObject);
    procedure InitSnapshotTables;
    procedure UpdateSnapshotElapsedTime;
    procedure UpdateSnapshotErrors;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  System.Math,
  System.IOUtils,
  USettings,
  UCommon,
  UFileVersion;

const
  // Период обновления "Все данные"
  cUpdateAllDataInterval = c1Minute * 5;

  // Сообщения
  cLogMsg = '%s  %s';

  cStartPointReplica     = 'начало репликации %s';
  cElapsedReplica        = 'прошло %s';
  cStartPointSession     = 'начало сессии %s';
  cElapsedSession        = 'прошло %s';
  cSessionNumber         = 'сессия № %d';
  cCompareQueryExecuting = 'выполняется запрос ...';



function BelongsTo(AControl, ASerachParent: TWinControl): Boolean;
var
  tmpParent: TWinControl;
begin
  tmpParent := AControl.Parent;

  while (tmpParent <> nil) and (tmpParent <> ASerachParent) do
    tmpParent := tmpParent.Parent;

  Result := (tmpParent = ASerachParent);
end;

procedure TfrmMain.ReadSettings;
begin
  edtMasterServer.Text   := TSettings.MasterServer;
  edtMasterDatabase.Text := TSettings.MasterDatabase;
  edtMasterUser.Text     := TSettings.MasterUser;
  edtMasterPassword.Text := TSettings.MasterPassword;
  edtMasterPort.Text     := IntToStr(TSettings.MasterPort);

  edtSlaveServer.Text   := TSettings.SlaveServer;
  edtSlaveDatabase.Text := TSettings.SlaveDatabase;
  edtSlaveUser.Text     := TSettings.SlaveUser;
  edtSlavePassword.Text := TSettings.SlavePassword;
  edtSlavePort.Text     := IntToStr(TSettings.SlavePort);

  edtLibLocation.Text := TSettings.LibLocation;

  seSelectRange.Value      := TSettings.ReplicaSelectRange;
  sePacketRange.Value      := TSettings.ReplicaPacketRange;
  seReconnectTimeout.Value := TSettings.ReconnectTimeoutMinute;

  chkWriteLog.Checked      := TSettings.UseLog;
  chkShowLog.Checked       := TSettings.UseLogGUI;
  chkWriteCommands.Checked := TSettings.WriteCommandsToFile;
  chkStopIfErr.Checked     := TSettings.StopIfError;
  chkSaveErr1.Checked      := TSettings.SaveErrStep1InDB;
  chkSaveErr2.Checked      := TSettings.SaveErrStep2InDB;

  chkDeviationOnlyRecCount.Checked := TSettings.CompareDeviationRecCountOnly;
  chkDeviationOnlySeq.Checked      := TSettings.CompareDeviationSequenceOnly;

  edtSnapshotSelectCount.Text     := IntToStr(TSettings.SnapshotSelectCount);
  edtSnapshotInsertCount.Text     := IntToStr(TSettings.SnapshotInsertCount);
  edtSnapshotBlobSelectCount.Text := IntToStr(TSettings.SnapshotBlobSelectCount);
  edtSnapshotSelectTextCount.Text := IntToStr(TSettings.SnapshotSelectTextCount);
  edtSnapshotInsertTextCount.Text := IntToStr(TSettings.SnapshotInsertTextCount);
  SwitchShowLog;
end;

procedure TfrmMain.SaveSnapshotLog(ALogMessage: string);
var F: TextFile;
    cFile: string;
begin
  cFile := ExtractFilePath(ParamStr(0))+'\Replicator_Snapshot.log';
  AssignFile(F, cFile);
  if FileExists(cFile) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, DateTimeToStr(Now) + ' : ' + lbCurrentTable.Caption + ' - ' + ALogMessage);
  CloseFile(F);
end;

procedure TfrmMain.sePacketRangeChange(Sender: TObject);
begin
  TSettings.ReplicaPacketRange := sePacketRange.Value;
end;

procedure TfrmMain.seReconnectTimeoutChange(Sender: TObject);
begin
  seReconnectTimeout.Value := Max(0, seReconnectTimeout.Value);
  TSettings.ReconnectTimeoutMinute := seReconnectTimeout.Value;
end;

procedure TfrmMain.seSelectRangeChange(Sender: TObject);
begin
  TSettings.ReplicaSelectRange := seSelectRange.Value;
end;

procedure TfrmMain.SnapshotElapsedTimerTimer(Sender: TObject);
begin
  FSnapshotElapsedSeconds := SecondsBetween(FSnapshotStartTime, Now);
  UpdateSnapshotElapsedTime;
end;

procedure TfrmMain.SnapshotThreadError(AError: string);
begin
  inc(FErrors);
  FSnapshotTableHasErrors := true;
  UpdateSnapshotErrors;
  SnapshotLog.Lines.Add(AError);
  SaveSnapshotLog(AError);
end;

procedure TfrmMain.SnapshotThreadFinish;
begin
  TThread.CreateAnonymousThread(procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          FSnapshotThread.Free;
          FSnapshotThread := nil;
          if FSnapshotRunning then
            btnSnapshotStart.Click;
        end)
    end).Start;
end;

procedure TfrmMain.SnapshotThreadFinishTable(ATableName: string);
var I: integer;
begin
  for I := 0 to lvTables.Items.Count - 1 do
    if SameText(lvTables.Items[I].Caption, ATableName) then
    begin
      lvTables.Items[I].MakeVisible(false);
      if FSnapshotTableHasErrors then
        lvTables.Items[I].ImageIndex := 3
      else
        lvTables.Items[I].ImageIndex := 2;
      break;
    end;
  lbStatus.Caption := '';
end;

procedure TfrmMain.SnapshotThreadMessage(AMessage: string);
begin
  if SnapshotLog.Lines.Count > 100000 then SnapshotLog.Lines.Clear;
  SnapshotLog.Lines.Add(AMessage);
end;

procedure TfrmMain.SnapshotThreadNewTable(ATableName: string);
var I: integer;
begin
  lbCurrentTable.Caption := ATableName;
  FSnapshotTableHasErrors := false;
  SnapshotThreadProcessed(0, 0);
  for I := 0 to lvTables.Items.Count - 1 do
    if SameText(lvTables.Items[I].Caption, ATableName) then
    begin
      lvTables.Items[I].MakeVisible(false);
      lvTables.Items[I].ImageIndex := 1;
      break;
    end;
  SnapshotLog.Lines.Add('     '+ ATableName);
end;

procedure TfrmMain.SnapshotThreadProcessed(ATotalCount,
  AProcessedCount: int64);
begin
  lbProcessed.Caption := IntToStr(AProcessedCount) + ' / ' + IntToStr(ATotalCount);
  if ATotalCount = 0 then
    lbProcessedPercent.Caption := '-'
  else
    lbProcessedPercent.Caption := FormatFloat('0.00' , AProcessedCount * 100.0 / ATotalCount) + ' %';
  lbProcessed.Left := lbCurrentTable.Left + lbCurrentTable.Width + 20;
  lbProcessedPercent.Left := lbProcessed.Left + lbProcessed.Width + 20;
  lbStatus.Left := lbProcessedPercent.Left + lbProcessedPercent.Width + 20;
end;

procedure TfrmMain.SnapshotThreadStatus(AStatus: string);
begin
  lbStatus.Caption := AStatus;
end;

procedure TfrmMain.StartReplica;
const
  cStartPerlica = 'Старт репликации: StartId = %d    select %d    в пакете %d    версия %s';
var
  iStartId, iSelectRange, iPacketRange: Integer;
begin
  FStartTimeReplica := Now;
  lbAllStart.Caption := Format(cStartPointReplica, [FormatDateTime(cTimeStrShort, Now)]);

  iStartId     := StrToIntDef(edtSsnMinId.Text, 0);
  iSelectRange := seSelectRange.Value;
  iPacketRange := sePacketRange.Value;

  LogMessage(Format(cStartPerlica, [iStartId, seSelectRange.Value, sePacketRange.Value, GetFileVersion]));
  LogMessage('');

  StopReplicaThread;
  FReplicaThrd := TReplicaThread.Create(cCreateSuspended, iStartId, iSelectRange, iPacketRange, LogMessage, tknDriven);

  FReplicaThrd.OnNewSession    := OnNewSession;
  FReplicaThrd.OnEndSession    := OnEndSession;
  FReplicaThrd.OnTerminate     := OnTerminateReplica;
  FReplicaThrd.OnNeedRestart   := OnNeedReplicaRestart;
  FReplicaThrd.OnChangeStartId := OnChangeStartId;

  FReplicaThrd.Start;

  btnStartReplication.Enabled := False;
  btnStop.Enabled             := True;

  tmrElapsed.Enabled := True;
end;

procedure TfrmMain.StopAlterSlaveSequences;
begin
  if FAlterSlaveSequencesThrd <> nil then
  begin
    FAlterSlaveSequencesThrd.Stop;
    FAlterSlaveSequencesThrd.WaitFor;
    FreeAndNil(FAlterSlaveSequencesThrd);
  end;
end;

procedure TfrmMain.StopApplyScriptThread;
begin
  if FApplyScriptThrd <> nil then
  begin
    FApplyScriptThrd.Stop;
    FApplyScriptThrd.WaitFor;
    FreeAndNil(FApplyScriptThrd);
  end;
end;

procedure TfrmMain.StopCompareRecCountMSThread;
begin
  if FCompareRecCountMSThrd <> nil then
  begin
    FCompareRecCountMSThrd.Stop;
    FCompareRecCountMSThrd.WaitFor;
    FreeAndNil(FCompareRecCountMSThrd);
  end;
end;

procedure TfrmMain.StopCompareSeqMSThread;
begin
  if FCompareSeqMSThrd <> nil then
  begin
    FCompareSeqMSThrd.Stop;
    FCompareSeqMSThrd.WaitFor;
    FreeAndNil(FCompareSeqMSThrd);
  end;
end;

procedure TfrmMain.StopLastIdThread;
begin
  if FLastIdThrd <> nil then
  begin
    FLastIdThrd.Stop;
    FLastIdThrd.WaitFor;
    FreeAndNil(FLastIdThrd);
  end;
end;

procedure TfrmMain.StopMinMaxThread;
begin
  if FMinMaxThrd <> nil then
  begin
    FMinMaxThrd.Stop;
    FMinMaxThrd.WaitFor;
    FreeAndNil(FMinMaxThrd);
  end;
end;

procedure TfrmMain.StopMoveProcToSlaveThread;
begin
  if FMoveProcToSlaveThrd <> nil then
  begin
    FMoveProcToSlaveThrd.Stop;
    FMoveProcToSlaveThrd.WaitFor;
    FreeAndNil(FMoveProcToSlaveThrd);
  end;
end;

procedure TfrmMain.StopReplicaThread;
begin
  tmrRestartReplica.Enabled := False;// остановить таймер реконнекта

  if FReplicaThrd <> nil then
  begin
    FReplicaThrd.Stop;
    FReplicaThrd.WaitFor;
    FreeAndNil(FReplicaThrd);
  end;
end;

procedure TfrmMain.SwitchShowLog;
begin
  if chkShowLog.Checked then
    pgcLog.ActivePage := tsMemo
  else
    pgcLog.ActivePage := tsChk;
end;

procedure TfrmMain.tmrElapsedTimer(Sender: TObject);
begin
  lbAllElapsed.Caption := Format(cElapsedReplica, [Elapsed(FStartTimeReplica)]);

  if FStartTimeSession > 0 then
    lbSsnElapsed.Caption := Format(cElapsedSession, [Elapsed(FStartTimeSession)]);
end;

procedure TfrmMain.tmrUpdateAllDataTimer(Sender: TObject);
begin
  (Sender as TTimer).Enabled := False;
  CheckReplicaMaxMin;
end;

procedure TfrmMain.WriteSettings;
begin
  TSettings.MasterServer   := edtMasterServer.Text;
  TSettings.MasterDatabase := edtMasterDatabase.Text;
  TSettings.MasterUser     := edtMasterUser.Text;
  TSettings.MasterPassword := edtMasterPassword.Text;
  TSettings.MasterPort     := StrToIntDef(edtMasterPort.Text, TSettings.DefaultPort);

  TSettings.SlaveServer   := edtSlaveServer.Text;
  TSettings.SlaveDatabase := edtSlaveDatabase.Text;
  TSettings.SlaveUser     := edtSlaveUser.Text;
  TSettings.SlavePassword := edtSlavePassword.Text;
  TSettings.SlavePort     := StrToIntDef(edtSlavePort.Text, TSettings.DefaultPort);

  TSettings.LibLocation  := edtLibLocation.Text;
  TSettings.UseLogGUI    := chkShowLog.Checked;

  TSettings.ReplicaSelectRange := seSelectRange.Value;
  TSettings.ReplicaPacketRange := sePacketRange.Value;
  TSettings.SnapshotSelectCount     := StrToIntDef(edtSnapshotSelectCount.Text, TSettings.DefaultSnapshotSelectCount);
  TSettings.SnapshotInsertCount     := StrToIntDef(edtSnapshotInsertCount.Text, TSettings.DefaultSnapshotInsertCount);
  TSettings.SnapshotBlobSelectCount := StrToIntDef(edtSnapshotBlobSelectCount.Text, TSettings.DefaultSnapshotBlobSelectCount);
  TSettings.SnapshotSelectTextCount := StrToIntDef(edtSnapshotSelectTextCount.Text, TSettings.DefaultSnapshotSelectTextCount);
  TSettings.SnapshotInsertTextCount := StrToIntDef(edtSnapshotInsertTextCount.Text, TSettings.DefaultSnapshotInsertTextCount);
end;

procedure TfrmMain.ApplyScript;
var
  tmpFiles: TStringList;
begin
  btnApplyScript.Enabled     := False;
  btnCancelScript.Enabled    := True;
  btnUpdateScriptIni.Enabled := False;

  StopApplyScriptThread;

  tmpFiles := TStringList.Create;
  try
    TSettings.ReadScriptFiles(tmpFiles); // читаем список скриптов из INI-файла
    FApplyScriptThrd := TApplyScriptThread.Create(
      cCreateSuspended,
      FScriptFiles.GetScriptContent(tmpFiles), // возвращает список SQL для указанных файлов
      FScriptFiles.ShortNames, // Возвращает список коротких имен файлов. Будет использоваться в сообщении об ошибке
      LogApplyScript,
      tknDriven
    );
    FApplyScriptThrd.OnTerminate := OnTerminateApplyScript;
    FApplyScriptThrd.Start;
  finally
    FreeAndNil(tmpFiles);
  end;
end;

procedure TfrmMain.AssignOnExitSettings;
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
    if Components[I] is TEdit then
      if BelongsTo(TEdit(Components[I]), tsSettings) then
      begin
//        OutputDebugString(PWideChar('Edit.name = ' + Components[I].Name));
        TEdit(Components[I]).OnExit := OnExitSettings;
      end;
  edtSnapshotSelectCount.OnExit := OnExitSettings;
  edtSnapshotInsertCount.OnExit := OnExitSettings;
  edtSnapshotBlobSelectCount.OnExit := OnExitSettings;
  edtSnapshotSelectTextCount.OnExit := OnExitSettings;
  edtSnapshotInsertTextCount.OnExit := OnExitSettings;
end;

procedure TfrmMain.btnCancelCompareRecCountClick(Sender: TObject);
begin
  btnCancelCompareRecCount.Enabled := False;
  StopCompareRecCountMSThread;
end;

procedure TfrmMain.btnCancelCompareSeqClick(Sender: TObject);
begin
  btnCancelCompareSeq.Enabled := False;
  StopCompareSeqMSThread;
end;

procedure TfrmMain.btnCancelScriptClick(Sender: TObject);
begin
  btnCancelScript.Enabled := False;
  StopApplyScriptThread;
end;

procedure TfrmMain.btnClearSnapshotLogClick(Sender: TObject);
begin
  SnapshotLog.Clear;
end;

procedure TfrmMain.btnLibLocationClick(Sender: TObject);
begin
  {$WARNINGS OFF}
  with opndlgMain.FileTypes.Add do
  begin
    DisplayName := 'Клиентская библиотека PostgreSQL';
    FileMask := 'libpq.dll';
  end;

  if opndlgMain.Execute then
    edtLibLocation.Text := opndlgMain.FileName;
  {$WARNINGS ON}
end;

procedure TfrmMain.btnUpdateScriptIniClick(Sender: TObject);
begin
  try
    TSettings.WriteScriptFiles(FScriptFiles.ShortNames);
    LogApplyScript('Список скриптов обновлен в INI-файле');
  except
    on E: Exception do
      LogApplyScript(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TfrmMain.btnMaxIdClick(Sender: TObject);
const
  cMsg = 'Max Id = %d';
begin
  LogMessage(Format(cMsg, [FData.MaxId]));
end;

procedure TfrmMain.btnMinIdClick(Sender: TObject);
const
  cMsg = 'Min Id = %d';
begin
  LogMessage(Format(cMsg, [FData.MinId]));
end;

procedure TfrmMain.btnMoveProcsToSlaveClick(Sender: TObject);
begin
  btnMoveProcsToSlave.Enabled     := False;
  btnStopMoveProcsToSlave.Enabled := True;

  StopMoveProcToSlaveThread;

  FMoveProcToSlaveThrd := TMoveProcToSlaveThread.Create(cCreateSuspended, LogMessage, tknDriven);
  FMoveProcToSlaveThrd.OnTerminate := OnTerminateMoveSavedProcToSlave;
  FMoveProcToSlaveThrd.Start;
end;

procedure TfrmMain.btnReplicaCommandsSQLClick(Sender: TObject);
const
  cStartPerlica = 'Старт репликации: %d, диапазон select: %d, команд в пакете: %d, SQL:' + #13#10 + '%s';
  cCmdCountMsg = 'В пакете всего команд: %d';
//var
//  iStart, iSelectRange: Integer;
begin
//  iStart := StrToIntDef(edtSsnMinId.Text, 0);
//  iSelectRange := seSelectRange.Value;

  // формирование SelectSQL для ZQuery, который вернет набор команд репликации
//  FData.BuildReplicaCommandsSQL(iStart, iSelectRange);
//  LogMessage(
//    Format(
//      cStartPerlica, [iStart, iSelectRange, sePacketRange.Value, FData.qrySelectReplicaCmd.SQL.Text]
//    )
//  );

  // количество команд репликации
  LogMessage(Format(cCmdCountMsg, [FData.GetReplicaCmdCount]));
end;

procedure TfrmMain.btnStartAlterSlaveSequencesClick(Sender: TObject);
begin
  StopAlterSlaveSequences;
  FAlterSlaveSequencesThrd := TAlterSlaveSequencesThread.Create(cCreateSuspended, LogMessage, tknDriven);
  FAlterSlaveSequencesThrd.OnTerminate := OnTerminateAlterSlaveSequences;
  FAlterSlaveSequencesThrd.Start;

  btnStartAlterSlaveSequences.Enabled := False;
  btnStopAlterSlaveSequences.Enabled  := True;
end;

procedure TfrmMain.btnStartReplicationClick(Sender: TObject);
begin
  StartReplica;
end;

procedure TfrmMain.btnApplyScriptClick(Sender: TObject);
begin
  ApplyScript;
end;

procedure TfrmMain.btnScriptPathClick(Sender: TObject);
var
  sScriptFolder, sInitPath: string;
begin
  sInitPath := TSettings.ScriptPath;
  if not TDirectory.Exists(sInitPath) then
    sInitPath := ExtractFilePath(ParamStr(0));

  {$WARNINGS OFF}
  with opndlgMain do
  begin
    Title := 'Выберите папку со скриптами';
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    OkButtonLabel := 'Выбрать';
    DefaultFolder := sInitPath;
    if Execute then
    begin
      sScriptFolder        := FileName;
      edtScriptPath.Text   := sScriptFolder;
      TSettings.ScriptPath := sScriptFolder;
    end;
  end;
  {$WARNINGS ON}

  if Length(sScriptFolder) > 0 then
  begin
    FreeAndNil(FScriptFiles);
    FScriptFiles := TScriptFiles.Create(sScriptFolder, LogApplyScript);
  end;
end;

procedure TfrmMain.btnSendSinglePacketClick(Sender: TObject);
var
  tmpWorker: TSinglePacket;
begin
  LogMessage('Старт выгрузки одного пакета ');
  tmpWorker := TSinglePacket.Create(
    cCreateSuspended,
    StrToIntDef(edtSsnMinId.Text, 0),
    seSelectRange.Value,
    sePacketRange.Value,
    LogMessage
  );
  tmpWorker.OnTerminate := OnTerminateSinglePacket;
  tmpWorker.OnChangeStartId := OnChangeStartId;
  tmpWorker.Start;
  btnSendSinglePacket.Enabled := False;
end;

procedure TfrmMain.btnSnapshotPauseClick(Sender: TObject);
begin
  if not Assigned(FSnapshotThread) then Exit;
  FSnapshotThread.Paused := not FSnapshotThread.Paused;
  if FSnapshotThread.Paused then
  begin
    btnSnapshotPause.Caption := 'Продолжить';
    FSnapshotElapsedSecondsBeforePause := FSnapshotElapsedSecondsBeforePause + FSnapshotElapsedSeconds;
    SnapshotElapsedTimer.Enabled := false;
  end
  else
  begin
    btnSnapshotPause.Caption := 'Пауза';
    FSnapshotStartTime := Now;
    FSnapshotElapsedSeconds := 0;
    SnapshotElapsedTimer.Enabled := true;
  end;
end;

procedure TfrmMain.btnSnapshotStartClick(Sender: TObject);
begin
  if not FSnapshotRunning then
  begin
    if not FData.IsBothConnected then
    begin
      ShowMessage('Подключение к базам не установлено');
      Exit;
    end;
    FSnapshotRunning := true;
    btnSnapshotStart.Caption := 'Стоп';
    btnSnapshotPause.Enabled := true;
    FSnapshotStartTime := Now;
    FSnapshotElapsedSeconds := 0;
    FSnapshotElapsedSecondsBeforePause := 0;
    UpdateSnapshotElapsedTime;
    FErrors := 0;
    UpdateSnapshotErrors;
    SnapshotElapsedTimer.Enabled := true;
    InitSnapshotTables;
    FSnapshotThread := TSnapshotThread.Create;
    FSnapshotThread.OnError := SnapshotThreadError;
    FSnapshotThread.OnFinish := SnapshotThreadFinish;
    FSnapshotThread.OnNewTable := SnapshotThreadNewTable;
    FSnapshotThread.OnFinishTable := SnapshotThreadFinishTable;
    FSnapshotThread.OnProcessed := SnapshotThreadProcessed;
    FSnapshotThread.OnMessage := SnapshotThreadMessage;
    FSnapshotThread.OnStatus := SnapshotThreadStatus;
    FSnapshotThread.Start;
  end
  else
  begin
    FSnapshotRunning := false;
    SnapshotElapsedTimer.Enabled := false;
    if Assigned(FSnapshotThread) then
    begin
      Screen.Cursor := crHourGlass;
      try
        //FSnapshotThread.FreeOnTerminate := false;
        if FSnapshotThread.Paused then
          FSnapshotThread.Paused := false;
        FSnapshotThread.Terminate;
        FSnapshotThread.WaitFor;
        FSnapshotThread.Free;
        FSnapshotThread := nil;
//        FreeAndNil(FSnapshotThread);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    btnSnapshotStart.Caption := 'Старт';
    btnSnapshotPause.Enabled := false;
    btnSnapshotPause.Caption := 'Пауза';
  end;
end;

procedure TfrmMain.btnStopAlterSlaveSequencesClick(Sender: TObject);
begin
  StopAlterSlaveSequences;
  btnStopAlterSlaveSequences.Enabled := False;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  btnStop.Enabled := False;
  StopReplicaThread;
end;

procedure TfrmMain.btnStopMoveProcsToSlaveClick(Sender: TObject);
begin
  StopMoveProcToSlaveThread;
  btnStopMoveProcsToSlave.Enabled := False;
end;

procedure TfrmMain.btnTestMasterClick(Sender: TObject);
begin
  FData.conMaster.Disconnect;

  if FData.IsMasterConnected then
    LogMessage('Master подключен');
end;

procedure TfrmMain.btnTestSlaveClick(Sender: TObject);
begin
  FData.conSlave.Disconnect;

  if FData.IsSlaveConnected then
    LogMessage('Slave подключен');
end;

procedure TfrmMain.btnUpdateCompareRecCountClick(Sender: TObject);
begin
  CompareMasterSlaveRecCount;
end;

procedure TfrmMain.btnUpdateCompareSeqClick(Sender: TObject);
begin
  CompareMasterSlaveSeq;
end;

procedure TfrmMain.btnUseMinIdClick(Sender: TObject);
begin
  edtSsnMinId.Text   := IntToStr(FData.MinId);
  TSettings.ReplicaLastId := 0;
end;

procedure TfrmMain.CheckReplicaMaxMin;
begin
  StopMinMaxThread;
  FMinMaxThrd := TMinMaxIdThread.Create(cCreateSuspended,  LogMessage, tknDriven);
  FMinMaxThrd.OnTerminate := OnTerminateMinMaxId;
  FMinMaxThrd.Start;
end;

procedure TfrmMain.FetchLastId;
begin
  StopLastIdThread;
  FLastIdThrd := TLastIdThread.Create(cCreateSuspended, LogMessage, tknDriven);
  FLastIdThrd.OnTerminate := OnTerminateLastId;
  FLastIdThrd.Start;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FSnapshotRunning then
  begin
    if MessageDlg('Процедура переноса данных еще не завершена. Вы уверены, что хотите закрыть программу ?',
                  mtConfirmation, [mbYes, mbNo], 0, mbYes) <> mrYes then
      Action := caNone
    else
    begin
      btnSnapshotStart.Click;
      Sleep(100); // wait for anonymous thread to finish
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSnapshotRunning := false;
end;

procedure TfrmMain.UpdateProgBarPosition(AProgBar: TProgressBar; const AMax, ACurrValue, ARecCount: Int64);
begin
  AProgBar.Max  := 100;
  AProgBar.Min  := 1;

  if (AMax <= 0) or (ARecCount <= 0) then
  begin
    AProgBar.Position := 0;
    Exit;
  end;

  Assert(AMax > 0, 'Ожидается AMax > 0, а имеем AMax = ' + IntTosTr(AMax));
  AProgBar.Position := Round(100 * ACurrValue / AMax);
end;

procedure TfrmMain.UpdateSnapshotElapsedTime;
  function SecondsToTimeString(ASeconds: integer): string;
  var nDate: TDateTime;
      nHours, nMinutes, nSeconds: integer;
  begin
    nDate := IncSecond(0, ASeconds);
    nSeconds := SecondOf(nDate);
    nDate := IncSecond(nDate, -nSeconds);
    nMinutes := MinuteOf(nDate);
    nDate := IncMinute(nDate, -nMinutes);
    nHours := HoursBetween(0, nDate);
    Result := FormatFloat('#,##0', nHours) + ':' + FormatFloat('00', nMinutes) + ':' + FormatFloat('00', nSeconds);
  end;
begin
  lbElapsed.Caption := SecondsToTimeString(FSnapshotElapsedSeconds + FSnapshotElapsedSecondsBeforePause);
end;

procedure TfrmMain.UpdateSnapshotErrors;
begin
  lbErrors.Caption := IntToStr(FErrors);
end;

procedure TfrmMain.chkDeviationOnlyRecCountClick(Sender: TObject);
begin
  TSettings.CompareDeviationRecCountOnly := chkDeviationOnlyRecCount.Checked;
end;

procedure TfrmMain.chkDeviationOnlySeqClick(Sender: TObject);
begin
  TSettings.CompareDeviationSequenceOnly := chkDeviationOnlySeq.Checked;
end;

procedure TfrmMain.chkSaveErr1Click(Sender: TObject);
begin
  TSettings.SaveErrStep1InDB := chkSaveErr1.Checked;
end;

procedure TfrmMain.chkSaveErr2Click(Sender: TObject);
begin
  TSettings.SaveErrStep2InDB := chkSaveErr2.Checked;
end;

procedure TfrmMain.chkShowLogClick(Sender: TObject);
begin
  SwitchShowLog;
  TSettings.UseLogGUI := chkShowLog.Checked;
end;

procedure TfrmMain.chkStopIfErrClick(Sender: TObject);
begin
  TSettings.StopIfError := chkStopIfErr.Checked;
end;

procedure TfrmMain.chkWriteCommandsClick(Sender: TObject);
begin
  TSettings.WriteCommandsToFile := chkWriteCommands.Checked;
end;

procedure TfrmMain.chkWriteLogClick(Sender: TObject);
begin
  TSettings.UseLog := chkWriteLog.Checked;
end;

procedure TfrmMain.CompareMasterSlaveRecCount;
begin
  StopCompareRecCountMSThread;
  FCompareRecCountMSThrd := TCompareRecCountMSThread.Create(cCreateSuspended, chkDeviationOnlyRecCount.Checked, LogMessage, tknDriven);
  FCompareRecCountMSThrd.OnTerminate := OnTerminateCompareRecCountMS;
  FCompareRecCountMSThrd.Start;

  lbCompareExecutingRecCount.Caption := cCompareQueryExecuting;
  lbCompareExecutingRecCount.Visible := True;
  btnUpdateCompareRecCount.Enabled := False;
  btnCancelCompareRecCount.Enabled := True;
  chkDeviationOnlyRecCount.Enabled := False;
end;

procedure TfrmMain.CompareMasterSlaveSeq;
begin
  StopCompareSeqMSThread;
  FCompareSeqMSThrd := TCompareSeqMSThread.Create(cCreateSuspended, chkDeviationOnlySeq.Checked, LogMessage, tknDriven);
  FCompareSeqMSThrd.OnTerminate := OnTerminateCompareSeqMS;
  FCompareSeqMSThrd.Start;

  lbCompareExecutingSeq.Caption := cCompareQueryExecuting;
  lbCompareExecutingSeq.Visible := True;
  btnUpdateCompareSeq.Enabled := False;
  btnCancelCompareSeq.Enabled := True;
  chkDeviationOnlySeq.Enabled := False;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Replicator - ' + GetFileVersion;

  FLog := TLog.Create;
  pgcMain.ActivePage := tsLog;

  FetchLastId;

  FData := TdmData.Create(nil, LogMessage);

  ReadSettings;
  AssignOnExitSettings;

  edtScriptPath.Text := TSettings.ScriptPath;
  FScriptFiles := TScriptFiles.Create(TSettings.ScriptPath, LogApplyScript);

  grdCompareRecCount.OnDrawColumnCell := grdDrawColumnCell;
  grdCompareSeq.OnDrawColumnCell      := grdDrawColumnCell;
end;

destructor TfrmMain.Destroy;
begin
  StopReplicaThread;
  StopMinMaxThread;
  StopLastIdThread;
  StopCompareRecCountMSThread;
  StopCompareSeqMSThread;
  StopAlterSlaveSequences;
  StopApplyScriptThread;
  StopMoveProcToSlaveThread;

  WriteSettings;
  FreeAndNil(FData);
  FreeAndNil(FLog);
  FreeAndNil(FScriptFiles);

  inherited;
end;

procedure TfrmMain.edtLibLocationChange(Sender: TObject);
begin
  TSettings.LibLocation  := edtLibLocation.Text;
end;

procedure TfrmMain.edtStartReplicaExit(Sender: TObject);
begin
  TSettings.ReplicaLastId := StrToIntDef(edtSsnMinId.Text, 1) - 1;
end;

procedure TfrmMain.grdDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TStringGrid;
  Texto: string;
  R: TRect;
begin
  R := Rect;
  R.Top  := R.Top + 2;
  R.Left := R.Left + 2;

  Grid := TStringGrid(Sender);
  if Column.Field.IsBlob then
  begin
    Grid.Canvas.FillRect(Rect);
    Texto := Column.Field.AsString;
    DrawText(Grid.Canvas.Handle,
             PChar(Texto),
             StrLen(PChar(Texto)),
             R,
             DT_WORDBREAK);
  end
  else
    (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmMain.InitSnapshotTables;
var FItem: TListItem;
begin
  lvTables.Items.BeginUpdate;
  try
    lvTables.Clear;
    with FData do
    begin
      qrySnapshotTables.Close;
      qrySnapshotTables.Open;
      while not qrySnapshotTables.Eof do
      begin
        FItem := lvTables.Items.Add;
        FItem.Caption := qrySnapshotTables.FieldByName('table_name').AsString;
        FItem.ImageIndex := 0;
        qrySnapshotTables.Next;
      end;
    end;
  finally
    lvTables.Items.EndUpdate;
  end;
end;

procedure TfrmMain.LogApplyScript(const AMsg, AFileName: string; const aUID: Cardinal; AMsgType: TLogMessageType);
var
  sFileName: string;
begin
  if TSettings.UseLog then // выбрана настройка "записывать лог в файл"
  begin
    if Length(Trim(AFileName)) = 0 then
      sFileName := cDefLogFileName
    else
      sFileName := AFileName; // пишем в специальный файл

    FLog.Write(sFileName, AMsg);
  end;

  mmoScriptLog.Lines.Add(Format(cLogMsg, [FormatDateTime(cTimeStrShort, Now), AMsg]));
end;

procedure TfrmMain.LogMessage(const AMsg, AFileName: string; const aUID: Cardinal; AMsgType: TLogMessageType);
var
  iObjIndex, iPos: Integer;
  sMsg, sLine: string;
begin

  if TSettings.UseLog then // выбрана настройка "записывать лог в файл"
    if Length(Trim(AFileName)) = 0 then // пишем в файл по умолчанию
    begin
      // не записываем в файл сообщение, переданное для той же самой строки
      // за исключением случая, когда это последнее сообщение для той же самой строки
      if (FPrevUID > 0) and (FPrevUID <> aUID) then
      begin
        iObjIndex := lstLog.Items.IndexOfObject(TObject(FPrevUID));
        if iObjIndex <> -1 then
        begin
          sLine := lstLog.Items[iObjIndex];// в начале строки записана дата/время, нужно это убрать
          iPos := Pos(' ', sLine);
          sLine := Copy(sLine, iPos, Length(sLine) - iPos + 1);
          sLine := Trim(sLine);
          FLog.Write(cDefLogFileName, sLine);
        end;
      end;

      // записываем в файл все сообщения, у которых специально не указан aUID
      if aUID = 0 then
        FLog.Write(cDefLogFileName, AMsg);
    end
    else
      FLog.Write(AFileName, AMsg, False); // пишем в специальный файл, False означает "не записывать отметку времени в текст файла"

  if Length(Trim(AFileName)) = 0  then // не выводим в lstLog сообщение, которое предназначено для сохранения в отдельный файл
  begin
    sMsg := Format(cLogMsg, [FormatDateTime(cTimeStrShort, Now), AMsg]);

    case AMsgType of
      lmtPlain: // обычное сообщение
        begin
          if aUID <> 0 then // строка c таким aUID могла быть добавлена в lstLog ранее
          begin
            iObjIndex := lstLog.Items.IndexOfObject(TObject(aUID));

            if iObjIndex = -1 then // это новая запись
              lstLog.Items.AddObject(sMsg, TObject(aUID))
            else
              lstLog.Items[iObjIndex] := sMsg;
          end
          else
            lstLog.Items.AddObject(sMsg, TObject(aUID));

          lstLog.Perform(WM_VSCROLL, SB_BOTTOM, 0);
          lstLog.Perform(WM_VSCROLL, SB_ENDSCROLL, 0);
        end;

      lmtError: // сообщение об ошибке
        begin
          splHrz.Visible := True;
          mmoError.Visible := True;
          mmoError.Lines.Add(sMsg);
          mmoError.Perform(WM_VSCROLL, SB_BOTTOM, 0);
          mmoError.Perform(WM_VSCROLL, SB_ENDSCROLL, 0);
        end;
    end;
  end;

  FPrevUID := aUID;
end;

procedure TfrmMain.mmoLogChange(Sender: TObject);
begin
  SendMessage((Sender as TMemo).Handle, EM_LINESCROLL, 0, (Sender as TMemo).Lines.Count);
end;

procedure TfrmMain.OnChangeStartId(const ANewStartId: Int64);
var
  iReplicaMax, iRecCount: Int64;
begin
  edtSsnMinId.Text := IntToStr(ANewStartId);

  if FSsnStep > 0 then
  begin
    pbSession.Position := Max(0, Trunc((ANewStartId - FSsnMinId) / FSsnStep));
    pbSession.Position := Min(pbSession.Position, pbSession.Max);
  end;

  iReplicaMax := StrToInt64Def(edtAllMaxId.Text, 0);
  iRecCount   := StrToInt64Def(edtAllRecCount.Text, 0);
  UpdateProgBarPosition(pbAll, iReplicaMax, ANewStartId, iRecCount);

  if (ANewStartId mod 2) = 0 then Exit;

  lbAllElapsed.Caption := Format(cElapsedReplica, [Elapsed(FStartTimeReplica)]);
  if FStartTimeSession > 0 then
    lbSsnElapsed.Caption := Format(cElapsedSession, [Elapsed(FStartTimeSession)]);
end;

procedure TfrmMain.OnEndSession(Sender: TObject);
begin
  lbSsnElapsed.Caption := Format(cElapsedSession, [Elapsed(FStartTimeSession)]);
  lbSsnNumber.Caption  := lbSsnNumber.Caption + ' окончена';
  FStartTimeSession := 0;
  LogMessage('');
end;

procedure TfrmMain.OnExitSettings(Sender: TObject);
begin
  WriteSettings;
end;

procedure TfrmMain.OnNeedReplicaRestart(Sender: TObject);
begin
  with tmrRestartReplica do
  begin
    Enabled  := False;
    OnTimer  := OnTimerRestartReplica;
    Interval := TSettings.ReconnectTimeoutMinute * c1Minute;
    Enabled  := Interval > 0;
  end;
end;

procedure TfrmMain.OnNewSession(const AStart: TDateTime; const AMinId, AMaxId: Int64; const ARecCount, ASessionNumber: Integer);
begin
  edtSsnMinId.Text    := IntToStr(AMinId);
  edtSsnMaxId.Text    := IntToStr(AMaxId);
  edtSsnRecCount.Text := IntToStr(ARecCount);

  FStartTimeSession := AStart;

  lbSsnNumber.Caption := Format(cSessionNumber, [ASessionNumber]);
  lbSsnStart.Caption  := Format(cStartPointSession, [FormatDateTime(cTimeStrShort, Now)]);

  pbSession.Visible  := True;
  pbSession.Position := 0;
  pbSession.Min      := 1;
  pbSession.Max      := Max(pbSession.Min, ARecCount);

  FSsnMinId := AMinId;
  FSsnMaxId := AMaxId;
  if ARecCount > 0 then
    FSsnStep  := (FSsnMaxId - FSsnMinId) / ARecCount
  else
    FSsnStep := 1;
end;

procedure TfrmMain.OnTerminateAlterSlaveSequences(Sender: TObject);
begin
  btnStopAlterSlaveSequences.Enabled  := False;
  btnStartAlterSlaveSequences.Enabled := True;
end;

procedure TfrmMain.OnTerminateApplyScript(Sender: TObject);
var
  tmpResult: TApplyScriptResult;
  thrdWorker: TWorkerThread;
  sMsg: string;
begin
  thrdWorker := Sender as TWorkerThread;
  tmpResult  := TApplyScriptResult(thrdWorker.MyReturnValue);

  case tmpResult of
    asNoAction: sMsg := '';
    asSuccess:  sMsg := 'Скрипты успешно выполнены';
    asError:    sMsg := '';//'Не удалось выполнить скрипты';
  end;

  if Length(sMsg) > 0 then
    LogApplyScript(sMsg);

  btnApplyScript.Enabled     := True;
  btnCancelScript.Enabled    := False;
  btnUpdateScriptIni.Enabled := True;
end;

procedure TfrmMain.OnTerminateCompareRecCountMS(Sender: TObject);
var
  P: PCompareMasterSlave;
  lwResult: LongWord;
  sSQL: string;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;

  dsCompareRecCount.DataSet := nil;

  if lwResult > 0 then
  begin
    P := PCompareMasterSlave(lwResult);
    try
      sSQL := P^.ResultSQL;
    finally
      Dispose(P);
    end;

    if FData.IsSlaveConnected and (Length(sSQL) > 0) then
      try
        with FData.qryCompareRecCountMS do
        begin
          Close;
          SQL.Clear;
          SQL.Add(sSQL);
          Open;
        end;
      except
        on E: Exception do
          LogMessage(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;

    dsCompareRecCount.DataSet := FData.qryCompareRecCountMS;
  end;

  lbCompareExecutingRecCount.Caption := '';
  btnUpdateCompareRecCount.Enabled := True;
  btnCancelCompareRecCount.Enabled := False;
  chkDeviationOnlyRecCount.Enabled := True;
end;

procedure TfrmMain.OnTerminateCompareSeqMS(Sender: TObject);
var
  P: PCompareMasterSlave;
  lwResult: LongWord;
  sSQL: string;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;

  dsCompareSeq.DataSet := nil;

  if lwResult > 0 then
  begin
    P := PCompareMasterSlave(lwResult);
    try
      sSQL := P^.ResultSQL;
    finally
      Dispose(P);
    end;

    if FData.IsSlaveConnected and (Length(sSQL) > 0) then
      try
        with FData.qryCompareSeqMS do
        begin
          Close;
          SQL.Clear;
          SQL.Add(sSQL);
          Open;
        end;
      except
        on E: Exception do
          LogMessage(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;

    dsCompareSeq.DataSet := FData.qryCompareSeqMS;
  end;

  lbCompareExecutingSeq.Caption := '';
  btnUpdateCompareSeq.Enabled := True;
  btnCancelCompareSeq.Enabled := False;
  chkDeviationOnlySeq.Enabled := True;
end;

procedure TfrmMain.OnTerminateLastId(Sender: TObject);
var
  lwResult: LongWord;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;

  edtSsnMinId.Text := IntToStr(lwResult + 1); // стартовый Id реплики

  btnStartReplication.Enabled         := True;
  btnMoveProcsToSlave.Enabled         := True;
  btnStartAlterSlaveSequences.Enabled := True;

  // Запускаем CheckReplicaMaxMin после того, как стало известно значение LastId
  // Это нужно чтобы правильно установить параметры прогресбара в OnTerminateMinMaxId
   CheckReplicaMaxMin;
end;

procedure TfrmMain.OnTerminateMinMaxId(Sender: TObject);
var
  P: PMinMaxId;
  iStart: Integer;
  lwResult: LongWord;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;

  if lwResult > 0 then
  begin
    P := PMinMaxId(lwResult);
    try
      edtAllMinId.Text    := IntToStr(P^.MinId);
      edtAllMaxId.Text    := IntToStr(P^.MaxId);
      edtAllRecCount.Text := IntToStr(P^.RecCount);

      iStart := StrToIntDef(edtSsnMinId.Text, 0);
      UpdateProgBarPosition(pbAll, P^.MaxId, iStart, P^.RecCount);

    finally
      Dispose(P);
    end;
  end;

  // запускаем таймер обновления "Все данные"
  tmrUpdateAllData.Interval := cUpdateAllDataInterval;
  tmrUpdateAllData.Enabled  := True;
end;

procedure TfrmMain.OnTerminateMoveSavedProcToSlave(Sender: TObject);
begin
  btnMoveProcsToSlave.Enabled     := True;
  btnStopMoveProcsToSlave.Enabled := False;
end;

procedure TfrmMain.OnTerminateReplica(Sender: TObject);
var
  sMsg: string;
  replicaFinish: TReplicaFinished;
  thrdWorker: TWorkerThread;
begin
  tmrElapsed.Enabled := False;

  thrdWorker := (Sender as TWorkerThread);
  replicaFinish := TReplicaFinished(thrdWorker.MyReturnValue);

  case replicaFinish of
    rfUnknown:     sMsg := 'Репликация остановилась по неизвестной причине';
    rfComplete:    sMsg := 'Репликация завершена';
    rfStopped:     sMsg := 'Репликация остановлена вручную';
    rfErrStopped:  sMsg := 'Репликация остановилась из-за ошибки';
    rfNoConnect:   sMsg := 'Не удалось начать репликацию - нет связи';
    rfLostConnect: sMsg := 'Репликация остановилась из-за потери связи';
  end;

  LogMessage(sMsg);
  LogMessage('');

  btnStartReplication.Enabled := True;
  btnStop.Enabled             := False;

  lbAllElapsed.Caption := Format(cElapsedReplica, [Elapsed(FStartTimeReplica)]);

  // нужно сохранить в БД значение LastId
  FData.LastId := TSettings.ReplicaLastId;
end;

procedure TfrmMain.OnTerminateSinglePacket(Sender: TObject);
var
  tmpWorker: TWorkerThread;
  iCount: Integer;
const
  cEnd = 'Окончание выгрузки одного пакета. Выполнено %d команд';
begin
  tmpWorker := (Sender as TWorkerThread);
  iCount := tmpWorker.MyReturnValue;

  LogMessage(Format(cEnd, [iCount]));

  btnSendSinglePacket.Enabled := True;
end;

procedure TfrmMain.OnTimerRestartReplica(Sender: TObject);
begin
  tmrRestartReplica.Enabled := False;
  StartReplica;
end;

end.
