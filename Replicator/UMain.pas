unit UMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
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
  UData;


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
    grdCompare: TDBGrid;
    btnUpdateCompare: TButton;
    chkDeviationOnly: TCheckBox;
    dsCompare: TDataSource;
    lbCompareExecuting: TLabel;
    btnCancelCompare: TButton;
    lbReconnectTimeout: TLabel;
    seReconnectTimeout: TSpinEdit;
    lbReconnectMinute: TLabel;
    tmrRestartReplica: TTimer;
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
    procedure btnUpdateCompareClick(Sender: TObject);
    procedure grdCompareDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnCancelCompareClick(Sender: TObject);
    procedure seReconnectTimeoutChange(Sender: TObject);
  private
    FLog: TLog;
    FData: TdmData;
    FReplicaThrd: TReplicaThread;
    FMinMaxThrd: TMinMaxIdThread;
    FCompareMSThrd: TCompareMasterSlaveThread;
    FSsnMinId: Integer;
    FSsnMaxId: Integer;
    FSsnStep: Double;
    FStartTimeReplica: TDateTime;
    FStartTimeSession: TDateTime;
    FPrevUID: Cardinal;
  private
    procedure ReadSettings;
    procedure WriteSettings;
    procedure AssignOnExitSettings;
    procedure SwitchShowLog;
    procedure CompareMasterSlave;
    procedure CheckReplicaMaxMin;
    procedure StartReplica;
    procedure StopReplicaThread;
    procedure StopMinMaxThread;
    procedure StopCompareMSThread;
    procedure LogMessage(const AMsg: string; const AFileName: string = ''; const aUID: Cardinal = 0);
    procedure OnChangeStartId(const ANewStartId: Integer);
    procedure OnNewSession(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer);
    procedure OnEndSession(Sender: TObject);
    procedure OnNeedReplicaRestart(Sender: TObject);
    procedure OnTimerRestartReplica(Sender: TObject);
    procedure OnTerminateSinglePacket(Sender: TObject);
    procedure OnTerminateReplica(Sender: TObject);
    procedure OnTerminateMinMaxId(Sender: TObject);
    procedure OnTerminateCompareMS(Sender: TObject);
  private
    procedure OnExitSettings(Sender: TObject);
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
  USettings,
  UCommon;

const
  cStartPointReplica = 'начало репликации %s';
  cElapsedReplica = 'прошло %s';
  cStartPointSession = 'начало сессии %s';
  cElapsedSession = 'прошло %s';
  cSessionNumber = 'сессия № %d';



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
  edtSsnMinId.Text    := IntToStr(TSettings.ReplicaStart);

  seSelectRange.Value      := TSettings.ReplicaSelectRange;
  sePacketRange.Value      := TSettings.ReplicaPacketRange;
  seReconnectTimeout.Value := TSettings.ReconnectTimeoutMinute;

  chkWriteLog.Checked      := TSettings.UseLog;
  chkShowLog.Checked       := TSettings.UseLogGUI;
  chkWriteCommands.Checked := TSettings.WriteCommandsToFile;
  chkStopIfErr.Checked     := TSettings.StopIfError;
  chkDeviationOnly.Checked := TSettings.CompareDeviationOnly;

  SwitchShowLog;
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

procedure TfrmMain.StartReplica;
const
  cStartPerlica = 'Старт репликации: StartId = %d';
var
  iStart, iSelectRange, iPacketRange: Integer;
begin
  FStartTimeReplica := Now;
  lbAllStart.Caption := Format(cStartPointReplica, [FormatDateTime(cTimeStrShort, Now)]);

  iStart       := TSettings.ReplicaStart;
  iSelectRange := seSelectRange.Value;
  iPacketRange := sePacketRange.Value;

  LogMessage(Format(cStartPerlica, [iStart]));
  LogMessage('');

  StopReplicaThread;
  FReplicaThrd := TReplicaThread.Create(cCreateSuspended, iStart, iSelectRange, iPacketRange, LogMessage, tknDriven);

  FReplicaThrd.OnNewSession    := OnNewSession;
  FReplicaThrd.OnEndSession    := OnEndSession;
  FReplicaThrd.OnTerminate     := OnTerminateReplica;
  FReplicaThrd.OnNeedRestart   := OnNeedReplicaRestart;
  FReplicaThrd.OnChangeStartId := OnChangeStartId;

  FReplicaThrd.Start;

  btnStartReplication.Enabled := False;
  btnStop.Enabled := True;
  tmrElapsed.Enabled := True;
end;

procedure TfrmMain.StopCompareMSThread;
begin
  if FCompareMSThrd <> nil then
  begin
    FCompareMSThrd.Stop;
    FCompareMSThrd.WaitFor;
    FreeAndNil(FCompareMSThrd);
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

procedure TfrmMain.btnCancelCompareClick(Sender: TObject);
begin
  btnCancelCompare.Enabled := False;
  StopCompareMSThread;
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

procedure TfrmMain.btnStartReplicationClick(Sender: TObject);
begin
  StartReplica;
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

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  StopReplicaThread;
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

procedure TfrmMain.btnUpdateCompareClick(Sender: TObject);
begin
  CompareMasterSlave;
end;

procedure TfrmMain.btnUseMinIdClick(Sender: TObject);
begin
  edtSsnMinId.Text   := IntToStr(FData.MinId);
  TSettings.ReplicaStart := StrToIntDef(edtSsnMinId.Text, 0);
end;

