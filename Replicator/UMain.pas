unit UMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin,
  UDefinitions,
  ULog,
  UData;


type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    tsLog: TTabSheet;
    tsSettings: TTabSheet;
    pnlLogTop: TPanel;
    pnlLogLeft: TPanel;
    pnlLog: TPanel;
    mmoLog: TMemo;
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
    {$WARNINGS ON}
    procedure chkShowLogClick(Sender: TObject);
    procedure btnLibLocationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  private
    FLog: TLog;
    FData: TdmData;
    FReplicaThrd: TReplicaThread;
    FStartTimeReplica: TDateTime;
    FStartTimeSession: TDateTime;
  private
    procedure ReadSettings;
    procedure WriteSettings;
    procedure AssignOnExitSettings;
    procedure SwitchShowLog;
    procedure LogMessage(const AMsg: string; const AFileName: string = ''; ALine: TMessageLine = mlNew);
    procedure OnChangeStartId(const ANewStartId: Integer);
    procedure OnNewSession(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer);
    procedure OnEndSession(Sender: TObject);
    procedure OnTerminateSinglePacket(Sender: TObject);
    procedure OnTerminateReplica(Sender: TObject);
  private
    procedure OnExitSettings(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  UConstants,
  USettings,
  UCommon;

const
  cStartPointReplica = 'начало репликации %s';
  cElapsedReplica = 'прошло %s';
  cStartPointSession = 'начало сессии %s';
  cElapsedSession = 'прошло %s';
  cSessionNumber = 'сесси€ є %d';



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

  edtLibLocation.Text  := TSettings.LibLocation;
  edtSsnMinId.Text := IntToStr(TSettings.ReplicaStart);

  seSelectRange.Value       := TSettings.ReplicaSelectRange;
  sePacketRange.Value := TSettings.ReplicaPacketRange;

  chkWriteLog.Checked := TSettings.UseLog;
  chkShowLog.Checked  := TSettings.UseLogGUI;
  SwitchShowLog;
end;

procedure TfrmMain.sePacketRangeChange(Sender: TObject);
begin
  TSettings.ReplicaPacketRange := sePacketRange.Value;
end;

procedure TfrmMain.seSelectRangeChange(Sender: TObject);
begin
  TSettings.ReplicaSelectRange := seSelectRange.Value;
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
end;

procedure TfrmMain.AssignOnExitSettings;
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
    if Components[I] is TEdit then
      if BelongsTo(TEdit(Components[I]), tsSettings) then
      begin
        OutputDebugString(PWideChar('Edit.name = ' + Components[I].Name));
        TEdit(Components[I]).OnExit := OnExitSettings;
      end;
end;

procedure TfrmMain.btnLibLocationClick(Sender: TObject);
begin
  {$WARNINGS OFF}
  with opndlgMain.FileTypes.Add do
  begin
    DisplayName := ' лиентска€ библиотека PostgreSQL';
    FileMask := 'libpq.dll';
  end;

  if opndlgMain.Execute then
    edtLibLocation.Text := opndlgMain.FileName;
  {$WARNINGS ON}
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

procedure TfrmMain.btnReplicaCommandsSQLClick(Sender: TObject);
const
  cStartPerlica = '—тарт репликации: %d, диапазон select: %d, команд в пакете: %d, SQL:' + #13#10 + '%s';
  cCmdCountMsg = '¬ пакете всего команд: %d';
var
  iStart, iSelectRange: Integer;
begin
  iStart := StrToIntDef(edtSsnMinId.Text, 0);
  iSelectRange := seSelectRange.Value;

  // формирование SelectSQL дл€ ZQuery, который вернет набор команд репликации
  FData.BuildReplicaCommandsSQL(iStart, iSelectRange);
  LogMessage(
    Format(
      cStartPerlica, [iStart, iSelectRange, sePacketRange.Value, FData.qrySelectReplicaCmd.SQL.Text]
    )
  );

  // количество команд репликации
  LogMessage(Format(cCmdCountMsg, [FData.GetReplicaCmdCount]));
end;

procedure TfrmMain.btnStartReplicationClick(Sender: TObject);
const
  cStartPerlica = '—тарт репликации: %d, диапазон select: %d, команд в пакете: %d';
var
  iStart, iSelectRange, iPacketRange: Integer;
  tmpMinMax: TMinMaxId;
begin
  FStartTimeReplica := Now;
  lbAllStart.Caption := Format(cStartPointReplica, [FormatDateTime(cTimeStrShort, Now)]);

  iStart       := TSettings.ReplicaStart;
  iSelectRange := seSelectRange.Value;
  iPacketRange := sePacketRange.Value;

  tmpMinMax := FData.GetMinMaxId;

  pbAll.Visible  := True;
  pbAll.Step     := 1;
  pbAll.Min      := 1;
  pbAll.Max      := tmpMinMax.MaxId - tmpMinMax.MinId;
  pbAll.Position := iStart - tmpMinMax.MinId;

  LogMessage(Format(cStartPerlica, [iStart, iSelectRange, iPacketRange]));

  FReplicaThrd := TReplicaThread.Create(cCreateSuspended, iStart, iSelectRange, iPacketRange, LogMessage);
  FReplicaThrd.OnChangeStartId := OnChangeStartId;
  FReplicaThrd.OnNewSession := OnNewSession;
  FReplicaThrd.OnEndSession := OnEndSession;
  FReplicaThrd.OnTerminate  := OnTerminateReplica;
  FReplicaThrd.Start;

  btnStartReplication.Enabled := False;
  btnStop.Enabled := True;
  tmrElapsed.Enabled := True;
end;

procedure TfrmMain.btnSendSinglePacketClick(Sender: TObject);
var
  tmpWorker: TSinglePacket;
begin
  LogMessage('—тарт выгрузки одного пакета ');
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

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  if FReplicaThrd <> nil then
    FReplicaThrd.Stop;

  FReplicaThrd := nil;
  btnStop.Enabled := False;
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

procedure TfrmMain.btnUseMinIdClick(Sender: TObject);
begin
  edtSsnMinId.Text   := IntToStr(FData.MinId);
  TSettings.ReplicaStart := StrToIntDef(edtSsnMinId.Text, 0);
end;

procedure TfrmMain.chkShowLogClick(Sender: TObject);
begin
  SwitchShowLog;
  TSettings.UseLogGUI := chkShowLog.Checked;
end;

procedure TfrmMain.chkWriteLogClick(Sender: TObject);
begin
  TSettings.UseLog := chkWriteLog.Checked;
end;

procedure TfrmMain.edtStartReplicaExit(Sender: TObject);
begin
  TSettings.ReplicaStart := StrToIntDef(edtSsnMinId.Text, 1);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteSettings;
  FreeAndNil(FData);
  FreeAndNil(FLog);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  tmpMinMax: TMinMaxId;
begin
  FLog := TLog.Create;
  pgcMain.ActivePage := tsLog;
  ReadSettings;
  AssignOnExitSettings;

  FData := TdmData.Create(
    nil,
    StrToIntDef(edtSsnMinId.Text, 0),
    seSelectRange.Value,
    sePacketRange.Value,
    LogMessage
  );
  FData.OnChangeStartId := OnChangeStartId;

  if FData.IsMasterConnected then
  begin
    tmpMinMax := FData.GetMinMaxId;

    edtAllMinId.Text    := IntToStr(tmpMinMax.MinId);
    edtAllMaxId.Text    := IntToStr(tmpMinMax.MaxId);
    edtAllRecCount.Text := IntToStr(tmpMinMax.RecCount);
  end;
end;

procedure TfrmMain.LogMessage(const AMsg, AFileName: string; ALine: TMessageLine);
var
  prevLine: TMessageLine;
begin
  if TSettings.UseLog then // выбрана настройка "записывать лог в файл"
    if Length(Trim(AFileName)) = 0 then
    begin
      // не записываем в файл сообщение, переданное дл€ той же самой строки
      // за исключением случа€, когда это последнее сообщение дл€ той же самой строки
      if (ALine = mlNew) and (prevLine = mlSame) and (mmoLog.Lines.Count > 0) then
        FLog.Write('application.log', mmoLog.Lines[Pred(mmoLog.Lines.Count)]);

      // не записываем в файл сообщение, переданное дл€ той же самой строки
      if (ALine = mlNew) then
        FLog.Write('application.log', AMsg);
    end
    else
      FLog.Write(AFileName, AMsg);

  if Length(Trim(AFileName)) = 0  then // не выводим в лог сообщение, которое предназначено дл€ сохранени€ в отдельный файл
  case ALine of
    mlNew:  mmoLog.Lines.Add(AMsg);
    mlSame: mmoLog.Lines[Pred(mmoLog.Lines.Count)] := AMsg; // запись в последнюю строку
  end;

  prevLine := ALine;
end;

procedure TfrmMain.mmoLogChange(Sender: TObject);
begin
  SendMessage((Sender as TMemo).Handle, EM_LINESCROLL, 0, (Sender as TMemo).Lines.Count);
end;

procedure TfrmMain.OnChangeStartId(const ANewStartId: Integer);
begin
  edtSsnMinId.Text := IntToStr(ANewStartId);
  pbSession.StepIt;
  pbAll.StepIt;

  lbAllElapsed.Caption := Format(cElapsedReplica, [Elapsed(FStartTimeReplica)]);
  if FStartTimeSession > 0 then
    lbSsnElapsed.Caption := Format(cElapsedSession, [Elapsed(FStartTimeSession)]);
end;

procedure TfrmMain.OnEndSession(Sender: TObject);
begin
  lbSsnElapsed.Caption := Format(cElapsedSession, [Elapsed(FStartTimeSession)]);
  FStartTimeSession := 0;
end;

procedure TfrmMain.OnExitSettings(Sender: TObject);
begin
  WriteSettings;
end;

procedure TfrmMain.OnNewSession(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer);
begin
  edtSsnMinId.Text    := IntToStr(AMinId);
  edtSsnMaxId.Text    := IntToStr(AMaxId);
  edtSsnRecCount.Text := IntToStr(ARecCount);

  FStartTimeSession := AStart;

  lbSsnNumber.Caption := Format(cSessionNumber, [ASessionNumber]);
  lbSsnStart.Caption  := Format(cStartPointSession, [FormatDateTime(cTimeStrShort, Now)]);

  pbSession.Visible  := True;
  pbSession.Position := 1;
  pbSession.Step     := 1;
  pbSession.Max      := ARecCount;
end;

procedure TfrmMain.OnTerminateReplica(Sender: TObject);
const
  cEnd = '–епликаци€ завершена';
begin
  tmrElapsed.Enabled := False;

  LogMessage(cEnd);
  btnStartReplication.Enabled := True;
  btnStop.Enabled := False;

  lbAllElapsed.Caption := Format(cElapsedReplica, [Elapsed(FStartTimeReplica)]);
end;

procedure TfrmMain.OnTerminateSinglePacket(Sender: TObject);
var
  tmpWorker: TWorkerThread;
  iCount: Integer;
const
  cEnd = 'ќкончание выгрузки одного пакета. ¬ыполнено %d команд';
begin
  tmpWorker := (Sender as TWorkerThread);
  iCount := tmpWorker.MyReturnValue;

  LogMessage(Format(cEnd, [iCount]));

  btnSendSinglePacket.Enabled := True;
end;

end.