procedure TfrmMain.CheckReplicaMaxMin;

begin
  if FData.IsMasterConnected then
  begin
    StopMinMaxThread;
    FMinMaxThrd := TMinMaxIdThread.Create(
      cCreateSuspended, TSettings.ReplicaStart, TSettings.ReplicaSelectRange, TSettings.ReplicaPacketRange, LogMessage, tknDriven);
    FMinMaxThrd.OnTerminate := OnTerminateMinMaxId;
    FMinMaxThrd.Start;
  end
  else
    LogMessage('Проверьте настройки подключения к базе данных');
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

procedure TfrmMain.CompareMasterSlave;
const
  cCompareQueryExecuting = 'выполняется запрос ...';
begin
  StopCompareMSThread;
  FCompareMSThrd := TCompareMasterSlaveThread.Create(cCreateSuspended, chkDeviationOnly.Checked, LogMessage, tknDriven);
  FCompareMSThrd.OnTerminate := OnTerminateCompareMS;
  FCompareMSThrd.Start;
  lbCompareExecuting.Caption := cCompareQueryExecuting;
  lbCompareExecuting.Visible := True;
  btnUpdateCompare.Enabled := False;
  btnCancelCompare.Enabled := True;
  chkDeviationOnly.Enabled := False;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
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

  CheckReplicaMaxMin;
end;

destructor TfrmMain.Destroy;
begin
  StopReplicaThread;
  StopMinMaxThread;
  StopCompareMSThread;
  WriteSettings;
  FreeAndNil(FData);
  FreeAndNil(FLog);

  inherited;
end;

procedure TfrmMain.edtLibLocationChange(Sender: TObject);
begin
  TSettings.LibLocation  := edtLibLocation.Text;
end;

procedure TfrmMain.edtStartReplicaExit(Sender: TObject);
begin
  TSettings.ReplicaStart := StrToIntDef(edtSsnMinId.Text, 1);
end;

procedure TfrmMain.grdCompareDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TStringGrid;
  Texto: String;
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

procedure TfrmMain.LogMessage(const AMsg, AFileName: string; const aUID: Cardinal);
const
  cMsg = '%s  %s';
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
      FLog.Write(AFileName, AMsg); // пишем в специальный файл

  if Length(Trim(AFileName)) = 0  then // не выводим в lstLog сообщение, которое предназначено для сохранения в отдельный файл
  begin
    sMsg := Format(cMsg, [FormatDateTime(cTimeStrShort, Now), AMsg]);

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

  FPrevUID := aUID;
end;

procedure TfrmMain.mmoLogChange(Sender: TObject);
begin
  SendMessage((Sender as TMemo).Handle, EM_LINESCROLL, 0, (Sender as TMemo).Lines.Count);
end;

procedure TfrmMain.OnChangeStartId(const ANewStartId: Integer);
var
  iReplicaMin: Integer;
begin
  edtSsnMinId.Text := IntToStr(ANewStartId);

  if FSsnStep > 0 then
    pbSession.Position := Trunc((ANewStartId - FSsnMinId) / FSsnStep);

  iReplicaMin := StrToIntDef(edtAllMinId.Text, 0);
  pbAll.Position := ANewStartId - iReplicaMin;

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

procedure TfrmMain.OnNewSession(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer);
begin
  edtSsnMinId.Text    := IntToStr(AMinId);
  edtSsnMaxId.Text    := IntToStr(AMaxId);
  edtSsnRecCount.Text := IntToStr(ARecCount);

  FStartTimeSession := AStart;

  lbSsnNumber.Caption := Format(cSessionNumber, [ASessionNumber]);
  lbSsnStart.Caption  := Format(cStartPointSession, [FormatDateTime(cTimeStrShort, Now)]);

  pbSession.Visible  := True;
  pbSession.Position := 0;
  pbSession.Step     := 1;
  pbSession.Min      := 1;
  pbSession.Max      := ARecCount;

  FSsnMinId := AMinId;
  FSsnMaxId := AMaxId;
  FSsnStep  := (FSsnMaxId - FSsnMinId) / ARecCount;
end;

procedure TfrmMain.OnTerminateCompareMS(Sender: TObject);
var
  P: PCompareMasterSlave;
  lwResult: LongWord;
  sSQL: string;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;

  dsCompare.DataSet := nil;

  if lwResult > 0 then
  begin
    P := PCompareMasterSlave(lwResult);
    try
      sSQL := P^.ResultSQL;
    finally
      Dispose(P);
    end;

    if FData.IsSlaveConnected then
      try
        with FData.qryCompareMasterSlave do
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

    dsCompare.DataSet := FData.qryCompareMasterSlave;
  end;

  lbCompareExecuting.Caption := '';
  btnUpdateCompare.Enabled := True;
  btnCancelCompare.Enabled := False;
  chkDeviationOnly.Enabled := True;
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

      iStart:= TSettings.ReplicaStart;

      if (P^.MaxId > P^.MinId) then
      begin
        pbAll.Step := 1;
        pbAll.Min  := 1;
        pbAll.Max  := P^.RecCount;
        if (P^.MaxId > iStart) and (iStart > P^.MinId) then
          pbAll.Position := iStart - P^.MinId
        else
          pbAll.Position := pbAll.Min;
      end;
    finally
      Dispose(P);
    end;
  end;
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
  btnStop.Enabled := False;

  lbAllElapsed.Caption := Format(cElapsedReplica, [Elapsed(FStartTimeReplica)]);
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
